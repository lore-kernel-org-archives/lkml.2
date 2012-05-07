Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757325Ab2EGQRY (ORCPT <rfc822;w@1wt.eu>);
	Mon, 7 May 2012 12:17:24 -0400
Received: from s15943758.onlinehome-server.info ([217.160.130.188]:40192 "EHLO
	mail.x86-64.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756814Ab2EGQRW (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 7 May 2012 12:17:22 -0400
Date: Mon, 7 May 2012 18:17:10 +0200
From: Borislav Petkov <bp@amd64.org>
To: Mauro Carvalho Chehab <mchehab@redhat.com>
Cc: Linux Edac Mailing List <linux-edac@vger.kernel.org>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        Doug Thompson <norsk5@yahoo.com>,
        Borislav Petkov <borislav.petkov@amd.com>
Subject: Re: [EDAC_ABI PATCH v13 01/26] amd64_edac: convert driver to use the
 new edac ABI
Message-ID: <20120507161710.GF11462@aftab.osrc.amd.com>
References: <1334607133-30039-1-git-send-email-mchehab@redhat.com>
 <1334607705-30320-1-git-send-email-mchehab@redhat.com>
 <1334607705-30320-2-git-send-email-mchehab@redhat.com>
 <20120507143143.GD11462@aftab.osrc.amd.com>
 <4FA7F468.8070101@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <4FA7F468.8070101@redhat.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, May 07, 2012 at 01:12:24PM -0300, Mauro Carvalho Chehab wrote:
> That happens because the EDAC core couldn't find any EDAC labels for the affected
> memory.
> 
> There are two reasons for seeing a "unknown memory":
> 	1) there's no label information. This is fixed by:
> 	   http://git.kernel.org/?p=linux/kernel/git/mchehab/linux-edac.git;a=commit;h=b14dbb9b8220f8e07634125bf0e315f739cbf501
> 	2) there's no info about the label e. g. something like the old 
> 	   edac_mc_handle_ce_no_info().
> 
> As csrow and channel info is filled on your log, it is very likely to be
> caused by (1) and that you didn't load the labels for this system with edac-ctl.
> 
> If you had a table with the labels for your motherboard at /etc/edac/labels.db
> and run "edac-ctl --load" during your system init (that's the default on RHEL/Fedora,
> not sure what other distros do), the message would be like:
> 
> EDAC MC0: CE amd64_edac on DIMM_4B (csrow 3 channel 1 page 0x5bac7 offset 0x388 grain 0 syndrome 0xb1be )
> 
> > IOW, simply having:
> > 
> > [ 2377.742279] EDAC MC0: CE amd64_edac (csrow:3 channel:1 page:0x5bac7 offset:0x388 grain:0 syndrome:0xb1be)
> > 
> > is much better IMO.
> > 
> > Also, formatting that info with ":" makes the data even easily
> > understandable and parseable.
> 
> Ok. I'll write a patch to replace it at the end of the series.

Why not rebase this patch? Your tree is not merged anywhere yet.

-- 
Regards/Gruss,
Boris.

Advanced Micro Devices GmbH
Einsteinring 24, 85609 Dornach
GM: Alberto Bozzo
Reg: Dornach, Landkreis Muenchen
HRB Nr. 43632 WEEE Registernr: 129 19551
