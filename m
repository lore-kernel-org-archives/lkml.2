Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753707Ab2CCX5b (ORCPT <rfc822;w@1wt.eu>);
	Sat, 3 Mar 2012 18:57:31 -0500
Received: from li9-11.members.linode.com ([67.18.176.11]:44451 "EHLO
	test.thunk.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752797Ab2CCX5a (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sat, 3 Mar 2012 18:57:30 -0500
Date: Sat, 3 Mar 2012 17:01:11 -0500
From: "Ted Ts'o" <tytso@mit.edu>
To: Alan Cox <alan@lxorguk.ukuu.org.uk>
Cc: "John G. Heim" <jheim@math.wisc.edu>, linux-kernel@vger.kernel.org
Subject: Re: speakup bug
Message-ID: <20120303220111.GB6117@thunk.org>
Mail-Followup-To: Ted Ts'o <tytso@mit.edu>,
	Alan Cox <alan@lxorguk.ukuu.org.uk>,
	"John G. Heim" <jheim@math.wisc.edu>, linux-kernel@vger.kernel.org
References: <BFFDBC9B6BA14BE1AC8E266A3A456A63@hinkle>
 <20120303173916.7eca9391@pyramind.ukuu.org.uk>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20120303173916.7eca9391@pyramind.ukuu.org.uk>
User-Agent: Mutt/1.5.20 (2009-06-14)
X-SA-Exim-Connect-IP: <locally generated>
X-SA-Exim-Mail-From: tytso@thunk.org
X-SA-Exim-Scanned: No (on test.thunk.org); SAEximRunCond expanded to false
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sat, Mar 03, 2012 at 05:39:16PM +0000, Alan Cox wrote:
> On Sat, 3 Mar 2012 11:18:12 -0600
> "John G. Heim" <jheim@math.wisc.edu> wrote:
> 
> > I need help fixing a bug in the driver for serial hardware  speech synths in 
> > the speakup screen reader. According to the comments in the code, it is in a 
> > part of the code that is trying to "steal" the serial port.
> 
> Yes - and the code is broken. To start with it's assumig a legacy PC
> serial port at 0x3F8 and that it can beat the serial layer to it.

Worse yet, it busy waits when sending characters to the UART.  Ugh...

> The proper fix is to make the drivers work via the serial layer properly.
> The speakup people have been told this repeatedly for years and years
> which is why their drivers work on less and less systems and won't run
> with things PCI or USB serial ports, and why they are forever buried in
> staging.

The driver desperately needs to be rewritten to attach to the serial
layer via a tty line discpline.  That way it will work on other types
of serial ports (i.e., PCI bus attached and USB devices).

   	  	       	       		    - Ted
