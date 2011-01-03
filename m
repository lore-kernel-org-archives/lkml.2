Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932432Ab1ACSCx (ORCPT <rfc822;w@1wt.eu>);
	Mon, 3 Jan 2011 13:02:53 -0500
Received: from 81-174-11-161.staticnet.ngi.it ([81.174.11.161]:36296 "EHLO
	mail.enneenne.com" rhost-flags-OK-FAIL-OK-OK) by vger.kernel.org
	with ESMTP id S932322Ab1ACSCw (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 3 Jan 2011 13:02:52 -0500
Date: Mon, 3 Jan 2011 19:02:47 +0100
From: Rodolfo Giometti <giometti@enneenne.com>
To: Alan Cox <alan@lxorguk.ukuu.org.uk>
Cc: linux-kernel@vger.kernel.org, Russell Coker <russell@coker.com.au>,
        Greg Kroah-Hartman <gregkh@suse.de>
Message-ID: <20110103180247.GF22102@gundam.enneenne.com>
Mail-Followup-To: Alan Cox <alan@lxorguk.ukuu.org.uk>,
	linux-kernel@vger.kernel.org, Russell Coker <russell@coker.com.au>,
	Greg Kroah-Hartman <gregkh@suse.de>
References: <1294067735-21466-1-git-send-email-giometti@linux.it> <1294067735-21466-2-git-send-email-giometti@linux.it> <20110103171452.5e258743@lxorguk.ukuu.org.uk>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20110103171452.5e258743@lxorguk.ukuu.org.uk>
Organization: GNU/Linux Device Drivers, Embedded Systems and Courses
X-PGP-Key: gpg --keyserver keyserver.linux.it --recv-keys D25A5633
User-Agent: Mutt/1.5.18 (2008-05-17)
X-SA-Exim-Connect-IP: 192.168.32.254
X-SA-Exim-Mail-From: giometti@enneenne.com
Subject: Re: [PATCH] char nvtty: Network Virtual Terminal support
X-SA-Exim-Version: 4.2.1 (built Wed, 25 Jun 2008 17:14:11 +0000)
X-SA-Exim-Scanned: Yes (on mail.enneenne.com)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Jan 03, 2011 at 05:14:52PM +0000, Alan Cox wrote:
> > By using these devices and a proper compatible server (not included
> > here but you can use sredird) you can get access to a remote tty
> > device as the tty device itself was conneted with your local host.
> > All data and settings are sent and received through the network.
> 
> Interesting but would it not be better to keep all the network stuff in
> user space given that most sane environments will have crypto on them ?

Yes, but in most cases this is used on not-crypted connections (as far
as I know there are no crypted server for this protocol yet), however
we can easily get a crypted connection by connecting with localhost
and then using a program like cryptcat for the crypto stuff.

> It's also a less than ideal protocol in that it can't represent some of
> the things termios can, nor can it report arbitary speeds properly.

I see, but it is widely used and also it can be enhanced to better fit
termios capabilities.

However by using this protocol "as is" we can do several useful
things! :)

> Is there a reason it couldn't use pty/tty pairs either as is or tweaked
> to better report termios changes and allow modem line reporting ?

This is the solution that cyclades-serial-client uses (the userland
program where my patch is derived from) but as far as I know pty/tty
pairs cannot be used to report termios settings but only data... is
that right? =:-o

Ciao,

Rodolfo

-- 

GNU/Linux Solutions                  e-mail: giometti@enneenne.com
Linux Device Driver                          giometti@linux.it
Embedded Systems                     phone:  +39 349 2432127
UNIX programming                     skype:  rodolfo.giometti
Freelance ICT Italia - Consulente ICT Italia - www.consulenti-ict.it
