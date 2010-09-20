Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756872Ab0ITQSY (ORCPT <rfc822;w@1wt.eu>);
	Mon, 20 Sep 2010 12:18:24 -0400
Received: from mail-wy0-f174.google.com ([74.125.82.174]:34199 "EHLO
	mail-wy0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752275Ab0ITQSX convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 20 Sep 2010 12:18:23 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=mime-version:in-reply-to:references:date:message-id:subject:from:to
         :cc:content-type:content-transfer-encoding;
        b=ZZB/MVF8DMLhd3SSivxLtiALD/RgAmaMwFqAptJPvOqaf5M8On52bjzEiIedwoEXfd
         UPFUoctH2yIdUq6m0Hwvf5vP4Rt6nJMrjbCqYlnb7sWTg+nsDnqsQUI7aEbzuL8bfeVV
         OBslNK/Q/NBAogcjgagk5PCnhi8trONraE10o=
MIME-Version: 1.0
In-Reply-To: <1283160144-6848-1-git-send-email-nab@linux-iscsi.org>
References: <1283160144-6848-1-git-send-email-nab@linux-iscsi.org>
Date: Mon, 20 Sep 2010 18:18:21 +0200
Message-ID: <AANLkTimPh+SNroYoavomwVtQ5UHsr7Lsq_229Vkbc1CB@mail.gmail.com>
Subject: Re: [RFC 15/22] tcm: Add FILEIO subsystem plugin
From: Fubo Chen <fubo.chen@gmail.com>
To: "Nicholas A. Bellinger" <nab@linux-iscsi.org>
Cc: linux-scsi <linux-scsi@vger.kernel.org>,
        linux-kernel <linux-kernel@vger.kernel.org>,
        FUJITA Tomonori <fujita.tomonori@lab.ntt.co.jp>,
        Mike Christie <michaelc@cs.wisc.edu>, Christoph Hellwig <hch@lst.de>,
        Hannes Reinecke <hare@suse.de>,
        James Bottomley <James.Bottomley@suse.de>,
        Jens Axboe <axboe@kernel.dk>, Boaz Harrosh <bharrosh@panasas.com>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Aug 30, 2010 at 11:22 AM, Nicholas A. Bellinger
<nab@linux-iscsi.org> wrote:
> From: Nicholas Bellinger <nab@linux-iscsi.org>
>
> This patch adds the O_SYNC FILEIO subsystem plugin for accessing struct file
> using Linux/VFS struct file_operations.  It also includes WriteCache and FUA
> Write Emulation support to struct file using fs/sync.c/vfs_fsync_range()
>
> Signed-off-by: Nicholas A. Bellinger <nab@linux-iscsi.org>
>
> [ ... ]
>
> +static int fd_do_writev(struct fd_request *req, struct se_task *task)
> +{
> +       struct file *fd = req->fd_dev->fd_file;
> +       struct scatterlist *sg = task->task_sg;
> +       struct iovec iov[req->fd_sg_count];

Kernel stack size is 8 KB. On a 64-bit system struct iovec takes 16
bytes. What happens if req->fd_sg_count is large ? Kernel crash ?

Fubo.
