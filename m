Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754094Ab2CDAl2 (ORCPT <rfc822;w@1wt.eu>);
	Sat, 3 Mar 2012 19:41:28 -0500
Received: from li9-11.members.linode.com ([67.18.176.11]:44301 "EHLO
	test.thunk.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753677Ab2CDAl0 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sat, 3 Mar 2012 19:41:26 -0500
Date: Sat, 3 Mar 2012 19:41:16 -0500
From: "Ted Ts'o" <tytso@mit.edu>
To: Samuel Thibault <samuel.thibault@ens-lyon.org>,
        "John G. Heim" <jheim@math.wisc.edu>,
        Alan Cox <alan@lxorguk.ukuu.org.uk>, linux-kernel@vger.kernel.org
Subject: Re: speakup bug
Message-ID: <20120304004116.GA3042@thunk.org>
Mail-Followup-To: Ted Ts'o <tytso@mit.edu>,
	Samuel Thibault <samuel.thibault@ens-lyon.org>,
	"John G. Heim" <jheim@math.wisc.edu>,
	Alan Cox <alan@lxorguk.ukuu.org.uk>, linux-kernel@vger.kernel.org
References: <BFFDBC9B6BA14BE1AC8E266A3A456A63@hinkle>
 <20120303173916.7eca9391@pyramind.ukuu.org.uk>
 <FD8CB954D8084F998E24C4558E41C627@hinkle>
 <20120304001806.GO4180@type.famille.thibault.fr>
 <20120304002111.GP4180@type.famille.thibault.fr>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <20120304002111.GP4180@type.famille.thibault.fr>
User-Agent: Mutt/1.5.20 (2009-06-14)
X-SA-Exim-Connect-IP: <locally generated>
X-SA-Exim-Mail-From: tytso@thunk.org
X-SA-Exim-Scanned: No (on test.thunk.org); SAEximRunCond expanded to false
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sun, Mar 04, 2012 at 01:21:11AM +0100, Samuel Thibault wrote:
> Samuel Thibault, le Sun 04 Mar 2012 01:18:06 +0100, a écrit :
> > Just for the record: what we need is being able to open a serial port
> > and read/write from inside the kernel. Using a daemon that does the open
> > and setting up speakup as a line discipline would be possible, but it
> > then depends on / working, and that's not something e.g. administrators
> > can really afford depending on.
> 
> BTW: yes, that does not mean that speakup couldn't use a line discipline
> already. Sure, still on the TODO list for years too.

Actualy you *can* open a tty from the kernel.  Look at how
/dev/console is opened in kernel_init() in init/main.c.  So you could
set up the line discipline out of the kernel if you really wanted to
get the speakup system set up in early boot, as opposed to setting
things up in either the initial ramdisk or in the init scripts.

If you don't even want a dependency on /, life gets a little harder,
but is that really that important?  The advantages of doing it cleanly
is that it will work on systems that don't have a normal serial port,
but only have a USB interface (for example, if you were going to try
to hack in support for a mobile device or some other embedded system).

   	   	       	 	       	  - Ted
