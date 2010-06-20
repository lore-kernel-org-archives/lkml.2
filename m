Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756097Ab0FTRea (ORCPT <rfc822;w@1wt.eu>);
	Sun, 20 Jun 2010 13:34:30 -0400
Received: from mail-vw0-f46.google.com ([209.85.212.46]:38870 "EHLO
	mail-vw0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755875Ab0FTRe1 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 20 Jun 2010 13:34:27 -0400
MIME-Version: 1.0
X-Originating-IP: [72.93.233.2]
In-Reply-To: <1277052831.1548.103.camel@Joe-Laptop.home>
References: <1277018446.1548.66.camel@Joe-Laptop.home>
	<16004456-69D9-41BD-8597-5590BB7B099E@wilsonet.com>
	<1277052831.1548.103.camel@Joe-Laptop.home>
Date: Sun, 20 Jun 2010 13:34:26 -0400
Message-ID: <AANLkTik4LVNFxj7GHs0HDGBA9Rdf0IP7BJmFwfx_qwGz@mail.gmail.com>
Subject: Re: [PATCH] drivers/media/IR/imon.c: Use pr_err instead of err
From: Jarod Wilson <jarod@wilsonet.com>
To: Joe Perches <joe@perches.com>
Cc: Mauro Carvalho Chehab <mchehab@infradead.org>,
       linux-media <linux-media@vger.kernel.org>,
       LKML <linux-kernel@vger.kernel.org>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sun, Jun 20, 2010 at 12:53 PM, Joe Perches <joe@perches.com> wrote:
> On Sun, 2010-06-20 at 11:58 -0400, Jarod Wilson wrote:
>> On Jun 20, 2010, at 3:20 AM, Joe Perches <joe@perches.com> wrote:
>> Use the standard error logging mechanisms.
>> > Add #define pr_fmt(fmt) KBUILD_MODNAME ":%s" fmt, __func__
>> > Remove __func__ from err calls, add '\n', rename to pr_err
>> Eh. If we're going to make a change here, I'd rather it be to using
>> dev_err instead, since most of the other spew in this driver uses
>> similar.
>
> The idea is to eventually remove info/err/warn from usb.h by
> changing the code outside of drivers/usb first.
>
> There will always be some mix of printk or pr_<level> along
> with dev_<level> because struct device * is NULL or as is
> mostly used here there's no struct imon_context * available.
>
> I suggest you have a look and see which ones of these
> changes could use dev_<level> instead.

Ah, tbh, didn't look all that closely. Okay, I'll see if any of them
can actually be made into dev_err instead of pr_err, but any that
can't, sure, there's no problem w/this change.

-- 
Jarod Wilson
jarod@wilsonet.com
