Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932552Ab0J0Vhu (ORCPT <rfc822;w@1wt.eu>);
	Wed, 27 Oct 2010 17:37:50 -0400
Received: from zeniv.linux.org.uk ([195.92.253.2]:33093 "EHLO
	ZenIV.linux.org.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932495Ab0J0Vhr (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 27 Oct 2010 17:37:47 -0400
Date: Wed, 27 Oct 2010 22:37:45 +0100
From: Al Viro <viro@ZenIV.linux.org.uk>
To: Chris Metcalf <cmetcalf@tilera.com>
Cc: Arnd Bergmann <arnd@arndb.de>, linux-arch@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: Re: situation with signals
Message-ID: <20101027213745.GI19804@ZenIV.linux.org.uk>
References: <20100923221141.GK19804@ZenIV.linux.org.uk>
 <9lYpY1#WLHA.1516@exchange1.tad.internal.tilera.com>
 <4CC89352.7020808@tilera.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <4CC89352.7020808@tilera.com>
User-Agent: Mutt/1.5.20 (2009-08-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Oct 27, 2010 at 05:02:10PM -0400, Chris Metcalf wrote:

> I set aside this thread to look at when I had a minute, and I believe there
> is just one of the signal issues present in the tile code.  The fix is to
> reset regs->fault to something other than the "syscall" fault type when
> exiting from do_signal(), so I'll submit that up for 2.6.37 shortly.
> 
> Otherwise I think tile is doing things right, though I admit, the signal
> support is pretty deep magic generally.

FWIW, I'd do that in handle_signal() when hitting a syscall restart.
BTW, is everything in your pt_regs safe to modify?  I.e. could bogus
values put there by sigreturn lead to something like kernel mode being
retained when you return from syscall or interesting flags being
set, etc.?
