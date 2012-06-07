Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756202Ab2FGUUU (ORCPT <rfc822;w@1wt.eu>);
	Thu, 7 Jun 2012 16:20:20 -0400
Received: from mail-ey0-f174.google.com ([209.85.215.174]:58299 "EHLO
	mail-ey0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754789Ab2FGUUQ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 7 Jun 2012 16:20:16 -0400
Message-ID: <4FD10CFC.8030000@gmail.com>
Date: Thu, 07 Jun 2012 22:20:12 +0200
From: Maarten Lankhorst <m.b.lankhorst@gmail.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:12.0) Gecko/20120430 Thunderbird/12.0.1
MIME-Version: 1.0
To: lee.g.rosenbaum@intel.com, mingo@kernel.org, hpa@zytor.com,
        linux-kernel@vger.kernel.org, jordan.l.justen@intel.com,
        tglx@linutronix.de, rydberg@euromail.se, matt.fleming@intel.com
CC: linux-tip-commits@vger.kernel.org
Subject: Re: [tip:x86/urgent] x86, efi stub: Add .reloc section back into
 image
References: <1339085121-12760-1-git-send-email-jordan.l.justen@intel.com> <tip-743628e868c5992354fc80b4d1e9a6143da1c0e6@git.kernel.org>
In-Reply-To: <tip-743628e868c5992354fc80b4d1e9a6143da1c0e6@git.kernel.org>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hey,

Op 07-06-12 20:37, tip-bot for Jordan Justen schreef:
> Commit-ID:  743628e868c5992354fc80b4d1e9a6143da1c0e6
> Gitweb:     http://git.kernel.org/tip/743628e868c5992354fc80b4d1e9a6143da1c0e6
> Author:     Jordan Justen <jordan.l.justen@intel.com>
> AuthorDate: Thu, 7 Jun 2012 09:05:21 -0700
> Committer:  H. Peter Anvin <hpa@zytor.com>
> CommitDate: Thu, 7 Jun 2012 09:52:33 -0700
>
> x86, efi stub: Add .reloc section back into image
>
> Some UEFI firmware will not load a .efi with a .reloc section
> with a size of 0.
>
> Therefore, we create a .efi image with 4 main areas and 3 sections.
> 1. PE/COFF file header
> 2. .setup section (covers all setup code following the first sector)
> 3. .reloc section (contains 1 dummy reloc entry, created in build.c)
> 4. .text section (covers the remaining kernel image)
>
Scary how some patches arrive a few minutes before you need them.
I can verify applying this patch fixes efi stub booting for my system.
I wasn't even aware it was broken, but it definitely didn't want to boot
without. :-)

~Maarten
