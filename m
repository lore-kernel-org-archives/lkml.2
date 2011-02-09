Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754031Ab1BIKeO (ORCPT <rfc822;w@1wt.eu>);
	Wed, 9 Feb 2011 05:34:14 -0500
Received: from 1wt.eu ([62.212.114.60]:60450 "EHLO 1wt.eu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752817Ab1BIKeN (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 9 Feb 2011 05:34:13 -0500
Date: Wed, 9 Feb 2011 11:34:01 +0100
From: Willy Tarreau <w@1wt.eu>
To: Alan Cox <alan@lxorguk.ukuu.org.uk>
Cc: "Jayson R. King" <dev@jaysonking.com>, LKML <linux-kernel@vger.kernel.org>,
        Stable team <stable@kernel.org>
Subject: Re: [stable] 2.6.27.58-rc1 build error Re: [PATCH 21/23] hvc_console: Fix race between hvc_close and hvc_remove
Message-ID: <20110209103401.GB18732@1wt.eu>
References: <4D52080A.1090100@jaysonking.com> <20110209094434.3928bf26@lxorguk.ukuu.org.uk>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20110209094434.3928bf26@lxorguk.ukuu.org.uk>
User-Agent: Mutt/1.4.2.3i
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Feb 09, 2011 at 09:44:34AM +0000, Alan Cox wrote:
> On Tue, 08 Feb 2011 21:20:42 -0600
> "Jayson R. King" <dev@jaysonking.com> wrote:
> 
> > drivers/char/hvc_console.c: In function 'hvc_open':
> > drivers/char/hvc_console.c:315: error: implicit declaration of function 
> > 'tty_kref_get'
> > drivers/char/hvc_console.c:324: warning: assignment makes pointer from 
> > integer without a cast
> > drivers/char/hvc_console.c:341: error: implicit declaration of function 
> > 'tty_kref_put'
> > drivers/char/hvc_console.c: In function 'hvc_poll':
> > drivers/char/hvc_console.c:558: warning: assignment makes pointer from 
> > integer without a cast
> > drivers/char/hvc_console.c: In function 'hvc_remove':
> > drivers/char/hvc_console.c:759: warning: assignment makes pointer from 
> > integer without a cast
> > 
> > I don't see a tty_kref_get or tty_kref_put on 2.6.27. Those functions 
> > first appeared in 2.6.28.
> 
> Correct - for 2.6.27 I don't think you *can* make the tty layer
> non-exploitable without a major backport

So unless the bug is critical (I don't think it is), I'd rather avoid
a major backport at this stage.

Willy

