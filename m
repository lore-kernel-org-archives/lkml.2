Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932123Ab2EGRUs (ORCPT <rfc822;w@1wt.eu>);
	Mon, 7 May 2012 13:20:48 -0400
Received: from mx1.redhat.com ([209.132.183.28]:63497 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1757249Ab2EGRUq (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 7 May 2012 13:20:46 -0400
Message-ID: <4FA7FF6C.7020404@redhat.com>
Date: Mon, 07 May 2012 13:59:24 -0300
From: Mauro Carvalho Chehab <mchehab@redhat.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:12.0) Gecko/20120430 Thunderbird/12.0.1
MIME-Version: 1.0
To: Borislav Petkov <bp@amd64.org>
CC: Linux Edac Mailing List <linux-edac@vger.kernel.org>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        Doug Thompson <norsk5@yahoo.com>,
        Borislav Petkov <borislav.petkov@amd.com>
Subject: Re: [EDAC_ABI PATCH v13 01/26] amd64_edac: convert driver to use
 the new edac ABI
References: <1334607133-30039-1-git-send-email-mchehab@redhat.com> <1334607705-30320-1-git-send-email-mchehab@redhat.com> <1334607705-30320-2-git-send-email-mchehab@redhat.com> <20120507143143.GD11462@aftab.osrc.amd.com> <4FA7F468.8070101@redhat.com> <20120507161710.GF11462@aftab.osrc.amd.com>
In-Reply-To: <20120507161710.GF11462@aftab.osrc.amd.com>
X-Enigmail-Version: 1.4.1
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Em 07-05-2012 13:17, Borislav Petkov escreveu:
> On Mon, May 07, 2012 at 01:12:24PM -0300, Mauro Carvalho Chehab wrote:
>> That happens because the EDAC core couldn't find any EDAC labels for the affected
>> memory.
>>
>> There are two reasons for seeing a "unknown memory":
>> 	1) there's no label information. This is fixed by:
>> 	   http://git.kernel.org/?p=linux/kernel/git/mchehab/linux-edac.git;a=commit;h=b14dbb9b8220f8e07634125bf0e315f739cbf501
>> 	2) there's no info about the label e. g. something like the old 
>> 	   edac_mc_handle_ce_no_info().
>>
>> As csrow and channel info is filled on your log, it is very likely to be
>> caused by (1) and that you didn't load the labels for this system with edac-ctl.
>>
>> If you had a table with the labels for your motherboard at /etc/edac/labels.db
>> and run "edac-ctl --load" during your system init (that's the default on RHEL/Fedora,
>> not sure what other distros do), the message would be like:
>>
>> EDAC MC0: CE amd64_edac on DIMM_4B (csrow 3 channel 1 page 0x5bac7 offset 0x388 grain 0 syndrome 0xb1be )
>>
>>> IOW, simply having:
>>>
>>> [ 2377.742279] EDAC MC0: CE amd64_edac (csrow:3 channel:1 page:0x5bac7 offset:0x388 grain:0 syndrome:0xb1be)
>>>
>>> is much better IMO.
>>>
>>> Also, formatting that info with ":" makes the data even easily
>>> understandable and parseable.
>>
>> Ok. I'll write a patch to replace it at the end of the series.
> 
> Why not rebase this patch? Your tree is not merged anywhere yet.

This change has nothing to do with "amd64_edac: convert driver to use the new edac ABI",
but to the previous patch.

It is possible to merge it with the previous patch that made the changes
at the edac_mc core, but that would require to re-review that patch, and will
loose the history about this specific change.

If all you want is to have this change applied before the amd64 patch, for you
to better test it, I've re-based it on my experimental tree to be between
the two patches:
	http://git.infradead.org/users/mchehab/edac.git/commitdiff/3f4610491cc58dda8c737378212559dce77adde2

Anyway, if you still prefer that I merge it with "edac: Change internal representation to work with layers"
patch, I can do it.

Regards,
Mauro
