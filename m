Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755729Ab0LDUh6 (ORCPT <rfc822;w@1wt.eu>);
	Sat, 4 Dec 2010 15:37:58 -0500
Received: from mail-pv0-f174.google.com ([74.125.83.174]:57390 "EHLO
	mail-pv0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752018Ab0LDUh4 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 4 Dec 2010 15:37:56 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-type:content-disposition:in-reply-to:user-agent;
        b=H1ZwHp2bl2Iq7ie6gigsG25SmCO2SR1oK+39SP6GW/BDsxk9YNkxtHAlhEkZgMsMuS
         0pFQc3f8kplo49S8KV07ZLZoLmcFz4k9MngutzfFR8ErFc0pJA1eC/DaIGmfSteda3Qh
         K0iBL11cUmGfajlAwE6FqK80wfEPduzd6MsSc=
Date: Sat, 4 Dec 2010 12:37:50 -0800
From: Dmitry Torokhov <dmitry.torokhov@gmail.com>
To: Oliver Neukum <oliver@neukum.org>
Cc: Valentine Barshak <vbarshak@mvista.com>, Jiri Kosina <jkosina@suse.cz>,
        linux-usb@vger.kernel.org, linux-input@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH] USB: USBHID: Fix race between disconnect and hiddev_ioctl
Message-ID: <20101204203750.GA7326@core.coreip.homeip.net>
References: <20101203172746.GA31045@mvista.com>
 <20101203231611.GB22969@core.coreip.homeip.net>
 <201012042122.23852.oliver@neukum.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <201012042122.23852.oliver@neukum.org>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sat, Dec 04, 2010 at 09:22:23PM +0100, Oliver Neukum wrote:
> Am Samstag, 4. Dezember 2010, 00:16:12 schrieb Dmitry Torokhov:
> > > Since disconnect can happen at any time, we can't initialize
> > > struct hid_device *hid = hiddev->hid at the beginning of ioctl
> > > and then use it.
> > > 
> > > This change checks hiddev->exist flag while holding
> > > the existancelock and uses hid_device only if it exists.
> > 
> > Why didn't you take the lock and check hiddev->exist at the beginning of
> > ioctl handler instead of pushing it down into individual command
> > handlers? I guess it would slow down HIDIOCGVERSION but I think we could
> > pay this price for code that is more clear ;)
> 
> Strictly speaking you'd change the semantics. Right now you can execute
> the ioctl even if you know you are holding an fd to a disconnected device
> open.

No, I do not think I would. I do not believe that the availability for
HIDIOCGVERSION on disconnected device is spelled out in API/ABI spec. We
only know that ioctl will either succeed or appropriate error code is
returned. The fact that right now HIDIOCGVERSION is available on
disconnected devices is just an implementation detail subject to change.

-- 
Dmitry
