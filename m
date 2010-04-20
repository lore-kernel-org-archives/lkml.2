Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755243Ab0DTUgE (ORCPT <rfc822;w@1wt.eu>);
	Tue, 20 Apr 2010 16:36:04 -0400
Received: from www84.your-server.de ([213.133.104.84]:36885 "EHLO
	www84.your-server.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755159Ab0DTUgB (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 20 Apr 2010 16:36:01 -0400
Subject: Re: [PATCH 0/4] enhanced reimplemention of the kfifo API
From: Stefani Seibold <stefani@seibold.net>
To: Greg KH <gregkh@suse.de>
Cc: linux-kernel@vger.kernel.org, akpm@linux-foundation.org,
       andi@firstfloor.org, alan@lxorguk.ukuu.org.uk, tytso@mit.edu,
       iws@ovro.caltech.edu
In-Reply-To: <20100420201642.GA32373@suse.de>
References: <1271794000-18897-1-git-send-email-stefani@seibold.net>
	 <20100420201642.GA32373@suse.de>
Content-Type: text/plain; charset="ISO-8859-15"
Date: Tue, 20 Apr 2010 22:35:47 +0200
Message-ID: <1271795747.16051.18.camel@wall-e.seibold.net>
Mime-Version: 1.0
X-Mailer: Evolution 2.28.3.1 
Content-Transfer-Encoding: 7bit
X-Authenticated-Sender: stefani@seibold.net
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

>  
> > This are the features which are currently not used in the kernel:
> > 
> > kfifo_to_user()
> > kfifo_from_user()
> > kfifo_dma_....() macros
> > kfifo_esize()
> > kfifo_recsize()
> > kfifo_put()
> > kfifo_get()
> > the fixed size record elements, exclude "unsigned char" fifo's and
> > the variable size records fifo's
> 
> If you have features that have no users, why add them?  Do you think
> that some drivers need/want these features?
> 

Some developers ask me for this features, so i am a nice girl and
implemented it. Especially the kfifo_to_user() and kfifo_from_user() was
desired and is IMHO very useful. 

kfifo_put(), kfifo_get(), kfifo_esize() and kfifo_recsize() didn't coast
anything, because there are only macros.

Andrew agreed that we add this for a given time period, and have a look
what happens. The code overhead is not to much.

It is a chicken and egg problem: If we do not provide this features,
nobody can use it and everyone will write it's own implementation.

I also plan to port some drivers to the new generic kfifo API, where i
own the hardware.

Stefani


