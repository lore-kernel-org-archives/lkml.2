Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753282Ab2D2O1N (ORCPT <rfc822;w@1wt.eu>);
	Sun, 29 Apr 2012 10:27:13 -0400
Received: from mx1.redhat.com ([209.132.183.28]:42694 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750896Ab2D2O1L (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 29 Apr 2012 10:27:11 -0400
Message-ID: <4F9D4F6E.4070106@redhat.com>
Date: Sun, 29 Apr 2012 11:25:50 -0300
From: Mauro Carvalho Chehab <mchehab@redhat.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:11.0) Gecko/20120329 Thunderbird/11.0.1
MIME-Version: 1.0
To: Borislav Petkov <bp@amd64.org>
CC: Joe Perches <joe@perches.com>,
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
        =?ISO-8859-1?Q?Niklas_S=F6derlund?= <niklas.soderlund@ericsson.com>,
        Shaohui Xie <Shaohui.Xie@freescale.com>,
        Josh Boyer <jwboyer@gmail.com>, linuxppc-dev@lists.ozlabs.org
Subject: Re: [PATCH EDACv16 1/2] edac: Change internal representation to work
 with layers
References: <1335289087-11337-1-git-send-email-mchehab@redhat.com> <1335291342-14922-1-git-send-email-mchehab@redhat.com> <20120427133304.GE9626@aftab.osrc.amd.com> <1335535895.25521.7.camel@joe2Laptop> <4F9AC44A.5000509@redhat.com> <20120428085223.GB26065@aftab.osrc.amd.com>
In-Reply-To: <20120428085223.GB26065@aftab.osrc.amd.com>
X-Enigmail-Version: 1.4
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Em 28-04-2012 05:52, Borislav Petkov escreveu:
> On Fri, Apr 27, 2012 at 01:07:38PM -0300, Mauro Carvalho Chehab wrote:
>> Yes. This is a common issue at the EDAC core: on several places, it calls the
>> edac debug macros (DEBUGF0...DEBUGF4) passing a __func__ as an argument, while
>> the debug macros already handles that. I suspect that, in the past, the __func__
>> were not at the macros, but some patch added it there, and forgot to fix the
>> occurrences of its call.
> 
> The patch that added it is d357cbb445208 and you reviewed it.

And you wrote the patch that caused it.

> 
>> This is something that needs to be reviewed at the entire EDAC core (and likely
>> at the drivers).
> 
> Looks like a job for a newbie to get her/his feet wet with kernel work.

> 
>> I opted to not touch on this at the existing debug logic, as I think that the
>> better is to address all those issues on one separate patch, after fixing the
>> EDAC core bugs.
> 
> No,
> 
> you simply need to remove the __func__ argument in your newly added debug call:
> 
>                 debugf2("%s: %d: dimm%zd (%d:%d:%d): row %d, chan %d\n", __func__,
>                         i, (dimm - mci->dimms),
>                         pos[0], pos[1], pos[2], row, chn);
> 
> And while you're at it, remove the rest of the __func__ arguments from
> your newly added debugfX calls.

A single patch fixing this everywhere at drivers/edac is better and clearer than adding 
an unrelated fix on this patch. This is already complex enough to add more unrelated
things there.

Also, a simple perl/coccinelle script can replace all such __func__ occurrences 
on one shot.

Regards,
Mauro

