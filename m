Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756113Ab0IQS0M (ORCPT <rfc822;w@1wt.eu>);
	Fri, 17 Sep 2010 14:26:12 -0400
Received: from mail-qy0-f174.google.com ([209.85.216.174]:51658 "EHLO
	mail-qy0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755178Ab0IQS0K (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 17 Sep 2010 14:26:10 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=sender:message-id:date:from:user-agent:mime-version:to:cc:subject
         :references:in-reply-to:content-type:content-transfer-encoding;
        b=l3TrNvwXnQoG8vxijjfr5OmBGE2zaeE9txWc3OKLMlbllQ6edYuh+Yp6Q6XIVYVaDM
         /Ie9bLt97l5bWs+bwmupcxJuEbn9hDe6XDM3rSWEk1vONTwOXZsBZoA6Xoy+GsR6Mvjm
         XSFAlAIB1NoDYkU8TLLTYS26UJn/Xu2JocCoA=
Message-ID: <4C93B2BC.8000404@garzik.org>
Date: Fri, 17 Sep 2010 14:26:04 -0400
From: Jeff Garzik <jeff@garzik.org>
User-Agent: Mozilla/5.0 (X11; U; Linux x86_64; en-US; rv:1.9.1.12) Gecko/20100907 Fedora/3.0.7-1.fc12 Thunderbird/3.0.7
MIME-Version: 1.0
To: "Nicholas A. Bellinger" <nab@linux-iscsi.org>
CC: Tim Chen <tim.c.chen@linux.intel.com>,
        linux-scsi <linux-scsi@vger.kernel.org>,
        linux-kernel <linux-kernel@vger.kernel.org>,
        Vasu Dev <vasu.dev@linux.intel.com>, Andi Kleen <ak@linux.intel.com>,
        Matthew Wilcox <willy@linux.intel.com>,
        James Bottomley <James.Bottomley@suse.de>,
        Mike Christie <michaelc@cs.wisc.edu>,
        James Smart <james.smart@emulex.com>,
        Andrew Vasquez <andrew.vasquez@qlogic.com>,
        FUJITA Tomonori <fujita.tomonori@lab.ntt.co.jp>,
        Hannes Reinecke <hare@suse.de>, Joe Eykholt <jeykholt@cisco.com>,
        Christoph Hellwig <hch@lst.de>
Subject: Re: [PATCH 0/8] Drop host_lock around LLD SHT->queuecommand() caller
References: <1284676521-10737-1-git-send-email-nab@linux-iscsi.org> <1284686949.7280.99.camel@schen9-DESK> <1284687070.13344.135.camel@haakon2.linux-iscsi.org>
In-Reply-To: <1284687070.13344.135.camel@haakon2.linux-iscsi.org>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 09/16/2010 09:31 PM, Nicholas A. Bellinger wrote:
> On Thu, 2010-09-16 at 18:29 -0700, Tim Chen wrote:
>> On Thu, 2010-09-16 at 15:35 -0700, Nicholas A. Bellinger wrote:
>>> From: Nicholas Bellinger<nab@linux-iscsi.org>
>>>
>>> Greetings all,
>>>
>>> This series contains the first round of a whole-sale conversion for droping
>>> struct Scsi_Host->host_lock around struct Scsi_Host->queuecommand() within
>>> scsi_dispatch_cmd().  So with this first patch the only part of scsi_dispatch_cmd()
>>> that is protected by host_lock is scsi_cmd_get_serial)_.
>>>
>>
>> Maybe we can change the host->cmd_serial_number to atomic and totally
>> avoid the need to take host_lock.
>
> Hmmmm good point, then we would also need an atomic_t for signaling
> (shost_state == SHOST_DEL) in scsi_dispatch_cmd() to be able to
> completly drop host_lock usage within scsi_dispatch_cmd().
>
> I can take a look at doing this specific part, if you would be willing
> to have a look at the host->cmd_serial_number conversion piece.  ;)

But that raises the familiar tale of:  using multiple atomics (w/ their 
locked instructions) may cost more than a spinlock.

	Jeff



