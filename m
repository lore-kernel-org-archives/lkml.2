Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755579Ab0FTQx4 (ORCPT <rfc822;w@1wt.eu>);
	Sun, 20 Jun 2010 12:53:56 -0400
Received: from mail.perches.com ([173.55.12.10]:1226 "EHLO mail.perches.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754524Ab0FTQxy (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 20 Jun 2010 12:53:54 -0400
Subject: Re: [PATCH] drivers/media/IR/imon.c: Use pr_err instead of err
From: Joe Perches <joe@perches.com>
To: Jarod Wilson <jarod@wilsonet.com>
Cc: Mauro Carvalho Chehab <mchehab@infradead.org>,
       linux-media <linux-media@vger.kernel.org>,
       LKML <linux-kernel@vger.kernel.org>
In-Reply-To: <16004456-69D9-41BD-8597-5590BB7B099E@wilsonet.com>
References: <1277018446.1548.66.camel@Joe-Laptop.home>
	 <16004456-69D9-41BD-8597-5590BB7B099E@wilsonet.com>
Content-Type: text/plain; charset="UTF-8"
Date: Sun, 20 Jun 2010 09:53:51 -0700
Message-ID: <1277052831.1548.103.camel@Joe-Laptop.home>
Mime-Version: 1.0
X-Mailer: Evolution 2.28.3 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sun, 2010-06-20 at 11:58 -0400, Jarod Wilson wrote:
> On Jun 20, 2010, at 3:20 AM, Joe Perches <joe@perches.com> wrote:
> Use the standard error logging mechanisms.
> > Add #define pr_fmt(fmt) KBUILD_MODNAME ":%s" fmt, __func__
> > Remove __func__ from err calls, add '\n', rename to pr_err
> Eh. If we're going to make a change here, I'd rather it be to using  
> dev_err instead, since most of the other spew in this driver uses  
> similar.

The idea is to eventually remove info/err/warn from usb.h by
changing the code outside of drivers/usb first.

There will always be some mix of printk or pr_<level> along
with dev_<level> because struct device * is NULL or as is
mostly used here there's no struct imon_context * available.

I suggest you have a look and see which ones of these
changes could use dev_<level> instead.

cheers, Joe


