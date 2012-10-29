Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758833Ab2J2MRL (ORCPT <rfc822;w@1wt.eu>);
	Mon, 29 Oct 2012 08:17:11 -0400
Received: from bedivere.hansenpartnership.com ([66.63.167.143]:54612 "EHLO
	bedivere.hansenpartnership.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1754978Ab2J2MRJ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 29 Oct 2012 08:17:09 -0400
Message-ID: <1351513026.2480.4.camel@dabdike.sthat4.btopenzone.com>
Subject: Re: [PATCH] aic7xxx_old: silence GCC warnings
From: James Bottomley <James.Bottomley@HansenPartnership.com>
To: Paul Bolle <pebolle@tiscali.nl>
Cc: linux-scsi@vger.kernel.org, linux-kernel@vger.kernel.org
Date: Mon, 29 Oct 2012 12:17:06 +0000
In-Reply-To: <1351506978.1339.8.camel@x61.thuisdomein>
References: <1348219723.1581.5.camel@x61.thuisdomein>
	 <1351506978.1339.8.camel@x61.thuisdomein>
Content-Type: text/plain; charset="UTF-8"
X-Mailer: Evolution 3.4.4 
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 2012-10-29 at 11:36 +0100, Paul Bolle wrote:
> On Fri, 2012-09-21 at 11:28 +0200, Paul Bolle wrote:
> > Building the aic7xxx_old driver triggers these GCC warnings:
> >     drivers/scsi/aic7xxx_old.c:7901:5: warning: case value '257' not in enumerated type 'ahc_chip' [-Wswitch]
> >     drivers/scsi/aic7xxx_old.c:7898:5: warning: case value '513' not in enumerated type 'ahc_chip' [-Wswitch]
> >     drivers/scsi/aic7xxx_old.c:8517:5: warning: case value '257' not in enumerated type 'ahc_chip' [-Wswitch]
> >     drivers/scsi/aic7xxx_old.c:8510:5: warning: case value '513' not in enumerated type 'ahc_chip' [-Wswitch]
> > 
> > Fix these warnings by adopting the idiom used elsewhere in this driver.
> > Since AHC_EISA and AHC_VL are only ever set for AHC_AIC7770 this fix
> > should not lead to any functional change.
> > 
> > Signed-off-by: Paul Bolle <pebolle@tiscali.nl>
> > ---
> > 0) I noticed these warnings while building v3.6-rc6 on current Fedora
> > 17, using Fedora's default config.
> 
> Identical warnings can be seen while building v3.7-rc3. What's the
> status of my patch? Did anyone found some time to have a look at it?

the aic7xxx_old driver is in deep maintenance; I don't think anyone can
actually test changes to it anymore, so we just keep it around unchanged
for the odd really old card that can't be driven by the current driver.
For this reason, we tend only to do tested bug fixes to it because
no-one will notice if any error is introduced.

mvsas has a maintainer: poke them harder and aic94xx is currently
maintainerless, so it will depend on someone finding the time to test.

James


