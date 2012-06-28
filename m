Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754243Ab2F1Tah (ORCPT <rfc822;w@1wt.eu>);
	Thu, 28 Jun 2012 15:30:37 -0400
Received: from youngberry.canonical.com ([91.189.89.112]:35057 "EHLO
	youngberry.canonical.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753877Ab2F1TaW (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 28 Jun 2012 15:30:22 -0400
Date: Thu, 28 Jun 2012 14:30:17 -0500
From: Seth Forshee <seth.forshee@canonical.com>
To: Matthew Garrett <mjg59@srcf.ucam.org>
Cc: Richard Purdie <rpurdie@rpsys.net>, linux-kernel@vger.kernel.org,
        platform-driver-x86@vger.kernel.org,
        Corentin Chary <corentin.chary@gmail.com>
Subject: Re: [PATCH] backlight: add support for disabling backlights via sysfs
Message-ID: <20120628193017.GA29456@thinkpad-t410>
Mail-Followup-To: Matthew Garrett <mjg59@srcf.ucam.org>,
	Richard Purdie <rpurdie@rpsys.net>, linux-kernel@vger.kernel.org,
	platform-driver-x86@vger.kernel.org,
	Corentin Chary <corentin.chary@gmail.com>
References: <1340910426-13269-1-git-send-email-seth.forshee@canonical.com>
 <20120628191043.GA9777@srcf.ucam.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20120628191043.GA9777@srcf.ucam.org>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Jun 28, 2012 at 08:10:43PM +0100, Matthew Garrett wrote:
> On Thu, Jun 28, 2012 at 02:07:06PM -0500, Seth Forshee wrote:
> 
> > Rather than trying to address this situation in a piecemeal fashion, we
> > should find a solution that deal with disabling broken backlights more
> > generically. This patch does so by adding an "enabled" attribute to
> > sysfs for backlight devices. Writing 0 to this attribute disables the
> > backlight, blocking most attempts to change the state. Tools like udev
> > can set use this attribute to disable known broken backlight interfaces,
> > and tools like gnome-settings-daemon can query the attribute to avoid
> > using disabled backlights.
> 
> I'm not entirely thrilled by this, especially because in several cases I 
> suspect that we're just going to end up disabling acpi_backlight rather 
> than fixing any of the range of integration bugs we still have with it. 
> If anyone has links with OEMs then I'd love to know how Windows handles 
> backlight control policy, but otherwise I think Corentin's approach of 
> having the vendor drivers promote or demote themselves makes more sense 
> than pushing the problem out to userspace.

I actually don't think Corentin's solution is a bad one. It does suffer
from a couple of shortcomings though. First, it only works for broken
ACPI backlights, and some platforms have other backlight interfaces that
are broken (e.g. the i915 backlight on the MacBook Pro 8,2). Second,
marking backlights as broken in the kernel necessitates ever-expanding
dmi blacklists in some of the platform drivers, unless we can get
vendors to stop providing broken backlight interfaces.

I'm all for fixing integration bugs in the ACPI backlight
implementations if we can, but some vendor implementations are just
flat-out broken, and it isn't always possible to get vendor cooperation.
In the case of Toshiba I've tried reaching out to them to work on ACPI
integration issues, but they flat out refused.

