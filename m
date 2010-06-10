Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759167Ab0FJN52 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 10 Jun 2010 09:57:28 -0400
Received: from ksp.mff.cuni.cz ([195.113.26.206]:36967 "EHLO
	atrey.karlin.mff.cuni.cz" rhost-flags-OK-OK-OK-FAIL)
	by vger.kernel.org with ESMTP id S1757992Ab0FJN50 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 10 Jun 2010 09:57:26 -0400
Date: Thu, 10 Jun 2010 15:56:34 +0200
From: Pavel Machek <pavel@ucw.cz>
To: Henrik Rydberg <rydberg@euromail.se>
Cc: Dmitry Torokhov <dmitry.torokhov@gmail.com>,
       Andrew Morton <akpm@linux-foundation.org>, linux-input@vger.kernel.org,
       linux-kernel@vger.kernel.org, Mika Kuoppala <mika.kuoppala@nokia.com>,
       Peter Hutterer <peter.hutterer@who-t.net>,
       Benjamin Tissoires <tissoire@cena.fr>, Stephane Chatty <chatty@enac.fr>,
       Rafi Rubin <rafi@seas.upenn.edu>, Michael Poole <mdpoole@troilus.org>
Subject: Re: [PATCH 2/2] input: mt: Document the MT event slot protocol
 (rev4)
Message-ID: <20100610135634.GD4514@ucw.cz>
References: <1274567437-2818-1-git-send-email-rydberg@euromail.se>
 <1274567437-2818-2-git-send-email-rydberg@euromail.se>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1274567437-2818-2-git-send-email-rydberg@euromail.se>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi!

> +Protocol Example A
> +------------------
> +
> +Here is what a minimal event sequence for a two-contact touch would look
> +like for a type A device:
> +
> +   ABS_MT_POSITION_X x[0]
> +   ABS_MT_POSITION_Y y[0]
> +   SYN_MT_REPORT
> +   ABS_MT_POSITION_X x[1]
> +   ABS_MT_POSITION_Y y[1]
> +   SYN_MT_REPORT
> +   SYN_REPORT
...
> -Usage
> ------
> +Here is the sequence after lifting the first contact:
> +
> +   ABS_MT_POSITION_X x[1]
> +   ABS_MT_POSITION_Y y[1]
> +   SYN_MT_REPORT
> +   SYN_REPORT

...

> +Protocol Example B
> +------------------
> +
> +Here is what a minimal event sequence for a two-contact touch would look
> +like for a type B device:
> +
> +   ABS_MT_SLOT 0
> +   ABS_MT_TRACKING_ID 45
> +   ABS_MT_POSITION_X x[0]
> +   ABS_MT_POSITION_Y y[0]
> +   ABS_MT_SLOT 1
> +   ABS_MT_TRACKING_ID 46
> +   ABS_MT_POSITION_X x[1]
> +   ABS_MT_POSITION_Y y[1]
> +   SYN_REPORT
> +
> +Here is the sequence after moving contact 45 in the x direction:
> +
> +   ABS_MT_SLOT 0
> +   ABS_MT_POSITION_X x[0]
> +   SYN_REPORT

With this proposed system, protocol A is *very* different from
protocol B. Is there way to make them more similar?
-- 
(english) http://www.livejournal.com/~pavelmachek
(cesky, pictures) http://atrey.karlin.mff.cuni.cz/~pavel/picture/horses/blog.html
