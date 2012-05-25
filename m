Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759090Ab2EYXpr (ORCPT <rfc822;w@1wt.eu>);
	Fri, 25 May 2012 19:45:47 -0400
Received: from caramon.arm.linux.org.uk ([78.32.30.218]:45679 "EHLO
	caramon.arm.linux.org.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752812Ab2EYXpq (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 25 May 2012 19:45:46 -0400
Date: Sat, 26 May 2012 00:45:38 +0100
From: Russell King - ARM Linux <linux@arm.linux.org.uk>
To: Richard Weinberger <richard@nod.at>
Cc: linux-kernel@vger.kernel.org, linux-arch@vger.kernel.org,
        linux-arm-kernel@lists.infradead.org
Subject: Re: [PATCH 01/20] arm: Do not call do_signal() with irqs disabled
Message-ID: <20120525234538.GB32000@n2100.arm.linux.org.uk>
References: <1337983476-22081-1-git-send-email-richard@nod.at>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1337983476-22081-1-git-send-email-richard@nod.at>
User-Agent: Mutt/1.5.19 (2009-01-05)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sat, May 26, 2012 at 12:04:17AM +0200, Richard Weinberger wrote:
> get_signal_to_deliver() calls try_to_freeze() which might sleep.

True enough, and this problem has been around for some time, and it's
not as simple to fix as "lets just ignore everything else and enable
interrupts to shutup the warning".

There's bigger issues here with syscall restarting that should be
resolved first, and there's work in progress to do that.  Again,
like I said in my previous email, Al's done a great deal of work
in this area and I get the impression that you're redoing some of
that.
