Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753918Ab2BWLyu (ORCPT <rfc822;w@1wt.eu>);
	Thu, 23 Feb 2012 06:54:50 -0500
Received: from mail-iy0-f174.google.com ([209.85.210.174]:65499 "EHLO
	mail-iy0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753656Ab2BWLys (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 23 Feb 2012 06:54:48 -0500
Authentication-Results: mr.google.com; spf=pass (google.com: domain of adobriyan@gmail.com designates 10.43.134.199 as permitted sender) smtp.mail=adobriyan@gmail.com; dkim=pass header.i=adobriyan@gmail.com
MIME-Version: 1.0
In-Reply-To: <20120221210625.89432A014E@akpm.mtv.corp.google.com>
References: <20120221210625.89432A014E@akpm.mtv.corp.google.com>
Date: Thu, 23 Feb 2012 13:54:48 +0200
Message-ID: <CACVxJT9GDB-BXW-B57=_c8s3EtZ=22BEKi8a_0tdr+YDkviYVg@mail.gmail.com>
Subject: Re: + locks-new-proc-lockinfo.patch added to -mm tree
From: Alexey Dobriyan <adobriyan@gmail.com>
To: linux-kernel@vger.kernel.org
Cc: dave@gnu.org, bfields@fieldses.org, ebiederm@xmission.com, matthew@wil.cx,
        viro@zeniv.linux.org.uk
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org
Content-Transfer-Encoding: 8bit
X-MIME-Autoconverted: from base64 to 8bit by nfs id q1NBsw4D030377

On Wed, Feb 22, 2012 at 12:06 AM,  <akpm@linux-foundation.org> wrote:
> +static void lockinfo_get_status(struct seq_file *f, struct file_lock *fl,

All caps sucks.

> + Â  Â  Â  if (fl->fl_type & LOCK_MAND) {
> + Â  Â  Â  Â  Â  Â  Â  seq_printf(f, "Access:\t\t %s\n",
> + Â  Â  Â  Â  Â  Â  Â  Â  Â  Â  Â  Â  Â (fl->fl_type & LOCK_READ)
> + Â  Â  Â  Â  Â  Â  Â  Â  Â  Â  Â  Â  Â ? (fl->fl_type & LOCK_WRITE) ? "RW Â  " : "READ "
> + Â  Â  Â  Â  Â  Â  Â  Â  Â  Â  Â  Â  Â : (fl->fl_type & LOCK_WRITE) ? "WRITE" : "NONE ");

I think using one of --, r-, -w, rw is nicer.
Trailing whitespace, why?

> + Â  Â  Â  } else {
> + Â  Â  Â  Â  Â  Â  Â  seq_printf(f, "Access:\t\t %s\n",
> + Â  Â  Â  Â  Â  Â  Â  Â  Â  Â  Â  Â  Â (lease_breaking(fl))
> + Â  Â  Â  Â  Â  Â  Â  Â  Â  Â  Â  Â  Â ? (fl->fl_type & F_UNLCK) ? "UNLCK" : "READ "
> + Â  Â  Â  Â  Â  Â  Â  Â  Â  Â  Â  Â  Â : (fl->fl_type & F_WRLCK) ? "WRITE" : "READ ");

Trailing whitespace.

> + Â  Â  Â  if (IS_POSIX(fl)) {
> + Â  Â  Â  Â  Â  Â  Â  if (fl->fl_end == OFFSET_MAX)
> + Â  Â  Â  Â  Â  Â  Â  Â  Â  Â  Â  seq_printf(f, "Start-end:\t %Ld-EOF\n\n", fl->fl_start);
> + Â  Â  Â  Â  Â  Â  Â  else
> + Â  Â  Â  Â  Â  Â  Â  Â  Â  Â  Â  seq_printf(f, "Start-end:\t %Ld-%Ld\n\n", fl->fl_start, fl->fl_end);
> + Â  Â  Â  } else {
> + Â  Â  Â  Â  Â  Â  Â  seq_printf(f, "Start-end:\t 0-EOF\n\n");

Separate start/end or range, if you want to keep it on one line.
ÿôèº{.nÇ+‰·Ÿ®‰­†+%ŠËÿ±éİ¶¥Šwÿº{.nÇ+‰·¥Š{±şG«éÿŠ{ayºÊ‡Ú™ë,j­¢f£¢·hšïêÿ‘êçz_è®(­éšŠİ¢j"ú¶m§ÿÿ¾«şG«éÿ¢¸?™¨è­Ú&£ø§~á¶iO•æ¬z·švØ^¶m§ÿÿÃÿ¶ìÿ¢¸?–I¥
