Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757503Ab2B1Xhi (ORCPT <rfc822;w@1wt.eu>);
	Tue, 28 Feb 2012 18:37:38 -0500
Received: from hulk.biessmann.org ([62.75.166.25]:46583 "EHLO
	hulk.biessmann.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757480Ab2B1Xhg (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 28 Feb 2012 18:37:36 -0500
Message-ID: <4F4D6532.4010906@biessmann.de>
Date: Wed, 29 Feb 2012 00:37:22 +0100
From: =?ISO-8859-1?Q?Andreas_Bie=DFmann?= <andreas@biessmann.de>
User-Agent: Mozilla/5.0 (Macintosh; Intel Mac OS X 10.7; rv:10.0.2) Gecko/20120216 Thunderbird/10.0.2
MIME-Version: 1.0
To: Bernhard Walle <bernhard@bwalle.de>
CC: mmarek@suse.cz, lacombar@gmail.com, linux-kernel@vger.kernel.org
Subject: Re: [PATCH] scripts/Kbuild.include: Fix portability problem of "echo
 -e"
References: <1330277718-2667-1-git-send-email-bernhard@bwalle.de>
In-Reply-To: <1330277718-2667-1-git-send-email-bernhard@bwalle.de>
X-Enigmail-Version: 1.3.5
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8bit
X-SPAM_bar: --
X-SPAM_score: -28
X-ChkData-Signature: e0aecb94051a5869b5deb36feca7a8f1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


On 26.02.12 18:35, Bernhard Walle wrote:
> "echo -e" is a GNU extension. When cross-compiling the kernel on a
> BSD-like operating system (Mac OS X in my case), this doesn't work.
> 
> One could install a GNU version of echo, put that in the $PATH before
> the system echo and use "/usr/bin/env echo", but the solution with
> printf is simpler.
> 
> Since it is no disadvantage on Linux, I hope that gets accepted even if
> cross-compiling the Linux kernel on another Unix operating system is
> quite a rare use case.
> 
> Signed-off-by: Bernhard Walle <bernhard@bwalle.de>

Tested-by: Andreas Bieﬂmann <andreas@biessmann.de>

Without that patch cross-compiling kernel for omap2 devices on BSD-style
hosts is broken.
For x86 targets the impact is not that hard but CFI is omitted even
though it is supported by assembler (in one case this led to a devious
error message pointing to a assembler bug in my cross toolchain).

So please consider applying this patch.
