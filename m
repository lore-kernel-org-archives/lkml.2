Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757957Ab1FFULV (ORCPT <rfc822;w@1wt.eu>);
	Mon, 6 Jun 2011 16:11:21 -0400
Received: from moutng.kundenserver.de ([212.227.126.171]:65094 "EHLO
	moutng.kundenserver.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756918Ab1FFULR (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 6 Jun 2011 16:11:17 -0400
From: Arnd Bergmann <arnd@arndb.de>
To: Geert Uytterhoeven <geert@linux-m68k.org>
Subject: Re: [PATCH/RFC] m68k/bitops: Make bitmap data pointer of atomic ops volatile
Date: Mon, 6 Jun 2011 22:11:15 +0200
User-Agent: KMail/1.13.6 (Linux/3.0.0-rc1nosema+; KDE/4.6.3; x86_64; ; )
Cc: linux-m68k@vger.kernel.org, Akinobu Mita <akinobu.mita@gmail.com>,
        linux-kernel@vger.kernel.org, Ben Hutchings <ben@decadent.org.uk>
References: <1307390873-29687-1-git-send-email-geert@linux-m68k.org>
In-Reply-To: <1307390873-29687-1-git-send-email-geert@linux-m68k.org>
MIME-Version: 1.0
Content-Type: Text/Plain;
  charset="utf-8"
Content-Transfer-Encoding: 8bit
Message-Id: <201106062211.15247.arnd@arndb.de>
X-Provags-ID: V02:K0:fNSsaN0wIkw3yWWFLxIm3/bgNK/q3QG3MgDURJgt2hs
 nkMdj3Yq8Z9Cz1ABpUt4mwHHD8CUkiR/j+688q4Vgpc4mIfsmm
 wWpT+HwjfVELWl6XKWW49RZdCYZmQHTcHxDocs3duW6hivSpIM
 l4jUXclc+5mkwI2xNfq1y2zcuaU66XLZZoltOJVKdH/zGn94eZ
 rp8TEFd+cISWyV2GKsaZA==
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Monday 06 June 2011 22:07:53 Geert Uytterhoeven wrote:
> 
> This fixes a.o.
> 
> drivers/ide/ide-io.c: In function ‘ide_lock_host’:
> drivers/ide/ide-io.c:415: warning: passing argument 2 of ‘__constant_test_and_set_bit’ discards qualifiers from pointer target type
> drivers/ide/ide-io.c:415: warning: passing argument 2 of ‘__generic_test_and_set_bit’ discards qualifiers from pointer target type
> 
> Suggested-by: Ben Hutchings <ben@decadent.org.uk>
> Signed-off-by: Geert Uytterhoeven <geert@linux-m68k.org>

I think the correct fix would be to mark the variable not volatile, as it
clearly has no business be marked as such. That doesn't mean your patch
is wrong, though. It probably doesn't hurt to do both.

	Arnd
