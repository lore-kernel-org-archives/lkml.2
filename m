Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756558Ab1DAPmW (ORCPT <rfc822;w@1wt.eu>);
	Fri, 1 Apr 2011 11:42:22 -0400
Received: from cpoproxy1-pub.bluehost.com ([69.89.21.11]:53995 "HELO
	outbound-mail-01.bluehost.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with SMTP id S1750777Ab1DAPmU (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 1 Apr 2011 11:42:20 -0400
DomainKey-Signature: a=rsa-sha1; q=dns; c=nofws; s=default; d=xenotime.net;
	h=Received:Date:From:To:Cc:Subject:Message-Id:In-Reply-To:References:Organization:X-Mailer:Mime-Version:Content-Type:Content-Transfer-Encoding:X-Identified-User;
	b=t5ytFk8/XEy9/d0aBE9jDWnS/NL3dWkemJskivlt6JoqVTYf5i3EifjJwZZCDuqp8UdM13uSfPy+orzlSIqU6jxnQc7XK2JTrhCvy0+r2f4zi2QR29LxH8YcXtm77Kcs;
Date: Fri, 1 Apr 2011 08:42:18 -0700
From: Randy Dunlap <rdunlap@xenotime.net>
To: Jeremy Jackson <jerj@coplanar.net>
Cc: Dmitry Torokhov <dmitry.torokhov@gmail.com>, linux-kernel@vger.kernel.org
Subject: Re: signal to PID 1 from serial console like KeyboardRequest or CAD
Message-Id: <20110401084218.d803b38d.rdunlap@xenotime.net>
In-Reply-To: <4D95F1B0.9060304@coplanar.net>
References: <4D8CD3D4.90900@coplanar.net>
	<20110331125706.9159a13d.rdunlap@xenotime.net>
	<20110401053757.GA9866@core.coreip.homeip.net>
	<4D95F1B0.9060304@coplanar.net>
Organization: YPO4
X-Mailer: Sylpheed 2.7.1 (GTK+ 2.16.6; x86_64-unknown-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
X-Identified-User: {1807:box742.bluehost.com:xenotime:xenotime.net} {sentby:smtp auth 50.53.38.135 authed with rdunlap@xenotime.net}
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, 01 Apr 2011 11:39:28 -0400 Jeremy Jackson wrote:

> On 04/01/2011 01:37 AM, Dmitry Torokhov wrote:
> > On Thu, Mar 31, 2011 at 12:57:06PM -0700, Randy Dunlap wrote:
> >> On Fri, 25 Mar 2011 13:41:40 -0400 Jeremy Jackson wrote:
> >>
> >>> Hi,
> >>>
> >>> Sent to linux-console with no reply for over a week...
> >>>
> >>> I ran into a problem recently on a Linux server with a remote serial
> >>> console.  /sbin/init (actually Upstart) was in a state where nothing
> >>> (useful) was running.  I had to power cycle the machine to get back to
> >>> the boot prompt.  This has the side-effect of triggering raid rebuilds.
> >>>
> >>> It would be nice to have what Ctrl-Alt-Del does at the VGA console with
> >>> PS/2 or USB keyboard. This sends a SIGINT to PID 1, and most distros
> >>> have this set to do "shutdown -r now" which attempts a clean reboot.
> >>
> >> so C_A_D works at console via PS/2 or USB keyboard, but not on a remote
> >> serial console?  Could it be an issue with whatever remote/serial software
> >> you are using?
> >
> > I believe it is simply a matter of console keymap and assigning "boot"
> > value to the desired combination.
> 
> The VGA console/keyboard isn't an issue here, C_A_D works great.  The 
> problem is, that functionality isn't available when using *serial* console.

That's why I asked whether it could be an issue with the serial interface
software.  E.g., minicom handles/processes certain keystrokes, other apps do things
differently, etc...


> >>> Once upon a time there was KeyboardRequest, which would send a SIGWINCH
> >>> to PID 1 (when pressing Alt-UP_arrow?).  I don't see any sign of this
> >>> feature in Linux 2.6.32 though.
> >>
> >> I couldn't find it in 2.4.37 either.
> >>
> >> Can 'loadkeys' help you any?
> >>
> >>> Looking at the Sysrq handlers in the kernel I don't see any keystrokes
> >>> that send SIGINT to PID 1 either.
> >>>
> >>> So, I'm wondering if it makes sense to add a Sysrq key to send a signal
> >>> to PID1 ?
> >>
> >> Dmitry, any ideas?
> >
> > We have SysRq bindings to unmount filesystems and reboot, isn't that
> > enough?
> 
> Reboot isn't clean... it doesn't signal MD-raid to "unmount" does it? 
> SysRq powerOff does cleanly shutdown md-raid, but who will drive to the 
> datacenter to press the power button to turn it back on?
> 
> I guess there are two ways to achieve clean (md-raid) reboot when using 
> serial console... a new SysRq to reboot "clean", or a new SysRq to 
> signal init.  Looking at ctrlaltdel(8), perhaps it could just one SysRq, 
> and let userspace (/sbin/init) configure it as needed.
> 
> 
> -- 
> Coplanar Networks
> http://www.coplanar.net
> (519)489-4903
> --
> To unsubscribe from this list: send the line "unsubscribe linux-kernel" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
> Please read the FAQ at  http://www.tux.org/lkml/


---
~Randy
*** Remember to use Documentation/SubmitChecklist when testing your code ***
