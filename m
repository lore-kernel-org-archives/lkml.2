Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932243Ab2ADX2U (ORCPT <rfc822;w@1wt.eu>);
	Wed, 4 Jan 2012 18:28:20 -0500
Received: from moutng.kundenserver.de ([212.227.17.10]:53365 "EHLO
	moutng.kundenserver.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932225Ab2ADX2M (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 4 Jan 2012 18:28:12 -0500
From: Arnd Bergmann <arnd@arndb.de>
To: Greg KH <gregkh@suse.de>
Subject: Re: [PATCH] serial: relocate remaining serial drivers from tty/ to tty/serial/
Date: Wed, 4 Jan 2012 23:27:33 +0000
User-Agent: KMail/1.12.2 (Linux/3.2.0-rc7; KDE/4.3.2; x86_64; ; )
Cc: Paul Gortmaker <paul.gortmaker@windriver.com>, Jiri Slaby <jslaby@suse.cz>,
        alan@linux.intel.com, linux-serial@vger.kernel.org,
        linux-kernel@vger.kernel.org, Jiri Slaby <jirislaby@gmail.com>
References: <1325707287-31038-1-git-send-email-paul.gortmaker@windriver.com> <4F04BFA8.9010100@windriver.com> <20120104220332.GA22985@suse.de>
In-Reply-To: <20120104220332.GA22985@suse.de>
MIME-Version: 1.0
Content-Type: Text/Plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Message-Id: <201201042327.33739.arnd@arndb.de>
X-Provags-ID: V02:K0:rg6yUf6si/AhyUpCN5IBr2H02B8q4PcUQJDLQqIHrl6
 jbRp/8XX57APWK/nHyvLWRWurEpBOfEfxiphBAn/r68gEi175Y
 OiZBcHH2c11LBh0KhxOEqYW5ouLg0aGvVRBJnO8mN93z9gdUtM
 x8//TLz0w9oGs91I4l4qWsrkKF+J07vehgse6z0oNw1GghzE6F
 n/9Fvk1I9pJZEa2mYHd/JCfSznJKtilr4iphtCn+BePeEZ/7tv
 cCXQzK6jpSJbi3i3Q6Sov27dUI60SwmOyOQclGwEoyksmX9G19
 T+0Zj5GYjT4uZaKb5UlkLm2lLE2hn0VfJ83VzPjc39o+a4V2g/
 nlqzwP8pgBYYkOUYUTxg=
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wednesday 04 January 2012, Greg KH wrote:
> > 
> > My thinking was that having a drivers/tty/serial dir and then
> > not having all the serial drivers in that dir violated the
> > principle of least surprise.  Is there a reason why the dir should
> > be the exclusive domain of drivers with a dependency on SERIAL_CORE?
> 
> Because that is what the directory is for?  :)
> 
> We have other "serial" like drivers all over the kernel, this was for
> the SERIAL_CORE drivers only at the moment.

My initial plan when moving some files to drivers/tty was to have a separate
directory for the non-SERIAL_CORE serial drivers next to drivers/tty/serial.

I would still prefer this solution, but I think we never agreed on a good
name for that directory. IIRC, I had suggested drivers/tty/legacy believing
that SERIAL_CORE was the modern way to implement a serial driver, but that
turned out not to be true and at lease one of these (bfin_jtag) is not
a legacy driver in practice.

Maybe drivers/tty/hw? I think that one has been suggested before, too.
I don't remember any argument against it and I think it would be nice
to separate the core implementation from actual device drivers.

	Arnd
