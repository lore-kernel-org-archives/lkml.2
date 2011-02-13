Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754942Ab1BMUmR (ORCPT <rfc822;w@1wt.eu>);
	Sun, 13 Feb 2011 15:42:17 -0500
Received: from mail-in-18.arcor-online.net ([151.189.21.58]:43325 "EHLO
	mail-in-18.arcor-online.net" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1754855Ab1BMUmN (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 13 Feb 2011 15:42:13 -0500
X-DKIM: Sendmail DKIM Filter v2.8.2 mail-in-14.arcor-online.net 889D29BEF2
Message-Id: <E1PoilV-0002pC-6Z@be1.7eggert.dyndns.org>
From: Bodo Eggert 
	<arcoristkaputtundbrauchtdiesentext.7eggert@nurfuerspam.de>
Subject: Re: [PATCH] loop: clear read-only flag in loop_clr_fd.
To: Tao Ma <tm@tao.ma>, linux-kernel@vger.kernel.org,
        Jens Axboe <axboe@kernel.dk>, Tejun Heo <tj@kernel.org>
Reply-To: 7eggert@nurfuerspam.de
Date: Sun, 13 Feb 2011 21:41:51 +0100
References: <glzzr-4Jt-1@gated-at.bofh.it> <glHQm-1vQ-25@gated-at.bofh.it>
User-Agent: KNode/0.10.9
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: 8Bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Tao Ma <tm@tao.ma> wrote:

> --- a/drivers/block/loop.c

> -     if (bdev)
> +     if (bdev) {
> +             set_device_ro(bdev, 0);
>  invalidate_bdev(bdev);
> +     }
>  set_capacity(lo->lo_disk, 0);
>  loop_sysfs_exit(lo);
>  if (bdev) {

This looks like set_device_ro() should imply invalidate_bdev().
-- 
E.G.G.E.R.T.: Electronic Guardian Generated for 
              Efficient Repair and Troubleshooting
        -- http://www.brunching.com/toys/toy-cyborger.html (down)
Friß, Spammer: PanIhbEe3@y.7eggert.dyndns.org iNEC@zy1oe.7eggert.dyndns.org

