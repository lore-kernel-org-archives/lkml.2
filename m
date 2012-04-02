Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752041Ab2DBMdd (ORCPT <rfc822;w@1wt.eu>);
	Mon, 2 Apr 2012 08:33:33 -0400
Received: from s15943758.onlinehome-server.info ([217.160.130.188]:39115 "EHLO
	mail.x86-64.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750992Ab2DBMdb (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 2 Apr 2012 08:33:31 -0400
Date: Mon, 2 Apr 2012 14:33:23 +0200
From: Borislav Petkov <bp@amd64.org>
To: Mauro Carvalho Chehab <mchehab@redhat.com>
Cc: Linux Edac Mailing List <linux-edac@vger.kernel.org>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH 03/13] edac: Don't initialize csrow's first_page &
 friends when not needed
Message-ID: <20120402123323.GA24238@aftab>
References: <1333039546-5590-1-git-send-email-mchehab@redhat.com>
 <1333039546-5590-4-git-send-email-mchehab@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1333039546-5590-4-git-send-email-mchehab@redhat.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Mar 29, 2012 at 01:45:36PM -0300, Mauro Carvalho Chehab wrote:
> Almost all edac	drivers	initialize first_page, last_page and
> page_mask.

Please call them csrow_info->first_page ... or csrow_info.first_page...
so that we can know of which struct they're members.

> Those vars are used inside the EDAC core, in	order to
> calculate the csrow affected by	an error, by using the routine
> edac_mc_find_csrow_by_page().
> 
> However, very few drivers actually use it:
>         e752x_edac.c
>         e7xxx_edac.c
>         i3000_edac.c
>         i82443bxgx_edac.c
>         i82860_edac.c
>         i82875p_edac.c
>         i82975x_edac.c
>         r82600_edac.c
> 
> There also a few other drivers that have their own calculus
> formula internally using those vars.
> 
> All the others are just wasting time by initializing those
> data.
> 
> While initializing data without using them won't cause any troubles, as
> those information is stored at the wrong place (at csrows structure), it
> is better to remove what is unused, in order to simplify the next patch.
> 
> Signed-off-by: Mauro Carvalho Chehab <mchehab@redhat.com>
> ---
>  drivers/edac/amd64_edac.c   |   38 ++------------------------------------

For the amd64_edac.c bits:

Acked-by: Borislav Petkov <borislav.petkov@amd.com>

-- 
Regards/Gruss,
Boris.

Advanced Micro Devices GmbH
Einsteinring 24, 85609 Dornach
GM: Alberto Bozzo
Reg: Dornach, Landkreis Muenchen
HRB Nr. 43632 WEEE Registernr: 129 19551
