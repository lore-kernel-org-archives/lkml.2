Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756669Ab1HVJIw (ORCPT <rfc822;w@1wt.eu>);
	Mon, 22 Aug 2011 05:08:52 -0400
Received: from mail-iy0-f170.google.com ([209.85.210.170]:64847 "EHLO
	mail-iy0-f170.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753717Ab1HVJIq (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 22 Aug 2011 05:08:46 -0400
MIME-Version: 1.0
In-Reply-To: <1313898848.75462.YahooMailNeo@web162014.mail.bf1.yahoo.com>
References: <1313898848.75462.YahooMailNeo@web162014.mail.bf1.yahoo.com>
Date: Mon, 22 Aug 2011 17:08:46 +0800
Message-ID: <CAM_iQpV7D1s9oisy1Zx6-MeiruEwm3BQ5sg1UqpmraF0BazXuA@mail.gmail.com>
Subject: Re: help for kernel initcall section (init.h)
From: =?UTF-8?Q?Am=C3=A9rico_Wang?= <xiyou.wangcong@gmail.com>
To: Pintu Agarwal <pintu_agarwal@yahoo.com>
Cc: "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org
Content-Transfer-Encoding: 8bit
X-MIME-Autoconverted: from base64 to 8bit by mail.home.local id p7M98txu019673

On Sun, Aug 21, 2011 at 11:54 AM, Pintu Agarwal <pintu_agarwal@yahoo.com> wrote:
> Hi,
>
> I need some help in modifying initcall section in init.h.
>
> That is :
>
> #define __define_initcall(level,fn,id) \
>  static initcall_t __initcall_##fn##id __used \
>  __attribute__((__section__(".initcall" level ".init"))) = fn
>
> I have to create two different kinds (and later more) of init section and use one of them based on some condition.
> For example, I have one init section for normal mode and one init section for charger mode.
> During charger mode, I do not have to execute all the initcall so a charger.initcall is create with lesser init function.
> The charger initcall section is as follows:
> #define __define_charger_initcall(level,fn,id) \
>  static initcall_t __charger_initcall_##fn##id __used \
>  __attribute__((__section__(".charger.initcall" level ".init"))) = fn
>
>
> Now the problem is that during compile time both of them needs to be polulated based on CHARGER_MODE is enabled or disabled.
> How can this decision be taken during compile time under the macro "__define_initcall" ??
>
> Something like :
>
> #define __define_initcall(level,fn,id)     \
>                                                        static initcall_t __initcall_##fn##id __used \
>                                                        __attribute__((__section__(".initcall" level ".init"))) = fn  \
>                                                        #if defined(CHARGER_MODE)  \
>                                                        static initcall_t __charger_initcall_##fn##id __used  \
>                                                        __attribute__((__section__(".charger.initcall" level ".init"))) = fn   \
>                                                        #endif

Hi,

Why not

X_initcall(foo_initcall);
#ifdef CHARGER_MODE
X_initcall(foo_charger_initcall);
#endif

?
���{.n�+�������+%�����ݶ��w��{.n�+����{��G�����{ay�ʇڙ�,j��f���h��������z_�(�階�ݢj"���m������G������?����&���~��iO��z��v�^�m����������?�I�
