Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757294Ab0FTUzK (ORCPT <rfc822;w@1wt.eu>);
	Sun, 20 Jun 2010 16:55:10 -0400
Received: from moutng.kundenserver.de ([212.227.17.8]:57836 "EHLO
	moutng.kundenserver.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757079Ab0FTUzF (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 20 Jun 2010 16:55:05 -0400
From: Arnd Bergmann <arnd@arndb.de>
To: Alan Cox <alan@lxorguk.ukuu.org.uk>
Subject: Re: [PATCH] serial: revert "Use block_til_ready helper"
Date: Sun, 20 Jun 2010 22:54:34 +0200
User-Agent: KMail/1.13.2 (Linux/2.6.35-rc3-00053-g34ffc96; KDE/4.4.2; x86_64; ; )
Cc: Tony Luck <tony.luck@intel.com>, Frederic Weisbecker <fweisbec@gmail.com>,
       linux-kernel@vger.kernel.org, Greg KH <gregkh@suse.de>,
       Thomas Gleixner <tglx@linutronix.de>,
       Andrew Morton <akpm@linux-foundation.org>,
       John Kacur <jkacur@redhat.com>, Al Viro <viro@zeniv.linux.org.uk>,
       Ingo Molnar <mingo@elte.hu>
References: <1273957196-13768-1-git-send-email-arnd@arndb.de> <201006192229.21971.arnd@arndb.de> <20100619225706.340eda52@lxorguk.ukuu.org.uk>
In-Reply-To: <20100619225706.340eda52@lxorguk.ukuu.org.uk>
MIME-Version: 1.0
Content-Type: Text/Plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Message-Id: <201006202254.34530.arnd@arndb.de>
X-Provags-ID: V01U2FsdGVkX18fpfRT31T8oLrVA0IRj8PL6D7EacEEsiNtwBM
 uF9KufIgXVtyXswZN2KpsEdXVEx8yjIg2eGKLgA+HZHJ9dTTfm
 njIX+leA78yqleeJG9nUw==
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Saturday 19 June 2010 23:57:06 Alan Cox wrote:
> 
> Important question - does it need a getty or will a simple cat < /dev/foo
> twice get garbled (or cat > if its garbling the other way)
>
> Which direction matters and whether a hangup is needed matters

What I see is totally reproducible but does not make any sense to me.
In my test setup I have a serial cable between /dev/ttyS0 (on-board
16550A) and /dev/ttyUSB0 on the same machine.

When I start minicom on ttyS0 (or cat, for that matter), and start
a getty on ttyUSB0 (or write into it any other way), everything is
totally fine.

I can observe the following problems when I start minicom on ttyUSB0:
- writing to ttyS0 using cat alone gives garbled output
- writing to ttyS0 using minicom always works
- running a getty on ttyS0 lets me log in once
- writing to ttyS0 using cat works fine while a working getty or minicom
  also has ttyS0 open
- running the getty on ttyS0 a second time gives me the same garbled
  output as cat gives me

The way that the output is garbled seems to be just missing characters,
in a mostly reproducible way. Repeatedly writing the string
abcdefghijklmnopqrstuvwxyz1234567890 into ttyS0 gives an output like
'akq7m3iy', where only every sixteenth character is shown, plus
an extra character in the second position.

	Arnd
