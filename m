Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756123Ab0JNVWl (ORCPT <rfc822;w@1wt.eu>);
	Thu, 14 Oct 2010 17:22:41 -0400
Received: from moutng.kundenserver.de ([212.227.126.186]:53685 "EHLO
	moutng.kundenserver.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752692Ab0JNVWk (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 14 Oct 2010 17:22:40 -0400
From: Arnd Bergmann <arnd@arndb.de>
To: Chris Metcalf <cmetcalf@tilera.com>
Subject: Re: [PATCH 04/14] arch/tile: change lower bound on syscall error return to -4095
Date: Thu, 14 Oct 2010 23:22:20 +0200
User-Agent: KMail/1.13.5 (Linux/2.6.31-19-generic; KDE/4.5.1; x86_64; ; )
Cc: Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
References: <cover.1287090280.git.cmetcalf@tilera.com> <a4dbc5ee52e8741522a2f87067b80116c6c7a934.1287090286.git.cmetcalf@tilera.com>
In-Reply-To: <a4dbc5ee52e8741522a2f87067b80116c6c7a934.1287090286.git.cmetcalf@tilera.com>
MIME-Version: 1.0
Content-Type: Text/Plain;
  charset="iso-8859-15"
Content-Transfer-Encoding: 7bit
Message-Id: <201010142322.20850.arnd@arndb.de>
X-Provags-ID: V02:K0:njv1KV/4Awr0vaNCXF1GNnYwGvla0IIsu78QqF6s6tt
 YwdNLsR1WJnIx3VMLl7i9ZViHbsUWrH2ClvuQl8+RxoJtu2Noq
 BkqeeT3vB4rX00wRZKArTscQb24yRWwTgUswYJx5QqmX78DLxm
 IVgovbaM5aQn2EpkI0UPKQDu6sAdo6ayhWI0SVdbYOPFjZWCzw
 Wt9M1cs5SLG460tPvnN/w==
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thursday 14 October 2010 21:14:29 Chris Metcalf wrote:
> Previously we were using -1023, which is fine for normal syscall
> error returns, but the common value in use for other platforms
> is -4095, and one Tilera-specific driver does use values in the
> -1100 range, so tickled this bug.

The patch is ok, but note that any value above starting at 512 is meant
as kernel internal, so funny things may happen if a driver goes
beyond that for errors returned to the user.

Better use just the predefined error codes if possible.

	Arnd
