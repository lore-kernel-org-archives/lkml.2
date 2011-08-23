Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754598Ab1HWMo4 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 23 Aug 2011 08:44:56 -0400
Received: from moutng.kundenserver.de ([212.227.17.8]:64157 "EHLO
	moutng.kundenserver.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752656Ab1HWMov (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 23 Aug 2011 08:44:51 -0400
From: Arnd Bergmann <arnd@arndb.de>
To: Andi Kleen <andi@firstfloor.org>
Subject: Re: [PATCH] Add a personality to report 2.6.x version numbers
Date: Tue, 23 Aug 2011 14:44:43 +0200
User-Agent: KMail/1.12.2 (Linux/2.6.37; KDE/4.3.2; x86_64; ; )
Cc: torvalds@linux-foundation.org, akpm@linux-foundation.org,
        linux-kernel@vger.kernel.org, Andi Kleen <ak@linux.intel.com>
References: <1313795710-30827-1-git-send-email-andi@firstfloor.org>
In-Reply-To: <1313795710-30827-1-git-send-email-andi@firstfloor.org>
MIME-Version: 1.0
Content-Type: Text/Plain;
  charset="iso-8859-15"
Content-Transfer-Encoding: 7bit
Message-Id: <201108231444.43731.arnd@arndb.de>
X-Provags-ID: V02:K0:yV0Uew/EV79I2hRx0NuNh5HOHMdP2/1+TqWmoBBvxk3
 xgLZ2eArbGOJD2WcjOPneKPHf67D9qyUbSJjcidmbUtxn4KU8e
 Gh7zAKOCUvIS4u9WTjMpPj/nqihO+ig6REy/dR0jSutb05+PqP
 50yJvRKO43BFkj6jnREiNHIRkx3u0yKOKnbbJTh3DO32Ehedfz
 6UxEqT5/etztO3TLf1Iag==
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Saturday 20 August 2011, Andi Kleen wrote:
> I ran into a couple of programs which broke with the new Linux 3.0 version.
> Some of those were binary only. I tried to use LD_PRELOAD to work
> around it, but it was quite difficult and in one case impossible
> because of a mix of 32bit and 64bit executables.

I guess another option would be to add a new sys_newnewuname syscall
and change glibc. You could use symbol versioning so that
old applications continue to see the 2.6.x version numbers, while
anything that is built against a new glibc would see the true
version.
 
> This patch adds a UNAME26 personality that makes the kernel
> report a 2.6.40+x version number instead. The x is the x in 3.x.

Why not just always return 3.6.39 or 2.6.40 hardcoded? If an application
does not understand the concept of future kernel versions, it won't need
to know which future version it's running on.
 
	Arnd
