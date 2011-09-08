Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932136Ab1IHDNI (ORCPT <rfc822;w@1wt.eu>);
	Wed, 7 Sep 2011 23:13:08 -0400
Received: from nm5-vm0.bullet.mail.ird.yahoo.com ([77.238.189.207]:25968 "HELO
	nm5-vm0.bullet.mail.ird.yahoo.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with SMTP id S1757952Ab1IHDNG convert rfc822-to-8bit
	(ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 7 Sep 2011 23:13:06 -0400
X-Yahoo-Newman-Property: ymail-3
X-Yahoo-Newman-Id: 727445.27741.bm@omp1016.mail.ird.yahoo.com
X-YMail-OSG: StMR6_gVM1mXHs2zbtUjOWhBjECGK31awAYFArR8eCjTU8V
 jOHf8OuM6n7rjWT5iKgLjArrjRJnj35Gb5Fn6Aj68FV1GeP1mVj64D5u9h7q
 JbyZ1QkcthNJ7ubQwultmBM4rhBdO2gC.qNkdbJTbd319tqpoOq10FSZb2CN
 QSM.1PXF56x1p1N9rI6.q1aojerjZmpqMLRRvAAkeLdCZWEjxm3Bf97yRSBU
 74NTqbwceH8wY7O7rP.64qKLVo_lKbHeRGsGsQZJLLSuLJHVlKpPlkK_5hSz
 TkGCRYR6MmTAdZ5DT1xwS8mW5FxmTZaGQHlnDdieuK0uH7q_jpBF3hcHStZm
 SVSEIAfCvnpNga6IwBRr6aNNOpULkurrrpI5kjjfPWF32kVhtMjO10L_6cNL
 9DBr0kaQH_0bxi_gO2MIN
X-RocketYMMF: hintak_leung
X-Mailer: YahooMailClassic/14.0.5 YahooMailWebService/0.8.113.315625
Message-ID: <1315451581.92826.YahooMailClassic@web29509.mail.ird.yahoo.com>
Date: Thu, 8 Sep 2011 04:13:01 +0100 (BST)
From: Hin-Tak Leung <htl10@users.sourceforge.net>
Reply-To: htl10@users.sourceforge.net
Subject: Re: Kernel 3.1.0-rc4 oops when connecting iPod
To: Pavel Ivanov <paivanof@gmail.com>,
        Seth Forshee <seth.forshee@canonical.com>
Cc: linux-fsdevel@vger.kernel.org, linux-kernel <linux-kernel@vger.kernel.org>,
        Christoph Hellwig <hch@tuxera.com>
In-Reply-To: <20110907175952.GC23829@thinkpad-t410>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

--- On Wed, 7/9/11, Seth Forshee <seth.forshee@canonical.com> wrote:

> Yes, that was definitely just an oversight. Has anyone
> provided a patch
> yet? If not I've pasted a patch below. Seems like a fix
> should be
> applied ASAP.
> 
> 
> From d27825b880028e9a45ba640d86c9e8101db0606b Mon Sep 17
> 00:00:00 2001
> From: Seth Forshee <seth.forshee@canonical.com>
> Date: Wed, 7 Sep 2011 10:38:35 -0700
> Subject: [PATCH] hfsplus: Fix kfree of wrong pointers in
> hfsplus_fill_super() error path
> 
> Commit 6596528 (hfsplus: ensure bio requests are not
> smaller than
> the hardware sectors) changed the pointers used for volume
> header
> allocations but failed to change the pointer freed in the
> error
> path of hfsplus_fill_super(). This patch fixes the
> problem.
> 
> Reported-by: Pavel Ivanov <paivanof@gmail.com>
> Signed-off-by: Seth Forshee <seth.forshee@canonical.com>
> Cc: <stable@kernel.org>

Acked-by: Hin-Tak Leung <htl10@users.sourceforge.net>

Please go ahead and submit the patch.

> ---
>  fs/hfsplus/super.c |    4 ++--
>  1 files changed, 2 insertions(+), 2 deletions(-)
> 
> diff --git a/fs/hfsplus/super.c b/fs/hfsplus/super.c
> index c106ca2..cadbb8c 100644
> --- a/fs/hfsplus/super.c
> +++ b/fs/hfsplus/super.c
> @@ -525,8 +525,8 @@ out_close_cat_tree:
>  out_close_ext_tree:
>      hfs_btree_close(sbi->ext_tree);
>  out_free_vhdr:
> -    kfree(sbi->s_vhdr);
> -    kfree(sbi->s_backup_vhdr);
> +    kfree(sbi->s_vhdr_buf);
> +    kfree(sbi->s_backup_vhdr_buf);
>  out_unload_nls:
>      unload_nls(sbi->nls);
>      unload_nls(nls);
> -- 
> 1.7.4.1
> 
> --
> To unsubscribe from this list: send the line "unsubscribe
> linux-fsdevel" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
> 
