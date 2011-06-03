Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753808Ab1FCQA6 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 3 Jun 2011 12:00:58 -0400
Received: from moutng.kundenserver.de ([212.227.17.9]:55564 "EHLO
	moutng.kundenserver.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751430Ab1FCQA5 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 3 Jun 2011 12:00:57 -0400
From: Arnd Bergmann <arnd@arndb.de>
To: Akinobu Mita <akinobu.mita@gmail.com>
Subject: Re: [PATCH] asm-generic: add another generic ext2 atomic bitops
Date: Fri, 3 Jun 2011 18:00:22 +0200
User-Agent: KMail/1.12.2 (Linux/2.6.37; KDE/4.3.2; x86_64; ; )
Cc: linux-kernel@vger.kernel.org, akpm@linux-foundation.org,
        linux-arch@vger.kernel.org
References: <1306938736-11119-1-git-send-email-akinobu.mita@gmail.com>
In-Reply-To: <1306938736-11119-1-git-send-email-akinobu.mita@gmail.com>
MIME-Version: 1.0
Content-Type: Text/Plain;
  charset="iso-8859-15"
Content-Transfer-Encoding: 7bit
Message-Id: <201106031800.22298.arnd@arndb.de>
X-Provags-ID: V02:K0:tOkbta8SrnaGnghf8G4tnQvQAQkd14w4hAI5zu+LGSM
 98t4zi4TOaTC1jCOKNQq558FF1KRczrtPmjmZPpe9iDicwhMsH
 gXjAjKjUocd6McbQYdAdYIn/d26EuebjQMFMeHUSgkkVToB9TE
 heOBi+rLHcsHtaSYC3j4MEIr62wz4QcnMhcsp0rhfZF0GS/TFL
 xFCOFzRdruqob7YQOQKXQ==
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wednesday 01 June 2011, Akinobu Mita wrote:
> The majority of architectures implement ext2 atomic bitops as
> test_and_{set,clear}_bit() without spinlock.
> 
> This adds this type of generic implementation in ext2-atomic.h and
> use it wherever possible.

The idea sounds really good, but I'm trying to keep the number of
ARCH_* macros low. How about instead providing a new
asm-generic/bitops/ext2-atomic-setbit.h or similar?

Each architecture can then include either the spinlock or the
atomic bitop based version.

	Arnd
