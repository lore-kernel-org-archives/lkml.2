Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755614Ab1K3HZM (ORCPT <rfc822;w@1wt.eu>);
	Wed, 30 Nov 2011 02:25:12 -0500
Received: from cantor2.suse.de ([195.135.220.15]:56102 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755134Ab1K3HZJ (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 30 Nov 2011 02:25:09 -0500
Message-ID: <4ED5DA4E.5060500@suse.de>
Date: Wed, 30 Nov 2011 08:25:02 +0100
From: Hannes Reinecke <hare@suse.de>
User-Agent: Mozilla/5.0 (X11; U; Linux x86_64; en-US; rv:1.9.2.14) Gecko/20110221 SUSE/3.1.8 Thunderbird/3.1.8
MIME-Version: 1.0
To: Mike Snitzer <snitzer@redhat.com>
Cc: Heiko Carstens <heiko.carstens@de.ibm.com>,
        "Jun'ichi Nomura" <j-nomura@ce.jp.nec.com>,
        James Bottomley <James.Bottomley@HansenPartnership.com>,
        Steffen Maier <maier@linux.vnet.ibm.com>,
        "linux-scsi@vger.kernel.org" <linux-scsi@vger.kernel.org>,
        Jens Axboe <axboe@kernel.dk>,
        Linux Kernel <linux-kernel@vger.kernel.org>,
        Alan Stern <stern@rowland.harvard.edu>,
        Thadeu Lima de Souza Cascardo <cascardo@linux.vnet.ibm.com>,
        "Taraka R. Bodireddy" <tarak.reddy@in.ibm.com>,
        "Seshagiri N. Ippili" <seshagiri.ippili@in.ibm.com>,
        "Manvanthara B. Puttashankar" <mputtash@in.ibm.com>,
        Jeff Moyer <jmoyer@redhat.com>, Shaohua Li <shaohua.li@intel.com>,
        gmuelas@de.ibm.com, dm-devel@redhat.com
Subject: Re: [GIT PULL] Queue free fix (was Re: [PATCH] block: Free queue
 resources at blk_release_queue())
References: <20111031100557.GA2621@osiris.boeblingen.de.ibm.com> <1320057746.2964.1.camel@dabdike> <4EAE8A7E.8000504@ce.jp.nec.com> <20111031130004.GB4768@osiris.boeblingen.de.ibm.com> <20111103182548.GA12131@redhat.com> <20111104091936.GB2397@osiris.boeblingen.de.ibm.com> <4EBA49C2.1000704@suse.de> <20111110161008.GA15659@osiris.boeblingen.de.ibm.com> <20111117162919.GA3812@redhat.com> <20111129120047.GA2456@osiris.boeblingen.de.ibm.com> <20111129201803.GB6827@redhat.com>
In-Reply-To: <20111129201803.GB6827@redhat.com>
X-Enigmail-Version: 1.1.2
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 11/29/2011 09:18 PM, Mike Snitzer wrote:
> On Tue, Nov 29 2011 at  7:00am -0500,
> Heiko Carstens <heiko.carstens@de.ibm.com> wrote:
> 
>>>>> Hmm. Just to be on the safe side, could you try this one:
>>>>>
>>>>> diff --git a/drivers/md/dm-mpath.c b/drivers/md/dm-mpath.c
>>>>> index 5e0090e..e6fad46 100644
>>>>> --- a/drivers/md/dm-mpath.c
>>>>> +++ b/drivers/md/dm-mpath.c
>>>>> @@ -920,8 +920,10 @@ static int multipath_map(struct dm_target *ti,
>>>>> struct reque
>>>>> st *clone,
>>>>>         map_context->ptr = mpio;
>>>>>         clone->cmd_flags |= REQ_FAILFAST_TRANSPORT;
>>>>>         r = map_io(m, clone, mpio, 0);
>>>>> -       if (r < 0 || r == DM_MAPIO_REQUEUE)
>>>>> +       if (r < 0 || r == DM_MAPIO_REQUEUE) {
>>>>>                 mempool_free(mpio, m->mpio_pool);
>>>>> +               map_context->ptr = NULL;
>>>>> +       }
>>>>>
>>>>>         return r;
>>>>>  }
>>>>
>>>> With your patch we haven't been able to reproduce the kernel crash until now.
>>>> Now we "only" run into I/O stalls, which before your patch we also did. But
>>>> repeatedly rebooting and retrying and ignoring the I/O stalls always lead to
>>>> a crash.
>>>> Gonzalo will run a couple of extra rounds so we can have a feeling if at least
>>>> one of the bugs could be fixed with your patch ;)
>>>
>>> Hi,
>>>
>>> Any update after further testing with Hannes' patch?
>>
>> Sorry for the late update, our internal IBM IMAP servers have been down
>> for nearly a week :/
>>
>> So, we were unable to reproduce the original bug with the patch applied
>> during various runs.
> 
> OK, so it seems to be a benenficial change (and obviously correct to
> me).  Hannes, care to formally post your fix to dm-devel so we can get
> it in 3.2-rc?
> 
Yep, will do.

Cheers,

Hannes
-- 
Dr. Hannes Reinecke		      zSeries & Storage
hare@suse.de			      +49 911 74053 688
SUSE LINUX Products GmbH, Maxfeldstr. 5, 90409 Nürnberg
GF: J. Hawn, J. Guild, F. Imendörffer, HRB 16746 (AG Nürnberg)
