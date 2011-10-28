Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932214Ab1J1KvC (ORCPT <rfc822;w@1wt.eu>);
	Fri, 28 Oct 2011 06:51:02 -0400
Received: from lnx503.hrz.tu-darmstadt.de ([130.83.156.232]:55327 "EHLO
	lnx503.hrz.tu-darmstadt.de" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1755387Ab1J1Ku7 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 28 Oct 2011 06:50:59 -0400
From: Uwe Bonnes <bon@elektron.ikp.physik.tu-darmstadt.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=unknown
Content-Transfer-Encoding: 7bit
Message-ID: <20138.35080.947860.881774@elektron.ikp.physik.tu-darmstadt.de>
Date: Fri, 28 Oct 2011 12:50:48 +0200
To: Andrew Worsley <amworsley@gmail.com>
CC: Greg Kroah-Hartman <gregkh@suse.de>, Alan Cox <alan@linux.intel.com>,
        Johan Hovold <jhovold@gmail.com>,
        Jean-Christophe PLAGNIOL-VILLARD <plagnioj@jcrosoft.com>,
        linux-usb@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH] Fix Corruption issue in USB ftdi driver drivers/usb/serial/ftdi_sio.c
In-Reply-To: <CA+Y=x3=xEa6XVspsodhbKOArtZ7VMYSMLhpF4WZ1sFNfaJ_E9g@mail.gmail.com>
References: <CA+Y=x3=xEa6XVspsodhbKOArtZ7VMYSMLhpF4WZ1sFNfaJ_E9g@mail.gmail.com>
X-Mailer: VM 7.19 under Emacs 21.3.1
X-PMX-TU: seen v1.2 by 5.6.1.2065439, Antispam-Engine: 2.7.2.376379, Antispam-Data: 2011.10.28.103614
X-PMX-RELAY: outgoing
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

>>>>> "Andrew" == Andrew Worsley <amworsley@gmail.com> writes:

    Andrew> ftdi_set_termios() is always setting the baud rate and data bits
    Andrew> and parity on every call. When called while characters are being
    Andrew> transmitted can cause the FTDI chip to corrupt the serial port
    Andrew> bit stream by stalling the output half a bit during the output
    Andrew> of a character.  Simple fix by skipping this setting if the baud
    Andrew> rate/data bits/parity are unchanged.

    Andrew> Signed-off-by: Andrew Worsley <amworsley@gmail.com> ----

    Andrew> This bug was observed on 2.6.32 kernel (this patch is ported to
    Andrew> latest kernel for ease of review).  Using a FTDI USB serial chip
    Andrew> at 38400 repeatedly generating output by running a simple
    Andrew> command such as "uname -a" or "echo Linux" gives occasional
    Andrew> corruption on the output

    Andrew> ...
    >> echo Linux
    Andrew> L$,3u=(Bnux

Could you please give a more specific receipe to reproduce the bug. Running
with an adapter with TX/RX shorted at "stty -F /dev/ttyUSB0" 38400", several
> uname -a /dev/ttyUSB0
runs gave no artifact in a "seyon -modem /dev/ttyUSB0" console.

Doing 
> uname -a /dev/ttyUSB0
in one xterm and receiving with
>cat /dev/ttyUSB0
in another xterm gives lot of repeated lines in the receiving terminal. But
I have the same behaviour with /dev/ttyS0 on a real serial port on the
mainboard.

Otherwise, shouldn't all control transfers to the FTDI be only done with the
tx buffer in the FTDI empty? I guess the RX buffer is not affected by some
change. But this is something to be done with great knowledge...

Bye
-- 
Uwe Bonnes                bon@elektron.ikp.physik.tu-darmstadt.de

Institut fuer Kernphysik  Schlossgartenstrasse 9  64289 Darmstadt
--------- Tel. 06151 162516 -------- Fax. 06151 164321 ----------
