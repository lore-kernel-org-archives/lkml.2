Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753489Ab2HMVgL (ORCPT <rfc822;w@1wt.eu>);
	Mon, 13 Aug 2012 17:36:11 -0400
Received: from cavan.codon.org.uk ([93.93.128.6]:59109 "EHLO
	cavan.codon.org.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752122Ab2HMVgJ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 13 Aug 2012 17:36:09 -0400
Date: Mon, 13 Aug 2012 22:36:07 +0100
From: Matthew Garrett <mjg59@srcf.ucam.org>
To: linux-kernel@vger.kernel.org, platform-driver-x86@vger.kernel.org,
        Bernhard Froemel <froemel@vmars.tuwien.ac.at>
Subject: Re: [PATCH 2/2] apple_gmux: Add support for newer hardware
Message-ID: <20120813213607.GB27838@srcf.ucam.org>
References: <1344889232-3907-1-git-send-email-mjg@redhat.com>
 <1344889232-3907-2-git-send-email-mjg@redhat.com>
 <20120813210444.GJ24088@thinkpad-t410>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20120813210444.GJ24088@thinkpad-t410>
User-Agent: Mutt/1.5.20 (2009-06-14)
X-SA-Exim-Connect-IP: <locally generated>
X-SA-Exim-Mail-From: mjg59@cavan.codon.org.uk
X-SA-Exim-Scanned: No (on cavan.codon.org.uk); SAEximRunCond expanded to false
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Aug 13, 2012 at 04:04:44PM -0500, Seth Forshee wrote:
> > +
> > +	while (i && (gwr & 0x01)) {
> > +		inb(gmux_data->iostart + GMUX_PORT_READ);
> > +		gwr = inb(gmux_data->iostart + GMUX_PORT_WRITE);
> > +		msleep(100);
> 
> Wouldn't it make more sense if the msleep was before reading the port
> again? Otherwise there's no substantial dely between the first and
> second times we read it.

Mm. I'm doing the same as the ACPI implementation - it may be that 
reading GMUX_PORT_READ triggers the update of GMUX_PORT_WRITE? Hard to 
know without the docs.

-- 
Matthew Garrett | mjg59@srcf.ucam.org
