Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751655Ab1EEGSW (ORCPT <rfc822;w@1wt.eu>);
	Thu, 5 May 2011 02:18:22 -0400
Received: from mx1.alphion.com ([75.147.97.34]:43937 "EHLO mx1.alphion.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751384Ab1EEGSV convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 5 May 2011 02:18:21 -0400
X-CTCH-RefID: str=0001.0A02020A.4DC24124.0062,ss=1,fgs=0
Content-class: urn:content-classes:message
MIME-Version: 1.0
Content-Type: text/plain;
	charset="us-ascii"
Content-Transfer-Encoding: 8BIT
X-MimeOLE: Produced By Microsoft Exchange V6.5
Subject: Network packet processing related Query
Date: Thu, 5 May 2011 02:18:09 -0400
Message-ID: <846629303ABF174A9EA5BB26D6965A5901E8B77C@MX2.AlphionCorp.local>
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
Thread-Topic: Network packet processing related Query
Thread-Index: AcwK7DRnlVJMJbuvQKij6WmvQJIymQ==
From: "Sachin Rane" <SRane@alphion.com>
To: <linux-kernel@vger.kernel.org>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi,

I want to improve my understanding about the logic of the code written
for 'process_backlog ()' .

File Source: net/core/dev.c,  linux-2.6.16

I am considering only Non-NAPI network devices ( > 1) in this
discussion.

The 'net_rx_action' function invokes 'dev->poll(dev, &budget)' for each
network device present in 'poll_list'. '
The default handler for Non-NAPI network devices is 'process_backlog
()'.

The signature of the function is:
static int process_backlog (struct net_device *backlog_dev, int *budget)

'backlog_dev' represents the device for which the 'poll' function is
invoked.

In the code body the function acts on CPU specific 'input_pkt_queue'.
This queue holds all the incoming packets from the network devices and
'poll_list' has reference for these network devices.

The function takes out one element (packet) from the 'input_pkt_queue'
and process the packet.

As the 'input_pkt_queue' is shared by all the network devices,
the 'packet' which is popped-out from the list can
be from any network device not required to be from 'backlog_dev' (the
device
for which 'process_backlog' has been called).

I have confusion here.
The code doesn't operate only on the packets queued-in by 'backlog_dev'
to
'input_pkt_queue'. It pops-out the node from the queue and process it.
But it updates the 'quota' which is specific for the device
'backlog_dev' for which the function have got called.

Why it is so? Am I missing out something here?

Thanks for reading my mail patiently.

Regards,
Sachin Rane
