Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753906Ab1GLPpo (ORCPT <rfc822;w@1wt.eu>);
	Tue, 12 Jul 2011 11:45:44 -0400
Received: from smtp106.prem.mail.ac4.yahoo.com ([76.13.13.45]:38114 "HELO
	smtp106.prem.mail.ac4.yahoo.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with SMTP id S1753153Ab1GLPpn (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 12 Jul 2011 11:45:43 -0400
X-Yahoo-SMTP: _Dag8S.swBC1p4FJKLCXbs8NQzyse1SYSgnAbY0-
X-YMail-OSG: R8TAtx8VM1lbwPbUHymsDpuMAzB4wOQi0yyGB8cMfMuF2XE
 px2ZvWNzVHlEjCRiTcZtmoLEPQz1wPfdiqn01BU_.CfK_9VEJ3OZr5oe3zRp
 gIVWZTBFSXT88paFerPOo04G1QSWzS3M7Ed5UNOVV5Wukcli0KphD5W0XRd6
 91gujtEdaA3uzZPtGVOgR4CjM32EP5mR329De7GTwNs3A0UGFYUjYz6JGCnZ
 6J44kVVsbZ_FpHFB9Feb0fI05kLKDKNWN9RFz6ERo9I0T4_rw6ZhEZLf90a4
 tDepxR9m3ECCqiggQ_JFYZfYVsY6OgzFyKyRakiLM4AV00y8-
X-Yahoo-Newman-Property: ymail-3
Date: Tue, 12 Jul 2011 10:45:40 -0500 (CDT)
From: Christoph Lameter <cl@linux.com>
X-X-Sender: cl@router.home
To: Hugh Dickins <hughd@google.com>
cc: Pekka Enberg <penberg@kernel.org>,
        Andrew Morton <akpm@linux-foundation.org>,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH next/mmotm] slab: fix DEBUG_SLAB build
In-Reply-To: <alpine.LSU.2.00.1107111152290.13035@sister.anvils>
Message-ID: <alpine.DEB.2.00.1107121045050.2530@router.home>
References: <alpine.LSU.2.00.1107111152290.13035@sister.anvils>
User-Agent: Alpine 2.00 (DEB 1167 2008-08-23)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; CHARSET=US-ASCII
Content-ID: <alpine.DEB.2.00.1107121045052.2530@router.home>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 11 Jul 2011, Hugh Dickins wrote:

> -#if ARCH_SLAB_MINALIGN
> -	if ((u32)objp & (ARCH_SLAB_MINALIGN-1)) {
> +	if ((unsigned long)objp & (ARCH_SLAB_MINALIGN-1)) {
>  		printk(KERN_ERR "0x%p: not aligned to ARCH_SLAB_MINALIGN=%d\n",

Change %d to %ul for consistencies sake and drop the cast of
ARCH_SLAB_MINALIGN?

