Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752339Ab2KDUwG (ORCPT <rfc822;w@1wt.eu>);
	Sun, 4 Nov 2012 15:52:06 -0500
Received: from moutng.kundenserver.de ([212.227.126.186]:49324 "EHLO
	moutng.kundenserver.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751846Ab2KDUwD (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 4 Nov 2012 15:52:03 -0500
From: Arnd Bergmann <arnd@arndb.de>
To: Julia Lawall <julia.lawall@lip6.fr>
Subject: Re: [PATCH] drivers/misc/kgdbts.c: remove eprintk
Date: Sun, 4 Nov 2012 20:51:58 +0000
User-Agent: KMail/1.12.2 (Linux/3.5.0; KDE/4.3.2; x86_64; ; )
Cc: walter harms <wharms@bfs.de>, kernel-janitors@vger.kernel.org,
        "Greg Kroah-Hartman" <gregkh@linuxfoundation.org>,
        Jason Wessel <jason.wessel@windriver.com>,
        kgdb-bugreport@lists.sourceforge.net, linux-kernel@vger.kernel.org
References: <1351940317-14812-1-git-send-email-Julia.Lawall@lip6.fr> <201211041939.51608.arnd@arndb.de> <alpine.DEB.2.02.1211042051190.1960@localhost6.localdomain6>
In-Reply-To: <alpine.DEB.2.02.1211042051190.1960@localhost6.localdomain6>
MIME-Version: 1.0
Content-Type: Text/Plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Message-Id: <201211042051.58473.arnd@arndb.de>
X-Provags-ID: V02:K0:xRwbcVeb1yeDBY2mPSftPQLckQX0jMjGQ0gppMnGnAj
 LuxMzFCbDYfAXW5QOuAx6KSBY5CmutsX7sUjLz+H6KN6r1LlmK
 YcooEk3G3/TLojoPzRpbXaB+HhF4wG/Vw0NFzA0C4/ZpsynG89
 aXoHM9osjexnvggbQ0b1PXFUwIB9KVQEnLUoykkW8M9/ZsqW+E
 XEp0gEupOlazde4znXLTXJ00HCzR/YUmPTwzTj1FOQ40yr3fc/
 kHEHwFWUXsun2zCJv47vKYW49uuxt7N5vZl+aQGF0DBpGPxFdd
 gw3RwQMfE/9h+klYosl/YawLvhg6YEYxndS+yD5WC9v6mll8u+
 4UEhCFGr/VE1X0/LVpZk=
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sunday 04 November 2012, Julia Lawall wrote:

> > Hmm, I did not think that WARN() took a KERN_ERR argument, which should
> > really be implied here. Looking at the code, it really seems to be required
> > at the moment, but only 5 out of 117 callers use it this way.
> >
> > Any idea what is going on here?
> 
> I'm not sure to understand the 5 and 117.  Using grep, I get 30 with 
> KERN_ERR, 61 with some KERN thing, and 1207 without KERN. 

Right, I was using 'grep -w', which misses a lot of the instances, although
I see still much fewer in the last category.

> If things are 
> set up such that warn_slowpath_fmt is called, then that function adds
> KERN_WARNING.  There is an alternate definition of __WARN_printf that just 
> does a printk.

I don't see yet where that KERN_WARNING gets added. Looking at
warn_slowpath_common, there are two or three lines that get printed at 
KERN_WARNING level, followed by the format that got passed into WARN(),
which may or may not include a printk level, but I don't see one getting
added.


	Arnd
