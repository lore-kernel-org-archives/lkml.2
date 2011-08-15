Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752196Ab1HOTbX (ORCPT <rfc822;w@1wt.eu>);
	Mon, 15 Aug 2011 15:31:23 -0400
Received: from mx1.redhat.com ([209.132.183.28]:12716 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751287Ab1HOTbW (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 15 Aug 2011 15:31:22 -0400
Date: Mon, 15 Aug 2011 15:31:01 -0400
From: Dave Jones <davej@redhat.com>
To: Justin Piszcz <jpiszcz@lucidpixels.com>
Cc: Jeff Layton <jlayton@samba.org>, Jesper Juhl <jj@chaosbits.net>,
        linux-kernel@vger.kernel.org, Alan Piszcz <ap@solarrain.com>,
        Steve French <sfrench@samba.org>, linux-cifs@vger.kernel.org
Subject: Re: Kernel 3.0: Instant kernel crash when mounting CIFS
Message-ID: <20110815193101.GA7295@redhat.com>
Mail-Followup-To: Dave Jones <davej@redhat.com>,
	Justin Piszcz <jpiszcz@lucidpixels.com>,
	Jeff Layton <jlayton@samba.org>, Jesper Juhl <jj@chaosbits.net>,
	linux-kernel@vger.kernel.org, Alan Piszcz <ap@solarrain.com>,
	Steve French <sfrench@samba.org>, linux-cifs@vger.kernel.org
References: <alpine.DEB.2.02.1108150506310.7571@p34.internal.lan>
 <alpine.LNX.2.00.1108151117480.19668@swampdragon.chaosbits.net>
 <20110815064734.403b630f@corrin.poochiereds.net>
 <alpine.DEB.2.02.1108150653200.7571@p34.internal.lan>
 <alpine.DEB.2.02.1108151357200.32349@p34.internal.lan>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <alpine.DEB.2.02.1108151357200.32349@p34.internal.lan>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Aug 15, 2011 at 02:01:12PM -0400, Justin Piszcz wrote:
 > It crashed again with the patches, this time I got a picture:
 > http://home.comcast.net/~jpiszcz/20110815/26030-kernel-crash-when-cifs-mount.jpg
 > 
 > The machine is up no issues until you try and mount a CIFS share, then
 > the problem occurs, every time (and with the patches as well).

This looks like you oopsed in cache_alloc_refill, and then after that
the watchdog kicked in, and spewed traces, scrolling the backtrace for
the actual oops off the screen.

Might be worth trying to reproduce it with CONFIG_LOCKUP_DETECTOR disabled.

We frequently see this sort of thing reported in Fedora. It would be
nice if we had a means of either reading scrollback when we lockup,
or buffering the output so we pause between dumping traces.

	Dave

