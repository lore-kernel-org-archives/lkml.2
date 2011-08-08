Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751577Ab1HHJIM (ORCPT <rfc822;w@1wt.eu>);
	Mon, 8 Aug 2011 05:08:12 -0400
Received: from mail-iy0-f170.google.com ([209.85.210.170]:36939 "EHLO
	mail-iy0-f170.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750899Ab1HHJII (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 8 Aug 2011 05:08:08 -0400
MIME-Version: 1.0
In-Reply-To: <20110806225202.GO6058@hexapodia.org>
References: <20110806225202.GO6058@hexapodia.org>
Date: Mon, 8 Aug 2011 17:08:07 +0800
Message-ID: <CAM_iQpVDo6U0_hwFCFoLVSVeBtCihZQPhxUS_3N4iz5tfSsoYA@mail.gmail.com>
Subject: Re: powertop "pread cpu0 0xe8 : Bad file descriptor" fixed by CONFIG_MSR
From: =?UTF-8?Q?Am=C3=A9rico_Wang?= <xiyou.wangcong@gmail.com>
To: Andy Isaacson <adi@hexapodia.org>
Cc: linux-kernel@vger.kernel.org
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sun, Aug 7, 2011 at 6:52 AM, Andy Isaacson <adi@hexapodia.org> wrote:
> I hadn't seen this issue discussed on the list, and I don't know of a
> powertop mailing list, so here's what stymied my use of powertop until I
> straced it.
>
> With CONFIG_MSR=n, powertop "1.97-2" (from Debian unstable) on 3.0.1
> (and presumably many other recent kernels) exits at startup with:
>
> pread cpu0 0xe8 : Bad file descriptor
>
> strace shows:
>
> open("/dev/cpu/0/msr", O_RDONLY) = -1 ENOENT (No such file or directory)
> pread(4294967295, 0x7fff4c8347c8, 8, 232) = -1 EBADF (Bad file descriptor)
>

Seems powertop forgot to check the return value of that open().
This is a bug of powertop, not kernel.
