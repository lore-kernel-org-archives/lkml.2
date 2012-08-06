Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756080Ab2HFL5o (ORCPT <rfc822;w@1wt.eu>);
	Mon, 6 Aug 2012 07:57:44 -0400
Received: from moutng.kundenserver.de ([212.227.126.171]:63001 "EHLO
	moutng.kundenserver.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756006Ab2HFL5m (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 6 Aug 2012 07:57:42 -0400
From: Arnd Bergmann <arnd@arndb.de>
To: qiang.liu@freescale.com
Subject: Re: [PATCH v6 6/8] fsl-dma: use spin_lock_bh to instead of spin_lock_irqsave
Date: Mon, 6 Aug 2012 11:57:17 +0000
User-Agent: KMail/1.12.2 (Linux/3.5.0; KDE/4.3.2; x86_64; ; )
Cc: linux-crypto@vger.kernel.org, linuxppc-dev@lists.ozlabs.org,
        dan.j.williams@intel.com, linux-kernel@vger.kernel.org,
        dan.j.williams@gmail.com, vinod.koul@intel.com,
        kim.phillips@freescale.com, herbert@gondor.hengli.com.au,
        davem@davemloft.net, gregkh@linuxfoundation.org,
        Li Yang <leoli@freescale.com>, Timur Tabi <timur@freescale.com>
References: <1344249361-10263-1-git-send-email-qiang.liu@freescale.com>
In-Reply-To: <1344249361-10263-1-git-send-email-qiang.liu@freescale.com>
MIME-Version: 1.0
Content-Type: Text/Plain;
  charset="iso-8859-15"
Content-Transfer-Encoding: 7bit
Message-Id: <201208061157.17667.arnd@arndb.de>
X-Provags-ID: V02:K0:R5AdbjTpjqRd6K+wXX7CKw05obfApn+6vpnVFxZOjaP
 g8NwIgTkQVHApm5adOQaK8UsCwOSNdYle0RBbySFCXWDdz1zD8
 KY3r1DuemF4OUGrfBOn7fjuGyK4ZCWSlTUSdIiGJLasujxBz3+
 VRJxV1iGJvocpaK/yjQWeRQV/y4YiTOLOPpJOoTXo9XV5DbHgm
 MV9LfL+feoH4fPAd1fn0aUPM7y8xaLIqiEOVr9UnatXh1lokWA
 5TsBHng6yQIX7nQsrvjjUrINlKLwPOhQtxY3yCtKeHEC/6rac2
 G71T7r4vPDHef4iiQcMQhPYFD/Mnt0BXc2m8nltg52ABofRrhT
 BOsbFmtubjSQpeaiAG88=
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Monday 06 August 2012, qiang.liu@freescale.com wrote:
> 
> From: Qiang Liu <qiang.liu@freescale.com>
> 
> The use of spin_lock_irqsave() is a stronger locking mechanism than is
> required throughout the driver. The minimum locking required should be
> used instead. Interrupts will be turned off and context will be saved,
> there is needless to use irqsave.
> 
> Change all instances of spin_lock_irqsave() to spin_lock_bh().
> All manipulation of protected fields is done using tasklet context or
> weaker, which makes spin_lock_bh() the correct choice.
> 
> Cc: Dan Williams <dan.j.williams@intel.com>
> Cc: Dan Williams <dan.j.williams@gmail.com>
> Cc: Vinod Koul <vinod.koul@intel.com>
> Cc: Li Yang <leoli@freescale.com>
> Cc: Timur Tabi <timur@freescale.com>
> Signed-off-by: Qiang Liu <qiang.liu@freescale.com>
> Acked-by: Ira W. Snyder <iws@ovro.caltech.edu>

Acked-by: Arnd Bergmann <arnd@arndb.de>

You could actually change the use of spin_lock_bh inside of the tasklet
function (dma_do_tasklet) do just spin_lock(), because softirqs are
already disabled there, but your version is also ok.
