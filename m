Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756670Ab1KQKdW (ORCPT <rfc822;w@1wt.eu>);
	Thu, 17 Nov 2011 05:33:22 -0500
Received: from nat28.tlf.novell.com ([130.57.49.28]:52747 "EHLO
	nat28.tlf.novell.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756645Ab1KQKdU convert rfc822-to-8bit (ORCPT
	<rfc822;groupwise-linux-kernel@vger.kernel.org:3:1>);
	Thu, 17 Nov 2011 05:33:20 -0500
Message-Id: <4EC4F0FD0200007800061840@nat28.tlf.novell.com>
X-Mailer: Novell GroupWise Internet Agent 12.0.0 
Date: Thu, 17 Nov 2011 10:33:17 +0000
From: "Jan Beulich" <JBeulich@suse.com>
To: <minipli@googlemail.com>
Cc: <herbert@gondor.hengli.com.au>, <linux-kernel@vger.kernel.org>
Subject: your patch "crypto: sha1 - SSSE3 based SHA1 implementation for
 x86-64" vs xsave
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 8BIT
Content-Disposition: inline
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Mathias,

in avx_usable() you use cpu_has_osxsave to determine whether AVX can
actually be used, but I can't see how that conditional would ever evaluate
to true. Checking CPUID.OSXSAVE is actually a user land requirement,
whereas in the kernel you should really look at kernel internal variables
to determine whether xsave was enabled (or, if you really want to stay
with using cpu_has_osxsave you'd have to force re-execution of
get_cpu_cap() after xsave got enabled on individual CPUs), namely
mmu_cr4_features having X86_CR4_OSXSAVE set.

Additionally, under a hypervisor, CPUID.OSXSAVE may be set (due to
the hypervisor having enabled xsave), while the kernel may be running
with xsave disabled (e.g. due to a command line option saying so).

Thanks, Jan

