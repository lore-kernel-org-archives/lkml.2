Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754730Ab1E3HAT (ORCPT <rfc822;w@1wt.eu>);
	Mon, 30 May 2011 03:00:19 -0400
Received: from moutng.kundenserver.de ([212.227.17.9]:63012 "EHLO
	moutng.kundenserver.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752096Ab1E3HAR (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 30 May 2011 03:00:17 -0400
From: Arnd Bergmann <arnd@arndb.de>
To: Mike Frysinger <vapier@gentoo.org>
Subject: Re: [PATCH/RFC] asm-generic/mutex-dec.h: add SMP support
Date: Mon, 30 May 2011 09:00:02 +0200
User-Agent: KMail/1.13.5 (Linux/2.6.39-rc4+; KDE/4.5.1; x86_64; ; )
Cc: linux-kernel@vger.kernel.org, Andrew Morton <akpm@linux-foundation.org>,
        linux-arch@vger.kernel.org, uclinux-dist-devel@blackfin.uclinux.org
References: <1306725568-10922-1-git-send-email-vapier@gentoo.org>
In-Reply-To: <1306725568-10922-1-git-send-email-vapier@gentoo.org>
MIME-Version: 1.0
Content-Type: Text/Plain;
  charset="iso-8859-15"
Content-Transfer-Encoding: 7bit
Message-Id: <201105300900.02884.arnd@arndb.de>
X-Provags-ID: V02:K0:5xCHeqY4i6UmpGJz9GZEu92gltk9ojFr0gCvy4hXM3M
 P2euTswlKmmYW+DQopo3BOeF9nMEdfCb9UDWlNScDUwAf7udRj
 f3C3N7WT8tUUOxLSMdiOPSimA5zN9QGDUbTGHpsr1szkG43ji+
 RoQakLhOfuKyP22WHLLCTNkos4fuSNM5QrmzRtDa0Lec6cH8W3
 j43bPnOF1Yj7Pnf6cuh5w==
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Monday 30 May 2011 05:19:28 Mike Frysinger wrote:
> To make these guys work on SMP systems, we just need to sprinkle a few
> barriers around.
> 
> Signed-off-by: Mike Frysinger <vapier@gentoo.org>
> ---
> note: this is what the Blackfin SMP port is using, but it doesn't seem
> like other SMP ports are ... so I wonder if we're just trying too hard
> and these barriers aren't actually necessary ?

On some architectures, atomic instructions are implicit barriers. On
others, the cmpxchg() macro contains a barrier. I'm not sure if there
is other code relying on that.

	Arnd
