Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754091Ab1BVOoq (ORCPT <rfc822;w@1wt.eu>);
	Tue, 22 Feb 2011 09:44:46 -0500
Received: from cantor2.suse.de ([195.135.220.15]:50761 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753515Ab1BVOop (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 22 Feb 2011 09:44:45 -0500
Date: Tue, 22 Feb 2011 06:37:04 -0800
From: Greg KH <gregkh@suse.de>
To: Subhasish Ghosh <subhasish@mistralsolutions.com>
Cc: Arnd Bergmann <arnd@arndb.de>, linux-arm-kernel@lists.infradead.org,
        Thomas Gleixner <tglx@linutronix.de>,
        Alan Cox <alan@lxorguk.ukuu.org.uk>, sachi@mistralsolutions.com,
        davinci-linux-open-source@linux.davincidsp.com, nsekhar@ti.com,
        open list <linux-kernel@vger.kernel.org>, m-watkins@ti.com
Subject: Re: [PATCH v2 13/13] tty: pruss SUART driver
Message-ID: <20110222143704.GA978@suse.de>
References: <1297435892-28278-1-git-send-email-subhasish@mistralsolutions.com>
 <20110218143500.23b3044b@lxorguk.ukuu.org.uk>
 <alpine.LFD.2.00.1102181917520.2701@localhost6.localdomain6>
 <201102181951.32631.arnd@arndb.de>
 <9826735BD9DD48A599C595D28C4A05F0@subhasishg>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <9826735BD9DD48A599C595D28C4A05F0@subhasishg>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Feb 22, 2011 at 02:12:32PM +0530, Subhasish Ghosh wrote:
> Hello,
> 
> I had kept separate files to affirm the modularity and ease of
> portability of the system.
> 
> There are three different interfaces,
> 1. The Linux driver interface
> 2. The PRU control interface
> 3. The McASP serializer interface.
> 
> To maintain modularity, I  had classified the files respectively as :
> 1.  pruss_suart.c
> 2.  pruss_suart_api.c
> 3.  pruss_suart_utils.c
> 
> This is not a single device which can be expressed as a single file,
> but functionally different devices logically cascaded together to
> work in unison.
> 
> We use the PRU for packet processing, but the actual data is
> transmitted/received through the
> McASP, which we use as a serializer.
> 
> I feel to combine these disparate functionalities into a single file
> will not
> 
> 1. Help better understanding the device. I mean, why should a TTY
> UART driver be aware of the McASP or the PRU.
> 2. In case of a bug in the API layer or McASP, the driver need not
> be touched, thus improve maintainability.
> 3. If we need to port it to another Linux version, just editing the
> driver file should suffice, this will reduce bugs while porting.

If your code is in the kernel tree, you do not need to ever port it to a
new version, as it will happen automatically as new kernels are
released, so this really isn't anything to worry about.

> To me, combining all of these into a single file only creates a
> mess. This is the reason I had separated them into different files!!
> I don't understand why should it be better to have all of these into
> a single file.

As Alan stated, just use 3 files in the directory with the other
drivers, you don't need a subdir for something small like this.

thanks,

greg k-h
