Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756162Ab2D3Pd6 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 30 Apr 2012 11:33:58 -0400
Received: from mx1.redhat.com ([209.132.183.28]:15713 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753319Ab2D3Pd4 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 30 Apr 2012 11:33:56 -0400
Message-ID: <4F9EB0D7.2070902@redhat.com>
Date: Mon, 30 Apr 2012 12:33:43 -0300
From: Mauro Carvalho Chehab <mchehab@redhat.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:11.0) Gecko/20120329 Thunderbird/11.0.1
MIME-Version: 1.0
To: Borislav Petkov <bp@amd64.org>
CC: Linux Edac Mailing List <linux-edac@vger.kernel.org>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        Doug Thompson <norsk5@yahoo.com>, Joe Perches <joe@perches.com>
Subject: Re: [PATCH v2] edac_mc: Cleanup per-dimm_info debug messages
References: <4F9E9958.6010606@redhat.com> <1335798160-9879-1-git-send-email-mchehab@redhat.com> <4F9EAB60.80000@redhat.com> <20120430152024.GK9303@aftab.osrc.amd.com>
In-Reply-To: <20120430152024.GK9303@aftab.osrc.amd.com>
X-Enigmail-Version: 1.4
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Em 30-04-2012 12:20, Borislav Petkov escreveu:
> On Mon, Apr 30, 2012 at 12:10:24PM -0300, Mauro Carvalho Chehab wrote:
>>> [  728.430828] EDAC DEBUG: edac_mc_dump_dimm: 	dimm2: channel 0 slot 2 mapped as virtual row 0, chan 2
>>> [  728.430834] EDAC DEBUG: edac_mc_dump_dimm: 	dimm->label = 'mc#0channel#0slot#2'
>>> [  728.430839] EDAC DEBUG: edac_mc_dump_dimm: 	dimm->nr_pages = 0x0
>>> [  728.430846] EDAC DEBUG: edac_mc_dump_dimm: 	dimm->grain = 0
>>> [  728.430850] EDAC DEBUG: edac_mc_dump_dimm: 	dimm->nr_pages = 0x0
>>
>> Hmm... just noticed that, just like the per-csrow register dumps, this routine
>> is called even when empty memories are used (in this case: nr_pages = 0).
>>
>> IMHO, as this is a registers dump, the better is to keep it as-is, but it would
>> be simple to add a test there - and at edac_mc_dump_csrow() - to just dump it
>> when dimm->nr_pages is not 0.
>>
>> What do you think?
> 
> Or even better, test dimm->nr_pages != 0 before calling
> edac_mc_dump_csrow() so that you can save yourself the function call.

Ok, I'll do that.

> Btw, where are the latest versions of your patches so that I can
> continue reviewing them?

The very latest series of patches are always at:
	git://git.infradead.org/users/mchehab/edac.git experimental

The latest version of "[PATCH EDACv16 1/2]edac: Change internal representation to work with layers"

is on one of the replies, and also at:

	http://git.infradead.org/users/mchehab/edac.git/commit/447b7929e633027ffe131f2f8f246bba5690cee7

I won't resend the 28 "foo: convert driver to use the new edac ABI" to the mailing list,
as there were no changes on them, except for a contextual change: 
	the .is_csrow field got renamed to .is_virt_csrow

So, there's no sense on flooding the mailing lists with them again.

The only one that you're likely interested is the amd64_edac one (the first one of the 28 patch
series). This patch were re-sent as PATCH EDACv16 2/2.

The next patch after them is "edac: Remove the legacy EDAC ABI"[1], with also didn't change
(maybe except for contextual changes).

After you review them, I'll re-send the other patches on my queue, probably breaking it into two
or three patch series.

[1] http://git.infradead.org/users/mchehab/edac.git/commit/d1390992c51323802e1ccddfa48b16f0be062621

Regards,
Mauro
