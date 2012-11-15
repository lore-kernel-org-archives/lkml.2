Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S2993463Ab2KOOjt (ORCPT <rfc822;w@1wt.eu>);
	Thu, 15 Nov 2012 09:39:49 -0500
Received: from moutng.kundenserver.de ([212.227.126.171]:59300 "EHLO
	moutng.kundenserver.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S2993283Ab2KOOjs (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 15 Nov 2012 09:39:48 -0500
From: Arnd Bergmann <arnd@arndb.de>
To: Rob Clark <rob.clark@linaro.org>
Subject: Re: [PATCH] ARM: add get_user() support for 8 byte types
Date: Thu, 15 Nov 2012 14:39:41 +0000
User-Agent: KMail/1.12.2 (Linux/3.5.0; KDE/4.3.2; x86_64; ; )
Cc: "Russell King - ARM Linux" <linux@arm.linux.org.uk>,
        linux-arm-kernel@lists.infradead.org, patches@linaro.org,
        linux-kernel@vger.kernel.org, linux-omap@vger.kernel.org,
        dri-devel@lists.freedesktop.org
References: <1352495853-9790-1-git-send-email-rob.clark@linaro.org> <201211151339.08016.arnd@arndb.de> <CAF6AEGuJReNtwUZX6HVZCE8GHuyEAyC8bM0GqZuVMV1=DrGJVw@mail.gmail.com>
In-Reply-To: <CAF6AEGuJReNtwUZX6HVZCE8GHuyEAyC8bM0GqZuVMV1=DrGJVw@mail.gmail.com>
MIME-Version: 1.0
Content-Type: Text/Plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Message-Id: <201211151439.41393.arnd@arndb.de>
X-Provags-ID: V02:K0:Fv7bnTvXwqxxK1QABDNYQs8ZQGjFVsj8/k8Feke0cXm
 JMvSUxMmvWcuUC2dBGHmqQDsc1VwBQsTUlJM/D6tn+YEPgCFwB
 sUdw9pUh7PibzTzvI8L8nBR7LdAMdU7SUjYvpTlEN1Qp87+AIT
 Q9wBrQ/N+N3iVL9iS/72S4T+Jmq3agyE4dIsS3a60es5RvHy8E
 SQ/9OkUa/eKkf5l5RtVgmKZO2M9lIdwPZfux9G23PKgOz1L+J8
 YfDtVWpeD8TUwqmW397oWR02/KHWF1aW703a8FbUXvID33atI4
 lz4Wh5sdmjOg+V5MEtx/MAPpQL+Mz6+QXB4rDKDMzS7ttIztQH
 JS0EMju4bGGvgvWxllRY=
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thursday 15 November 2012, Rob Clark wrote:
> > I still haven't heard a conclusive argument why we need to use get_user()
> > rather than copy_from_user() in the DRM code. Is this about a fast path
> > where you want to shave off a few cycles for each call, or does this
> > simplify the code structure, or something else?
> 
> well, it is mostly because it seemed like a good idea to first try to
> solve the root issue, rather than having to fix things up in each
> driver when someone from x86-world introduces a 64b get_user()..

As pointed out by hpa earlier, x86-32 doesn't have a 64b get_user
either. I don't think we have a lot of drivers that are used only
on 64-bit x86 and on 32-bit ARM but not on 32-bit x86.

> There are some other arch's that don't have 64b get_user(), but I
> don't think any that have any DRM drivers.  If 64b get_user() is
> really not intended to be supported by all archs, it is better to
> remove it from x86 and the other arch's that do currently support it,
> rather than making it possible to write drivers that are broken on
> some archs.

The majority of architectures we support have PCI and should be able
to build the regular (radeon, nouveau, MGA, VIA, ...) DRM drivers
AFAICT.

	Arnd
