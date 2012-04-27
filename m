Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759048Ab2D0QJB (ORCPT <rfc822;w@1wt.eu>);
	Fri, 27 Apr 2012 12:09:01 -0400
Received: from mx1.redhat.com ([209.132.183.28]:30506 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1757712Ab2D0QJA (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 27 Apr 2012 12:09:00 -0400
Message-ID: <4F9AC44A.5000509@redhat.com>
Date: Fri, 27 Apr 2012 13:07:38 -0300
From: Mauro Carvalho Chehab <mchehab@redhat.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:11.0) Gecko/20120329 Thunderbird/11.0.1
MIME-Version: 1.0
To: Joe Perches <joe@perches.com>
CC: Borislav Petkov <bp@amd64.org>,
        Linux Edac Mailing List <linux-edac@vger.kernel.org>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        Aristeu Rozanski <arozansk@redhat.com>,
        Doug Thompson <norsk5@yahoo.com>, Mark Gross <mark.gross@intel.com>,
        Jason Uhlenkott <juhlenko@akamai.com>,
        Tim Small <tim@buttersideup.com>,
        Ranganathan Desikan <ravi@jetztechnologies.com>,
        "Arvind R." <arvino55@gmail.com>, Olof Johansson <olof@lixom.net>,
        Egor Martovetsky <egor@pasemi.com>,
        Chris Metcalf <cmetcalf@tilera.com>, Michal Marek <mmarek@suse.cz>,
        Jiri Kosina <jkosina@suse.cz>,
        Dmitry Eremin-Solenikov <dbaryshkov@gmail.com>,
        Benjamin Herrenschmidt <benh@kernel.crashing.org>,
        Hitoshi Mitake <h.mitake@gmail.com>,
        Andrew Morton <akpm@linux-foundation.org>,
        =?UTF-8?B?TmlrbGFzIFPDtmRlcmx1bmQ=?= 
	<niklas.soderlund@ericsson.com>,
        Shaohui Xie <Shaohui.Xie@freescale.com>,
        Josh Boyer <jwboyer@gmail.com>, linuxppc-dev@lists.ozlabs.org
Subject: Re: [PATCH EDACv16 1/2] edac: Change internal representation to work
 with layers
References: <1335289087-11337-1-git-send-email-mchehab@redhat.com>  <1335291342-14922-1-git-send-email-mchehab@redhat.com>  <20120427133304.GE9626@aftab.osrc.amd.com> <1335535895.25521.7.camel@joe2Laptop>
In-Reply-To: <1335535895.25521.7.camel@joe2Laptop>
X-Enigmail-Version: 1.4
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Em 27-04-2012 11:11, Joe Perches escreveu:
> On Fri, 2012-04-27 at 15:33 +0200, Borislav Petkov wrote:
>> this patch gives
>>
>> [    8.278399] EDAC DEBUG: new_edac_mc_alloc: new_edac_mc_alloc: 0: dimm0 (0:0:0): row 0, chan 0
> 
> One too many __func__'s in some combination of the
> pr_fmt and/or dbg call and/or the actual call site?

Yes. This is a common issue at the EDAC core: on several places, it calls the
edac debug macros (DEBUGF0...DEBUGF4) passing a __func__ as an argument, while
the debug macros already handles that. I suspect that, in the past, the __func__
were not at the macros, but some patch added it there, and forgot to fix the
occurrences of its call.

This is something that needs to be reviewed at the entire EDAC core (and likely
at the drivers).

I opted to not touch on this at the existing debug logic, as I think that the
better is to address all those issues on one separate patch, after fixing the
EDAC core bugs.
> 
>>> diff --git a/drivers/edac/edac_core.h b/drivers/edac/edac_core.h
> []
>>> @@ -447,8 +447,13 @@ static inline void pci_write_bits32(struct pci_dev *pdev, int offset,
>>>  
>>>  #endif				/* CONFIG_PCI */
>>>  
>>> -extern struct mem_ctl_info *edac_mc_alloc(unsigned sz_pvt, unsigned nr_csrows,
>>> -					  unsigned nr_chans, int edac_index);
>>> +struct mem_ctl_info *edac_mc_alloc(unsigned sz_pvt, unsigned nr_csrows,
>>> +				   unsigned nr_chans, int edac_index);
>>
>> Why not "extern"?
> 
> Using extern function prototypes in .h files
> isn't generally necessary nor is extern the
> more common kernel style.

Yes. I never add extern on the code I write.

While CodingStyle doesn't explicitly say anything about that, its spirit
seem to indicate to that the right thing is avoid using it, like, for 
example:
	"Chapter 4: Naming

	C is a Spartan language, and so should your naming be."

(also on other places, like avoiding to use {} for single-statement if's).

So, useless clauses like "extern" doesn't seem to be the best choice.

Regards,
Mauro
