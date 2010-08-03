Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758423Ab0HDHIP (ORCPT <rfc822;w@1wt.eu>);
	Wed, 4 Aug 2010 03:08:15 -0400
Received: from ksp.mff.cuni.cz ([195.113.26.206]:50608 "EHLO
	atrey.karlin.mff.cuni.cz" rhost-flags-OK-OK-OK-FAIL)
	by vger.kernel.org with ESMTP id S1758263Ab0HDHIO (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 4 Aug 2010 03:08:14 -0400
Date: Tue, 3 Aug 2010 21:12:38 +0200
From: Pavel Machek <pavel@ucw.cz>
To: Patrick Pannuto <ppannuto@codeaurora.org>
Cc: linux-kernel@vger.kernel.org, apw@canonical.com, corbet@lwn.net
Subject: Re: [PATCH v2 0/4] timer: Added usleep[_range] timer
Message-ID: <20100803191049.GC1522@ucw.cz>
References: <1280345587-19725-1-git-send-email-ppannuto@codeaurora.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1280345587-19725-1-git-send-email-ppannuto@codeaurora.org>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed 2010-07-28 12:33:03, Patrick Pannuto wrote:
> After writing both documentation and a checkpatch rule explaining
> why the usleep API should never be used, it occurred to me that
> perhaps such an API should never be added :) - at least not in its
> previous form.
> 
> This iteration is similar, with the notable difference that now
> usleep has a "built-in slack" of 200%. This is analogous to msleep,
> which has a built-in slack of 0.4% (since it relies on legacy timers,
> which have a built-in slack of 0.4%). 200% slack is significantly
> greater than 0.4%, but the scale of usleep is also significantly
> different than that of msleep, and I believe 200% to be a sane
> default.

So, I do msleep(1 second) and it will delay for 3 seconds? Thats
excessive, and will be annoying/plain to see with just eyes. Better
select reasonable default (1%?) and let people who care switch to
msleep_range...
							Pavel

-- 
(english) http://www.livejournal.com/~pavelmachek
(cesky, pictures) http://atrey.karlin.mff.cuni.cz/~pavel/picture/horses/blog.html
