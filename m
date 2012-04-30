Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755425Ab2D3NCK (ORCPT <rfc822;w@1wt.eu>);
	Mon, 30 Apr 2012 09:02:10 -0400
Received: from mx1.redhat.com ([209.132.183.28]:58991 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754088Ab2D3NCJ (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 30 Apr 2012 09:02:09 -0400
Message-ID: <4F9E8CFE.1040801@redhat.com>
Date: Mon, 30 Apr 2012 10:00:46 -0300
From: Mauro Carvalho Chehab <mchehab@redhat.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:11.0) Gecko/20120329 Thunderbird/11.0.1
MIME-Version: 1.0
To: Borislav Petkov <bp@amd64.org>
CC: Linux Edac Mailing List <linux-edac@vger.kernel.org>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        Aristeu Rozanski <arozansk@redhat.com>,
        Doug Thompson <norsk5@yahoo.com>, Mark Gross <mark.gross@intel.com>,
        Jason Uhlenkott <juhlenko@akamai.com>,
        Tim Small <tim@buttersideup.com>,
        Ranganathan Desikan <ravi@jetztechnologies.com>,
        "Arvind R." <arvino55@gmail.com>, Olof Johansson <olof@lixom.net>,
        Egor Martovetsky <egor@pasemi.com>,
        Chris Metcalf <cmetcalf@tilera.com>, Michal Marek <mmarek@suse.cz>,
        Jiri Kosina <jkosina@suse.cz>, Joe Perches <joe@perches.com>,
        Dmitry Eremin-Solenikov <dbaryshkov@gmail.com>,
        Benjamin Herrenschmidt <benh@kernel.crashing.org>,
        Hitoshi Mitake <h.mitake@gmail.com>,
        Andrew Morton <akpm@linux-foundation.org>,
        =?ISO-8859-1?Q?Niklas_S=F6d?= =?ISO-8859-1?Q?erlund?= 
	<niklas.soderlund@ericsson.com>,
        Shaohui Xie <Shaohui.Xie@freescale.com>,
        Josh Boyer <jwboyer@gmail.com>, linuxppc-dev@lists.ozlabs.org
Subject: Re: [PATCH EDACv16 1/2] edac: Change internal representation to work
 with layers
References: <1335289087-11337-1-git-send-email-mchehab@redhat.com> <1335291342-14922-1-git-send-email-mchehab@redhat.com> <20120427133304.GE9626@aftab.osrc.amd.com> <4F9ABCEC.9090807@redhat.com> <20120428090523.GD26065@aftab.osrc.amd.com> <4F9D46F8.1020104@redhat.com> <20120430081513.GD8182@aftab.osrc.amd.com> <4F9E7059.5070804@redhat.com> <20120430111126.GD9303@aftab.osrc.amd.com> <4F9E7B45.8010908@redhat.com> <20120430123819.GF9303@aftab.osrc.amd.com>
In-Reply-To: <20120430123819.GF9303@aftab.osrc.amd.com>
X-Enigmail-Version: 1.4
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Em 30-04-2012 09:38, Borislav Petkov escreveu:
> On Mon, Apr 30, 2012 at 08:45:09AM -0300, Mauro Carvalho Chehab wrote:
>> Em 30-04-2012 08:11, Borislav Petkov escreveu:
>>> On Mon, Apr 30, 2012 at 07:58:33AM -0300, Mauro Carvalho Chehab wrote:

>>> This way it says "initializing 12 dimms" and the user thinks there are
>>> 12 DIMMs on his system where this might not be true.
>>
>>
>> I'm OK to remove the "initializing 12 dimms" message. It doesn't add anything
>> new.
>>
>> With regards do the other messages, if the debug messages are not clear, 
>> then let's fix them, instead of removing. What if we print, instead,
>> on a message like:
>>
>> 	"row 1, chan 1 will represent dimm5 (1:2:0) if not empty"
> 
> How about the following instead: the specific driver calls
> edac_mc_alloc(), it gets the allocated dimm array in mci->dimms
> _without_ dumping each dimm%d line. Then, each driver figures out which
> subset of that dimms array actually has populated slots and prints only
> the populated rank/slot/...
> 
> This information is much more valuable than saying how many _possible_
> slots the edac core has allocated.
> 
> Then, each driver can decide whether it makes sense to dump that info or
> not.

No, that would add extra complexity at the drivers level just due to debug
messages. I think that the better is to move this printk to the debug-specific
routine that is called only when the dimm is filled (edac_mc_dump_dimm).

With this cange, the message will be printed only for the filled dimms.

This is a cleanup patch, so I'll write it, together with the change that
will get rid of the loop that uses KERN_CONT. It will use a function added
by a latter patch at edac_mc_sysfs so it can't be merged on this patch
anyway.

Regards,
Mauro
