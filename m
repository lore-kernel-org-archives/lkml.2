Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757327Ab1CNVnH (ORCPT <rfc822;w@1wt.eu>);
	Mon, 14 Mar 2011 17:43:07 -0400
Received: from zone0.gcu-squad.org ([212.85.147.21]:1521 "EHLO
	services.gcu-squad.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753120Ab1CNVnF (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 14 Mar 2011 17:43:05 -0400
Date: Mon, 14 Mar 2011 22:42:44 +0100
From: Jean Delvare <khali@linux-fr.org>
To: Arnd Bergmann <arnd@arndb.de>
Cc: Jonathan Cameron <jic23@cam.ac.uk>,
        mems applications <mems.applications@st.com>, rdunlap@xenotime.net,
        carmine.iascone@st.com, matteo.dameno@st.com, rubini@cvml.unipv.it,
        linux-doc@vger.kernel.org, linux-kernel@vger.kernel.org,
        Guenter Roeck <guenter.roeck@ericsson.com>
Subject: Re: [PATCH] Add STMicroelectronics LPS001WP pressure sensor device
 driver into misc
Message-ID: <20110314224244.3d6d23ba@endymion.delvare>
In-Reply-To: <201103142136.43566.arnd@arndb.de>
References: <1300128906-1066-1-git-send-email-matteo.dameno@st.com>
	<4D7E771B.1040804@cam.ac.uk>
	<20110314211809.29da8518@endymion.delvare>
	<201103142136.43566.arnd@arndb.de>
X-Mailer: Claws Mail 3.7.5 (GTK+ 2.20.1; x86_64-unknown-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 14 Mar 2011 21:36:43 +0100, Arnd Bergmann wrote:
> On Monday 14 March 2011 21:18:09 Jean Delvare wrote:
> > Jonathan is correct. Pressure sensors are not hardware monitoring
> > devices, their drivers have nothing to do in drivers/hwmon. This is
> > something for drivers/misc or staging/iio.
> 
> I generally try to prevent people from adding more ad-hoc interfaces
> to drivers/misc. Anything that is called a drivers/misc driver to me
> must qualify as "there can't possibly be a second driver with the
> same semantics", otherwise it should be part of another subsystem
> with clear rules, or be put into its own file system.

I see drivers/misc differently. I see it as "not enough drivers of the
same type to justify a new subsystem". So I encourage people to put
things there in the absence of any suitable subsystem, until someone
gets enough motivation to start such a subsystem. This is more
pragmatic than requesting subsystems to be created upfront.

That being said, staging is another option nowadays.

> While it seems that right now everyone is just trying to keep move
> the driver to some other subsystem, I think it's worth noting that
> it is indeed a useful thing to have the driver, I'm optimistic
> that we can find some place for it. ;-)
> 
> Now how about the IIO stuff? This is the first time I've even
> heard about it. Does it have any major disadvantages besides
> being staging-quality?

This is indeed the major disadvantage. IIO seems to take a lot of time
to move out of staging, although I don't know what the current ETA is.

-- 
Jean Delvare
