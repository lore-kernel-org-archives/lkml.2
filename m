Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753461Ab2KDKxi (ORCPT <rfc822;w@1wt.eu>);
	Sun, 4 Nov 2012 05:53:38 -0500
Received: from mail-ea0-f174.google.com ([209.85.215.174]:34690 "EHLO
	mail-ea0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753120Ab2KDKxg (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 4 Nov 2012 05:53:36 -0500
Date: Sun, 4 Nov 2012 11:53:32 +0100
From: Lee Jones <lee.jones@linaro.org>
To: Paul Bolle <pebolle@tiscali.nl>
Cc: linux-kernel@vger.kernel.org, Karsten Keil <isdn@linux-pingi.de>,
        netdev@vger.kernel.org
Subject: Re: [PATCH 8/9] isdn: Remove unused variable causing a compile build
 warning
Message-ID: <20121104105332.GC27124@gmail.com>
References: <1351980150-24145-1-git-send-email-lee.jones@linaro.org>
 <1351980150-24145-9-git-send-email-lee.jones@linaro.org>
 <1351982441.1434.5.camel@x61.thuisdomein>
 <20121103224832.GA24262@gmail.com>
 <1352024091.1434.17.camel@x61.thuisdomein>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <1352024091.1434.17.camel@x61.thuisdomein>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sun, 04 Nov 2012, Paul Bolle wrote:

> On Sat, 2012-11-03 at 23:48 +0100, Lee Jones wrote:
> > On Sat, 03 Nov 2012, Paul Bolle wrote:
> > > On Sat, 2012-11-03 at 23:02 +0100, Lee Jones wrote:
> > > > This patch fixes:
> > > > drivers/isdn/i4l/isdn_common.c: In function ‘isdn_ioctl’:
> > > > drivers/isdn/i4l/isdn_common.c:1278:8: warning: unused variable ‘s’ [-Wunused-variable]
> > > 
> > > Did you have CONFIG_NETDEVICES not set in this build?
> > 
> > Ah yes, I see it. The function went down further than I thought
> > it did. So the real fix is to ensure 's' is defined inside of
> > some ifdef CONFIG_NETDEVICES guards. 
> 
> What puzzles me is that we only find these "#ifdef CONFIG_NETDEVICES"
> guards in this file and not in isdn_net.c, were all the ioctl commands
> guarded that way seem to be calling into. On first glance that doesn't
> make much sense.
> 
> (Actually the idea of having ISDN without NETDEVICES is a bit puzzling
> too. But there are too many parts of the isdn subsystem that I'm
> unfamiliar with to say whether that can make sense.)

I'm in the same position as you Paul. I just noticed the warning so
fixed it following the current way of doing things. Any, more
substantial changes requiring greater knowledge of the subsystem
would have to be done by someone else.

-- 
Lee Jones
Linaro ST-Ericsson Landing Team Lead
Linaro.org │ Open source software for ARM SoCs
Follow Linaro: Facebook | Twitter | Blog
