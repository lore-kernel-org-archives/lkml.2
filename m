Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751674Ab1AEPXW (ORCPT <rfc822;w@1wt.eu>);
	Wed, 5 Jan 2011 10:23:22 -0500
Received: from 81-174-11-161.staticnet.ngi.it ([81.174.11.161]:36535 "EHLO
	mail.enneenne.com" rhost-flags-OK-FAIL-OK-OK) by vger.kernel.org
	with ESMTP id S1750699Ab1AEPXU (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 5 Jan 2011 10:23:20 -0500
Date: Wed, 5 Jan 2011 16:23:13 +0100
From: Rodolfo Giometti <giometti@enneenne.com>
To: Hans-Peter Jansen <hpj@urpla.net>
Cc: linux-kernel@vger.kernel.org, Russell Coker <russell@coker.com.au>,
        Greg Kroah-Hartman <gregkh@suse.de>
Message-ID: <20110105152313.GC3937@enneenne.com>
Mail-Followup-To: Hans-Peter Jansen <hpj@urpla.net>,
	linux-kernel@vger.kernel.org, Russell Coker <russell@coker.com.au>,
	Greg Kroah-Hartman <gregkh@suse.de>
References: <1294067735-21466-1-git-send-email-giometti@linux.it>
 <201101041813.49759.hpj@urpla.net>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <201101041813.49759.hpj@urpla.net>
Organization: GNU/Linux Device Drivers, Embedded Systems and Courses
X-PGP-Key: gpg --keyserver keyserver.linux.it --recv-keys D25A5633
User-Agent: Mutt/1.5.20 (2009-06-14)
X-SA-Exim-Connect-IP: 192.168.32.37
X-SA-Exim-Mail-From: giometti@enneenne.com
Subject: Re: Network Virtual Terminal
X-SA-Exim-Version: 4.2.1 (built Wed, 25 Jun 2008 17:14:11 +0000)
X-SA-Exim-Scanned: Yes (on mail.enneenne.com)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Jan 04, 2011 at 06:13:46PM +0100, Hans-Peter Jansen wrote:
> Dear Rodolfo,
> 
> On Monday 03 January 2011, 16:15:34 Rodolfo Giometti wrote:
> > Hello,
> >
> > here my implementation of Network Virtual terminals (NVT tty)
> > according to RFC 854 and RFC 2217... actually this is the client side
> > part since as remote server I used sredird
> > (http://freshmeat.net/projects/sredird/).
> 
> Sounds interesting. Could you outline the limits a bit? In one of my use 
> cases, I need to support 1200 baud with a rather esoteric 7E2 serial 
> setup. (Needless to say, the client is a butt ugly win app to control 
> gasoline pumps, running inself in a VMware WS setup. I'm supporting 
> this since ten years now, where VMware took about 4 years to get the 
> serial setup right finally...) Being able to redirect the serial data 
> over network (in an inexpensive, but reliable way) would make my life 
> significant easier in this respect.

My code is just one halve of the game... to solve your problem you
need a server on the machine where the serial port is installed and
you need that the server itself can manage it.

Here a simple schema of the whole game (it's my testing environment
but it can explain the situation anyway):

        ------------------+
             +---------+  |
             | minicom |  |
             +---------+  |
                  |       | local PC with no
                  v       | serial ports
             /dev/nvtty0  |
                  |       |
        ------------------+
                  |
                  v
             /\/\/\/\/\
            | network |
             \/\/\/\/\/
                  |
        ------------------+
                  |       |
                  v       |
             +---------+  |
             | sredird |  |
             +---------+  | remote PC with
                  |       | serial ports
                  v       |
             /dev/ttyS0   |
                  |       |
        ------------------+
                  |
                  v
         embedded PC with
         a serial console

As you can see the program sredird
(http://freshmeat.net/projects/sredird/) manages the real serial port
according to the commands received from nvtty0 device and it
sends/receives the serial data to/from it and the userland application
(minicom in this example) doesn't see any difference from working on a
real serial port.

Hope this is useful to you.

Ciao,

Rodolfo

-- 

GNU/Linux Solutions                  e-mail: giometti@enneenne.com
Linux Device Driver                          giometti@linux.it
Embedded Systems                     phone:  +39 349 2432127
UNIX programming                     skype:  rodolfo.giometti
Freelance ICT Italia - Consulente ICT Italia - www.consulenti-ict.it
