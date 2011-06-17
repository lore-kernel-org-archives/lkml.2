Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754304Ab1FQG1e (ORCPT <rfc822;w@1wt.eu>);
	Fri, 17 Jun 2011 02:27:34 -0400
Received: from cantor.suse.de ([195.135.220.2]:50961 "EHLO mx1.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751743Ab1FQG1d (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 17 Jun 2011 02:27:33 -0400
Message-ID: <4DFAF3D2.5030506@suse.de>
Date: Fri, 17 Jun 2011 08:27:30 +0200
From: Hannes Reinecke <hare@suse.de>
User-Agent: Mozilla/5.0 (X11; U; Linux x86_64; en-US; rv:1.9.2.14) Gecko/20110221 SUSE/3.1.8 Thunderbird/3.1.8
MIME-Version: 1.0
To: Kay Sievers <kay.sievers@vrfy.org>
Cc: James Bottomley <James.Bottomley@hansenpartnership.com>,
        Greg KH <greg@kroah.com>, Nao Nishijima <nao.nishijima.xt@hitachi.com>,
        linux-scsi@vger.kernel.org, linux-kernel@vger.kernel.org,
        jcm@redhat.com, stefanr@s5r6.in-berlin.de,
        yrl.pp-manager.tt@hitachi.com
Subject: Re: [PATCH 1/3] [RFC] genhd: add a new attribute in device structure
References: <20110615081610.2237.44767.stgit@ltc233.sdl.hitachi.co.jp> <20110615081627.2237.9620.stgit@ltc233.sdl.hitachi.co.jp> <20110615153337.GA10160@kroah.com> <4DF9F11F.705@hitachi.com> <20110616154129.GA31498@kroah.com> <1308239454.2436.34.camel@mulgrave> <20110616161442.GA32113@kroah.com> <1308241506.2436.44.camel@mulgrave> <BANLkTi=qHhzwGfp4v8B1CAmT+gtA=sOgvw@mail.gmail.com> <BANLkTikUNqTxgD_+TTVpcFyRDu_fSesrsg@mail.gmail.com>
In-Reply-To: <BANLkTikUNqTxgD_+TTVpcFyRDu_fSesrsg@mail.gmail.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 8bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 06/16/2011 07:20 PM, Kay Sievers wrote:
> On Thu, Jun 16, 2011 at 19:09, Kay Sievers<kay.sievers@vrfy.org>  wrote:
>> On Thu, Jun 16, 2011 at 18:25, James Bottomley
>> <James.Bottomley@hansenpartnership.com>  wrote:
>>> On Thu, 2011-06-16 at 09:14 -0700, Greg KH wrote:
>>>> All userspace naming will be taken care of by the usual udev rules, so
>>>>> for disks, something like /dev/disk/by-preferred/<fred>  which would be
>>>>> the usual symbolic link.
>>>>
>>>> No, udev can not create such a link after the preferred name is set, as
>>>> it has no way of knowing that the name was set.
>>>
>>> It can if we trigger a uevent.  Note: I'm not advocating this ... I'd be
>>> equally happy having whatever sets the kernel name create the link (or
>>> tickle udev to create it).  We definitely require device links, though,
>>> to get this to work.
>
> Guess all that would work now, including mount(8) not canonicalizing.
> What would happen if we mount:
>    /dev/disk/by-pretty/foo
> and some tool later thinks the pretty name should better be 'bar', it
> writes the name to /sys, we get a uevent, the old link disappears, we
> get a new link, mount has no device node anymore for the mounted
> device ...
>
> So we basically get a one-shot additional pretty name? Guess, the
> _single_ name changed anytime later just asks for serious problems. We
> need to set it very early to be really useful, but how, where is it
> coming from?
>
Well, certain storage arrays are able to print out the user-defined 
name for the LUNs:

# sg_vpd -p 0xc8 /dev/sdc
Extended device identification (RDAC) VPD Page:
   Volume Unique Identifier: 60080e50001bf1f0000005004ddb05a4
     Creation Number: 1280, Timestamp: Tue May 24 03:11:00 2011
   Volume User Label: mas-1
   Storage Array Unique Identifier: 60080e50001bf1f0000000004d418973
   Storage Array User Label: LSI-SAS-DIF
   Logical Unit Number: 0000000000000000

where the 'Volume User Label' is the name the administrator has 
given to the LUN on the storage array.

So for these kind of things it would be useful.

However, a single pretty name is quite a limitation.
And I also fail to see why this can't be handled in userspace.

Cheers,

Hannes
-- 
Dr. Hannes Reinecke		      zSeries & Storage
hare@suse.de			      +49 911 74053 688
SUSE LINUX Products GmbH, Maxfeldstr. 5, 90409 Nürnberg
GF: J. Hawn, J. Guild, F. Imendörffer, HRB 16746 (AG Nürnberg)
