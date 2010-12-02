Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757895Ab0LBWzT (ORCPT <rfc822;w@1wt.eu>);
	Thu, 2 Dec 2010 17:55:19 -0500
Received: from cavan.codon.org.uk ([93.93.128.6]:57182 "EHLO
	cavan.codon.org.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753624Ab0LBWzR (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 2 Dec 2010 17:55:17 -0500
Date: Thu, 2 Dec 2010 22:55:11 +0000
From: Matthew Garrett <mjg59@srcf.ucam.org>
To: "Rafael J. Wysocki" <rjw@sisk.pl>
Cc: linux-pci@vger.kernel.org, linux-kernel@vger.kernel.org,
        jbarnes@virtuousgeek.org
Subject: Re: [PATCH] PCI: Disable ASPM if BIOS asks us to
Message-ID: <20101202225511.GA13040@srcf.ucam.org>
References: <1291326904-14822-1-git-send-email-mjg@redhat.com> <201012022324.31760.rjw@sisk.pl> <20101202223135.GA12652@srcf.ucam.org> <201012022351.39815.rjw@sisk.pl>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <201012022351.39815.rjw@sisk.pl>
User-Agent: Mutt/1.5.18 (2008-05-17)
X-SA-Exim-Connect-IP: <locally generated>
X-SA-Exim-Mail-From: mjg59@cavan.codon.org.uk
X-SA-Exim-Scanned: No (on cavan.codon.org.uk); SAEximRunCond expanded to false
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Dec 02, 2010 at 11:51:39PM +0100, Rafael J. Wysocki wrote:
> On Thursday, December 02, 2010, Matthew Garrett wrote:
> > On Thu, Dec 02, 2010 at 11:24:31PM +0100, Rafael J. Wysocki wrote:
> > > > +	if (!aspm_force) {
> > > >  		aspm_disabled = 1;
> > > > +		if (clear)
> > > > +			aspm_clear_state = clear;
> > > 
> > > Well, is the if(clear) really necessary?
> > 
> > If the FADT disables ASPM, and then we fail to get the control bits, 
> > we'd call this twice and turn off aspm_clear_state.
> 
> Ah, thanks.  So if you used a separate function for handling the "BIOS tells
> us there's no ASPM" case, that wouldn't be necessary? ;-)

Yeah. I'll rework and resend - I've also figured out that we need to 
clear the common PM bit.

-- 
Matthew Garrett | mjg59@srcf.ucam.org
