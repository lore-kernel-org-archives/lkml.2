Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758817Ab2CHWoj (ORCPT <rfc822;w@1wt.eu>);
	Thu, 8 Mar 2012 17:44:39 -0500
Received: from antcom.de ([188.40.178.216]:48504 "EHLO chuck.antcom.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753889Ab2CHWoi (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 8 Mar 2012 17:44:38 -0500
Message-ID: <4F593652.90809@antcom.de>
Date: Thu, 08 Mar 2012 23:44:34 +0100
From: Roland Stigge <stigge@antcom.de>
Organization: ANTCOM Open Source Research and Development
User-Agent: Mozilla/5.0 (X11; Linux i686 on x86_64; rv:8.0) Gecko/20120216 Icedove/8.0
MIME-Version: 1.0
To: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
CC: Alan Stern <stern@rowland.harvard.edu>, linux-usb@vger.kernel.org,
        linux-kernel@vger.kernel.org, w.sang@pengutronix.de,
        kevin.wells@nxp.com, linux-arm-kernel@lists.infradead.org,
        arnd@arndb.de
Subject: Re: [PATCH v4] USB: Support for LPC32xx SoC
References: <1331244574-32570-1-git-send-email-stigge@antcom.de> <20120308222234.GA25576@kroah.com>
In-Reply-To: <20120308222234.GA25576@kroah.com>
X-Enigmail-Version: 1.3.4
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi,

On 08/03/12 23:22, Greg Kroah-Hartman wrote:
> So, should this function just be called something else, for the type of
> hardware (lpc32xx?), and then do this check within the function?

Right. LPC32xx and PNX4008 seem to share much of the functionality but
they don't share the bits() part. How about renaming (the static)

pnx4008_set_usb_bits()
pnx4008_unset_usb_bits()

to

set_usb_bits()
unset_usb_bits()

and internally doing machine_is_pnx4008() dependent stuff?

Regarding the other pnx4008_*() functions that are shared with lpc32xx,
they only inherit the name for historical reasons. Which naming scheme
should apply here if change is due? One common name between those two
would be "nxp". We could replace everything common between pnx4008 and
lpc32xx with nxp (including ths driver name) and handle the small
pnx4008-specific stuff via machine_is_pnx4008().

Thanks in advance,

Roland
