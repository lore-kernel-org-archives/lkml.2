Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753110Ab0FZJ4k (ORCPT <rfc822;w@1wt.eu>);
	Sat, 26 Jun 2010 05:56:40 -0400
Received: from moutng.kundenserver.de ([212.227.17.8]:65411 "EHLO
	moutng.kundenserver.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752503Ab0FZJ4j (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 26 Jun 2010 05:56:39 -0400
From: Arnd Bergmann <arnd@arndb.de>
To: Chris Metcalf <cmetcalf@tilera.com>
Subject: Re: [PATCH] arch/tile: Miscellaneous cleanup changes.
Date: Sat, 26 Jun 2010 11:56:28 +0200
User-Agent: KMail/1.12.2 (Linux/2.6.31-19-generic; KDE/4.3.2; x86_64; ; )
Cc: linux-kernel@vger.kernel.org
References: <201006252110.o5PLArqD010774@farm-0002.internal.tilera.com>
In-Reply-To: <201006252110.o5PLArqD010774@farm-0002.internal.tilera.com>
MIME-Version: 1.0
Content-Type: Text/Plain;
  charset="iso-8859-15"
Content-Transfer-Encoding: 7bit
Message-Id: <201006261156.28495.arnd@arndb.de>
X-Provags-ID: V01U2FsdGVkX1+syntZPGjKOsgnGDtGSen+Xyu8BGbG2qwpV7L
 Gc54r24eO3KULst57Bbz7QFWbTj/Bk+GYohPXn1C2zmuRM3lug
 G0iCJGf5bYGkrvCRUXxKQ==
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Friday 25 June 2010, Chris Metcalf wrote:
> This commit is primarily changes caused by reviewing "sparse"
> and "checkpatch" output on our sources, so is somewhat noisy, since
> things like "printk() -> pr_err()" (or whatever) throughout the
> codebase tend to get tedious to read.  Rather than trying to tease
> apart precisely which things changed due to which type of code
> review, this commit includes various cleanups in the code:
> 
> - sparse: Add declarations in headers for globals.
> - sparse: Fix __user annotations.
> - sparse: Using gfp_t consistently instead of int.
> - sparse: removing functions not actually used.
> - checkpatch: Clean up printk() warnings by using pr_info(), etc.;
>   also avoid partial-line printks except in bootup code.
>   - checkpatch: Use exposed structs rather than typedefs.
>   - checkpatch: Change some C99 comments to C89 comments.
> 
> In addition, a couple of minor other changes are rolled in
> to this commit:
> 
> - Add support for a "raise" instruction to cause SIGFPE, etc., to be raised.
> - Remove some compat code that is unnecessary when we fully eliminate
>   some of the deprecated syscalls from the generic syscall ABI.
> - Update the tile_defconfig to reflect current config contents.
> 
> Signed-off-by: Chris Metcalf <cmetcalf@tilera.com>

Hi Chris,

As far as I can tell, all the changes in this patch look reasonable, but
as a rule you should never mix functional changes and cleanups in a single
patch. This is both for review purposes as well as for being able to bisect
specific regressions that might be introduced by the patch.

	Arnd
