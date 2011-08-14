Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754602Ab1HNSIl (ORCPT <rfc822;w@1wt.eu>);
	Sun, 14 Aug 2011 14:08:41 -0400
Received: from einhorn.in-berlin.de ([192.109.42.8]:49524 "EHLO
	einhorn.in-berlin.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754329Ab1HNSIj (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 14 Aug 2011 14:08:39 -0400
X-Envelope-From: stefanr@s5r6.in-berlin.de
Date: Sun, 14 Aug 2011 20:03:22 +0200
From: Stefan Richter <stefanr@s5r6.in-berlin.de>
To: Rob Landley <rob@landley.net>
Cc: linux-kernel@vger.kernel.org, Artem.Bityutskiy@nokia.com,
        busybox@busybox.net
Subject: Re: [BUG] Linux 3.0 commit 3627924acf70a broke
 include/mtd/ubi_user.h.
Message-ID: <20110814200322.3fa7109d@stein>
In-Reply-To: <4E4809BF.6040707@landley.net>
References: <4E4809BF.6040707@landley.net>
X-Mailer: Claws Mail 3.7.9 (GTK+ 2.24.4; x86_64-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Aug 14 Rob Landley wrote:
> "make headers_install" copies include/mtd/ubi_user.h to userspace, where
> things like busybox link against it.  With 3.0, building defconfig
> busybox gets this error:
> 
> In file included from miscutils/ubi_tools.c:63:
> /home/landley/aboriginal/aboriginal/build/simple-cross-compiler-i686/bin/../include/mtd/ubi-user.h:329:
> error: conflicting types for '__packed'
> /home/landley/aboriginal/aboriginal/build/simple-cross-compiler-i686/bin/../include/mtd/ubi-user.h:313:
> error: previous declaration of '__packed' was here
> 
> This is due to the Linux 3.0 commit in the title:
> 
>     UBI: use __packed instead of __attribute__((packed))
> 
> This relies on __packed being defined in:
> 
>   include/linux/compiler-gcc.h:
>   #define __packed			__attribute__((packed))
> 
> Which is not exported to userspace.
> 
> I.E. this "cleanup" broke the ability for userspace to use this header,
> even though the header is exported to userspace by headers_install.

As far as I can tell, the __packed or __attribute__((packed))
qualifications are superfluous in include/mtd/ubi-user.h anyway.
-- 
Stefan Richter
-=====-==-== =--- -===-
http://arcgraph.de/sr/
