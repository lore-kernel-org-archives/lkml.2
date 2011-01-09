Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752161Ab1AIA2g (ORCPT <rfc822;w@1wt.eu>);
	Sat, 8 Jan 2011 19:28:36 -0500
Received: from moutng.kundenserver.de ([212.227.126.186]:64275 "EHLO
	moutng.kundenserver.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751358Ab1AIA2f (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 8 Jan 2011 19:28:35 -0500
From: Arnd Bergmann <arnd@arndb.de>
To: "Guan Xuetao" <guanxuetao@mprc.pku.edu.cn>
Subject: Re: [PATCH] asm-generic headers: modify stat.h in include/asm-generic to be applicable to more architectures
Date: Sun, 9 Jan 2011 01:28:25 +0100
User-Agent: KMail/1.12.2 (Linux/2.6.37; KDE/4.3.2; x86_64; ; )
Cc: linux-arch@vger.kernel.org, linux-kernel@vger.kernel.org
References: <024501cbaf37$4e479fd0$ead6df70$@mprc.pku.edu.cn>
In-Reply-To: <024501cbaf37$4e479fd0$ead6df70$@mprc.pku.edu.cn>
MIME-Version: 1.0
Content-Type: Text/Plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Message-Id: <201101090128.25371.arnd@arndb.de>
X-Provags-ID: V02:K0:FqFaC4+DPBjoksP12DDq8oDwBV3RnHcppewFn78tm9F
 ZAz6YQJoRcya9ucIsjAqSGOu9Zr4AdrbPLEac3ePf3Gqp9jcmT
 mfUlJmOadqf3j2/KGAX01xq8O6KFRjznePEltzoOUJJL3+5dzS
 +e69OegtDyVPEqBU2zW7hGPv0q5ExcFdmNgjPLec5+o9QbRr1e
 nMHXfVPnfzDGwxCgbBTHA==
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Saturday 08 January 2011, Guan Xuetao wrote:
> From: Guan Xuetao <guanxuetao@mprc.pku.edu.cn>
> 
>  This patch modifies stat.h in include/asm-generic to be applicable to more architectures.
>  STAT64_HAS_BROKEN_ST_INO is defined in most architecture's asm/stat.h, and it need 
>  32-bit __st_ino member to be defined in different position of 64-bit st_ino member.
>  STAT64_PAD_BEFORE_ST_SIZE is the pad before st_size member, with default value 8 bytes.
>  STAT64_PAD_BEFORE_ST_BLOCKS is the pad before st_blocks member, with default value
>  4 bytes to align the following member to 64-bit.

I'd prefer not to apply this patch. It makes the generic header
significantly more complex, and I can't see a significant benefit.

The existing architectures would all still have to define the macros
you test and also keep defining stuff like __old_kernel_stat, while
risking to introduce bugs while changing to the common header. We've
done similar tricks in other places, where the differences between
architectures are smaller, but this one doesn't seem worth it
unless we can get to the point where we can define struct stat in
linux/stat.h for everyone and only do the macros for the architectures
that need it.

	Arnd
