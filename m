Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753250Ab1JLNXL (ORCPT <rfc822;w@1wt.eu>);
	Wed, 12 Oct 2011 09:23:11 -0400
Received: from moutng.kundenserver.de ([212.227.17.10]:49452 "EHLO
	moutng.kundenserver.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752992Ab1JLNXL (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 12 Oct 2011 09:23:11 -0400
From: Arnd Bergmann <arnd@arndb.de>
To: Jiri Slaby <jslaby@suse.cz>
Subject: Re: [PATCH 3/4] TTY: pty, release tty in all ptmx_open fail paths
Date: Wed, 12 Oct 2011 15:23:05 +0200
User-Agent: KMail/1.12.2 (Linux/2.6.37; KDE/4.3.2; x86_64; ; )
Cc: gregkh@suse.de, linux-kernel@vger.kernel.org, jirislaby@gmail.com,
        stable@kernel.org, Alan Cox <alan@lxorguk.ukuu.org.uk>
References: <4E8C6836.1090601@suse.cz> <1318411965-23917-1-git-send-email-jslaby@suse.cz> <1318411965-23917-3-git-send-email-jslaby@suse.cz>
In-Reply-To: <1318411965-23917-3-git-send-email-jslaby@suse.cz>
MIME-Version: 1.0
Content-Type: Text/Plain;
  charset="iso-8859-15"
Content-Transfer-Encoding: 7bit
Message-Id: <201110121523.05567.arnd@arndb.de>
X-Provags-ID: V02:K0:LnP2QBoukYV/YUQAKgd2+k94Q2p0793NMNsACQ4khtQ
 9cOgwJcez73QnR/J3bsP7SkZYZ91xzz+T4HyRpwmX8ZfdkZzml
 6d+OaNgZxZedLytRza4ja5PCT+yy5J3qT894iVtJqSh11joOSc
 BulQeqekoOUkRBaK44ZCNVyaddz2xeeFpBeYI2TLWCB3U1UxMF
 ySHHUcBHT0wtcItNy5gcvLu73Guek2ilFft/XeYRrAWlQJT91K
 iTLKY/A9xPe/T6mBNwN3QG7aQak4kEsIx7MF0ycarsIStvbg4n
 WEjUay3DZjNrWhYkY8qH4JRV9rsPYQjwuSfJ7db+mZVlCcyXEw
 WtI0xXKvaZwRdiCUj7x4=
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wednesday 12 October 2011, Jiri Slaby wrote:
> Mistakenly, commit 64ba3dc3143d (tty: never hold BTM while getting
> tty_mutex) switched one fail path in ptmx_open to not free the newly
> allocated tty.
> 
> Fix that by jumping to the appropriate place. And rename the labels so
> that it's clear what is going on there.
> 
> Introduced-in: v2.6.36-rc2
> Signed-off-by: Jiri Slaby <jslaby@suse.cz>
> Cc: stable@kernel.org
> Cc: Arnd Bergmann <arnd@arndb.de>
> Cc: Alan Cox <alan@lxorguk.ukuu.org.uk>
> Cc: Greg Kroah-Hartman <gregkh@suse.de>

Ok, I have checked that this patch returns the code into the state
before my broken patch, that looks good.

I think I made the same mistake trying to understand your patch
that I made originally when I introduced the bug, which was to
confuse the lifetime of the pty master with the lifetime of the
slave device, so I thought that tty_release should not be called
if we never called ptm_driver->ops->open(), but that's actually
a different device.

	Arnd
