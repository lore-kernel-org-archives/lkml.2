Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757989Ab0LBWw3 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 2 Dec 2010 17:52:29 -0500
Received: from ogre.sisk.pl ([217.79.144.158]:49783 "EHLO ogre.sisk.pl"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754221Ab0LBWw1 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 2 Dec 2010 17:52:27 -0500
From: "Rafael J. Wysocki" <rjw@sisk.pl>
To: Matthew Garrett <mjg59@srcf.ucam.org>
Subject: Re: [PATCH] PCI: Disable ASPM if BIOS asks us to
Date: Thu, 2 Dec 2010 23:51:39 +0100
User-Agent: KMail/1.13.5 (Linux/2.6.37-rc4+; KDE/4.4.4; x86_64; ; )
Cc: linux-pci@vger.kernel.org, linux-kernel@vger.kernel.org,
        jbarnes@virtuousgeek.org
References: <1291326904-14822-1-git-send-email-mjg@redhat.com> <201012022324.31760.rjw@sisk.pl> <20101202223135.GA12652@srcf.ucam.org>
In-Reply-To: <20101202223135.GA12652@srcf.ucam.org>
MIME-Version: 1.0
Content-Type: Text/Plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Message-Id: <201012022351.39815.rjw@sisk.pl>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thursday, December 02, 2010, Matthew Garrett wrote:
> On Thu, Dec 02, 2010 at 11:24:31PM +0100, Rafael J. Wysocki wrote:
> > > +	if (!aspm_force) {
> > >  		aspm_disabled = 1;
> > > +		if (clear)
> > > +			aspm_clear_state = clear;
> > 
> > Well, is the if(clear) really necessary?
> 
> If the FADT disables ASPM, and then we fail to get the control bits, 
> we'd call this twice and turn off aspm_clear_state.

Ah, thanks.  So if you used a separate function for handling the "BIOS tells
us there's no ASPM" case, that wouldn't be necessary? ;-)
