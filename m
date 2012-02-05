Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754387Ab2BERCW (ORCPT <rfc822;w@1wt.eu>);
	Sun, 5 Feb 2012 12:02:22 -0500
Received: from mail-iy0-f174.google.com ([209.85.210.174]:50590 "EHLO
	mail-iy0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753039Ab2BERCU (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 5 Feb 2012 12:02:20 -0500
Message-ID: <4F2EB618.7050503@gmail.com>
Date: Sun, 05 Feb 2012 10:02:16 -0700
From: "Berck E. Nash" <flyboy@gmail.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:8.0) Gecko/20120104 Icedove/8.0
MIME-Version: 1.0
To: skeggsb@gmail.com
CC: Dave Airlie <airlied@gmail.com>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        jak@jak-linux.org
Subject: Re: DRM nouveau crash with 3.2.0-rc5
References: <4EE2E9BB.8060801@gmail.com> 		<CAPM=9tzVxGbsE4+EgTd0apvGBCUcvtnjSH-ydbr-MOVSTf1QaQ@mail.gmail.com> 	 <CACAvsv6g+qz+-ja+4Qfinz04rr0EAyxwxQpFyfcE1fAtqQyuEA@mail.gmail.com> 	 <4EE42ADA.5000406@gmail.com> <1323590203.31951.2.camel@nisroch>  <4EE564CF.8090203@gmail.com> <1323753537.10514.0.camel@nisroch>
In-Reply-To: <1323753537.10514.0.camel@nisroch>
X-Enigmail-Version: 1.3.4
Content-Type: multipart/mixed;
 boundary="------------090508060007070000000603"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This is a multi-part message in MIME format.
--------------090508060007070000000603
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit

On 12/12/2011 10:18 PM, Ben Skeggs wrote:
> Are you able to bisect this back to a commit?  I've attempted on a few
> different cards to cause this and I'm not seeing it.

Okay, after one of the most time-consuming git bisects ever, I think
I've found it:

0b1076c4b2a06e517fafbb2b4704f23e69b05386 is the first bad commit
commit 0b1076c4b2a06e517fafbb2b4704f23e69b05386
Author: Julian Andres Klode <jak@jak-linux.org>
Date:   Tue Sep 27 19:00:48 2011 +0200

    staging: nvec: Introduce new internal API for msg alloc/free

    Introduce two new functions nvec_msg_alloc() and nvec_msg_free()
    that allocate and free message buffers from the internal pool
    of messages.

    Signed-off-by: Julian Andres Klode <jak@jak-linux.org>
    Acked-by: Marc Dietrich <marvin24@gmx.de>
    Signed-off-by: Greg Kroah-Hartman <gregkh@suse.de>

Since you guys have probably forgotten about this since it took so long,
I'll recap:

While watching video with mplayer, the nouveau driver crashes rendering
X totally non-responsive, though the system still behaves normally via
ssh or serial console.  Dmesg attached, and I've cc'ed the author of the
first bad commit.

Berck

--------------090508060007070000000603
Content-Type: text/plain;
 name="drm-crash3.log"
Content-Transfer-Encoding: base64
Content-Disposition: attachment;
 filename="drm-crash3.log"

WyAzMzQ5LjE2MDAxM10gW2RybV0gbm91dmVhdSAwMDAwOjAxOjAwLjA6IFBHUkFQSCAtIFRS
QVBfVkZFVENIIEZBVUxUClsgMzM0OS4xNjY2MDZdIFtkcm1dIG5vdXZlYXUgMDAwMDowMTow
MC4wOiBQR1JBUEggLSBUUkFQX1ZGRVRDSCAwMGYwMDAwMCAwMDAwZmUwYyAwMDAwMDAwMCAw
MDAwMDAwMApbIDMzNDkuMTc1OTc4XSBbZHJtXSBub3V2ZWF1IDAwMDA6MDE6MDAuMDogUEdS
QVBIIC0gVFJBUApbIDMzNDkuMTgxMjE3XSBbZHJtXSBub3V2ZWF1IDAwMDA6MDE6MDAuMDog
UEdSQVBIIC0gY2ggNSAoMHgwMDBjMmQzMDAwKSBzdWJjIDUgY2xhc3MgMHg4Mjk3IG10aGQg
MHgwZjA0IGRhdGEgMHgwMDAwMDAwMApbIDMzNDkuMTkyMDg0XSBbZHJtXSBub3V2ZWF1IDAw
MDA6MDE6MDAuMDogVk06IHRyYXBwZWQgcmVhZCBhdCAweDAwMDAwMDAwMDAgb24gY2ggMiBb
MHgwMDAwMGQwM10gUEdSQVBIL1ZGRVRDSC8wMCByZWFzb246IFBUX05PVF9QUkVTRU5UClsg
NTc2NC43NTEzODldIFtkcm1dIG5vdXZlYXUgMDAwMDowMTowMC4wOiBQRklGT19ETUFfUFVT
SEVSIC0gQ2ggMiBHZXQgMHgwMDIwMDI3M2YwIFB1dCAweDAwMjAwMjc0M2MgSWJHZXQgMHgw
MDAwMDA3MSBJYlB1dCAweDAwMDAwMDdlIFN0YXRlIDB4ODAwMDQyOTAgKGVycjogSU5WQUxJ
RF9DTUQpIFB1c2ggMHgwMDQwNjA0MApbIDU3NjQuNzY4MzI1XSBbZHJtXSBub3V2ZWF1IDAw
MDA6MDE6MDAuMDogUEdSQVBIIC0gREFUQV9FUlJPUiBJTlZBTElEX1ZBTFVFClsgNTc2NC43
NzUzNjBdIFtkcm1dIG5vdXZlYXUgMDAwMDowMTowMC4wOiBQR1JBUEggLSBEQVRBX0VSUk9S
ClsgNTc2NC43ODExNjldIFtkcm1dIG5vdXZlYXUgMDAwMDowMTowMC4wOiBQR1JBUEggLSBj
aCAyICgweDAwMDBkMDMwMDApIHN1YmMgMiBjbGFzcyAweDUwMmQgbXRoZCAweDAyODggZGF0
YSAweDAwMGNiNTc0ClsgNjgwOC4xNjU4MzhdIFtkcm1dIG5vdXZlYXUgMDAwMDowMTowMC4w
OiBQR1JBUEggLSBEQVRBX0VSUk9SIElOVkFMSURfVkFMVUUKWyA2ODA4LjE3MjY3Ml0gW2Ry
bV0gbm91dmVhdSAwMDAwOjAxOjAwLjA6IFBHUkFQSCAtIERBVEFfRVJST1IKWyA2ODA4LjE3
ODMwOF0gW2RybV0gbm91dmVhdSAwMDAwOjAxOjAwLjA6IFBHUkFQSCAtIGNoIDIgKDB4MDAw
MGQwMzAwMCkgc3ViYyAyIGNsYXNzIDB4NTAyZCBtdGhkIDB4MDI4NCBkYXRhIDB4MDAwNGFm
MDAKWzEwOTM4LjM2MDg1NF0gW2RybV0gbm91dmVhdSAwMDAwOjAxOjAwLjA6IFBHUkFQSCAt
IERBVEFfRVJST1IgSU5WQUxJRF9WQUxVRQpbMTA5MzguMzY3OTQ3XSBbZHJtXSBub3V2ZWF1
IDAwMDA6MDE6MDAuMDogUEdSQVBIIC0gREFUQV9FUlJPUgpbMTA5MzguMzczNzQwXSBbZHJt
XSBub3V2ZWF1IDAwMDA6MDE6MDAuMDogUEdSQVBIIC0gY2ggMiAoMHgwMDAwZDAzMDAwKSBz
dWJjIDIgY2xhc3MgMHg1MDJkIG10aGQgMHgwMjhjIGRhdGEgMHgyMDAzMTAwMAo=
--------------090508060007070000000603--
