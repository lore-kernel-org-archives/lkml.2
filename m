Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751628Ab2HZEtn (ORCPT <rfc822;w@1wt.eu>);
	Sun, 26 Aug 2012 00:49:43 -0400
Received: from moutng.kundenserver.de ([212.227.17.10]:56578 "EHLO
	moutng.kundenserver.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750939Ab2HZEtk (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 26 Aug 2012 00:49:40 -0400
From: Arnd Bergmann <arnd@arndb.de>
To: Catalin Marinas <catalin.marinas@arm.com>
Subject: Re: [PATCH v2 21/31] arm64: 32-bit (compat) applications support
Date: Sun, 26 Aug 2012 04:49:32 +0000
User-Agent: KMail/1.12.2 (Linux/3.5.0; KDE/4.3.2; x86_64; ; )
Cc: "linux-arch@vger.kernel.org" <linux-arch@vger.kernel.org>,
        "linux-arm-kernel@lists.infradead.org" 
	<linux-arm-kernel@lists.infradead.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        Will Deacon <Will.Deacon@arm.com>
References: <1344966752-16102-1-git-send-email-catalin.marinas@arm.com> <201208151434.05145.arnd@arndb.de> <20120824104338.GI7585@arm.com>
In-Reply-To: <20120824104338.GI7585@arm.com>
MIME-Version: 1.0
Content-Type: Text/Plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Message-Id: <201208260449.32807.arnd@arndb.de>
X-Provags-ID: V02:K0:w+DVwFf6aJpHEiaAH6ojht/7gpEUogaCE+awttFZJNP
 fQSSd+t3xwJJM7ydwyduN7xP/T9Z9BvUeksOA4/B563Dp+hich
 QCJj7aChYvthADkRkJUECqqd6PNeOG057pxZzYR8hanV/ayHxL
 hQ85k0cPGQJaLedc3BzCkQXlTGJZVV+ZOe79Yrp3dwtZezikJp
 DgEe5KsemMhBCC8G6PDbJiqeP32nIdWtC66ysXqA8HPx1twdBL
 rTlPuLNNaKhfVRJsSvefJHzMxBu9LJWlKwt7zoEOZwTKhCqa1G
 dGrlQlzHwB5InfZbtOlUsVg4gQ3VSevWxkHDr7gGNVPr+1njLJ
 zAapP6Kc7ASV1psDnuDs=
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Friday 24 August 2012, Catalin Marinas wrote:
> > What good is the run-time BUG() here? Nothing should be calling these
> > when CONFIG_COMPAT is disabled, so I think you should just remove
> > the #ifdef around the declarations, and the entire #else case.
> 
> They are called from handle_signal(), so that's to avoid #ifdef inside
> functions. I can drop the BUG() (but keep the empty function) and
> change the checks to is_compat_task() so that the compiler optimises the
> condition out when !COMPAT.
> 

Sounds good. Note that you can turn a lot of #ifdef into
if(IS_ENABLED(CONFIG_FOO)) as well, even if there is no other runtime
check for them.

	Arnd
