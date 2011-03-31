Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759319Ab1CaT5K (ORCPT <rfc822;w@1wt.eu>);
	Thu, 31 Mar 2011 15:57:10 -0400
Received: from cpoproxy3-pub.bluehost.com ([67.222.54.6]:56639 "HELO
	cpoproxy3-pub.bluehost.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with SMTP id S1759298Ab1CaT5I (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 31 Mar 2011 15:57:08 -0400
DomainKey-Signature: a=rsa-sha1; q=dns; c=nofws; s=default; d=xenotime.net;
	h=Received:Date:From:To:Cc:Subject:Message-Id:In-Reply-To:References:Organization:X-Mailer:Mime-Version:Content-Type:Content-Transfer-Encoding:X-Identified-User;
	b=o84dTVGBihYbMwbrT0Cle2lp7hfi8k1BxJDHN5m3dxVcKzPLh4pKyN0W3KtZQhfESqpyXR/MbQYzmEyTmLDz/vR0qxONWCmmP7k01I7sRhskoAZm51op7/cLxgKK0LrX;
Date: Thu, 31 Mar 2011 12:57:06 -0700
From: Randy Dunlap <rdunlap@xenotime.net>
To: Jeremy Jackson <jerj@coplanar.net>
Cc: linux-kernel@vger.kernel.org, Dmitry Torokhov <dmitry.torokhov@gmail.com>
Subject: Re: signal to PID 1 from serial console like KeyboardRequest or CAD
Message-Id: <20110331125706.9159a13d.rdunlap@xenotime.net>
In-Reply-To: <4D8CD3D4.90900@coplanar.net>
References: <4D8CD3D4.90900@coplanar.net>
Organization: YPO4
X-Mailer: Sylpheed 2.7.1 (GTK+ 2.16.6; x86_64-unknown-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
X-Identified-User: {1807:box742.bluehost.com:xenotime:xenotime.net} {sentby:smtp auth 50.53.42.51 authed with rdunlap@xenotime.net}
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, 25 Mar 2011 13:41:40 -0400 Jeremy Jackson wrote:

> Hi,
> 
> Sent to linux-console with no reply for over a week...
> 
> I ran into a problem recently on a Linux server with a remote serial 
> console.  /sbin/init (actually Upstart) was in a state where nothing 
> (useful) was running.  I had to power cycle the machine to get back to 
> the boot prompt.  This has the side-effect of triggering raid rebuilds.
> 
> It would be nice to have what Ctrl-Alt-Del does at the VGA console with 
> PS/2 or USB keyboard. This sends a SIGINT to PID 1, and most distros 
> have this set to do "shutdown -r now" which attempts a clean reboot.

so C_A_D works at console via PS/2 or USB keyboard, but not on a remote
serial console?  Could it be an issue with whatever remote/serial software
you are using?

> Once upon a time there was KeyboardRequest, which would send a SIGWINCH 
> to PID 1 (when pressing Alt-UP_arrow?).  I don't see any sign of this 
> feature in Linux 2.6.32 though.

I couldn't find it in 2.4.37 either.

Can 'loadkeys' help you any?

> Looking at the Sysrq handlers in the kernel I don't see any keystrokes 
> that send SIGINT to PID 1 either.
> 
> So, I'm wondering if it makes sense to add a Sysrq key to send a signal 
> to PID1 ?

Dmitry, any ideas?


---
~Randy
*** Remember to use Documentation/SubmitChecklist when testing your code ***
