Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933641Ab1JZQel (ORCPT <rfc822;w@1wt.eu>);
	Wed, 26 Oct 2011 12:34:41 -0400
Received: from c-adt-5.ataco.se ([213.115.168.248]:43295 "EHLO
	bixbite.inguza.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S933485Ab1JZQek (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 26 Oct 2011 12:34:40 -0400
X-Greylist: delayed 1101 seconds by postgrey-1.27 at vger.kernel.org; Wed, 26 Oct 2011 12:34:40 EDT
Date: Wed, 26 Oct 2011 18:16:11 +0200
From: Ola Lundqvist <opal@debian.org>
To: Justin Piszcz <jpiszcz@lucidpixels.com>, 646305-done@bugs.debian.org,
        646411-done@bugs.debian.org
Cc: linux-kernel@vger.kernel.org
Subject: Re: Bug#646411: 3.1-rcX (8,9,10): kernel does not validate
	swapfile on disk(?) - WAS: vnc4server 4.1.1+X4.3.0-3 crashing under
	normal use
Message-ID: <20111026161611.GA20211@inguza.net>
Reply-To: opal@debian.org
References: <alpine.DEB.2.02.1110221939380.26496@p34.internal.lan> <alpine.DEB.2.02.1110231756250.20069@p34.internal.lan>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <alpine.DEB.2.02.1110231756250.20069@p34.internal.lan>
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Ok, thanks. Closing the bug.

Best regards,

// Ola

On Sun, Oct 23, 2011 at 08:00:56PM -0400, Justin Piszcz wrote:
> Package: vnc4server
> Version: 4.1.1+X4.3.0-3
> Architecture: amd64 (x86-64)
> Kernel: 3.0-rc9
>
> Current theory--
>
> (Debian, ) You can close the bug report, my .swapfile was corrupted it  
> appears! When I ran swapoff -a and re-launched VNC it did not crash  
> anymore, unbelievable, I am also cc'ing the kernel mailing list on this 
> one,
> how come the kernel does not ALARM or WARN or BUG() when there is a 
> problem with the swapfile, is there no validation?
>
> I was testing many 3.1.0-rcX kernels (some of them crashed my machine) 
> and it must have corrupted that file.  The weird part is it only seemed 
> to (mainly) affect VNC, I also saw a coredump with xfs_db (randomly) and 
> a memtest86+ showed ok after 1-2 passes.
>
> Of course it was the last thing I decided to rule out and that was it-- 
> it appears, so far it has not crashed in over an hour, whereas it would 
> crash immediately in the past, over and over for several days so I 
> stopped using VNC until I had time to look into this problem further.
>
> Very interesting and putting this out there incase anyone else sees this  
> problem in the future, maybe it will help someone else.  But I wish the  
> kernel would alarm if there were some problem with the swapfile..  Even  
> when swap was not in use, the presence of the [bad] file would cause vnc  
> to coredump quickly (after launching chrome/thunderbird/etc)  After a  
> swapoff -a -- all problems, gone. All is back to normal now.
>
> I waited a few hours before sending this, still no problems/errors, very  
> interesting, will update if any future coredumps, but none yet..
>
> Justin.
>
>
>>
>> Problem: About 1-2 weeks ago (I apt-get dist-upgrade regularly), VNC server
>> began crashing, e.g. if you launch thunderbird/google chrome or other  
>> windows, the VNC server crashes.
>>
>> May be related to:
>> http://old.nabble.com/Bug-424860%3A-eclipse-randomly-crashes-(VNC)-X-server-p11945956.html
>> http://forums.fedoraforum.org/showthread.php?t=246145
>>
>> Example:
>>
>> $ strace -o /tmp/out -f Xvnc -geometry 1920x1200 -depth 24 -rfbauth  
>> ~/.vnc/passwd :1
>>
>> Xvnc Free Edition 4.1.1 - built Mar 10 2010 22:35:30
>> Copyright (C) 2002-2005 RealVNC Ltd.
>> See http://www.realvnc.com for information on VNC.
>> Underlying X server release 40300000, The XFree86 Project, Inc
>>
>>
>> Sat Oct 22 19:38:49 2011
>> vncext:      VNC extension running!
>> vncext:      Listening for VNC connections on port 5901
>> vncext:      created VNC server for screen 0
>> error opening security policy file /etc/X11/xserver/SecurityPolicy
>> Could not init font path element /usr/share/fonts/X11/Speedo/, removing 
>> from list!
>> Could not init font path element /usr/share/fonts/X11/CID/, removing 
>> from list!
>>
>> Sat Oct 22 19:38:51 2011
>> Connections: accepted: 0.0.0.0::53214
>> SConnection: Client needs protocol version 3.8
>> SConnection: Client requests security type VncAuth(2)
>>
>> Sat Oct 22 19:38:53 2011
>> VNCSConnST:  Server default pixel format depth 24 (32bpp) little-endian 
>> bgr888
>> VNCSConnST:  Client pixel format depth 8 (8bpp) rgb max 3,3,3 shift 4,2,0
>> VNCSConnST:  Client pixel format depth 24 (32bpp) little-endian rgb888
>> Segmentation fault (core dumped)
>>
>> --
>>
>> Core backtrace:
>>
>> $ gdb /usr/bin/Xvnc ./core.Xvnc.26042
>> GNU gdb (GDB) 7.3-debian
>> Copyright (C) 2011 Free Software Foundation, Inc.
>> License GPLv3+: GNU GPL version 3 or later <http://gnu.org/licenses/gpl.html>
>> This is free software: you are free to change and redistribute it.
>> There is NO WARRANTY, to the extent permitted by law.  Type "show copying"
>> and "show warranty" for details.
>> This GDB was configured as "x86_64-linux-gnu".
>> For bug reporting instructions, please see:
>> <http://www.gnu.org/software/gdb/bugs/>...
>> Reading symbols from /usr/bin/Xvnc...(no debugging symbols found)...done.
>> [New LWP 26042]
>>
>> warning: Can't read pathname for load map: Input/output error.
>> Core was generated by `Xvnc -geometry 1920x1200 -depth 24 -rfbauth  
>> /home/user/.vnc/passwd :1'.
>> Program terminated with signal 11, Segmentation fault.
>> #0  0x00000000004cbed4 in ?? ()
>> (gdb) bt
>> #0  0x00000000004cbed4 in ?? ()
>> #1  0x00000000004dd577 in ?? ()
>> #2  0x00000000005832a2 in ?? ()
>> #3  0x00000000005834ff in ?? ()
>> #4  0x0000000000426d90 in ?? ()
>> #5  0x000000000040be86 in ?? ()
>> #6  0x00007f070be96ead in __libc_start_main ()
>>   from /lib/x86_64-linux-gnu/libc.so.6
>> #7  0x0000000000409259 in ?? ()
>> #8  0x00007fff22a53788 in ?? ()
>> #9  0x000000000000001c in ?? ()
>> #10 0x0000000000000008 in ?? ()
>> #11 0x00007fff22a54b2e in ?? ()
>> #12 0x00007fff22a54b33 in ?? ()
>> #13 0x00007fff22a54b3d in ?? ()
>> #14 0x00007fff22a54b47 in ?? ()
>> #15 0x00007fff22a54b4e in ?? ()
>> #16 0x00007fff22a54b51 in ?? ()
>> #17 0x00007fff22a54b5a in ?? ()
>> #18 0x00007fff22a54b70 in ?? ()
>> #19 0x0000000000000000 in ?? ()
>> (gdb)
>>
>> --
>>
>>
>> Strace output: (4M)
>> http://home.comcast.net/~jpiszcz/20111022/vnc-strace.out
>>
>> From the $HOME/.vnc/*log file:
>>
>> (xfdesktop:5201): Wnck-CRITICAL **: wnck_workspace_get_number: 
>> assertion `WNCK_IS_WORKSPACE (space)' failed
>> libpager-Message: Setting the pager rows returned false. Maybe the 
>> setting is not applied.
>>
>> Sat Oct 22 14:26:14 2011
>> Connections: accepted: 0.0.0.0::49493
>> SConnection: Client needs protocol version 3.8
>> SConnection: Client requests security type VncAuth(2)
>>
>> Sat Oct 22 14:26:15 2011
>> VNCSConnST:  Server default pixel format depth 24 (32bpp) little-endian 
>> bgr888
>> VNCSConnST:  Client pixel format depth 8 (8bpp) rgb max 3,3,3 shift 4,2,0
>>
>> Sat Oct 22 14:26:16 2011
>> VNCSConnST:  Client pixel format depth 24 (32bpp) little-endian rgb888
>> Gkr-Message: secret service operation failed: The name  
>> org.freedesktop.secrets was not provided by any .service files
>> XIO:  fatal IO error 11 (Resource temporarily unavailable) on X server ":1"
>>      after 143 requests (143 known processed) with 0 events remaining.
>> xfce4-panel: Fatal IO error 11 (Resource temporarily unavailable) on X 
>> server :1.0.
>> xfdesktop: Fatal IO error 11 (Resource temporarily unavailable) on X 
>> server :1.0.
>> [31476:31476:297527619035:ERROR:chrome_browser_main_x11.cc(57)] X IO 
>> Error detected
>> xfwm4: Fatal IO error 11 (Resource temporarily unavailable) on X server :1.0.
>> xfce4-session: Fatal IO error 11 (Resource temporarily unavailable) on 
>> X server :1.
>> XIO:  fatal IO error 11 (Resource temporarily unavailable) on X server ":1"
>>      after 64951 requests (64951 known processed) with 0 events remaining.
>> Thunar: Fatal IO error 11 (Resource temporarily unavailable) on X 
>> server :1.0.
>> wrapper: Fatal IO error 11 (Resource temporarily unavailable) on X 
>> server :1.0.
>> running 'ssh-agent -s -k'
>> xfsettingsd: Fatal IO error 11 (Resource temporarily unavailable) on X 
>> server :1.
>> unset SSH_AUTH_SOCK;
>> unset SSH_AGENT_PID;
>> echo Agent pid 5181 killed;
>>
>>
>> --
>>
>> Thoughts?
>>
>> Justin.
>>
>
>
>

-- 
 --------------------- Ola Lundqvist ---------------------------
/  opal@debian.org                     Annebergsslingan 37      \
|  ola@inguza.com                      654 65 KARLSTAD          |
|  http://inguza.com/                  +46 (0)70-332 1551       |
\  gpg/f.p.: 7090 A92B 18FE 7994 0C36  4FE4 18A1 B1CF 0FE5 3DD9 /
 ---------------------------------------------------------------
