Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758066Ab1DAP7s (ORCPT <rfc822;w@1wt.eu>);
	Fri, 1 Apr 2011 11:59:48 -0400
Received: from mail-pw0-f46.google.com ([209.85.160.46]:45059 "EHLO
	mail-pw0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752984Ab1DAP7r (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 1 Apr 2011 11:59:47 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-type:content-disposition:in-reply-to:user-agent;
        b=IFftE9bgYxX6V7Qj33ue0ZIvGeygFPUJPZOclhvIWvZacPutQShKxC+D8+YWnmdEOg
         EbxwsEW/Ej1RmeTrVZpkZzi7P28T1SNUu2L8XjSxUM5KbE47cM1HOIbsdnMLNnLACUgh
         N/+Ek7ovoRrPdkUhRTkToHDUSOxIsoTXxI2Ig=
Date: Fri, 1 Apr 2011 08:59:38 -0700
From: Dmitry Torokhov <dmitry.torokhov@gmail.com>
To: Jeremy Jackson <jerj@coplanar.net>
Cc: Randy Dunlap <rdunlap@xenotime.net>, linux-kernel@vger.kernel.org
Subject: Re: signal to PID 1 from serial console like KeyboardRequest or CAD
Message-ID: <20110401155938.GA9163@core.coreip.homeip.net>
References: <4D8CD3D4.90900@coplanar.net>
 <20110331125706.9159a13d.rdunlap@xenotime.net>
 <20110401053757.GA9866@core.coreip.homeip.net>
 <4D95F1B0.9060304@coplanar.net>
 <20110401084218.d803b38d.rdunlap@xenotime.net>
 <4D95F37E.8080107@coplanar.net>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <4D95F37E.8080107@coplanar.net>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Apr 01, 2011 at 11:47:10AM -0400, Jeremy Jackson wrote:
> On 04/01/2011 11:42 AM, Randy Dunlap wrote:
> >On Fri, 01 Apr 2011 11:39:28 -0400 Jeremy Jackson wrote:
> >
> >>On 04/01/2011 01:37 AM, Dmitry Torokhov wrote:
> >>>On Thu, Mar 31, 2011 at 12:57:06PM -0700, Randy Dunlap wrote:
> >>>>On Fri, 25 Mar 2011 13:41:40 -0400 Jeremy Jackson wrote:
> >>>>
> >>>>>Hi,
> >>>>>
> >>>>>Sent to linux-console with no reply for over a week...
> >>>>>
> >>>>>I ran into a problem recently on a Linux server with a remote serial
> >>>>>console.  /sbin/init (actually Upstart) was in a state where nothing
> >>>>>(useful) was running.  I had to power cycle the machine to get back to
> >>>>>the boot prompt.  This has the side-effect of triggering raid rebuilds.
> >>>>>
> >>>>>It would be nice to have what Ctrl-Alt-Del does at the VGA console with
> >>>>>PS/2 or USB keyboard. This sends a SIGINT to PID 1, and most distros
> >>>>>have this set to do "shutdown -r now" which attempts a clean reboot.
> >>>>
> >>>>so C_A_D works at console via PS/2 or USB keyboard, but not on a remote
> >>>>serial console?  Could it be an issue with whatever remote/serial software
> >>>>you are using?
> >>>
> >>>I believe it is simply a matter of console keymap and assigning "boot"
> >>>value to the desired combination.
> >>
> >>The VGA console/keyboard isn't an issue here, C_A_D works great.  The
> >>problem is, that functionality isn't available when using *serial* console.
> >
> >That's why I asked whether it could be an issue with the serial interface
> >software.  E.g., minicom handles/processes certain keystrokes, other apps do things
> >differently, etc...
> 
> OK I guess I should clarify... when using Linux serial console, you
> can send BREAK <letter> to use SysRq functions.

Ah, right, we hardwire BREAK to SysRq when using serial console...

>  In minicom, META-F
> sends break.  This works fine for all the existing functions linux
> offers, r = reboot immediate, i = kill all tasks, etc.  But, there
> is no function available to reboot *clean*, or to signal PID 1
> (/sbin/init) to do same.  So, minicom is working/configured
> properly, Linux just doesn't offer a feature similar to C_A_D via
> serial.

SysRQ+REISUB should do it I think.

-- 
Dmitry
