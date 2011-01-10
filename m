Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752957Ab1AJJQz (ORCPT <rfc822;w@1wt.eu>);
	Mon, 10 Jan 2011 04:16:55 -0500
Received: from cantor2.suse.de ([195.135.220.15]:39016 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751908Ab1AJJQy (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 10 Jan 2011 04:16:54 -0500
From: Thomas Renninger <trenn@suse.de>
Organization: SUSE Products GmbH
To: Yin Kangkai <kangkai.yin@linux.intel.com>
Subject: Re: [PATCH V2] platform-driver-x86: ACPI EC Extra driver for Oaktrail
Date: Mon, 10 Jan 2011 10:16:50 +0100
User-Agent: KMail/1.13.5 (Linux/2.6.36-18-desktop; KDE/4.5.3; x86_64; ; )
Cc: Matthew Garrett <mjg59@srcf.ucam.org>,
        "platform-driver-x86" <platform-driver-x86@vger.kernel.org>,
        linux-kernel@vger.kernel.org, "Wang, Yong Y" <yong.y.wang@intel.com>,
        "Liu, Bing Wei" <bing.wei.liu@intel.com>,
        Corentin Chary <corentin.chary@gmail.com>
References: <20110106025949.GJ9496@kai-debian> <20110107220940.GA32575@srcf.ucam.org> <20110110071013.GJ30215@kai-debian>
In-Reply-To: <20110110071013.GJ30215@kai-debian>
MIME-Version: 1.0
Content-Type: Text/Plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Message-Id: <201101101016.50662.trenn@suse.de>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

...

> > Is any hardware actually going to ship with this identifier, or will 
> > vendors change the string?
> 
> 
> I think vendors and OEMs will change this string. But we can add the
> DMI_BOARD_NAME, DMI_BOARD_VERSION, etc. back later, can we?

I could imagine vendors will also build a higher level WMI, ACPI or
whatever interface on it (EC bits should not be accessed directly).
Compare with acer-wmi, hp-wmi, platformXY-*, ...
They have their userspace tools/drivers in place for Windows and I
doubt they will add these EC bits there. Instead I expect they will
use the same API which works for their other platforms and add some
ACPI code to glue the EC bits with their (depending on vendor mostly
ACPI based) their Windows laptop driver.
We also have these drivers (re-engineered or implemented by the vendors)
which would result in double HW access.

If this driver can only be loaded on the Intel systems..., but what
would happen if you try to load this one together with the platformXY-
driver on a sold system which provides another mechanism to access this
functionality?

Hm, googling for the oaktrail platform, it seem to be a bit special..,
but as Windows7 runs on it, I do not see why above cannot/will not
happen.

   Thomas
