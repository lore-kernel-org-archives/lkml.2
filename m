Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754943Ab1KBJAL (ORCPT <rfc822;w@1wt.eu>);
	Wed, 2 Nov 2011 05:00:11 -0400
Received: from bedivere.hansenpartnership.com ([66.63.167.143]:39394 "EHLO
	bedivere.hansenpartnership.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751325Ab1KBJAJ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 2 Nov 2011 05:00:09 -0400
Subject: re: [SCSI] compat_ioct: fix bsg SG_IO
From: James Bottomley <James.Bottomley@HansenPartnership.com>
To: Dan Carpenter <dan.carpenter@oracle.com>
Cc: FUJITA Tomonori <fujita.tomonori@lab.ntt.co.jp>,
        Giridhar Malavali <giridhar.malavali@qlogic.com>,
        linux-scsi@vger.kernel.org, linux-kernel@vger.kernel.org
In-Reply-To: <20111102081642.GD4751@mwanda>
References: <20111102081642.GD4751@mwanda>
Content-Type: text/plain; charset="UTF-8"
Date: Wed, 02 Nov 2011 12:58:58 +0400
Message-ID: <1320224338.15504.6.camel@dabdike>
Mime-Version: 1.0
X-Mailer: Evolution 2.32.1 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 2011-11-02 at 11:16 +0300, Dan Carpenter wrote:
> 84eb8fb42c120 "[SCSI] compat_ioct: fix bsg SG_IO" introduces an
> uninitialized variable use.
> 
>    278  static int sg_ioctl_trans(unsigned int fd, unsigned int cmd,
>    279                          sg_io_hdr32_t __user *sgio32)
>    280  {
>    281          sg_io_hdr_t __user *sgio;
>    282          u16 iovec_count;
>    283          u32 data;
>    284          void __user *dxferp;
>    285          int err;
>    286          int interface_id;
>    287  
>    288          if (get_user(interface_id, &sgio32->interface_id))
>                                             ^^^^^^
> sgio32 is unitialized here.  Unfortunately Gcc doesn't warn about it.

I don't quite understand what makes you think that: it's passed in as an
argument to the function.  It's a pointer to the userspace 32 bit
representation of the structure.  The use logic is a slightly convoluted
way of saying we only understand the 'S' header but we're going to let
the real ioctl routine say what the error is if it's not type 'S'.

James


