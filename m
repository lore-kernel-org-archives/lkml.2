Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755869Ab0GCTNk (ORCPT <rfc822;w@1wt.eu>);
	Sat, 3 Jul 2010 15:13:40 -0400
Received: from moutng.kundenserver.de ([212.227.126.187]:56844 "EHLO
	moutng.kundenserver.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755629Ab0GCTNi (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 3 Jul 2010 15:13:38 -0400
From: Arnd Bergmann <arnd@arndb.de>
To: Chris Metcalf <cmetcalf@tilera.com>
Subject: Re: [PATCH] arch/tile: updates to hardwall code from community feedback.
Date: Sat, 3 Jul 2010 21:13:26 +0200
User-Agent: KMail/1.13.5 (Linux/2.6.35-rc3+; KDE/4.4.90; x86_64; ; )
Cc: linux-kernel@vger.kernel.org, linux-arch@vger.kernel.org
References: <201007030217.o632HoK9004030@farm-0002.internal.tilera.com>
In-Reply-To: <201007030217.o632HoK9004030@farm-0002.internal.tilera.com>
MIME-Version: 1.0
Content-Type: Text/Plain;
  charset="iso-8859-15"
Content-Transfer-Encoding: 7bit
Message-Id: <201007032113.26655.arnd@arndb.de>
X-Provags-ID: V01U2FsdGVkX181gFLHMBA12eB9k++UnoCW8Af+hZlh0+TmvHh
 KN5FsFC3FX47uRKIKmEWuZ+OTSvfvO3tm1uBTVu5AtNM+WgZv7
 15Hi+5RJZXmHcV/RSdkrA==
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Friday 02 July 2010 17:45:18 Chris Metcalf wrote:
> 
> This change reflects some feedback from Arnd Bergmann, and also
> fixes a compat issue by removing the requirement that the cpumask
> pointer passed to the ioctl point to memory whose size is a
> multiple of sizeof(long), since that is awkward when userspace
> has a different sizeof(long).
> 
> The compat_ptr() declaration was fixed and used to pass the
> compat_ioctl argument to the normal ioctl.  So far we limit compat
> code to 2GB, so the difference between zero-extend and sign-extend
> (the latter being correct, eventually) had been overlooked.
> 
> Remove the file_to_hardwall() abstractions since they're not
> really needed.

Looks good.

> In addition, use <linux/list_types.h> to simplify hardwall code.
> Instead of using a bogus hardwall_list type, we can now use
> the proper list_head type directly.

It sounds like this is now ending up in linux/types.h,
so you'll have to change that again.

> Signed-off-by: Chris Metcalf <cmetcalf@tilera.com>

Acked-by: Arnd Bergmann <arnd@arndb.de>
