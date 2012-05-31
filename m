Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758236Ab2EaON6 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 31 May 2012 10:13:58 -0400
Received: from smtp101.prem.mail.ac4.yahoo.com ([76.13.13.40]:47594 "HELO
	smtp101.prem.mail.ac4.yahoo.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with SMTP id S1757496Ab2EaON5 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 31 May 2012 10:13:57 -0400
X-Yahoo-Newman-Property: ymail-3
X-YMail-OSG: XzUk4.QVM1m1eS5CZhACniSbohg03p6PmNzzQ1Pm1N5C__Z
 ZaOm2uDo7FMlDklOyddTeJKfs4_sEBKbdW88SRaiMtUM_VuTH7XjSe2VrG9x
 ylI2OIKvjaxEWOsTJ3Ge.x8Q9ELIfkxQ3dfiK1HlxMYbTzzPpU9IQNNZB17.
 XebkEkL2jhFjII0jTMpGDk_vlrPN8DJsQsoxbfP9bRGSZB.Ua_j9XKh8uofH
 tI2H.zgwqqV7kY9S3GKgQDWpZk5UMci.8v0jiMR6lwwCkSAlyjfMgbenbXGn
 muOwjtgu59JXAqcjzZd4ZWzZBh86CO3XF9oRAMA49Aek.mclJEiz.J6hfJRF
 B.e6v1c.MTUpYQyaxq5xnwuqR6zP0ZXFexCVixy5eqfj.Cri8YmbUbZTc4r8
 X
X-Yahoo-SMTP: _Dag8S.swBC1p4FJKLCXbs8NQzyse1SYSgnAbY0-
Date: Thu, 31 May 2012 09:13:51 -0500 (CDT)
From: Christoph Lameter <cl@linux.com>
X-X-Sender: cl@router.home
To: Andi Kleen <andi@firstfloor.org>
cc: linux-kernel@vger.kernel.org, Andi Kleen <ak@linux.intel.com>,
        penberg@kernel.org
Subject: Re: [PATCH] slab/mempolicy: always use local policy from interrupt
 context v3
In-Reply-To: <1338438844-5022-1-git-send-email-andi@firstfloor.org>
Message-ID: <alpine.DEB.2.00.1205310913310.5555@router.home>
References: <1338438844-5022-1-git-send-email-andi@firstfloor.org>
User-Agent: Alpine 2.00 (DEB 1167 2008-08-23)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

>
> slab_node() could access current->mempolicy from interrupt context.
> However there's a race condition during exit where the mempolicy
> is first freed and then the pointer zeroed.
>
> Using this from interrupts seems bogus anyways. The interrupt
> will interrupt a random process and therefore get a random
> mempolicy. Many times, this will be idle's, which noone can change.
>
> Just disable this here and always use local for slab
> from interrupts. I also cleaned up the callers of slab_node a bit
> which always passed the same argument.
>
> I believe the original mempolicy code did that in fact,
> so it's likely a regression.

Reviewed-by: Christoph Lameter <cl@linux.com>

