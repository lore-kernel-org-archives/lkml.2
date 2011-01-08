Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751762Ab1AHScu (ORCPT <rfc822;w@1wt.eu>);
	Sat, 8 Jan 2011 13:32:50 -0500
Received: from kroah.org ([198.145.64.141]:58025 "EHLO coco.kroah.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751371Ab1AHScu (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sat, 8 Jan 2011 13:32:50 -0500
Date: Sat, 8 Jan 2011 10:31:35 -0800
From: Greg KH <greg@kroah.com>
To: "Artem S. Tashkinov" <t.artem@lycos.com>
Cc: Geert Uytterhoeven <geert@linux-m68k.org>, linux-kernel@vger.kernel.org,
        Claudio Scordino <claudio@evidence.eu.com>
Subject: Re: On Linux numbering scheme
Message-ID: <20110108183135.GA22661@kroah.com>
References: <18673709.2121294505029740.JavaMail.root@mail-zbox20.bo3.lycos.com>
 <27552986.2181294505105130.JavaMail.root@mail-zbox20.bo3.lycos.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <27552986.2181294505105130.JavaMail.root@mail-zbox20.bo3.lycos.com>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sat, Jan 08, 2011 at 11:45:05AM -0500, Artem S. Tashkinov wrote:
> > What userspace scripts/applications expect numbers like that?  How do
> > they handle releases like what Linus just did (2.6.37)?
> > 
> 
> I've just grepped through all the shell scripts installed in Fedora 14 and
> I haven't found any `uname -r` references, so it seems like  the base system
> is quite safe (I haven't tried to grep through binaries as I have no clue
> how to check them).
> 
> However sources of VMWare/NVIDIA/VBox/etc. kernel modules have multiples
> instances of:
> 
> #if LINUX_VERSION_CODE < KERNEL_VERSION(2, 4, 7)
> #  error This driver does not support 2.4 kernels older than 2.4.7!
> #elif LINUX_VERSION_CODE < KERNEL_VERSION(2, 5, 0)
> #  define KERNEL_2_4
> #elif LINUX_VERSION_CODE < KERNEL_VERSION(2, 6, 0)
> #  error This driver does not support 2.5 kernels!
> #elif LINUX_VERSION_CODE < KERNEL_VERSION(2, 7, 0)
> #  define KERNEL_2_6
> #else
> #  error This driver does not support development kernels!
> #endif
> 
> So, it seems like the only obstacle that stops us from starting a completely
> new numbering scheme is proprietary or corporations driven/developed software.

No, those work just fine as well, you need to look at the KERNEL_VERSION
macro to see that.

And any numbering scheme we come up with, will of course be an
incremental number greater than our current number.

But this topic is on hold now until the next kernel summit when it will
be revisited again.  I narrowly missed changing the numbering scheme
last year, hopefully this year will be different.

thanks,

greg k-h
