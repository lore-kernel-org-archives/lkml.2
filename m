Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754055Ab2FFNQV (ORCPT <rfc822;w@1wt.eu>);
	Wed, 6 Jun 2012 09:16:21 -0400
Received: from s15943758.onlinehome-server.info ([217.160.130.188]:42440 "EHLO
	mail.x86-64.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752410Ab2FFNQS (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 6 Jun 2012 09:16:18 -0400
Date: Wed, 6 Jun 2012 15:16:43 +0200
From: Borislav Petkov <bp@amd64.org>
To: Mauro Carvalho Chehab <mchehab@redhat.com>
Cc: Randy Dunlap <rdunlap@xenotime.net>,
        Stephen Rothwell <sfr@canb.auug.org.au>, linux-next@vger.kernel.org,
        LKML <linux-kernel@vger.kernel.org>,
        Doug Thompson <dougthompson@xmission.com>, linux-edac@vger.kernel.org
Subject: Re: linux-next: Tree for Jun 5 (amd64_edac)
Message-ID: <20120606131643.GF1644@aftab.osrc.amd.com>
References: <20120605133000.f2d21fb02881ef54a7bfe728@canb.auug.org.au>
 <4FCE333F.6060207@xenotime.net>
 <4FCE4408.1030506@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <4FCE4408.1030506@redhat.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Jun 05, 2012 at 02:38:16PM -0300, Mauro Carvalho Chehab wrote:
> Thanks for pointing it. The enclosed patch should fix it.
> 
> amd64_edac: Avoid compilation breakage
> 
> when:
> 	CONFIG_EDAC_AMD64=m
> 	CONFIG_EDAC_AMD64_ERROR_INJECTION=y
> 	# CONFIG_EDAC_DEBUG is not set
> 
> The compilation breaks, as amd64_remove_sysfs_dbg_files() were not declared
> as static.
> 
> Signed-off-by: Mauro Carvalho Chehab <mchehab@redhat.com>
> 
> diff --git a/drivers/edac/amd64_edac.h b/drivers/edac/amd64_edac.h
> index 098f336..8d48047 100644
> --- a/drivers/edac/amd64_edac.h
> +++ b/drivers/edac/amd64_edac.h
> @@ -421,7 +421,7 @@ static inline int amd64_create_sysfs_dbg_files(struct mem_ctl_info *mci)
>  {
>  	return 0;
>  }
> -void inline amd64_remove_sysfs_dbg_files(struct mem_ctl_info *mci)
> +static void inline amd64_remove_sysfs_dbg_files(struct mem_ctl_info *mci)

Please merge this one with the previous patch which causes the breakage:

commit faf20d4e226c53a963c384d36d8aa82c77be6dfb
Author: Mauro Carvalho Chehab <mchehab@redhat.com>
Date:   Wed Mar 21 14:00:44 2012 -0300

    amd64_edac: convert sysfs logic to use struct device

    Now that the EDAC core supports struct device, there's no sense
    on having any logic at the EDAC core to simulate it. So, instead
    of adding such logic there, change the logic at amd64_edac to
    use it.

    Reviewed-by: Aristeu Rozanski <arozansk@redhat.com>
    Cc: Doug Thompson <norsk5@yahoo.com>
    Cc: Borislav Petkov <borislav.petkov@amd.com>
    Signed-off-by: Mauro Carvalho Chehab <mchehab@redhat.com>

Thanks.

-- 
Regards/Gruss,
Boris.

Advanced Micro Devices GmbH
Einsteinring 24, 85609 Dornach
GM: Alberto Bozzo
Reg: Dornach, Landkreis Muenchen
HRB Nr. 43632 WEEE Registernr: 129 19551
