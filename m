Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755221Ab1CLSIR (ORCPT <rfc822;w@1wt.eu>);
	Sat, 12 Mar 2011 13:08:17 -0500
Received: from mail-fx0-f46.google.com ([209.85.161.46]:60499 "EHLO
	mail-fx0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753816Ab1CLSIQ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 12 Mar 2011 13:08:16 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=sender:date:from:to:cc:subject:message-id:mime-version:content-type
         :content-disposition:user-agent;
        b=mdj5QCBHg5paBDKWSOtvg4QTKm4p72gfd1EaNtGtdxuc033pTMMg84zWY6LIMUHgei
         Letgx3eTvQQQNky9L7wdjya5n3Ll4nEhPEZCBHhNyAR/kQPySou7zkUZKn0frhDGHkOx
         rBsz96JNMet7WjMEXaie3YvO6QXjWonXNmI5A=
Date: Sat, 12 Mar 2011 21:08:09 +0300
From: Vasiliy Kulikov <segoon@openwall.com>
To: linux-kernel@vger.kernel.org
Cc: Mauro Carvalho Chehab <mchehab@infradead.org>,
        Manjunatha Halli <manjunatha_halli@ti.com>,
        Hans Verkuil <hverkuil@xs4all.nl>, linux-media@vger.kernel.org
Subject: [bug] radio: wl128x: sleep inside of spinlock
Message-ID: <20110312180809.GA17963@albatros>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi,

There is a copy_to_user() call inside of spin_lock_irqsave()/spin_unlock_irqrestore():

drivers/media/radio/wl128x/fmdrv_common.c:

    /* Copies RDS data from internal buffer to user buffer */
    u32 fmc_transfer_rds_from_internal_buff(struct fmdev *fmdev, struct file *file,
            u8 __user *buf, size_t count)
    {
        ...
        spin_lock_irqsave(&fmdev->rds_buff_lock, flags);
        ...
            if (copy_to_user(buf, &fmdev->rx.rds.buff[fmdev->rx.rds.rd_idx],
        ...
        spin_unlock_irqrestore(&fmdev->rds_buff_lock, flags);
        return ret;
    }

-- 
Vasiliy
