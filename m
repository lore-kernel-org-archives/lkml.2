Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755744Ab1DOOIb (ORCPT <rfc822;w@1wt.eu>);
	Fri, 15 Apr 2011 10:08:31 -0400
Received: from cantor2.suse.de ([195.135.220.15]:60582 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751425Ab1DOOIa (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 15 Apr 2011 10:08:30 -0400
Message-ID: <4DA8515C.4050905@suse.cz>
Date: Fri, 15 Apr 2011 16:08:28 +0200
From: Michal Marek <mmarek@suse.cz>
User-Agent: Mozilla/5.0 (X11; U; Linux x86_64; en-US; rv:1.9.2.13) Gecko/20101206 SUSE/3.1.7 Thunderbird/3.1.7
MIME-Version: 1.0
To: Artem Bityutskiy <dedekind1@gmail.com>
Cc: linux-kbuild@vger.kernel.org, linux-kernel@vger.kernel.org,
        Paulo Marques <pmarques@grupopie.com>,
        Randy Dunlap <rdunlap@xenotime.net>
Subject: Re: [PATCH v2 2/2] kbuild: move KALLSYMS_EXTRA_PASS from Kconfig
 to Makefile
References: <1301999098-21412-1-git-send-email-dedekind1@gmail.com> <1301999098-21412-2-git-send-email-dedekind1@gmail.com>
In-Reply-To: <1301999098-21412-2-git-send-email-dedekind1@gmail.com>
Content-Type: text/plain; charset=ISO-8859-2; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 5.4.2011 12:24, Artem Bityutskiy wrote:
> From: Artem Bityutskiy<Artem.Bityutskiy@nokia.com>
>
> At the moment we have the CONFIG_KALLSYMS_EXTRA_PASS Kconfig switch,
> which users can enable or disable while configuring the kernel. This
> option is then used by 'make' to determine whether an extra kallsyms
> pass is needed or not.
>
> However, this approach is not nice and confusing, and this patch moves
> CONFIG_KALLSYMS_EXTRA_PASS from Kconfig to Makefile instead. The
> rationale is below.
>
> 1. CONFIG_KALLSYMS_EXTRA_PASS is really about the build time, not
>     run-time. There is no real need for it to be in Kconfig. It is
>     just an additional work-around which should be used only in rare
>     cases, when someone breaks kallsyms, so Kbuild/Makefile is much
>     better place for this option.
> 2. Grepping CONFIG_KALLSYMS_EXTRA_PASS shows that many defconfigs have
>     it enabled, probably not because they try to work-around a kallsyms
>     bug, but just because the Kconfig help text is confusing and does
>     not really make it clear that this option should not be used unless
>     except when kallsyms is broken.
> 3. And since many people have CONFIG_KALLSYMS_EXTRA_PASS enabled in
>     their Kconfig, we do might fail to notice kallsyms bugs in time. E.g.,
>     many testers use "make allyesconfig" to test builds, which will enable
>     CONFIG_KALLSYMS_EXTRA_PASS and kallsyms breakage will not be noticed.
>
> To address that, this patch:
>
> 1. Kills CONFIG_KALLSYMS_EXTRA_PASS
> 2. Changes Makefile so that people can use "make KALLSYMS_EXTRA_PASS=1"
>     to enable the extra pass if needed. Additionally, they may define
>     KALLSYMS_EXTRA_PASS as an environment variable.
> 3. By default KALLSYMS_EXTRA_PASS is disabled and if kallsyms has issues,
>     "make" should print a warning and suggest using KALLSYMS_EXTRA_PASS
> 4. Add "make help" entry for KALLSYMS_EXTRA_PASS

I merged the patches, but removed the make help text. Rationale: People 
who don't need it don't need the help text, for those that need it the 
help text wouldn't provide more information than the error message. Is 
this OK with you?

Michal
