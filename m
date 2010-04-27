Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754151Ab0D0KZe (ORCPT <rfc822;w@1wt.eu>);
	Tue, 27 Apr 2010 06:25:34 -0400
Received: from mtagate7.uk.ibm.com ([194.196.100.167]:60135 "EHLO
	mtagate7.uk.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753490Ab0D0KZc (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 27 Apr 2010 06:25:32 -0400
Date: Tue, 27 Apr 2010 12:26:11 +0200
From: Heiko Carstens <heiko.carstens@de.ibm.com>
To: Christoph Egger <siccegge@cs.fau.de>
Cc: Martin Schwidefsky <schwidefsky@de.ibm.com>, linux390@de.ibm.com,
       Tim Abbott <tabbott@ksplice.com>, Sam Ravnborg <sam@ravnborg.org>,
       linux-s390@vger.kernel.org, linux-kernel@vger.kernel.org,
       vamos@i4.informatik.uni-erlangen.de
Subject: Re: [PATCH] Doublecheck for CONFIG_64
Message-ID: <20100427102611.GB2670@osiris.boeblingen.de.ibm.com>
References: <20100426140618.GB2710@faui49.informatik.uni-erlangen.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20100426140618.GB2710@faui49.informatik.uni-erlangen.de>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Apr 26, 2010 at 04:06:18PM +0200, Christoph Egger wrote:
> THis is a check for CONFIG_64 inside a block that is only active when
> CONFIG_64 is set. So the check is actually useless and potentially
> irritation.
> 
> --- a/arch/s390/kernel/vdso.c
> +++ b/arch/s390/kernel/vdso.c
> @@ -102,11 +102,7 @@ static void vdso_init_per_cpu_data(int cpu, struct vdso_per_cpu_data *vpcd)
>  /*
>   * Allocate/free per cpu vdso data.
>   */
> -#ifdef CONFIG_64BIT
>  #define SEGMENT_ORDER	2
> -#else
> -#define SEGMENT_ORDER	1
> -#endif

Applied, thanks.
