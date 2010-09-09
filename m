Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756704Ab0IIANe (ORCPT <rfc822;w@1wt.eu>);
	Wed, 8 Sep 2010 20:13:34 -0400
Received: from smtp1.linux-foundation.org ([140.211.169.13]:37256 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751385Ab0IIAN1 convert rfc822-to-8bit
	(ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 8 Sep 2010 20:13:27 -0400
MIME-Version: 1.0
In-Reply-To: <20100830184620.GA4818@core2.telecom.by>
References: <20100830184620.GA4818@core2.telecom.by>
From: Linus Torvalds <torvalds@linux-foundation.org>
Date: Wed, 8 Sep 2010 17:12:37 -0700
Message-ID: <AANLkTikyv10vkg1g+G3LW+nu=0omBpc40KehOUH=YXk2@mail.gmail.com>
Subject: Re: 2.6.36-rc3: EIP is at scsi_init_io+...
To: Alexey Dobriyan <adobriyan@gmail.com>,
        FUJITA Tomonori <fujita.tomonori@lab.ntt.co.jp>,
        Jens Axboe <jaxboe@fusionio.com>
Cc: akpm@linux-foundation.org, James.Bottomley@suse.de,
        linux-scsi@vger.kernel.org, linux-kernel@vger.kernel.org
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hmm. No noise about this one.

Jens, Fujita, James, any comments?

On Mon, Aug 30, 2010 at 11:46 AM, Alexey Dobriyan <adobriyan@gmail.com> wrote:
> Not much of a calltrace, it scrolled away because of hardlockup detector.
> On the bright side, radeon KMS worked correctly and actually showed it.
>
> $ addr2line -e vmlinux ffffffff812d207b
> drivers/scsi/scsi_lib.c:1015
>
>  1012  err_exit:
>  1013          scsi_release_buffers(cmd);
>  1014          scsi_put_command(cmd);
>  1015  ===>    cmd->request->special = NULL; <===
>  1016          return error;
>  1017  }
>  1018  EXPORT_SYMBOL(scsi_init_io);

I do have to say that it looks rather wrong that it accesses "cmd"
after it has done the "scsi_put_command(cmd)" on it.

I also note that that was introduced pretty recently by commit
610a63498f7 ("scsi: fix discard page leak"), merged during this merge
window. That does look suspicious to me.

                    Linus
