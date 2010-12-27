Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753082Ab0L0Ds6 (ORCPT <rfc822;w@1wt.eu>);
	Sun, 26 Dec 2010 22:48:58 -0500
Received: from sabe.cs.wisc.edu ([128.105.6.20]:54149 "EHLO sabe.cs.wisc.edu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752703Ab0L0Ds5 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 26 Dec 2010 22:48:57 -0500
Message-ID: <4D180BBA.3050709@cs.wisc.edu>
Date: Sun, 26 Dec 2010 21:44:58 -0600
From: Mike Christie <michaelc@cs.wisc.edu>
User-Agent: Mozilla/5.0 (X11; U; Linux x86_64; en-US; rv:1.9.1.15) Gecko/20101027 Fedora/3.0.10-1.fc12 Thunderbird/3.0.10
MIME-Version: 1.0
To: open-iscsi@googlegroups.com
CC: "Nicholas A. Bellinger" <nab@linux-iscsi.org>,
        Matthew Wilcox <matthew@wil.cx>,
        linux-scsi <linux-scsi@vger.kernel.org>,
        linux-kernel <linux-kernel@vger.kernel.org>,
        James Bottomley <James.Bottomley@suse.de>,
        Jeff Garzik <jeff@garzik.org>, Christoph Hellwig <hch@lst.de>,
        FUJITA Tomonori <fujita.tomonori@lab.ntt.co.jp>,
        Hannes Reinecke <hare@suse.de>
Subject: Re: [PATCH 01/12] libiscsi: Convert to host_lock less	w/	interrupts
 disabled internally
References: <1292793727-31957-1-git-send-email-nab@linux-iscsi.org>	 <1292793727-31957-2-git-send-email-nab@linux-iscsi.org>	 <20101219233835.GJ1263@parisc-linux.org>	 <1292807703.20840.29.camel@haakon2.linux-iscsi.org>	 <1292808126.20840.33.camel@haakon2.linux-iscsi.org>	 <20101220020758.GK1263@parisc-linux.org>	 <1292837413.20840.47.camel@haakon2.linux-iscsi.org>	 <4D0FF6A5.9040209@cs.wisc.edu> <1293139434.4649.122.camel@haakon2.linux-iscsi.org>
In-Reply-To: <1293139434.4649.122.camel@haakon2.linux-iscsi.org>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 12/23/2010 03:23 PM, Nicholas A. Bellinger wrote:
> On Mon, 2010-12-20 at 18:36 -0600, Mike Christie wrote:
>> On 12/20/2010 03:30 AM, Nicholas A. Bellinger wrote:
>>> After a quick audit of iscsi_session->lock usage, and I see that
>>> iscsi_complete_pdu(), iscsi_tmf_timedout(), iscsi_eh_cmd_timed_out(),
>>> iscsi_check_transport_timeouts() are using spin_lock(), and
>>> iscsi_session_failure() and iscsi_conn_failure() are using
>>> spin_lock_irqsave().
>>>
>>> Mike and Hannes, would you guys mind commenting on this..?  From what I
>>> can determine these should all be converted to use spin_lock_bh(),
>>> yes..?
>>>
>>
>> Yeah, they can use _bh locking. I was going to use them for qla4xxx eh,
>> which does iscsi processing in its irq, but we never did.
>
> Thanks for the clarification.  I would be happy to submit a patch next
> week for this seperately from the host_lock-less conversion pieces, or
> would you prefer handle this yourself..?
>

I am testing something now. Do not worry about it. Thanks for the work 
on this.
