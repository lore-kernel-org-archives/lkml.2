Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751881Ab1HKEXc (ORCPT <rfc822;w@1wt.eu>);
	Thu, 11 Aug 2011 00:23:32 -0400
Received: from zeniv.linux.org.uk ([195.92.253.2]:49452 "EHLO
	ZenIV.linux.org.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751301Ab1HKEX0 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 11 Aug 2011 00:23:26 -0400
Date: Thu, 11 Aug 2011 05:23:19 +0100
From: Al Viro <viro@ZenIV.linux.org.uk>
To: richard -rw- weinberger <richard.weinberger@gmail.com>
Cc: David Woodhouse <dwmw2@infradead.org>, Arnaud Lacombe <lacombar@gmail.com>,
        "H. Peter Anvin" <hpa@zytor.com>, linux-kernel@vger.kernel.org,
        linux-kbuild@vger.kernel.org,
        user-mode-linux-devel@lists.sourceforge.net
Subject: Re: [PATCH 1/5] um: Use __i386__ in ifdef for vsyscall exports, not
 SUBARCH_i386
Message-ID: <20110811042319.GP2203@ZenIV.linux.org.uk>
References: <1312151063.18010.25.camel@i7.infradead.org>
 <20110731224834.GC2203@ZenIV.linux.org.uk>
 <20110731225801.GD2203@ZenIV.linux.org.uk>
 <1312153988.18010.39.camel@i7.infradead.org>
 <CAFLxGvyewG70ZgU41Kmu_eOYpjZ0TVXYwYq1AfS1sXONAM6G_w@mail.gmail.com>
 <20110801043207.GE2203@ZenIV.linux.org.uk>
 <CAFLxGvwxQ2VeqkDpkiVks35DHxZFvAP5nKUtD7i4Z32291otOg@mail.gmail.com>
 <20110809233817.GL2203@ZenIV.linux.org.uk>
 <20110810040445.GM2203@ZenIV.linux.org.uk>
 <20110810174432.GN2203@ZenIV.linux.org.uk>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20110810174432.GN2203@ZenIV.linux.org.uk>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Aug 10, 2011 at 06:44:32PM +0100, Al Viro wrote:

> Fixed and pushed (um-header.git #master); however, looking around that area
> shows more races ;-/

Such as, for example, seriously broken handling of free_winch(): delaying
free_irq() until after return from IRQ handler is nice, but not enough -
freeing struct winch itself (or winch->stack, for that matter) is also best
left until after free_irq().  Normal way to do that is schedule_work()...
Fixed and pushed...

Folks, I don't know what to do with all that stuff; as far as I'm concerned
the ideal variant would be to have functioning git tree maintained by Richard.
Is that possible?  I can ask to start pulling um-header.git into linux-next,
but I would very much prefer to avoid that, TYVM...  If nothing else, ACK/NAK
on the stuff in there should be done by architecture maintainer(s).
