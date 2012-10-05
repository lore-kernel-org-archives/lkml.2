Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757115Ab2JETI0 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 5 Oct 2012 15:08:26 -0400
Received: from mail-pb0-f46.google.com ([209.85.160.46]:51093 "EHLO
	mail-pb0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750749Ab2JETIY (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 5 Oct 2012 15:08:24 -0400
Date: Fri, 5 Oct 2012 12:08:19 -0700
From: Dmitry Torokhov <dmitry.torokhov@gmail.com>
To: Alan Cox <alan@lxorguk.ukuu.org.uk>
Cc: mathieu.poirier@linaro.org, akpm@linux-foundation.org,
        linux-kernel@vger.kernel.org, rdunlap@xenotime.net, arve@android.com,
        kernel-team@android.com, john.stultz@linaro.org
Subject: Re: [PATCH] drivers/tty: Folding Android's keyreset driver in sysRQ
Message-ID: <20121005190819.GB24356@core.coreip.homeip.net>
References: <1349459969-17473-1-git-send-email-mathieu.poirier@linaro.org>
 <20121005181608.GA24356@core.coreip.homeip.net>
 <20121005195303.6e652997@pyramind.ukuu.org.uk>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20121005195303.6e652997@pyramind.ukuu.org.uk>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Oct 05, 2012 at 07:53:03PM +0100, Alan Cox wrote:
> > I have the same objection as before: using platform device solely for
> > the purpose of passing some data from board code to the driver. Surely
> > there are other ways of passing this bit of data... What about, for
> > example, making it an empty weak symbol so that board code could
> > override it with strong one?
> 
> I have the same objection to it being passed in other weird ways. This is
> cross architecture, cross device stuff. Magic architecture goo and weak
> symbols are not the right solution.

The right solution is module option + DT. However they want to have
compatibility for older boards. For that I think weak symbol is just
fine.

> 
> The reset switch is a device, physically and logically.

Except that this one isn't. It is a magic sequence of key presses done
on a physical device that is already registered with the kernel. We do
not register SysRQ itself as a separate device, we do not register Mac
button mangler as a separate device, and I do not see the reason here
either.

Thanks.

-- 
Dmitry
