Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754069Ab1E2Nq5 (ORCPT <rfc822;w@1wt.eu>);
	Sun, 29 May 2011 09:46:57 -0400
Received: from cantor.suse.de ([195.135.220.2]:48501 "EHLO mx1.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753882Ab1E2Nq4 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 29 May 2011 09:46:56 -0400
Date: Sun, 29 May 2011 21:47:45 +0800
From: Greg KH <gregkh@suse.de>
To: Chris Metcalf <cmetcalf@tilera.com>
Cc: linux-kernel@vger.kernel.org, Arnd Bergmann <arnd@arndb.de>,
        Eric Biederman <ebiederm@aristanetworks.com>,
        Chris Wright <chrisw@sous-sol.org>,
        Benjamin Thery <benjamin.thery@bull.net>,
        Phil Carmody <ext-phil.2.carmody@nokia.com>
Subject: Re: [PATCH v2] arch/tile: add hypervisor-based character driver for
 SPI flash ROM
Message-ID: <20110529134745.GA26524@suse.de>
References: <4DD6FB9E.2050604@tilera.com>
 <20110521032102.GD19907@suse.de>
 <201105211133.50238.arnd@arndb.de>
 <4DD7C3A7.5010402@tilera.com>
 <BANLkTim-d-8w1_idg4u302aB3MqTo7q4Sg@mail.gmail.com>
 <201105281516.p4SFGfHg024703@farm-0010.internal.tilera.com>
 <20110528212347.GA11303@suse.de>
 <4DE19407.8040407@tilera.com>
 <20110529114517.GA13513@suse.de>
 <4DE2399C.9090500@tilera.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <4DE2399C.9090500@tilera.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sun, May 29, 2011 at 08:18:36AM -0400, Chris Metcalf wrote:
> >> Is there a good example of a character device that has multiple minors and
> >> also is registered with sysfs?
> > Lots of them, look all over the kernel, and in LDD3 there's even an
> > outdated example of one I think.
> 
>  I didn't actually find many drivers that have both cdev_add with count>1,
> and mention sysfs or kobj, but char/raw.c is one that looks pretty clean. 
> (I found only four others total: uio/uio.c, s390/char/vmlogrdr.c,
> staging/comedi/comedi_fops.c, and staging/vme/devices/vme_user.c.)

No, you don't need "raw" kobjects or sysfs at all.  Just use the
device_create() call.

Hope this helps,

greg k-h
