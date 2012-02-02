Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755557Ab2BBKvF (ORCPT <rfc822;w@1wt.eu>);
	Thu, 2 Feb 2012 05:51:05 -0500
Received: from atrey.karlin.mff.cuni.cz ([195.113.26.193]:36409 "EHLO
	atrey.karlin.mff.cuni.cz" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754405Ab2BBKvC (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 2 Feb 2012 05:51:02 -0500
Date: Thu, 2 Feb 2012 11:50:59 +0100
From: Pavel Machek <pavel@ucw.cz>
To: Keith Packard <keithp@keithp.com>, stern@rowland.harvard.edu,
        "Rafael J. Wysocki" <rjw@sisk.pl>
Cc: linux-kernel@vger.kernel.org, linux-usb@vger.kernel.org,
        linux-bluetooth@vger.kernel.org
Subject: Re: [PATCH] Regression: Revert "Bluetooth: use buffer priority to
 mark URB_ISO_ASAP flag"
Message-ID: <20120202105059.GC1643@atrey.karlin.mff.cuni.cz>
References: <1327298281-2502-1-git-send-email-keithp@keithp.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1327298281-2502-1-git-send-email-keithp@keithp.com>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi!

> This reverts commit b8aabfc92249b239c425da7e4ca85b7e4855e984.
> 
> URB_ISO_ASAP may only be used with iso end points, but this patch was
> attempting to use it with a bulk endpoint. When DEBUG is defined in
> the USB stack, it checks for invalid flags and returns -EINVAL instead
> of actually transmitting the data.
> 
> Signed-off-by: Keith Packard <keithp@keithp.com>

This patch fixes a regression, and it is not in 3.3.0-rc2.

(And for the record I also believe that #ifdef debug should not
introduce extra error returns. WARN_ON() should be enough. Don't break
systems for people who try to be nice and enable debugging.)
									Pavel
-- 
(english) http://www.livejournal.com/~pavelmachek
(cesky, pictures) http://atrey.karlin.mff.cuni.cz/~pavel/picture/horses/blog.html
