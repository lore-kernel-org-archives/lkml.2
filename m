Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754758Ab2GQO2O (ORCPT <rfc822;w@1wt.eu>);
	Tue, 17 Jul 2012 10:28:14 -0400
Received: from smtp102.prem.mail.ac4.yahoo.com ([76.13.13.41]:29941 "HELO
	smtp102.prem.mail.ac4.yahoo.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with SMTP id S1751420Ab2GQO2N (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 17 Jul 2012 10:28:13 -0400
X-Yahoo-Newman-Property: ymail-3
X-YMail-OSG: vH8UAp8VM1nv3TxUHck0YVWhz_u1bzeYRWuWY0dutHztCci
 _Sv.A9Ari1L0mnKE3sn3C2d51jGB94KL5wBVVfc2vMkSAWEfcIvKVDnaNKdK
 hIx1YYJgTQv9y_GinWtGtD0.0u805c9N2bZ1AWsq9bjnCyKCS0irYWaERj7W
 rGcUwLCUP5En1b459_tUVaDkfY7lh86f8pApp58_oAgeco2LPqPs4x95ImC.
 zeZ8araHFNUCQhx5GczmKOwyF0ZeE.OdKx.GztnHv9v.mG28yubeVlskio_8
 f1hVfgXIauqlcRPXzJIFkWlATEJg8c0oOsZzi4I4tkivoLeSQm03dZg6MOh8
 1_kC354qJ1uL4wWZoAU7aQXOhs2sLPemDkeM39N6wG.CVaq4u1uCKWwQU2Dh
 agEeK_sKuBquSrV5ffHPLvCZIDIBPxJr24.nc
X-Yahoo-SMTP: _Dag8S.swBC1p4FJKLCXbs8NQzyse1SYSgnAbY0-
Date: Tue, 17 Jul 2012 09:28:09 -0500 (CDT)
From: Christoph Lameter <cl@linux.com>
X-X-Sender: cl@router.home
To: Joonsoo Kim <js1304@gmail.com>
cc: akpm@linux-foundation.org, linux-kernel@vger.kernel.org,
        linux-mm@kvack.org, Sasha Levin <levinsasha928@gmail.com>
Subject: Re: [PATCH 2/4 v2] mm: fix possible incorrect return value of
 migrate_pages() syscall
In-Reply-To: <1342528415-2291-2-git-send-email-js1304@gmail.com>
Message-ID: <alpine.DEB.2.00.1207170925250.13599@router.home>
References: <Yes> <1342528415-2291-1-git-send-email-js1304@gmail.com> <1342528415-2291-2-git-send-email-js1304@gmail.com>
User-Agent: Alpine 2.00 (DEB 1167 2008-08-23)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 17 Jul 2012, Joonsoo Kim wrote:

> @@ -1382,6 +1382,8 @@ SYSCALL_DEFINE4(migrate_pages, pid_t, pid, unsigned long, maxnode,
>
>  	err = do_migrate_pages(mm, old, new,
>  		capable(CAP_SYS_NICE) ? MPOL_MF_MOVE_ALL : MPOL_MF_MOVE);
> +	if (err > 0)
> +		err = -EBUSY;
>
>  	mmput(mm);
>  out:

Why not have do_migrate_pages() return EBUSY if we do not need the number
of failed/retried pages?

