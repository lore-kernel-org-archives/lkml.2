Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751492Ab0CWK3i (ORCPT <rfc822;w@1wt.eu>);
	Tue, 23 Mar 2010 06:29:38 -0400
Received: from fg-out-1718.google.com ([72.14.220.156]:42005 "EHLO
	fg-out-1718.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750719Ab0CWK3h (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 23 Mar 2010 06:29:37 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=mime-version:date:message-id:subject:from:to:content-type;
        b=kRRre1mx03E+bernc9Vq53KQTHDkuxhCLDRs2jvRRbCqIpAT+MPxcQoatuF7MjqW2M
         S4/vyyQOEFEG/BE4JZsNL74WLz4EdPcDmgjahU9x+3uYfpg96Ux85gO4FgsIoOapFdHH
         xupLUVSyuvgzVkSTmQT151MbgO2R71AVFD3xc=
MIME-Version: 1.0
Date: Tue, 23 Mar 2010 11:29:35 +0100
Message-ID: <cabda6421003230329w3fe596dbn8e4b37cc36118f9f@mail.gmail.com>
Subject: [PATCH v1 0/3] max3100: improvements
From: christian pellegrin <chripell@gmail.com>
To: linux-kernel@vger.kernel.org
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi all,

I think all the comments sent to me were dealt with so I'm resending
the patches. I haven't received any feedback about the addition to the
threaded interrupt code, but that part hasn't changed.

This bunch of patches should solve the problems noted by Feng to the
max3100 driver. It was tested on an S3C2440 system which has a rather
bad SPI master controller. The efficiency is very good on zmodem
receive (near 100% at 115200) and not so bad on zmodem send (around
95% at 115200). I guess the reason is the TX buffer of the MAX3100
being just one byte deep. All the tests were done with two MAX3100
running on the same SPI bus: the first one as a console and under
test, the second one happily receiving a 4800 bit/s NMEA stream from a
GPS (with a process checking we don't get wrong sentences). I also did
the simple "cut&paste a screenful of charters" test and it worked! The
console was stressed as much I could (things like putting the S3C to
suspend during a zmodem transfer and checking it restarts after
resume).


-- 
Christian Pellegrin, see http://www.evolware.org/chri/
"Real Programmers don't play tennis, or any other sport which requires
you to change clothes. Mountain climbing is OK, and Real Programmers
wear their climbing boots to work in case a mountain should suddenly
spring up in the middle of the computer room."
