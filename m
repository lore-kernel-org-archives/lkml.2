Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757312Ab1FUSDT (ORCPT <rfc822;w@1wt.eu>);
	Tue, 21 Jun 2011 14:03:19 -0400
Received: from mo-p00-ob.rzone.de ([81.169.146.160]:58357 "EHLO
	mo-p00-ob.rzone.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757150Ab1FUSDR (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 21 Jun 2011 14:03:17 -0400
X-RZG-AUTH: :O2kGeEG7b/pS1EO8W3C+nMaWotNRcyCeCTTmQgOI2iYXpKw2M5aRJ08f0lpVYriOzQ==
X-RZG-CLASS-ID: mo00
Subject: Re: [PATCH 1/1] drm/radeon: Fix Asus M2A-VM HDMI EDID error
 flooding problem
From: Thomas Reim <thomas.reim@nepomuc.de>
To: Alex Deucher <alexdeucher@gmail.com>
Cc: Thomas Reim <reimth@googlemail.com>, Dave Airlie <airlied@redhat.com>,
        Mario Kleiner <mario.kleiner@tuebingen.mpg.de>,
        Jean Delvare <khali@linux-fr.org>,
        Tyson Whitehead <twhitehead@gmail.com>,
        Jason Wessel <jason.wessel@windriver.com>,
        dri-devel@lists.freedesktop.org, linux-kernel@vger.kernel.org,
        Thomas Reim <rdratlos@yahoo.co.uk>
In-Reply-To: <BANLkTi=cna6rLmwLCcPZsR-AMZKp4HVPDg@mail.gmail.com>
References: <1308670305-7096-1-git-send-email-rdratlos@yahoo.co.uk>
	 <BANLkTi=cna6rLmwLCcPZsR-AMZKp4HVPDg@mail.gmail.com>
Content-Type: text/plain; charset="UTF-8"
Date: Tue, 21 Jun 2011 20:03:03 +0200
Message-ID: <1308679383.5981.7.camel@Mark-Aurel.gas.de>
Mime-Version: 1.0
X-Mailer: Evolution 2.30.3 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Dear Alex, 

yes, the proposed fix should also fix the 'drm/radeon: workaround a hw
bug on some radeon chipsets with all-0 EDIDs.' issue. The trick is, that
we check within the Radeon domain directly on i2c interface level, if an
EDID can be retrieved at all, before we hand over to the main drm edid
functions. 

If you can provide some logs from Dave, I can double-check.

Regards,

  Thomas

> On Tue, Jun 21, 2011 at 11:31 AM, Thomas Reim <reimth@googlemail.com> wrote:
> > Some integrated ATI Radeon chipset implementations
> > (e. g. Asus M2A-VM HDMI) indicate the availability
> > of a DDC even when there's no monitor connected.
> > In this case, drm_get_edid and drm_edid_block_valid
> > periodically dump data and kernel errors into system
> > log files and onto terminals, which lead to an unacceptable
> > system behaviour.
> >
> > Tested since kernel 2.35 on Asus M2A-VM HDMI board
> >
> > Signed-off-by: Thomas Reim <rdratlos@yahoo.co.uk>
> 
> Does this patch fix the issue:
> http://git.kernel.org/?p=linux/kernel/git/airlied/drm-2.6.git;a=commitdiff;h=4a9a8b71e12d41abb71c4e741bff524f016cfef4
> 
> Alex
> 
> > ---
> >  drivers/gpu/drm/radeon/radeon_connectors.c |   10 +++++
> >  drivers/gpu/drm/radeon/radeon_display.c    |   11 +++++
> >  drivers/gpu/drm/radeon/radeon_i2c.c        |   60 ++++++++++++++++++++++++++++
> >  drivers/gpu/drm/radeon/radeon_mode.h       |    1 +
> >  4 files changed, 82 insertions(+), 0 deletions(-)
> >


