Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756417Ab1G2NAQ (ORCPT <rfc822;w@1wt.eu>);
	Fri, 29 Jul 2011 09:00:16 -0400
Received: from moutng.kundenserver.de ([212.227.126.187]:56770 "EHLO
	moutng.kundenserver.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756327Ab1G2NAO (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 29 Jul 2011 09:00:14 -0400
From: Arnd Bergmann <arnd@arndb.de>
To: linux-arm-kernel@lists.infradead.org
Cc: Tomasz Figa <tomasz.figa@gmail.com>,
        Russell King - ARM Linux <linux@arm.linux.org.uk>,
        linux-samsung-soc@vger.kernel.org, Kukjin Kim <kgene.kim@samsung.com>,
        "'Ben Dooks'" <ben-linux@fluff.org>, linux-kernel@vger.kernel.org,
        Michal Marek <mmarek@suse.cz>, linux-kbuild@vger.kernel.org
Subject: Re: Question about "Inconsistent kallsyms data"
Date: Fri, 29 Jul 2011 15:00:03 +0200
Message-ID: <1338073.oTaTOFP5NR@wuerfel>
User-Agent: KMail/4.6.0 (Linux/3.0.0-rc1nosema+; KDE/4.6.90; x86_64; ; )
In-Reply-To: <1514384.7oMe1aulyC@flatron>
References: <02ae01cc4d91$aed71670$0c854350$%kim@samsung.com> <2563791.8cBqodrk1o@flatron> <1514384.7oMe1aulyC@flatron>
MIME-Version: 1.0
Content-Transfer-Encoding: 7Bit
Content-Type: text/plain; charset="us-ascii"
X-Provags-ID: V02:K0:qoW2O1+EXp7JPiHzHtIjnIEKqJTm+K4a0Z5BM2NAJfe
 wnj7lin2t4CguAib9wbRAfR9fOtMnOFyzQ4qtH+9QxMusAZZKt
 845BEfq6uSn9seRrf1fwgHNA08a9DgejyERfAIUgHIp5gN6icd
 bbpBFnfzn9oOd0b1qlvL01fVRd81uFzanGQOSt9l+SnuscALYN
 3FAgokwhwkvaRgWmC2lnQ==
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Friday 29 July 2011 13:30:20 Tomasz Figa wrote:
> 
> I have no idea why, but I cannot reproduce the issue anymore, even after make 
> distclean or starting with a clean tree. A build system bug?
> 
> I do not know much technical details about the kernel build system, but might 
> it be a concurrency issue (I use make -j5 for building with 5 jobs)?

I could reproduce it on some systems, but it changes when you switch compiler
versions or other flags, or the exact kernel version, so it's impossible
to bisect if you have the same problem that I saw.

I got all the way to the point where I could add a nop instruction in one
file and it would go away because the code size grew across some magic
number.

	Arnd
