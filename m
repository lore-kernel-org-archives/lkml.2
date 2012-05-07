Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755828Ab2EGInp (ORCPT <rfc822;w@1wt.eu>);
	Mon, 7 May 2012 04:43:45 -0400
Received: from cpsmtpb-ews02.kpnxchange.com ([213.75.39.5]:4558 "EHLO
	cpsmtpb-ews02.kpnxchange.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1755594Ab2EGIno (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 7 May 2012 04:43:44 -0400
Message-ID: <1336380219.1933.16.camel@x61.thuisdomein>
Subject: Re: [PATCH] ramster: depend on CONFIG_NET for sock_* functions
From: Paul Bolle <pebolle@tiscali.nl>
To: Sasha Levin <levinsasha928@gmail.com>
Cc: gregkh@linuxfoundation.org, dan.magenheimer@oracle.com,
        sjenning@linux.vnet.ibm.com, linux-kernel@vger.kernel.org
Date: Mon, 07 May 2012 10:43:39 +0200
In-Reply-To: <CA+1xoqcWvJbGgaWt-5XvANH5zZiMXpZVZEQv4cWTr1XHdPu-7Q@mail.gmail.com>
References: <1336377752-23985-1-git-send-email-levinsasha928@gmail.com>
	 <1336378205.1933.3.camel@x61.thuisdomein>
	 <CA+1xoqcWvJbGgaWt-5XvANH5zZiMXpZVZEQv4cWTr1XHdPu-7Q@mail.gmail.com>
Content-Type: text/plain; charset="UTF-8"
X-Mailer: Evolution 3.2.3 (3.2.3-3.fc16) 
Content-Transfer-Encoding: 7bit
Mime-Version: 1.0
X-OriginalArrivalTime: 07 May 2012 08:43:39.0261 (UTC) FILETIME=[7FC882D0:01CD2C2D]
X-RcptDomain: vger.kernel.org
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 2012-05-07 at 10:29 +0200, Sasha Levin wrote:
> On Mon, May 7, 2012 at 10:10 AM, Paul Bolle <pebolle@tiscali.nl> wrote:
> > On Mon, 2012-05-07 at 10:02 +0200, Sasha Levin wrote:
> >> --- a/drivers/staging/ramster/Kconfig
> >> +++ b/drivers/staging/ramster/Kconfig
> >> @@ -1,6 +1,6 @@
> >>  config RAMSTER
> >>       bool "Cross-machine RAM capacity sharing, aka peer-to-peer tmem"
> >> -     depends on (CLEANCACHE || FRONTSWAP) && CONFIGFS_FS=y && !ZCACHE && !XVMALLOC && !HIGHMEM
> >> +     depends on (CLEANCACHE || FRONTSWAP) && CONFIGFS_FS=y && !ZCACHE && !XVMALLOC && !HIGHMEM && CONFIG_NET
> >
> > s/CONFIG_NET/NET/ again, I'd say. How was this tested?
> 
> Hm... ran the build again with the patch and noticed it stopped
> complaining, but apparently it wasn't enough.

Well, my guess is that the errors you ran into weren't displayed because
a dependency on an undefined Kconfig symbol (like CONFIG_NET is) will
always fail. Ie, your patch made "RAM capacity sharing" simply disappear
from the build.


Paul Bolle

