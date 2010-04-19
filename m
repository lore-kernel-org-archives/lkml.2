Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751981Ab0DSVqw (ORCPT <rfc822;w@1wt.eu>);
	Mon, 19 Apr 2010 17:46:52 -0400
Received: from rcsinet10.oracle.com ([148.87.113.121]:18081 "EHLO
	rcsinet10.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751178Ab0DSVqv (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 19 Apr 2010 17:46:51 -0400
Date: Mon, 19 Apr 2010 14:44:57 -0700
From: Randy Dunlap <randy.dunlap@oracle.com>
To: lkml <linux-kernel@vger.kernel.org>
Cc: bugzilla-daemon@bugzilla.kernel.org
Subject: Re: [Bugme-new] [Bug 15812] New: utsname.domainname not set in
 x86_32 processes (causing "YPBINDPROC_DOMAIN: domain not bound" errors)
Message-Id: <20100419144457.7c9d5761.randy.dunlap@oracle.com>
In-Reply-To: <bug-15812-10286@https.bugzilla.kernel.org/>
References: <bug-15812-10286@https.bugzilla.kernel.org/>
Organization: Oracle Linux Eng.
X-Mailer: Sylpheed 2.7.1 (GTK+ 2.16.6; x86_64-unknown-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
X-Auth-Type: Internal IP
X-Source-IP: acsinet15.oracle.com [141.146.126.227]
X-CT-RefId: str=0001.0A090209.4BCCCF24.019F:SCFMA922111,ss=1,fgs=0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 19 Apr 2010 21:29:15 GMT bugzilla-daemon@bugzilla.kernel.org wrote:

> https://bugzilla.kernel.org/show_bug.cgi?id=15812
> 
>            Summary: utsname.domainname not set in x86_32 processes
>                     (causing "YPBINDPROC_DOMAIN: domain not bound" errors)
>            Product: Platform Specific/Hardware
>            Version: 2.5
>     Kernel Version: 2.6.34-rc4
>           Platform: All
>         OS/Version: Linux
>               Tree: Mainline
>             Status: NEW
>           Severity: normal
>           Priority: P1
>          Component: x86-64
>         AssignedTo: platform_x86_64@kernel-bugs.osdl.org
>         ReportedBy: adi@hexapodia.org
>                 CC: hch@lst.de
>         Regression: Yes
> 
> 
> 2.6.34-rc4 uname(2) from a x86_32 process copies out 325 bytes rather than the
> 390 bytes that 2.6.31 copied out (and that userland expects):

Just to clarify (?), that's a 32-bit process on a 64-bit kernel, right?


> 2.6.31.12% cat foo.c
> main()
> {
>         char buf[1000];
>         memset(buf, 'x', sizeof(buf));
>         uname(buf);
>         write(1, buf, sizeof(buf));
>         return 0;
> }
> 2.6.31.12% i686-linux-gcc foo.c
> 2.6.31.12% ./a.out | hd
> 00000000  4c 69 6e 75 78 00 00 00  00 00 00 00 00 00 00 00  |Linux...........|
> 00000010  00 00 00 00 00 00 00 00  00 00 00 00 00 00 00 00  |................|
> *
> 00000040  00 63 76 70 65 34 33 30  30 00 00 00 00 00 00 00  |.cvpe4300.......|
> 00000050  00 00 00 00 00 00 00 00  00 00 00 00 00 00 00 00  |................|
> *
> 00000080  00 00 32 2e 36 2e 33 31  2e 31 32 2d 63 76 70 32  |..2.6.31.12-cvp2|
> 00000090  30 31 30 30 33 32 39 2d  30 30 31 34 38 2d 67 39  |0100329-00148-g9|
> 000000a0  61 38 62 36 36 61 00 00  00 00 00 00 00 00 00 00  |a8b66a..........|
> 000000b0  00 00 00 00 00 00 00 00  00 00 00 00 00 00 00 00  |................|
> 000000c0  00 00 00 23 36 20 53 4d  50 20 54 75 65 20 41 70  |...#6 SMP Tue Ap|
> 000000d0  72 20 36 20 31 36 3a 30  33 3a 33 31 20 50 44 54  |r 6 16:03:31 PDT|
> 000000e0  20 32 30 31 30 00 00 00  00 00 00 00 00 00 00 00  | 2010...........|
> 000000f0  00 00 00 00 00 00 00 00  00 00 00 00 00 00 00 00  |................|
> 00000100  00 00 00 00 78 38 36 5f  36 34 00 00 00 00 00 00  |....x86_64......|
> 00000110  00 00 00 00 00 00 00 00  00 00 00 00 00 00 00 00  |................|
> *
> 00000140  00 00 00 00 00 28 6e 6f  6e 65 29 00 00 00 00 00  |.....(none).....|
> 00000150  00 00 00 00 00 00 00 00  00 00 00 00 00 00 00 00  |................|
> *
> 00000180  00 00 00 00 00 00 78 78  78 78 78 78 78 78 78 78  |......xxxxxxxxxx|
> 00000190  78 78 78 78 78 78 78 78  78 78 78 78 78 78 78 78  |xxxxxxxxxxxxxxxx|
> *
> 000003e0  78 78 78 78 78 78 78 78                           |xxxxxxxx|
> 000003e8
> 
> 2.6.34-rc4% ./a.out | hd
> 00000000  4c 69 6e 75 78 00 00 00  00 00 00 00 00 00 00 00  |Linux...........|
> 00000010  00 00 00 00 00 00 00 00  00 00 00 00 00 00 00 00  |................|
> *
> 00000040  00 63 76 70 2d 6c 6f 61  6e 65 72 2d 31 36 00 00  |.cvp-loaner-16..|
> 00000050  00 00 00 00 00 00 00 00  00 00 00 00 00 00 00 00  |................|
> *
> 00000080  00 00 32 2e 36 2e 33 34  2d 72 63 34 2d 30 30 31  |..2.6.34-rc4-001|
> 00000090  31 35 2d 67 64 63 35 37  64 61 33 00 00 00 00 00  |15-gdc57da3.....|
> 000000a0  00 00 00 00 00 00 00 00  00 00 00 00 00 00 00 00  |................|
> *
> 000000c0  00 00 00 23 36 20 53 4d  50 20 46 72 69 20 41 70  |...#6 SMP Fri Ap|
> 000000d0  72 20 31 36 20 31 30 3a  34 31 3a 34 33 20 50 44  |r 16 10:41:43 PD|
> 000000e0  54 20 32 30 31 30 00 00  00 00 00 00 00 00 00 00  |T 2010..........|
> 000000f0  00 00 00 00 00 00 00 00  00 00 00 00 00 00 00 00  |................|
> 00000100  00 00 00 00 78 38 36 5f  36 34 00 00 00 00 00 00  |....x86_64......|
> 00000110  00 00 00 00 00 00 00 00  00 00 00 00 00 00 00 00  |................|
> *
> 00000140  00 00 00 00 00 78 78 78  78 78 78 78 78 78 78 78  |.....xxxxxxxxxxx|
> 00000150  78 78 78 78 78 78 78 78  78 78 78 78 78 78 78 78  |xxxxxxxxxxxxxxxx|
> *
> 000003e0  78 78 78 78 78 78 78 78                           |xxxxxxxx|
> 000003e8
> 
> This results in 32-bit applications that attempt to use libnss_nis's getpwuid()
> to fail with "YPBINDPROC_DOMAIN: Domain not bound", because they use an
> uninitialized value for domainname.
> 
> -- 
> Configure bugmail: https://bugzilla.kernel.org/userprefs.cgi?tab=email
> ------- You are receiving this mail because: -------
> You are on the CC list for the bug.


---
~Randy
