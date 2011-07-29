Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753075Ab1G2VXb (ORCPT <rfc822;w@1wt.eu>);
	Fri, 29 Jul 2011 17:23:31 -0400
Received: from ogre.sisk.pl ([217.79.144.158]:34796 "EHLO ogre.sisk.pl"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753044Ab1G2VX3 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 29 Jul 2011 17:23:29 -0400
From: "Rafael J. Wysocki" <rjw@sisk.pl>
To: Pavel Machek <pavel@ucw.cz>
Subject: Re: [linux-pm] better oopsing when frozen
Date: Fri, 29 Jul 2011 22:27:54 +0200
User-Agent: KMail/1.13.6 (Linux/3.0.0+; KDE/4.6.0; x86_64; ; )
Cc: Oliver Neukum <oneukum@suse.de>, linux-pm@lists.linux-foundation.org,
        linux-kernel@vger.kernel.org,
        Andrew Morton <akpm@linux-foundation.org>
References: <201107251043.19932.oneukum@suse.de> <20110729195430.GB1720@ucw.cz>
In-Reply-To: <20110729195430.GB1720@ucw.cz>
MIME-Version: 1.0
Content-Type: Text/Plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Message-Id: <201107292227.54948.rjw@sisk.pl>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Friday, July 29, 2011, Pavel Machek wrote:
> On Mon 2011-07-25 10:43:19, Oliver Neukum wrote:
> > Hi Rafael,
> > 
> > I had a problem with the kernel stopping the machine forever because I got an
> > oops while tasks were frozen. It seems to me that we should thaw when this
> > happens. How about this approach?
> 
> Danger, Will Robinson. You must not write to the filesystems after
> hibernation started. By thawing, you may do just that.
> 
> It should be safe to thaw as long as final suspend signature is not
> on disk and will not be written there.

This only applies to hibernation and only when we're going to restore
from the image the presumably hasn't been saved yet, right?

However, there's another problem I didn't think of before.  Namely,
we cannot thaw tasks before resuming devices in case we've already
suspended them, because that will defeat the very purpose of the
freezing in the first place.

Thanks,
Rafael
