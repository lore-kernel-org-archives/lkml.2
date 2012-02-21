Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755001Ab2BUUQo (ORCPT <rfc822;w@1wt.eu>);
	Tue, 21 Feb 2012 15:16:44 -0500
Received: from mail-yx0-f174.google.com ([209.85.213.174]:53605 "EHLO
	mail-yx0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752777Ab2BUUQm convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 21 Feb 2012 15:16:42 -0500
Authentication-Results: mr.google.com; spf=pass (google.com: domain of airlied@gmail.com designates 10.236.174.106 as permitted sender) smtp.mail=airlied@gmail.com; dkim=pass header.i=airlied@gmail.com
MIME-Version: 1.0
In-Reply-To: <201202212112.26663.toralf.foerster@gmx.de>
References: <201202212112.26663.toralf.foerster@gmx.de>
Date: Tue, 21 Feb 2012 20:16:42 +0000
Message-ID: <CAPM=9tynF-NiNdk=AyJYBz_=x3bQi_-T8i+LXYL+08rBE8XYDw@mail.gmail.com>
Subject: Re: compile error in drivers/gpu/drm/radeon/radeon_state.o
From: Dave Airlie <airlied@gmail.com>
To: =?ISO-8859-1?Q?Toralf_F=F6rster?= <toralf.foerster@gmx.de>
Cc: dri-devel@lists.freedesktop.org, linux-kernel@vger.kernel.org
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

2012/2/21 Toralf Förster <toralf.foerster@gmx.de>:
>
> Hello,
>
> the build of latest git (.config attached) failed, make ends with :
> ...
>  CC [M]  drivers/gpu/drm/radeon/radeon_cp.o
>  CC [M]  drivers/gpu/drm/radeon/radeon_state.o
> In file included from /home/tfoerste/devel/linux/arch/x86/include/asm/uaccess.h:573:0,
>                 from include/drm/drmP.h:64,
>                 from drivers/gpu/drm/radeon/radeon_state.c:30:
> In function 'copy_from_user',
>    inlined from 'radeon_cp_clear' at drivers/gpu/drm/radeon/radeon_state.c:2171:6:
> /home/tfoerste/devel/linux/arch/x86/include/asm/uaccess_32.h:211:26: error: call to 'copy_from_user_overflow' declared with attribute error:
> copy_from_user() buffer size is not provably correct
> make[4]: *** [drivers/gpu/drm/radeon/radeon_state.o] Error 1
> make[3]: *** [drivers/gpu/drm/radeon] Error 2
> make[2]: *** [drivers/gpu/drm] Error 2
> make[1]: *** [drivers/gpu] Error 2
> make: *** [drivers] Error 2
>
turn off CONFIG_DEBUG_STRICT_USER_COPY_CHECKS

Its a bug in gcc's checks code.

Dave.
