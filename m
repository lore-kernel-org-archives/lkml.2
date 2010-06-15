Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758252Ab0FOUXw (ORCPT <rfc822;w@1wt.eu>);
	Tue, 15 Jun 2010 16:23:52 -0400
Received: from lirone.symas.net ([64.71.152.235]:44128 "EHLO lirone.symas.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754332Ab0FOUXv (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 15 Jun 2010 16:23:51 -0400
Message-ID: <4C17E14F.5090908@symas.com>
Date: Tue, 15 Jun 2010 13:23:43 -0700
From: Howard Chu <hyc@symas.com>
User-Agent: Mozilla/5.0 (X11; U; Linux x86_64; rv:1.9.3a5pre) Gecko/20100607 Firefox 3.6
MIME-Version: 1.0
To: Alan Cox <alan@lxorguk.ukuu.org.uk>
CC: linux-kernel@vger.kernel.org, Greg KH <greg@kroah.com>
Subject: Re: [PATCH] tty: Add EXTPROC support for LINEMODE
References: <E1OObIu-0004K2-3K@lirone.symas.net> <20100615202924.24446d28@lxorguk.ukuu.org.uk> <4C17DA85.40803@symas.com>
In-Reply-To: <4C17DA85.40803@symas.com>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Howard Chu wrote:
>>> diff --git a/arch/alpha/include/asm/termbits.h b/arch/alpha/include/asm/termbits.h
>>> index ad854a4..879dd35 100644
>>> --- a/arch/alpha/include/asm/termbits.h
>>> +++ b/arch/alpha/include/asm/termbits.h
>>> @@ -180,6 +180,7 @@ struct ktermios {
>>>    #define FLUSHO	0x00800000
>>>    #define PENDIN	0x20000000
>>>    #define IEXTEN	0x00000400
>>> +#define EXTPROC	0x10000000
>>
>> For Alpha this value should match OSF if possible.
>
> I'm grubbing around looking for a live Alpha system now, doesn't seem likely
> that I'll find one. Not sure what needs to match here, it's also unlikely that
> OSF/1 (or any other SVR4 platform) ever provided a definition for this bit.
> Looking at the telnet README:
>   >>>>
> This is a distribution of both client and server telnet.  These programs
> have been compiled on:
> 			telnet	telnetd
> 	BSD 4.4		  x	  x
> 	BSD 4.3 Reno	  X	  X
> 	UNICOS 8.0	  X	  X
> 	UNICOS 7.C	  X	  X
> 	UNICOS 7.0	  X	  X
> 	UNICOS 6.1	  X	  X
> 	BSDI 1.0	  X	  X
> 	Solaris 2.2       x       x (no linemode in server)
> 	Solaris 2.3       x       x (no linemode in server)
> 	SunOs 4.1.3	  X	  X (no linemode in server)
> 	Ultrix 4.3	  X	  X (no linemode in server)
> 	DYNIX V3.0.17.9	  X	  X (no linemode in server)
> 	HP-UX 8.0	  x       x (no linemode in server)
> <<<<
>
> I doubt that anyone ever ported this feature over to those OSes.

Closest thing I've found so far is for HPUX 11i Version 2:
http://docs.hp.com/en/B2355-90848docs/B2355-90848docs.pdf

 >>>>
TIOCREMOTE This ioctl puts the STREAMS pty in and out of Remote Mode. When
            Remote Mode is on, input data will be flow-controlled and passed
            through ldterm without any input processing regardless of the
            terminal mode. When the pty master driver receives this ioctl,
            it will send an M_CTL message downstream to ldterm via ptm, pts,
            and ptem. The command in the M_CTL message is set to MC_NO_CANON
            or MC_DO_CANON depending whether to turn on or off the Remote
            Mode. The format of this ioctl is:
                  int ioctl(master_fd, TIOCREMOTE, argument)
            where the argument is set to 1 to turn on Remote Mode and 0 to
            turn it off. Remote Mode is normally used when doing remote line
            editing in a window manager, or whenever flow-controlled input is
            required. Each write to the master device produces a record
            boundary for the process reading the slave devices. In normal
            usage, a write of data is like the data typed as a line on the
            terminal; a write of 0 (zero) bytes is like typing an EOF
            (End-of-File) character.

TIOCSIGNAL This ioctl allows the master process to send a signal to the slave
            process. The format of this ioctl is:
 

                  int ioctl(master_fd, TIOCSIGNAL, argument)
            where the argument is the signal number as defined in the header
            file <sys/signal.h>. For example the master process can send an
            SIGINT signal to the slave process by doing:
                  ioctl(master_fd, TIOCSIGNAL, SIGINT)
<<<<

TIOCREMOTE seems to be the SVR4 analogue to TIOCPKT without any of the useful 
parts; it doesn't include the prefix byte, so it doesn't provide any state 
change information.

-- 
   -- Howard Chu
   CTO, Symas Corp.           http://www.symas.com
   Director, Highland Sun     http://highlandsun.com/hyc/
   Chief Architect, OpenLDAP  http://www.openldap.org/project/
