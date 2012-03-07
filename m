Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758543Ab2CGNS6 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 7 Mar 2012 08:18:58 -0500
Received: from mx0.aculab.com ([213.249.233.131]:51546 "HELO mx0.aculab.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with SMTP
	id S1758473Ab2CGNS4 convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 7 Mar 2012 08:18:56 -0500
X-MimeOLE: Produced By Microsoft Exchange V6.5
Content-class: urn:content-classes:message
MIME-Version: 1.0
Content-Type: text/plain;
	charset="us-ascii"
Content-Transfer-Encoding: 8BIT
Subject: RE: [PATCH v2] powerpc/srio: Fix the compile errors when building with 64bit
Date: Wed, 7 Mar 2012 13:18:01 -0000
Message-ID: <AE90C24D6B3A694183C094C60CF0A2F6026B6E91@saturn3.aculab.com>
In-Reply-To: <1331124924-18838-1-git-send-email-Gang.Liu@freescale.com>
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
Thread-Topic: [PATCH v2] powerpc/srio: Fix the compile errors when building with 64bit
Thread-Index: Acz8Ye8mTwug4m4eSvO2xH9Uw41SSwAAovMQ
From: "David Laight" <David.Laight@ACULAB.COM>
To: "Liu Gang" <Gang.Liu@freescale.com>, <linuxppc-dev@lists.ozlabs.org>,
        <Alexandre.Bounine@idt.com>
Cc: <r58472@freescale.com>, <linux-kernel@vger.kernel.org>,
        <r61911@freescale.com>, <paul.gortmaker@windriver.com>,
        <akpm@linux-foundation.org>, "Shaohui Xie" <Shaohui.Xie@freescale.com>
X-OriginalArrivalTime: 07 Mar 2012 13:18:02.0122 (UTC) FILETIME=[B936FEA0:01CCFC64]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

> diff --git a/arch/powerpc/sysdev/fsl_rmu.c
b/arch/powerpc/sysdev/fsl_rmu.c
> index 1548578..1bba6d1 100644
> --- a/arch/powerpc/sysdev/fsl_rmu.c
> +++ b/arch/powerpc/sysdev/fsl_rmu.c

> @@ -657,7 +658,8 @@ fsl_add_outb_message(struct rio_mport 
> *mport, struct rio_dev *rdev, int mbox,
>  	int ret = 0;
>  
>  	pr_debug("RIO: fsl_add_outb_message(): destid %4.4x mbox %d
buffer " \
> -		 "%8.8x len %8.8x\n", rdev->destid, mbox, (int)buffer,
len);
> +		 "%8.8lx len %8.8zx\n", rdev->destid, mbox,
> +		(unsigned long)buffer, len);

Should 'buffer' be printed with %p ??

	David


