Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752898Ab1BDObT (ORCPT <rfc822;w@1wt.eu>);
	Fri, 4 Feb 2011 09:31:19 -0500
Received: from opensource.wolfsonmicro.com ([80.75.67.52]:34132 "EHLO
	opensource2.wolfsonmicro.com" rhost-flags-OK-OK-OK-FAIL)
	by vger.kernel.org with ESMTP id S1752657Ab1BDObS (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 4 Feb 2011 09:31:18 -0500
Date: Fri, 4 Feb 2011 14:31:35 +0000
From: Mark Brown <broonie@opensource.wolfsonmicro.com>
To: Arve =?iso-8859-1?B?SGr4bm5lduVn?= <arve@android.com>
Cc: linux-arm-kernel@lists.infradead.org,
        Russell King <linux@arm.linux.org.uk>,
        Greg Kroah-Hartman <gregkh@suse.de>, linux-kernel@vger.kernel.org,
        Alexander Shishkin <virtuoso@slind.org>,
        Jason Wessel <jason.wessel@windriver.com>
Subject: Re: [PATCH 1/5] ARM: etm: Don't require clock control
Message-ID: <20110204143134.GE5393@opensource.wolfsonmicro.com>
References: <1296701663-12168-1-git-send-email-arve@android.com>
 <20110203124521.GK9810@sirena.org.uk>
 <AANLkTikybaV-jBo-q4Xb_POC5QRG9RRRV1RCDOnX9riG@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <AANLkTikybaV-jBo-q4Xb_POC5QRG9RRRV1RCDOnX9riG@mail.gmail.com>
X-Cookie: Long life is in store for you.
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Feb 03, 2011 at 04:30:46PM -0800, Arve Hjønnevåg wrote:
> On Thu, Feb 3, 2011 at 4:45 AM, Mark Brown

> > Would it not be cleaner for the affected platforms to ensure that
> > clk_get() does the right thing here, for example by returning a dummy
> > clock?  Otherwise we'll just silently carry on if we can't get a clock
> > we were supposed to which doesn't seem ideal.

> This clock seem to be an omap specific virtual clock that switches the
> clock source of the etb. It is not used to enable the clock when the
> etb is in use, and it does not seem to have a failure case other than
> not existing. So, I don't know that requiring this clock would cause
> fewer problems than making it optional.

That doesn't seem unreasonable, but in that case it'd be good to explain
why things are this way in the code (and the changelog) so someone
doesn't change the code back.
