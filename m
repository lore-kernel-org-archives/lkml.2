Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752747Ab1HPCKq (ORCPT <rfc822;w@1wt.eu>);
	Mon, 15 Aug 2011 22:10:46 -0400
Received: from smtp1.linux-foundation.org ([140.211.169.13]:35397 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751404Ab1HPCKq (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 15 Aug 2011 22:10:46 -0400
MIME-Version: 1.0
In-Reply-To: <20110815101846.58809a89.rdunlap@xenotime.net>
References: <CA+55aFycTvbuNzdgbHjoiNkTeDpzgu6Yf=vx9DU+PDOtC_17zA@mail.gmail.com>
 <20110815101846.58809a89.rdunlap@xenotime.net>
From: Linus Torvalds <torvalds@linux-foundation.org>
Date: Mon, 15 Aug 2011 19:09:57 -0700
Message-ID: <CA+55aFxsOMc9=p02r8-QhJ=h=Mqwckk4_Pnx9LQt5+fqMp_exQ@mail.gmail.com>
Subject: Re: [PATCH 3.1-rc2] x86: fix mm/fault.c build
To: Randy Dunlap <rdunlap@xenotime.net>, Andy Lutomirski <luto@mit.edu>,
        Peter Anvin <hpa@linux.intel.com>
Cc: x86@kernel.org, Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Aug 15, 2011 at 10:18 AM, Randy Dunlap <rdunlap@xenotime.net> wrote:
> From: Randy Dunlap <rdunlap@xenotime.net>
>
> arch/x86/mm/fault.c needs to include asm/vsyscall.h to fix a
> build error:
>
> arch/x86/mm/fault.c: In function '__bad_area_nosemaphore':
> arch/x86/mm/fault.c:728: error: 'VSYSCALL_START' undeclared (first use in this function)

Grr. This seems to be one of those "under certain configurations
only". I can trigger it with "allnoconfig", but not with my common
configuration or "allmodconfig"

I just don't see *why* it ends up being config-related. Can anybody
fill me in? It looks like some header file does a conditional include
of fixmap.h or something. Urgh. I *hate* those kinds of "some configs
work" cases.

              Linus
