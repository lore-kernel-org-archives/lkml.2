Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758136Ab1GKXxK (ORCPT <rfc822;w@1wt.eu>);
	Mon, 11 Jul 2011 19:53:10 -0400
Received: from cassiel.sirena.org.uk ([80.68.93.111]:33123 "EHLO
	cassiel.sirena.org.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752513Ab1GKXxI (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 11 Jul 2011 19:53:08 -0400
Date: Tue, 12 Jul 2011 00:53:06 +0100
From: Mark Brown <broonie@opensource.wolfsonmicro.com>
To: Lars-Peter Clausen <lars@metafoo.de>
Cc: Wim Van Sebroeck <wim@iguana.be>, LKML <linux-kernel@vger.kernel.org>,
        Linux Watchdog Mailing List <linux-watchdog@vger.kernel.org>,
        Alan Cox <alan@lxorguk.ukuu.org.uk>
Subject: Re: [PATCH 01/11] watchdog: WatchDog Timer Driver Core - Add basic
	framework
Message-ID: <20110711235306.GA5646@sirena.org.uk>
References: <1310392522-9949-1-git-send-email-wim@iguana.be> <4E1B8089.90103@metafoo.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <4E1B8089.90103@metafoo.de>
X-Cookie: I am NOT a nut....
User-Agent: Mutt/1.5.18 (2008-05-17)
X-SA-Exim-Connect-IP: <locally generated>
X-SA-Exim-Mail-From: broonie@sirena.org.uk
X-SA-Exim-Scanned: No (on cassiel.sirena.org.uk); SAEximRunCond expanded to false
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Jul 12, 2011 at 01:00:25AM +0200, Lars-Peter Clausen wrote:
> On 07/11/2011 04:19 PM, Wim Van Sebroeck wrote:

> > +	/* stop the watchdog */
> > +	err = wdd->ops->stop(wdd);
> Does it really make sense to allow stop() to fail? Will this ever happen, and

Some hardware can't be stopped, sometimes depending on circumstance.

> if yes do we gain anything by sending a additional ping?

It would increase the chances that someone sees the error message, or
that it gets written to disk or whatever (especially if the watchdog
time is short).
