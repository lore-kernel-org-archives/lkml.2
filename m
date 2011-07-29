Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752780Ab1G2Tyr (ORCPT <rfc822;w@1wt.eu>);
	Fri, 29 Jul 2011 15:54:47 -0400
Received: from atrey.karlin.mff.cuni.cz ([195.113.26.193]:39710 "EHLO
	atrey.karlin.mff.cuni.cz" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752493Ab1G2Tyq (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 29 Jul 2011 15:54:46 -0400
Date: Fri, 29 Jul 2011 21:54:30 +0200
From: Pavel Machek <pavel@ucw.cz>
To: Oliver Neukum <oneukum@suse.de>
Cc: linux-pm@lists.linux-foundation.org, linux-kernel@vger.kernel.org,
        rjw@sisk.pl
Subject: Re: [linux-pm] better oopsing when frozen
Message-ID: <20110729195430.GB1720@ucw.cz>
References: <201107251043.19932.oneukum@suse.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <201107251043.19932.oneukum@suse.de>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon 2011-07-25 10:43:19, Oliver Neukum wrote:
> Hi Rafael,
> 
> I had a problem with the kernel stopping the machine forever because I got an
> oops while tasks were frozen. It seems to me that we should thaw when this
> happens. How about this approach?

Danger, Will Robinson. You must not write to the filesystems after
hibernation started. By thawing, you may do just that.

It should be safe to thaw as long as final suspend signature is not
on disk and will not be written there.

-- 
(english) http://www.livejournal.com/~pavelmachek
(cesky, pictures) http://atrey.karlin.mff.cuni.cz/~pavel/picture/horses/blog.html
