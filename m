Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S966357Ab2C3Vc7 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 30 Mar 2012 17:32:59 -0400
Received: from out1-smtp.messagingengine.com ([66.111.4.25]:54161 "EHLO
	out1-smtp.messagingengine.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S966346Ab2C3Vcz (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 30 Mar 2012 17:32:55 -0400
X-Sasl-enc: hQvA0F01SI9h4iGO9X9uKQ2DmgZQaPOZ+EesR3Cyekrs 1333143174
Date: Fri, 30 Mar 2012 14:17:44 -0700
From: Greg KH <gregkh@linuxfoundation.org>
To: Arnd Bergmann <arnd@arndb.de>
Cc: Thomas Gleixner <tglx@linutronix.de>,
        Sasha Levin <levinsasha928@gmail.com>, viro@zeniv.linux.org.uk,
        davej@redhat.com, linux-kernel@vger.kernel.org
Subject: Re: [PATCH] kmsg: Use vmalloc instead of kmalloc when writing
Message-ID: <20120330211744.GA16314@kroah.com>
References: <1333127067-2043-1-git-send-email-levinsasha928@gmail.com>
 <20120330204235.GA883@kroah.com>
 <alpine.LFD.2.02.1203302247130.2542@ionos>
 <201203302105.52987.arnd@arndb.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <201203302105.52987.arnd@arndb.de>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Mar 30, 2012 at 09:05:52PM +0000, Arnd Bergmann wrote:
> On Friday 30 March 2012, Thomas Gleixner wrote:
> > I think so. This is an interface to inject stuff into dmesg. Limiting
> > that to a reasonable size makes sense. We can probably limit it to
> > something small like 1024, but I don't know about the "ideas" of those
> > folks who think that it's a great idea to do it at all.
> 
> I guess a page would be a reasonable size, similar to what we do for
> sysfs. 

Ok. Sasha, as you seem to have noticed this, care to dig in syslog and
systemd to get an idea of the buffer sizes they are expecting to pass
into kmsg, and if they can handle a short write properly?  If so,
restricting it to a page is fine with me, otherwise we might want to
make it a bit bigger.

thanks,

greg k-h
