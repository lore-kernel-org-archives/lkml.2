Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756041Ab1KHPat (ORCPT <rfc822;w@1wt.eu>);
	Tue, 8 Nov 2011 10:30:49 -0500
Received: from cantor2.suse.de ([195.135.220.15]:38717 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751981Ab1KHPar (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 8 Nov 2011 10:30:47 -0500
Message-ID: <4EB94B25.3030108@suse.de>
Date: Tue, 08 Nov 2011 16:30:45 +0100
From: Hannes Reinecke <hare@suse.de>
User-Agent: Mozilla/5.0 (X11; U; Linux x86_64; en-US; rv:1.9.2.14) Gecko/20110221 SUSE/3.1.8 Thunderbird/3.1.8
MIME-Version: 1.0
To: Stephen Rothwell <sfr@canb.auug.org.au>
Cc: James Bottomley <James.Bottomley@HansenPartnership.com>,
        LKML <linux-kernel@vger.kernel.org>,
        Bart Van Assche <bvanassche@acm.org>, linux-scsi@vger.kernel.org
Subject: Re: WARNING: at drivers/scsi/scsi_lib.c:1704
References: <20111107172408.834c6ffcecfe35f7452c7e60@canb.auug.org.au>	<1320677484.1215.10.camel@dabdike.int.hansenpartnership.com> <20111108110300.e8494242e6c404142b1fe4c0@canb.auug.org.au>
In-Reply-To: <20111108110300.e8494242e6c404142b1fe4c0@canb.auug.org.au>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 8bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 11/08/2011 01:03 AM, Stephen Rothwell wrote:
> Hi James,
>
> On Mon, 07 Nov 2011 08:51:24 -0600 James Bottomley<James.Bottomley@HansenPartnership.com>  wrote:
>>
>> Actually, I don't think it's anything to do with this: it's Anton's
>> fault
>>
>> commit f7c9c6bb14f3104608a3a83cadea10a6943d2804
>> Author: Anton Blanchard<anton@samba.org>
>> Date:   Thu Nov 3 08:56:22 2011 +1100
>>
>>      [SCSI] Fix block queue and elevator memory leak in scsi_alloc_sdev
>>
>> Doesn't completely do the teardown.  The true fix is to do a proper
>> teardown instead of hand rolling it.  Does this fix it for you?
>
> I don't get the WARNING any more, but now get lots of:
>
> scsi: killing requests for dead queue
>
Yeah, that is really annoying.
And what's more the printk is wrong, as it doesn't indicate
that we've actually killed requests. It's just announcing that we 
might start killing requests, provided the request_queue isn't empty.

I'll be sending a patch.

Cheers,

Hannes
-- 
Dr. Hannes Reinecke		      zSeries & Storage
hare@suse.de			      +49 911 74053 688
SUSE LINUX Products GmbH, Maxfeldstr. 5, 90409 Nürnberg
GF: J. Hawn, J. Guild, F. Imendörffer, HRB 16746 (AG Nürnberg)
