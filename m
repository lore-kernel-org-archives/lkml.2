Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754704Ab0IOQjG (ORCPT <rfc822;w@1wt.eu>);
	Wed, 15 Sep 2010 12:39:06 -0400
Received: from moutng.kundenserver.de ([212.227.17.10]:51433 "EHLO
	moutng.kundenserver.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752152Ab0IOQjE (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 15 Sep 2010 12:39:04 -0400
From: Arnd Bergmann <arnd@arndb.de>
To: Valdis.Kletnieks@vt.edu
Subject: Re: [PATCH 00/15] change default_llseek action
Date: Wed, 15 Sep 2010 18:37:29 +0200
User-Agent: KMail/1.12.2 (Linux/2.6.35-16-generic; KDE/4.3.2; x86_64; ; )
Cc: linux-kernel@vger.kernel.org, Al Viro <viro@zeniv.linux.org.uk>,
        Christoph Hellwig <hch@infradead.org>, David Airlie <airlied@linux.ie>,
        dri-devel@lists.freedesktop.org, Jeremy Kerr <jk@ozlabs.org>,
        "John W. Linville" <linville@tuxdriver.com>,
        Julia Lawall <julia@diku.dk>,
        Linus Torvalds <torvalds@linux-foundation.org>,
        linux-fsdevel@vger.kernel.org, linux-omap@vger.kernel.org,
        linuxppc-dev@ozlabs.org, linux-wireless@vger.kernel.org,
        netdev@vger.kernel.org, Samuel Ortiz <samuel@sortiz.org>,
        Stephen Rothwell <sfr@canb.auug.org.au>,
        Tony Lindgren <tony@atomide.com>
References: <1284495763-7506-1-git-send-email-arnd@arndb.de> <9828.1284565136@localhost>
In-Reply-To: <9828.1284565136@localhost>
MIME-Version: 1.0
Content-Type: Text/Plain;
  charset="iso-8859-15"
Content-Transfer-Encoding: 7bit
Message-Id: <201009151837.30026.arnd@arndb.de>
X-Provags-ID: V02:K0:ex9V76nyzMg12EaSj+o1mbNufW8QptUVw/LKeoZHEVA
 /IMkt9dbVPHFWezEZ6GO2YrEKXZn8kIGbwcrfEyFwDSCYEvWS/
 T5CTzLGFoy4I8j8LNpyYX2x2HY4ThX1RZ+D17IDtOfkd+u5DMd
 7paLzS7gGeLkilqdaoiASgwGYoD5ZCld0z9AxPl20UKXEPxxR+
 7Mv6FkUzuv7vBtbZkCwkg==
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wednesday 15 September 2010, Valdis.Kletnieks@vt.edu wrote:
>   Show Details
>   On Tue, 14 Sep 2010 22:22:28 +0200, Arnd Bergmann said:
> 
> > This changes all instances of struct file_operations in
> > the kernel to have a .llseek operation and then changes
> > the default to no_llseek, which returns -ESPIPE, which
> > is what we had decided some time ago in a discussion
> > with Christoph Hellwig.
> 
> I don't suppose there's any clean way to throw a build error or a
> printk_on_once() or something if we encounter an unconverted 'struct
> file_operations', is there? I have this creeping fear that this patch will go
> upstream during the merge window - as will 12 new staging/ drivers from authors
> who didn't get the memo yet.
> 
> Other than the "missed converting a new usage" issue, it looks OK to me.

One advantage of the scripted approach is that I can run the script
repeatedly, and send a patch after -rc1 fixing up all the new file
operations.

Moreover, any new drivers are by definition not regressions and staging
drivers are expected to have issues. IIRC the most common llseek operation
is 'noop_llseek', which usually means it should have been 'no_llseek' to
start with, but since this has been in a released kernel, some random
user application might expect a seek on that file to succeed without
error.

	Arnd
