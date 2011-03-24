Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756908Ab1CXOQI (ORCPT <rfc822;w@1wt.eu>);
	Thu, 24 Mar 2011 10:16:08 -0400
Received: from mx1.redhat.com ([209.132.183.28]:55065 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751877Ab1CXOQG (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 24 Mar 2011 10:16:06 -0400
Date: Thu, 24 Mar 2011 15:15:53 +0100
From: Petr Pisar <ppisar@redhat.com>
To: Alan Cox <alan@lxorguk.ukuu.org.uk>
Cc: linux-kernel@vger.kernel.org
Subject: Re: [PATCH] Clean console safely
Message-ID: <20110324141552.GA1291@dhcp-0-146.brq.redhat.com>
Mail-Followup-To: Alan Cox <alan@lxorguk.ukuu.org.uk>,
	linux-kernel@vger.kernel.org
References: <1300960611-4820-1-git-send-email-ppisar@redhat.com>
 <20110324102431.5e017efe@lxorguk.ukuu.org.uk>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <20110324102431.5e017efe@lxorguk.ukuu.org.uk>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Mar 24, 2011 at 10:24:31AM +0000, Alan Cox wrote:
> On Thu, 24 Mar 2011 10:56:51 +0100
> Petr Písař <ppisar@redhat.com> wrote:
> 
> > Traditional \E[2J sequence erases console display but scroll-back
> > buffer and underlying device (frame) buffer keep data that can be
> > accessed by scrolling console back.
> > 
> > This patch introduce new \E[J parameter 3 that allows to scramble
> > scroll-back buffer explicitly. Session locking programs (screen,
> > vlock) can use it to prevent attacker to browse locked console
> > history.
> > ---
> >  drivers/tty/vt/vt.c |    6 ++++++
> >  1 files changed, 6 insertions(+), 0 deletions(-)
> 
> Looks sensible enough
> 
> There are a set of official codes that are probably more relevant, and
> also deal with the timing of events
> 
> See DECSR/DECSRC on a later VT terminal, also DECSTR which 
> 
> DECSR = secure reset, return to power up state, \E[n+p where n is an
> optional value from 1-16383 which if provided is replied back from the tty
> as a DECSRC response (hence 'secure'). It's defined to clear off
> screen memory, and also other weirdness a user may have set up so could
> reasonably also be extended a bit if there is other stuff founbd in
> future that such a reset really ought to clean up - eg for mingetty.
> 
> http://www.vt100.net/docs/vt520-rm/ek-vt520-rm.pdf (page 299)
> 
> ED 3J looks fine but is a new "made up" extension.
> 
The problem with DECSRC as well as DECSTR or RIS is they reset terminal font,
keyboard layout, unicode mode and other configuration. That's the reason why
I rejected enhancing RIS implemented in Linux VT already. In other words,
I'm searching for a clear display feature which preserves configuration.
I read console_codes(4), console_ioctl(4), and now the VT520 documentation and
I did not find any existing control code. The most close seems ED J for me.

-- Petr
