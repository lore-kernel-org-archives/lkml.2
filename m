Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755484Ab2JIMJ0 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 9 Oct 2012 08:09:26 -0400
Received: from moutng.kundenserver.de ([212.227.17.10]:57890 "EHLO
	moutng.kundenserver.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752651Ab2JIMJX (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 9 Oct 2012 08:09:23 -0400
From: Arnd Bergmann <arnd@arndb.de>
To: Greg Ungerer <gerg@snapgear.com>
Subject: Re: [PATCH 01/16] ARM: warnings in arch/arm/include/asm/uaccess.h
Date: Tue, 9 Oct 2012 12:08:54 +0000
User-Agent: KMail/1.12.2 (Linux/3.5.0; KDE/4.3.2; x86_64; ; )
Cc: linux-arm-kernel@lists.infradead.org, linux-kernel@vger.kernel.org,
        arm@kernel.org, Greg Ungerer <gerg@uclinux.org>,
        Russell King <rmk+kernel@arm.linux.org.uk>
References: <1349448930-23976-1-git-send-email-arnd@arndb.de> <1349448930-23976-2-git-send-email-arnd@arndb.de> <50726966.5010503@snapgear.com>
In-Reply-To: <50726966.5010503@snapgear.com>
MIME-Version: 1.0
Content-Type: Text/Plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Message-Id: <201210091208.55090.arnd@arndb.de>
X-Provags-ID: V02:K0:LY1sJPkcFOaQTo6DXCfmsfBahytUlM0fBhiYuDRYpZE
 xo7DHKVrVXg7WiQeJzSfq9D7ZXL1gDkTF8eV3fDHqQ918/nUgd
 3Hn4kDaohbLAbssQYR8ldFbw3uUokvKkZP7odkAO5++BnRHtod
 D+hmGRvaZiSWjtdGSoqEqwz9YEngEoFhNTkRFmgvfUZyxWY6ME
 AniZ/IegYDTUCexBHbqOtp6T8SAGiQiNRDpQClPemyS7CXYWhX
 UvkS81EyvkvIw26UlOzF6y6F69AjN3SiEtxH468odrXzPSejzw
 S1auIlCibr7Iiy2gk5N23D9nk5NbrDpfzGqSK7d4CYjfzhls2D
 hT/MecVVEDtfXIf/Ep30=
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Monday 08 October 2012, Greg Ungerer wrote:
> On 06/10/12 00:55, Arnd Bergmann wrote:
> > On NOMMU ARM, the __addr_ok() and __range_ok() macros do not evaluate
> > their arguments, which may lead to harmless build warnings in some
> > code where the variables are not used otherwise. Adding a cast to void
> > gets rid of the warning and does not make any semantic changes.
> >
> > Without this patch, building at91x40_defconfig results in:
> >
> > fs/read_write.c: In function 'rw_copy_check_uvector':
> > fs/read_write.c:684:9: warning: unused variable 'buf' [-Wunused-variable]
> >
> > Signed-off-by: Arnd Bergmann <arnd@arndb.de>
> > Cc: Greg Ungerer <gerg@uclinux.org>
> > Cc: Russell King <rmk+kernel@arm.linux.org.uk>
> 
> Acked-by: Greg Ungerer <gerg@uclinux.org>

Thanks!

> I can pick it up and push to the arm-soc tree.

Well, my idea was that I would prefer the patches go through some other tree
besides arm-soc since they are not really the main purpose for this tree.

The core ARM patches in particular should go through Russell's ARM tree.
I have a few more that come in during the merge window and plan to send
him a pull request for those.

	Arnd
