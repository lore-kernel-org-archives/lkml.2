Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751294Ab0LUKxf (ORCPT <rfc822;w@1wt.eu>);
	Tue, 21 Dec 2010 05:53:35 -0500
Received: from daytona.panasas.com ([67.152.220.89]:40574 "EHLO
	daytona.panasas.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750828Ab0LUKxd (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 21 Dec 2010 05:53:33 -0500
Message-ID: <4D108726.2080003@panasas.com>
Date: Tue, 21 Dec 2010 12:53:26 +0200
From: Boaz Harrosh <bharrosh@panasas.com>
User-Agent: Mozilla/5.0 (X11; U; Linux x86_64; en-US; rv:1.9.1.15) Gecko/20101027 Fedora/3.0.10-1.fc12 Thunderbird/3.0.10
MIME-Version: 1.0
To: Mike Christie <michaelc@cs.wisc.edu>
CC: "Nicholas A. Bellinger" <nab@linux-iscsi.org>,
        linux-scsi <linux-scsi@vger.kernel.org>,
        linux-kernel <linux-kernel@vger.kernel.org>,
        James Bottomley <James.Bottomley@suse.de>,
        Jeff Garzik <jeff@garzik.org>, Christoph Hellwig <hch@lst.de>,
        FUJITA Tomonori <fujita.tomonori@lab.ntt.co.jp>,
        Hannes Reinecke <hare@suse.de>,
        Mike Anderson <andmike@linux.vnet.ibm.com>, Tejun Heo <tj@kernel.org>,
        Vasu Dev <vasu.dev@linux.intel.com>,
        Tim Chen <tim.c.chen@linux.intel.com>, Andi Kleen <ak@linux.intel.com>,
        Ravi Anand <ravi.anand@qlogic.com>,
        Andrew Vasquez <andrew.vasquez@qlogic.com>,
        Joe Eykholt <jeykholt@cisco.com>, James Smart <james.smart@emulex.com>,
        Douglas Gilbert <dgilbert@interlog.com>,
        adam radford <aradford@gmail.com>,
        Kashyap Desai <Kashyap.Desai@lsi.com>,
        MPTFusionLinux <DL-MPTFusionLinux@lsi.com>
Subject: Re: [PATCH 01/12] libiscsi: Convert to host_lock less w/ interrupts
 disabled internally
References: <1292793727-31957-1-git-send-email-nab@linux-iscsi.org> <1292793727-31957-2-git-send-email-nab@linux-iscsi.org> <4D0FF7E6.2060104@cs.wisc.edu>
In-Reply-To: <4D0FF7E6.2060104@cs.wisc.edu>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-OriginalArrivalTime: 21 Dec 2010 10:53:32.0388 (UTC) FILETIME=[4F111240:01CBA0FD]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 12/21/2010 02:42 AM, Mike Christie wrote:
> On 12/19/2010 03:21 PM, Nicholas A. Bellinger wrote:
>>   prepd_fault:
>> @@ -1732,12 +1728,10 @@ fault:
>>   		scsi_out(sc)->resid = scsi_out(sc)->length;
>>   		scsi_in(sc)->resid = scsi_in(sc)->length;
>>   	}
>> -	done(sc);
>> -	spin_lock(host->host_lock);
>> +	sc->scsi_done(sc);
>>   	return 0;
> 
> 
> Did you mean to send this patch or a different one? I think you sent a 
> patch with this before and I said it was wrong. Did you disagree with 
> that comment or did you change something else so it now works?

Mike hi

I think Nick is gone for the holidays. What I understood is that he's
waiting for you to fix it. Because he's not sure what the proper solution
is. Do you have time to look into it? (It will take you much faster then me)

On 12/19/2010 11:21 PM, Nicholas A. Bellinger wrote:
> *) libiscsi: NULL sc->scsi_done() callback in exception path in iscsi_queuecommand().
> The last status on this from Mike Christie was:
> 
> "This will NULL pointer. See a couple lines above where we NULL it. 
> iscsi_free_task checks if the scsi_done pointer is set and if it is it 
> will call scsi_done.
> 
> It is a hack to prevent the normal completion path from calling 
> scsi_done. For the case where we return SCSI_MLQUEUE_TARGET_BUSY (the 
> prepd_reject case) we need something to prevent scsi_done from getting 
> called.
> 
> For the return 0/prepd_fault case we can just call sc->scsi_done, but we 
> have to move some code around."
> 
> mnc, have you been able to take another look at this..?
> 

Thanks
Boaz

