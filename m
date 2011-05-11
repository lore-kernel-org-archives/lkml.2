Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755691Ab1ELClx (ORCPT <rfc822;w@1wt.eu>);
	Wed, 11 May 2011 22:41:53 -0400
Received: from mail4.comsite.net ([205.238.176.238]:6649 "EHLO
	mail4.comsite.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751148Ab1ELClw (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 11 May 2011 22:41:52 -0400
X-Default-Received-SPF: pass (skip=forwardok (res=PASS)) x-ip-name=71.22.127.106;
From: Milton Miller <miltonm@bga.com>
Subject: Re: [PATCH] arch/c6x: new architecture port for linux
Date: Wed, 11 May 2011 20:13:51 -0000
To: Mark Salter <msalter@redhat.com>
In-Reply-To: <1305144843-5058-1-git-send-email-msalter@redhat.com>
References: <1305144843-5058-1-git-send-email-msalter@redhat.com>
Message-Id: <c64-naming@mdm.bga.com>
Cc: linux-kernel@vger.kernel.org
X-Originating-IP: 71.22.127.106
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


On Wed, 11 May 2011 around 17:11:19 EST, Mark Salter wrote:
> This patch series adds support for a new architecture (arch/c6x) to
> Linux. This architecture supports members of the Texas Instruments
> family of C64x single and multicore DSPs. The multicore DSPs do not
> support cache coherancy, so are not suitable for SMP. Also, these are
> no-mmu processors. This core architecture is VLIW with an instruction
> set optimized for DSP applications. For details on the processors:

So all the changelogs talk about C64x but the arch and all the configs
are called c6x?  Is it that hard to type 2 digits?   Or do you expect
an additional chip that breaks the C64 but would fit the C6x name?


Also, a couple of one liners while preparing my comments on hvc_c6x:

[09/16] C6X: add kernel files

in kernel/setup.c you include linux/delay.h multiple times



[11/16] C6X: add lib files

arch/c6x/lib/memset.c

(1) file header says linux/arch/c6x/lib/memcmp.c
(you should probably just delete such headers, they are just maintence errors)

(2) it appears to mach lib/string.c implementation except (1) register (2)
uses post-increment instead of pre-increment.   Does it matter with gcc?

arch/c6x/lib/memcmp.c
	your version returns -1 or 1 while string.c returns the difference
after promotion to int.   man page for userspace says just integer less
than or greater, so I guess this is ok.  But is this more efficient,
or could you use the generic version?


milton
