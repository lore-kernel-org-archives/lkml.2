Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753272Ab1DAFiF (ORCPT <rfc822;w@1wt.eu>);
	Fri, 1 Apr 2011 01:38:05 -0400
Received: from mail-iw0-f174.google.com ([209.85.214.174]:43367 "EHLO
	mail-iw0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752690Ab1DAFiD (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 1 Apr 2011 01:38:03 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-type:content-disposition:in-reply-to:user-agent;
        b=OMtaDiSI11DZXzKZRpY9PLYCh14xLtABy08/pzKaRfkqV7t4h2BwGM8aGakXrLMZEk
         GnFTCGMqBc9XyGEw+uoHoMKZv4zKdRpshpjF2g4HESv7XwMAQMwZBLnlk8+c1aT2s0pb
         tD9YFv6vFWHKnRGovAD4nlAVT2YnaSaa+Jvqw=
Date: Thu, 31 Mar 2011 22:37:57 -0700
From: Dmitry Torokhov <dmitry.torokhov@gmail.com>
To: Randy Dunlap <rdunlap@xenotime.net>
Cc: Jeremy Jackson <jerj@coplanar.net>, linux-kernel@vger.kernel.org
Subject: Re: signal to PID 1 from serial console like KeyboardRequest or CAD
Message-ID: <20110401053757.GA9866@core.coreip.homeip.net>
References: <4D8CD3D4.90900@coplanar.net>
 <20110331125706.9159a13d.rdunlap@xenotime.net>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20110331125706.9159a13d.rdunlap@xenotime.net>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Mar 31, 2011 at 12:57:06PM -0700, Randy Dunlap wrote:
> On Fri, 25 Mar 2011 13:41:40 -0400 Jeremy Jackson wrote:
> 
> > Hi,
> > 
> > Sent to linux-console with no reply for over a week...
> > 
> > I ran into a problem recently on a Linux server with a remote serial 
> > console.  /sbin/init (actually Upstart) was in a state where nothing 
> > (useful) was running.  I had to power cycle the machine to get back to 
> > the boot prompt.  This has the side-effect of triggering raid rebuilds.
> > 
> > It would be nice to have what Ctrl-Alt-Del does at the VGA console with 
> > PS/2 or USB keyboard. This sends a SIGINT to PID 1, and most distros 
> > have this set to do "shutdown -r now" which attempts a clean reboot.
> 
> so C_A_D works at console via PS/2 or USB keyboard, but not on a remote
> serial console?  Could it be an issue with whatever remote/serial software
> you are using?

I believe it is simply a matter of console keymap and assigning "boot"
value to the desired combination.

> 
> > Once upon a time there was KeyboardRequest, which would send a SIGWINCH 
> > to PID 1 (when pressing Alt-UP_arrow?).  I don't see any sign of this 
> > feature in Linux 2.6.32 though.
> 
> I couldn't find it in 2.4.37 either.
> 
> Can 'loadkeys' help you any?
> 
> > Looking at the Sysrq handlers in the kernel I don't see any keystrokes 
> > that send SIGINT to PID 1 either.
> > 
> > So, I'm wondering if it makes sense to add a Sysrq key to send a signal 
> > to PID1 ?
> 
> Dmitry, any ideas?

We have SysRq bindings to unmount filesystems and reboot, isn't that
enough?

-- 
Dmitry
