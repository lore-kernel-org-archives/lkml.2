Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752932Ab0EJMYx (ORCPT <rfc822;w@1wt.eu>);
	Mon, 10 May 2010 08:24:53 -0400
Received: from mail-gy0-f174.google.com ([209.85.160.174]:41818 "EHLO
	mail-gy0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751885Ab0EJMYv (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 10 May 2010 08:24:51 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=mime-version:in-reply-to:references:date:message-id:subject:from:to
         :cc:content-type;
        b=g7n7m5AneonxO2AybmACEUBGAfjIQqB9TUgwiAuvD5I8hXdw/He7Lm6Dsfo4NGSLac
         Mpa2N8txtx5x1+03vDetFWgQt9jN5u6eZNh1SMfUcvDcD63fKRG95czG95ZhxoCD359y
         GY42nikbHbWCdasUEnY4DApxuivJquwPdSLF4=
MIME-Version: 1.0
In-Reply-To: <20100510115642.GB27497@kernel.dk>
References: <20100510061602.GB2858@localhost.localdomain>
	 <20100510115642.GB27497@kernel.dk>
Date: Mon, 10 May 2010 20:24:49 +0800
Message-ID: <AANLkTilVZpXlY294vzHS5gVf4f1M4fuz_vN17LOpoRxc@mail.gmail.com>
Subject: Re: [PATCH] Block: Check major number before allocate the buffer in 
	register_blkdev()
From: wzt wzt <wzt.wzt@gmail.com>
To: Jens Axboe <jens.axboe@oracle.com>
Cc: linux-kernel@vger.kernel.org
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

the original code use kmalloc() to allocate struct blk_major_name
buffer first,  then find the major number in major_names array. if
found it,  it will kfree() the unused struct blk_major_name buffer,
if register_blkdev() called many times like:
register_blkdev(22, "aa");
....
register_blkdev(22, "aa");
kmalloc()/kfree() will be no need to invoked many times, my point is
that find the major number first, then allocate the buffer will be
better. this patch can handle the special case.

On Mon, May 10, 2010 at 7:56 PM, Jens Axboe <jens.axboe@oracle.com> wrote:
> On Mon, May 10 2010, wzt.wzt@gmail.com wrote:
>> Check major number before allocate the buffer, if the major number is not exist,
>> and the register_blkdev() called many times, kmalloc()/kfree() will be no need
>> to invoked many times. So check the major number before use kmalloc() to allocate
>> the buffer will be better.
>
> This would generally be sound advice for performance oriented code, but
> I can't see it making any difference here.
>
> --
> Jens Axboe
>
>
