Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755520Ab2EEMxV (ORCPT <rfc822;w@1wt.eu>);
	Sat, 5 May 2012 08:53:21 -0400
Received: from mail-pz0-f45.google.com ([209.85.210.45]:52078 "EHLO
	mail-pz0-f45.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755310Ab2EEMxR (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 5 May 2012 08:53:17 -0400
Date: Sat, 5 May 2012 05:51:53 -0700
From: Anton Vorontsov <cbouatmailru@gmail.com>
To: "Pallala, Ramakrishna" <ramakrishna.pallala@intel.com>
Cc: Mika Westerberg <mika.westerberg@iki.fi>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH v2] smb347_charger: Cleanup power supply registration
 code in probe
Message-ID: <20120505125153.GA31018@lizard>
References: <1334809818-5958-1-git-send-email-ramakrishna.pallala@intel.com>
 <20120419190820.GB877@mwesterb-mobl.lan>
 <D854C92F57B1B347B57E531E78D05EAD10EC08@BGSMSX102.gar.corp.intel.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
In-Reply-To: <D854C92F57B1B347B57E531E78D05EAD10EC08@BGSMSX102.gar.corp.intel.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Apr 20, 2012 at 03:48:35AM +0000, Pallala, Ramakrishna wrote:
> > Subject: Re: [PATCH v2] smb347_charger: Cleanup power supply registration code in probe
> > 
> > On Thu, Apr 19, 2012 at 10:00:18AM +0530, Ramakrishna Pallala wrote:
> > > This patch checks if the usb or mains charging is enabled by the
> > > platform before registering with the power supply class.
> > 
> > I still don't like the idea of having the power-supplies registered conditionally. Now
> > you need to check in every place whether the corresponding power-supply is registered or
> > not which makes the code uglier and more prone to errors.

Yes, I understand. There's a bit more code in the kernel,
true. But it saves tons of code in userland and makes things
more reliable for the latter.

> These are the reasons behind this patch submission:
> 1. if we don't support USB/AC charging don't enable it, saves
> 	kernel resources and don't give user wrong idea about charging capabilities.
> 2. if a platform driver or any other chip can do USB/AC charging they will register with PS and
> 	user/userspace will not get confused b/w two sysfs interfaces.
> 
> I will leave the decision the Anton.

Well, as I always said, it was somewhat a mistake to introduce
'present' property. It was supposed to be something like 'battery
cells present, if hot-swappable' property.

If the device itself doesn't have a feature (i.e. no USB
socket), you should not register it, otherwise userland
will have to bother detecting actual information (because
the kernel literally lies to the userland if it registers
absent hw features).

So, I'm all for this patch -- it is now applied.

Thank you!

-- 
Anton Vorontsov
Email: cbouatmailru@gmail.com
