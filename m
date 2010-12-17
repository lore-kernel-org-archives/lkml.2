Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755105Ab0LRKUM (ORCPT <rfc822;w@1wt.eu>);
	Sat, 18 Dec 2010 05:20:12 -0500
Received: from lo.gmane.org ([80.91.229.12]:44798 "EHLO lo.gmane.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754101Ab0LRKUH (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sat, 18 Dec 2010 05:20:07 -0500
X-Injected-Via-Gmane: http://gmane.org/
To: linux-kernel@vger.kernel.org
From: Francis Galiegue <fgaliegue@gmail.com>
Subject: Re: [PATCH v7 1/7] drivers:media:radio: wl128x: fmdrv common header file
Date: Fri, 17 Dec 2010 11:02:26 +0000 (UTC)
Message-ID: <loom.20101217T115727-612@post.gmane.org>
References: <1292583996-4440-1-git-send-email-manjunatha_halli@ti.com> <1292583996-4440-2-git-send-email-manjunatha_halli@ti.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
X-Complaints-To: usenet@dough.gmane.org
X-Gmane-NNTP-Posting-Host: sea.gmane.org
User-Agent: Loom/3.14 (http://gmane.org/)
X-Loom-IP: 82.235.191.170 (Mozilla/5.0 (X11; U; Linux x86_64; en-US; rv:1.9.2.13) Gecko/20101216 Gentoo Firefox/3.6.13)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

manjunatha_halli <at> ti.com> writes:

[...]
> +
> +#define NO_OF_ENTRIES_IN_ARRAY(array) (sizeof(array) / sizeof(array[0]))
> +

Hello,

There is already ARRAY_SIZE() defined in <linux/kernel.h>. And while we're at
it, git grep '#define ARRAY_SIZE' tells that there are 4 definitions in arch:

arch/powerpc/boot/types.h:#define ARRAY_SIZE(x) (sizeof(x) / sizeof((x)[0]))
arch/um/include/shared/user.h:#define ARRAY_SIZE(x) (sizeof(x) /
sizeof((x)[0]))
arch/x86/boot/boot.h:#define ARRAY_SIZE(x) (sizeof(x) / sizeof(*(x)))
arch/x86/boot/compressed/relocs.c:#define ARRAY_SIZE(x) (sizeof(x) /
sizeof((x)[0]))
include/linux/kernel.h:#define ARRAY_SIZE(arr) (sizeof(arr) / sizeof((arr)[0])  
+ __must_be_array(arr))

Does the __must_be_array() cause trouble with arch/? If not, shouldn't these
definitions be merged?


