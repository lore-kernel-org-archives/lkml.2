Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933793Ab1EWURB (ORCPT <rfc822;w@1wt.eu>);
	Mon, 23 May 2011 16:17:01 -0400
Received: from mail.agmk.net ([91.192.224.71]:44951 "EHLO mail.agmk.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1757356Ab1EWUQt (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 23 May 2011 16:16:49 -0400
X-Greylist: delayed 1878 seconds by postgrey-1.27 at vger.kernel.org; Mon, 23 May 2011 16:16:49 EDT
From: =?utf-8?q?Pawe=C5=82_Sikora?= <pluto@agmk.net>
To: linux-kernel@vger.kernel.org
Subject: [2.6.38.6] opteron server dies / how to debug call trace flood?
Date: Mon, 23 May 2011 21:45:23 +0200
User-Agent: KMail/1.13.7 (Linux/2.6.38.6-8; KDE/4.6.3; x86_64; ; )
Cc: arekm@pld-linux.org
MIME-Version: 1.0
Content-Type: Text/Plain;
  charset="utf-8"
Content-Transfer-Encoding: 8bit
Message-Id: <201105232145.23365.pluto@agmk.net>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi,

i'm currently testing the 2.6.38.6 with vserver/grsec on dual opteron
and it dies after some time. afaics on the remote ipmi console there's
a call trace flood without explicite kernel oops. machine respones
to pings but ssh is unavailable. here's the looged ipmi terminal:

(...)
Resource Manager: Runlevel has been reached...........................[ 3 ]

 .------------------------< PLD Linux 2.99 (Th) >------------------------*
:|:
:|:  Welcome to odra
:|:  Mon May 23  2011 19:31:50
:|:
 `---{ 0 users }---[ 2.6.38.6-8 ]---( x86_64 )------*


ttyS1 odra login: [ 3192.210129] Stack:
[ 3192.212164] Call Trace:
[ 3192.213016] Code: 90 90 90 90 90 55 48 c7 c0 d0 dd 00 00 48 89 e5 65 48 03 04 25 08 b5 00 00 ba 00 01 00 00 f0 66 0f c1 10 38 f2 74 06 f3 90 8a 10 <eb> f6 c9 c3 66 0f 1f 44 00 00 55 48 c7 c0 d0 dd 00 00 48 89 e5 
[ 3192.313455] Stack:
[ 3192.315494] Call Trace:
[ 3192.316350] Code: eb ad 90 90 90 90 90 90 90 55 48 c7 c0 d0 dd 00 00 48 89 e5 65 48 03 04 25 08 b5 00 00 ba 00 01 00 00 f0 66 0f c1 10 38 f2 74 06 <f3> 90 8a 10 eb f6 c9 c3 66 0f 1f 44 00 00 55 48 c7 c0 d0 dd 00 
[ 3192.416782] Stack:
[ 3192.418813] Call Trace:
[ 3192.419682] Code: 90 90 90 90 90 90 90 55 48 c7 c0 d0 dd 00 00 48 89 e5 65 48 03 04 25 08 b5 00 00 ba 00 01 00 00 f0 66 0f c1 10 38 f2 74 06 f3 90 <8a> 10 eb f6 c9 c3 66 0f 1f 44 00 00 55 48 c7 c0 d0 dd 00 00 48 
[ 3192.520109] Stack:
[ 3192.522135] Call Trace:
[ 3192.523015] Code: 90 90 90 90 90 90 90 55 48 c7 c0 d0 dd 00 00 48 89 e5 65 48 03 04 25 08 b5 00 00 ba 00 01 00 00 f0 66 0f c1 10 38 f2 74 06 f3 90 <8a> 10 eb f6 c9 c3 66 0f 1f 44 00 00 55 48 c7 c0 d0 dd 00 00 48 
[ 3192.626777] Stack:
[ 3192.628810] Call Trace:
[ 3192.629682] Code: 90 90 90 90 90 90 90 55 48 c7 c0 d0 dd 00 00 48 89 e5 65 48 03 04 25 08 b5 00 00 ba 00 01 00 00 f0 66 0f c1 10 38 f2 74 06 f3 90 <8a> 10 eb f6 c9 c3 66 0f 1f 44 00 00 55 48 c7 c0 d0 dd 00 00 48 
[ 3192.833431] Stack:
[ 3192.835461] Call Trace:
[ 3192.836350] Code: 90 90 90 90 90 90 90 55 48 c7 c0 d0 dd 00 00 48 89 e5 65 48 03 04 25 08 b5 00 00 ba 00 01 00 00 f0 66 0f c1 10 38 f2 74 06 f3 90 <8a> 10 eb f6 c9 c3 66 0f 1f 44 00 00 55 48 c7 c0 d0 dd 00 00 48 
[ 3192.936757] Stack:
[ 3192.938792] Call Trace:
[ 3192.939685] Code: 90 90 90 90 90 90 90 55 48 c7 c0 d0 dd 00 00 48 89 e5 65 48 03 04 25 08 b5 00 00 ba 00 01 00 00 f0 66 0f c1 10 38 f2 74 06 f3 90 <8a> 10 eb f6 c9 c3 66 0f 1f 44 00 00 55 48 c7 c0 d0 dd 00 00 48
(...)

is there any way to decrypt such flood?

BR,
Paweł.
