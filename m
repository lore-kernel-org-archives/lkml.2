Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753938Ab0LRIus (ORCPT <rfc822;w@1wt.eu>);
	Sat, 18 Dec 2010 03:50:48 -0500
Received: from ch-smtp01.sth.basefarm.net ([80.76.149.212]:51913 "EHLO
	ch-smtp01.sth.basefarm.net" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751251Ab0LRIuq (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 18 Dec 2010 03:50:46 -0500
From: "Henrik Rydberg" <rydberg@euromail.se>
Date: Sat, 18 Dec 2010 09:48:12 +0100
To: Dmitry Torokhov <dmitry.torokhov@gmail.com>
Cc: Jiri Kosina <jkosina@suse.cz>, Ping Cheng <pingc@wacom.com>,
        Chris Bagwell <chris@cnpbagwell.com>,
        Chase Douglas <chase.douglas@canonical.com>,
        Peter Hutterer <peter.hutterer@who-t.net>, linux-input@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH] Input: introduce device information ioctl
Message-ID: <20101218084812.GA7297@polaris.bitmath.org>
References: <1292531413-28924-1-git-send-email-rydberg@euromail.se>
 <20101217193935.GB2576@core.coreip.homeip.net>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20101217193935.GB2576@core.coreip.homeip.net>
User-Agent: Mutt/1.5.20 (2009-06-14)
X-Originating-IP: 83.248.200.95
X-Scan-Result: No virus found in message 1PTsSe-0002xj-3K.
X-Scan-Signature: ch-smtp01.sth.basefarm.net 1PTsSe-0002xj-3K aa105da734570ee409cb84836ef2ac00
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Dec 17, 2010 at 11:39:36AM -0800, Dmitry Torokhov wrote:
> On Thu, Dec 16, 2010 at 09:30:13PM +0100, Henrik Rydberg wrote:
> > Today, userspace sets up an input device based on the data it emits.
> > This is not always enough; a tablet and a touchscreen may emit exactly
> > the same data, for instance, but the former should be set up with a
> > pointer whereas the latter does not need to. Recently, a new type of
> > touchpad has emerged where the buttons are under the pad, which
> > changes handling logic without changing the emitted data. This patch
> > introduces a new ioctl, EVIOCGPROP, which enables user access to a set
> > of device properties useful during setup. The properties are given as
> > a bitmap in the same fashion as the event types, and are also made
> > available via sysfs.
> > 
> 
> Looks good to me.
> 
> Could you please also wire up /proc/bus/input/devices to show new
> 'props' (I think we could use  "B: PROP=" tags for them) and also to the
> uevent handler?

Sure thing. Regarding the devices file, it would have been nice if an
entry could be used to reproduce the device exactly. Currently, the
ABS limits are missing. Should we add them as well?

Henrik
