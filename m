Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S966015Ab2DLUH5 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 12 Apr 2012 16:07:57 -0400
Received: from smtp.snhosting.dk ([87.238.248.203]:58891 "EHLO
	smtp.domainteam.dk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S965957Ab2DLUHy (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 12 Apr 2012 16:07:54 -0400
Date: Thu, 12 Apr 2012 22:07:52 +0200
From: Sam Ravnborg <sam@ravnborg.org>
To: Andi Kleen <ak@linux.intel.com>
Cc: Geert Uytterhoeven <geert@linux-m68k.org>,
        Andi Kleen <andi@firstfloor.org>, linux-kernel@vger.kernel.org,
        linux-kbuild@vger.kernel.org, x86@kernel.org
Subject: Re: [PATCH 2/2] Add CONFIG_READABLE_ASM
Message-ID: <20120412200752.GA30685@merkur.ravnborg.org>
References: <1332960678-11879-1-git-send-email-andi@firstfloor.org> <1332960678-11879-2-git-send-email-andi@firstfloor.org> <CAMuHMdVX28zeebzN6277B5p2b=9s-Q06i01o5AHPyXAuKMigGQ@mail.gmail.com> <20120412194016.GA30558@merkur.ravnborg.org> <CAMuHMdXfpvprGD18_YYyctfrAk6iRJonWFGFRf9oSaH0u0zfhw@mail.gmail.com> <4F8733C5.5080609@linux.intel.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <4F8733C5.5080609@linux.intel.com>
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Apr 12, 2012 at 12:57:57PM -0700, Andi Kleen wrote:
>
>>> You should try cc-diasable-warning like this:
>>>
>>> KBUILD_CFLAGS += $(call cc-disable-warning, ipa-cp-clone)
>> That works, thanks!
>> Andi, does it still work as expected for you?
>
> No, unfortunately it doesn't enable the flag with my compiler.
> Also BTW ipa-cp-clone is not a warning, it's an optimization pass.

Yeah I see now.
cc-disable-warning only works on warnings - which starts with -W

Could you try this:

cc-disable-opt = $(call try-run,\
        $(CC) $(KBUILD_CPPFLAGS) $(KBUILD_CFLAGS) -f$(strip $(1)) -c -xc /dev/null -o "$$TMP",-fno-$(strip $(1)))

KBUILD_CFLAGS += $(call cc-disable-opt, ipa-cp-clone)


It will try if "gcc -fipa-cp-clone" is supported,
and add -fno-ipa-cp-clone in that case.

	Sam

