Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759596Ab1F1Qwq (ORCPT <rfc822;w@1wt.eu>);
	Tue, 28 Jun 2011 12:52:46 -0400
Received: from moutng.kundenserver.de ([212.227.17.10]:61424 "EHLO
	moutng.kundenserver.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1758636Ab1F1QvR (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 28 Jun 2011 12:51:17 -0400
From: Arnd Bergmann <arnd@arndb.de>
To: Alan Cox <alan@lxorguk.ukuu.org.uk>
Subject: Re: [PATCH] [media] v4l2 core: return -ENOIOCTLCMD if an ioctl doesn't exist
Date: Tue, 28 Jun 2011 18:50:56 +0200
User-Agent: KMail/1.12.2 (Linux/2.6.31-22-generic; KDE/4.3.2; x86_64; ; )
Cc: Linus Torvalds <torvalds@linux-foundation.org>,
        Hans Verkuil <hverkuil@xs4all.nl>,
        Mauro Carvalho Chehab <mchehab@redhat.com>,
        Sakari Ailus <sakari.ailus@iki.fi>,
        Linux Media Mailing List <linux-media@vger.kernel.org>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
References: <4E0519B7.3000304@redhat.com> <BANLkTi=6W0quy1M71UapwKDe97E67b4EiA@mail.gmail.com> <20110628174223.3d78ca4c@lxorguk.ukuu.org.uk>
In-Reply-To: <20110628174223.3d78ca4c@lxorguk.ukuu.org.uk>
MIME-Version: 1.0
Content-Type: Text/Plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Message-Id: <201106281850.57239.arnd@arndb.de>
X-Provags-ID: V02:K0:BqrCBd9vmzmzAc9dduuBlZAFXN8hm0nmpVkx5Oxu9Tk
 SwLNmDd7w6Ny5eGNvCPlRNKq/aecRXlqVkTKnST05aO6219pg0
 0vX92eDQFtaMVGuXWtIoiar8H0BCWT5TT4ownMuOWCEZAQRUbp
 u4pibpK82broNlAYaH4lWJY4lZOqcTP7yGJjBqqPjWQMa5vp0i
 mdQ1d4AKiYka8zbR466nw==
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tuesday 28 June 2011, Alan Cox wrote:
> > (In fact, the correct thing to do would probably be to just do
> > 
> >    #define ENOIOCTLCMD ENOTTY
> > 
> > and get rid of any translation - just giving ENOTTY a more appropriate
> > name and less chance for confusion)
> 
> Some code uses the two to separate 'the driver specific helper code
> doesn't handle this' and 'does handle this'. In that situation you take
> away the ability of a driver to override a midlayer ioctl with -ENOTTY to
> say "I don't support this even if most people do"

Right. Similarly, in compat_sys_ioctl returning -ENOIOCTLCMD from
fops->compat_ioctl means "the driver has provided no compatibility
handler for this command, need to check the global translation table",
while -ENOTTY returned from ->compat_ioctl means "this command won't
work on this device, don't bother looking at the table and don't
print an annoying message".

	Arnd
