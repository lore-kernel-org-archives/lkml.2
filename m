Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759604Ab0LNRYV (ORCPT <rfc822;w@1wt.eu>);
	Tue, 14 Dec 2010 12:24:21 -0500
Received: from mail-yx0-f174.google.com ([209.85.213.174]:64282 "EHLO
	mail-yx0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756206Ab0LNRYR (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 14 Dec 2010 12:24:17 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=message-id:date:from:user-agent:mime-version:to:cc:subject
         :references:in-reply-to:content-type:content-transfer-encoding;
        b=jiBG8EluXVydv0z7zBYXZw7v6TXQ5Bk1Xhz+FyVaeiJuWvBgIurYthHBAmH2xiraB0
         S2IuXNuV2ugxAUGGKilegSFRpz7vhZEv5ny9Oo3yv7rGd3BcaSy2RvcQnwFYf3Jhf+rf
         b289fHkMjyYePF3qV54kuaZ/0xpQ80lO94big=
Message-ID: <4D07A83C.9080707@gmail.com>
Date: Tue, 14 Dec 2010 09:24:12 -0800
From: Dirk Brandewie <dirk.brandewie@gmail.com>
User-Agent: Mozilla/5.0 (X11; U; Linux x86_64; en-US; rv:1.9.2.12) Gecko/20101103 Fedora/1.0-0.33.b2pre.fc13 Thunderbird/3.1.6
MIME-Version: 1.0
To: dirk.brandewie@gmail.com
CC: linux-kernel@vger.kernel.org, devicetree-discuss@lists.ozlabs.org,
        sodaville@linutronix.de, linuxppc-dev@lists.ozlabs.org,
        microblaze-uclinux@itee.uq.edu.au, linux-arch@vger.kernel.org,
        mmarek@suse.cz
Subject: Re: [PATCH 0/4] V3 Add ability to link device blob(s) into vmlinux
References: <cover.1291820033.git.dirk.brandewie@gmail.com>
In-Reply-To: <cover.1291820033.git.dirk.brandewie@gmail.com>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 12/08/2010 07:01 AM, dirk.brandewie@gmail.com wrote:
> From: Dirk Brandewie<dirk.brandewie@gmail.com>
>
> This patch set adds the ability to link device tree blobs into
> vmlinux.
>
> Patch 1 implements the changes to include/asm-generic/vmlinux.lds.h and
> adds a generic rule for generating DTB objects to be linked vmlinux.
>
> Patch 2 implements linking a DTB into an x86 image.
>
> Patch 3-4 move {powerpc,microblaze}/boot/Makefile to use the dtc rule
> in patch 1.
>
> This patch set has been tested on x86.
>
> Powerpc and Microblaze have been compile tested with and without patch
> 3 and 4 applied.
>
> Changes from V1:
>
> Documentation added for dtc command in Makefile.lib to
> Documentation/kbuild/makefiles.txt
> Separate DTB_ALIGNMENT define removed.
> FORCE removed from dtc rule.
> Removed hardcoded path to dts files from dtc command.
> Moved %.dtb: %.dts rule to arch specific makefiles.
>
> Patch for adding kernel command line option to pass in dtb_compat
> string dropped from this set will be submitted seperately.
>
> Changes from V2:
>
> Rule to create assembly wrapper for blob changed to use Sam Ravnborgs
> suggested implementation.
>
> Rules in architecture specific Makefiles changed to use the cmd
> function instead of the if_changed function.
>
> Dirk Brandewie (4):
>    of: Add support for linking device tree blobs into vmlinux
>    x86/of: Add building device tree blob(s) into image.
>    of/powerpc: Use generic rule to build dtb's
>    microblaze/of: Use generic rule to build dtb's
>
>   Documentation/kbuild/makefiles.txt |   15 +++++++++++++++
>   arch/microblaze/boot/Makefile      |   12 +++---------
>   arch/powerpc/boot/Makefile         |    8 +++-----
>   arch/x86/platform/ce4100/Makefile  |   10 ++++++++++
>   include/asm-generic/vmlinux.lds.h  |   13 +++++++++++--
>   scripts/Makefile.lib               |   23 +++++++++++++++++++++++
>   6 files changed, 65 insertions(+), 16 deletions(-)
>

Any Comments on this patch set?

--Dirk
