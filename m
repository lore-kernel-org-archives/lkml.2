Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756156Ab2D3PUe (ORCPT <rfc822;w@1wt.eu>);
	Mon, 30 Apr 2012 11:20:34 -0400
Received: from s15943758.onlinehome-server.info ([217.160.130.188]:40561 "EHLO
	mail.x86-64.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752415Ab2D3PUd (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 30 Apr 2012 11:20:33 -0400
Date: Mon, 30 Apr 2012 17:20:24 +0200
From: Borislav Petkov <bp@amd64.org>
To: Mauro Carvalho Chehab <mchehab@redhat.com>
Cc: Borislav Petkov <bp@amd64.org>,
        Linux Edac Mailing List <linux-edac@vger.kernel.org>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        Doug Thompson <norsk5@yahoo.com>, Joe Perches <joe@perches.com>
Subject: Re: [PATCH v2] edac_mc: Cleanup per-dimm_info debug messages
Message-ID: <20120430152024.GK9303@aftab.osrc.amd.com>
References: <4F9E9958.6010606@redhat.com>
 <1335798160-9879-1-git-send-email-mchehab@redhat.com>
 <4F9EAB60.80000@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <4F9EAB60.80000@redhat.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Apr 30, 2012 at 12:10:24PM -0300, Mauro Carvalho Chehab wrote:
> > [  728.430828] EDAC DEBUG: edac_mc_dump_dimm: 	dimm2: channel 0 slot 2 mapped as virtual row 0, chan 2
> > [  728.430834] EDAC DEBUG: edac_mc_dump_dimm: 	dimm->label = 'mc#0channel#0slot#2'
> > [  728.430839] EDAC DEBUG: edac_mc_dump_dimm: 	dimm->nr_pages = 0x0
> > [  728.430846] EDAC DEBUG: edac_mc_dump_dimm: 	dimm->grain = 0
> > [  728.430850] EDAC DEBUG: edac_mc_dump_dimm: 	dimm->nr_pages = 0x0
> 
> Hmm... just noticed that, just like the per-csrow register dumps, this routine
> is called even when empty memories are used (in this case: nr_pages = 0).
> 
> IMHO, as this is a registers dump, the better is to keep it as-is, but it would
> be simple to add a test there - and at edac_mc_dump_csrow() - to just dump it
> when dimm->nr_pages is not 0.
> 
> What do you think?

Or even better, test dimm->nr_pages != 0 before calling
edac_mc_dump_csrow() so that you can save yourself the function call.

Btw, where are the latest versions of your patches so that I can
continue reviewing them?

Thanks.

-- 
Regards/Gruss,
Boris.

Advanced Micro Devices GmbH
Einsteinring 24, 85609 Dornach
GM: Alberto Bozzo
Reg: Dornach, Landkreis Muenchen
HRB Nr. 43632 WEEE Registernr: 129 19551
