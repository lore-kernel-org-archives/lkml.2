Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752288Ab1HRSSS (ORCPT <rfc822;w@1wt.eu>);
	Thu, 18 Aug 2011 14:18:18 -0400
Received: from lucidpixels.com ([72.73.18.11]:44699 "EHLO lucidpixels.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750750Ab1HRSSR (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 18 Aug 2011 14:18:17 -0400
Date: Thu, 18 Aug 2011 14:18:15 -0400 (EDT)
From: Justin Piszcz <jpiszcz@lucidpixels.com>
To: Steve French <smfrench@gmail.com>
cc: Jeff Layton <jlayton@samba.org>, "J. R. Okajima" <hooanon05@yahoo.co.jp>,
        Jesper Juhl <jj@chaosbits.net>, linux-kernel@vger.kernel.org,
        Alan Piszcz <ap@solarrain.com>, Steve French <sfrench@samba.org>,
        linux-cifs@vger.kernel.org
Subject: Re: Kernel 3.0: Instant kernel crash when mounting CIFS (also crashes
 with linux-3.1-rc2
In-Reply-To: <CAH2r5msTpKdxwpgG+-3-gkkr5h7Ox1tL86q3LyTBMd1V8WS7aQ@mail.gmail.com>
Message-ID: <alpine.DEB.2.02.1108181413030.7903@p34.internal.lan>
References: <alpine.DEB.2.02.1108150506310.7571@p34.internal.lan> <alpine.LNX.2.00.1108151117480.19668@swampdragon.chaosbits.net> <20110815064734.403b630f@corrin.poochiereds.net> <alpine.DEB.2.02.1108150653200.7571@p34.internal.lan>
 <alpine.DEB.2.02.1108151357200.32349@p34.internal.lan> <alpine.DEB.2.02.1108171515050.5877@p34.internal.lan> <3300.1313637592@jrobl> <alpine.DEB.2.02.1108180632000.10458@p34.internal.lan> <alpine.DEB.2.02.1108180807070.7903@p34.internal.lan>
 <alpine.DEB.2.02.1108180821440.7903@p34.internal.lan> <20110818091140.385a9455@barsoom.rdu.redhat.com> <alpine.DEB.2.02.1108180914180.7903@p34.internal.lan> <20110818130408.71c55b96@barsoom.rdu.redhat.com> <alpine.DEB.2.02.1108181314310.7903@p34.internal.lan>
 <CAH2r5mvNkUWh0rYTbTEWmUPiRsxUbmrGNpTOaebiG0CCKRfA1g@mail.gmail.com> <alpine.DEB.2.02.1108181331180.7903@p34.internal.lan> <CAH2r5msTpKdxwpgG+-3-gkkr5h7Ox1tL86q3LyTBMd1V8WS7aQ@mail.gmail.com>
User-Agent: Alpine 2.02 (DEB 1266 2009-07-14)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII; format=flowed
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org



On Thu, 18 Aug 2011, Steve French wrote:

> If reading files - smbclient (ftp like syntax) should be able to reach
> wire speeds (assuming the server disk can keep up) and for
> writing it should be similar (perhaps a little slower but it won't
> use i/o sizes as large as cifs kernel client).  I would expect
> smbclient to/copy from Windows to be faster than Windows mount -> Samba.
>
> I reached near wirespeeds for GigE with cifs client (writing) to
> Winodws 2003/2008/r2
> and Samba - but didn't have fast enough disks to test 10GigE although I expect
> very good performance with that if you have fast enough server disks (and
> am willing to put performance patches in, if you detect additional
> changes that we should make for 10GigE - in particular allowing
> more than 50 simultaneous requests).
>
> If the registry fix for Windows 7 is in place (or if you copy to
> WIndows 2008, Windows 2003, WIndows 2008r2) -
> cifs kernel client is probably slightly faster for writes than alternatives,
> smbclient much faster for reads.
>
> If going the other direction (Windows client copying to/from Samba server) -
> Samba 3.6 (server) with SMB2 support
> turned on - is going to be faster than most alternatives.

Hi,

Downloading from an FTP Server on the windows machine:

<--- 150 Connection accepted
`file' at 418873344 (24%) 145.58M/s eta:9s [Receiving data]
`file' at 735510528 (42%) 162.93M/s eta:6s [Receiving data]
`file' at 1357185024 (78%) 172.89M/s eta:2s [Receiving data]
<--- 226 Transfer OK 
---- Got EOF on data connection
---- Closing data socket
1719784995 bytes transferred in 9 seconds (181.65M/s)

Same file (via CIFS): 50MB/s

Device eth6 [10.0.1.2] (1/1):
================================================================================
Incoming:                               Outgoing:
Curr: 49.17 MByte/s                     Curr: 0.58 MByte/s
Avg: 8.76 MByte/s                       Avg: 0.03 MByte/s
Min: 0.00 MByte/s                       Min: 0.00 MByte/s
Max: 197.68 MByte/s                     Max: 0.86 MByte/s
Ttl: 585.87 GByte                       Ttl: 6.97 GByte

0.02user 4.09system 0:33.84elapsed 12%CPU (0avgtext+0avgdata 3632maxresident)k

The RAID's on both systems can achieve > 750MiB/s sustained without any
problems (benchmarked in the past) and the system has 56 PCI-e 2.0 lanes
and a cable between two 10GbE nics.  Not sure where to start, Win7/box tweaks
or Linux/CIFS options?

Again, Samba -> Linux = 500MiB/s, so FTP > 3x faster than CIFS.
I know NFS gets a lot of testing (never had an issue with it/performance/etc)

However, regarding CIFS-- is there a test suite/or benchmark pack the CIFS 
developers use to make sure everything is working in order?

Justin.


