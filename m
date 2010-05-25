Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933407Ab0EYRez (ORCPT <rfc822;w@1wt.eu>);
	Tue, 25 May 2010 13:34:55 -0400
Received: from mail-px0-f174.google.com ([209.85.212.174]:49543 "EHLO
	mail-px0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932245Ab0EYRew (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 25 May 2010 13:34:52 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-type:content-disposition:in-reply-to:user-agent;
        b=LD0vqcebGTR/BjGMQlpx5LPAs/XFc6z3BC67hYsZF0IzFtaC7ZKDtLDCQtAxWx8MIx
         K0nEN1uNlcI25eUcV2iKcv+M/ubpiuorVYntywJmuU0oD3Pe3SMywYFkC87vgALEk4PH
         qkgiyPs384AA0Lwd6TDIS+pYLZmREgvs+oY3s=
Date: Tue, 25 May 2010 10:34:46 -0700
From: Dmitry Torokhov <dmitry.torokhov@gmail.com>
To: Henrik Rydberg <rydberg@euromail.se>
Cc: Andrew Morton <akpm@linux-foundation.org>, linux-input@vger.kernel.org,
       linux-kernel@vger.kernel.org, Mika Kuoppala <mika.kuoppala@nokia.com>,
       Peter Hutterer <peter.hutterer@who-t.net>,
       Benjamin Tissoires <tissoire@cena.fr>, Stephane Chatty <chatty@enac.fr>,
       Rafi Rubin <rafi@seas.upenn.edu>, Michael Poole <mdpoole@troilus.org>
Subject: Re: [PATCH 0/2] input: mt: Add EVIOC mechanism for MT slots
Message-ID: <20100525173446.GA4634@core.coreip.homeip.net>
References: <1274788379-11026-1-git-send-email-rydberg@euromail.se>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1274788379-11026-1-git-send-email-rydberg@euromail.se>
User-Agent: Mutt/1.5.20 (2009-08-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Henrik,

On Tue, May 25, 2010 at 01:52:57PM +0200, Henrik Rydberg wrote:
> These patches are in response to the discussion about input state
> retrieval.
> 
> The current EVIOCGABS method does not work with MT slots.  These
> patches provides a mechanism where a slot is first selected via a call
> to EVIOCSABS, after which the corresponding MT events can be extracted
> with calls to EVIOCGABS.
> 
> The symmetric operation, to set the MT state via EVIOCSABS, seems to
> violate input data integrity, and is therefore not implemented.
> 

This looks sane, however the question remains - is there any users for
this data? Like I mentioned, I can see the need to fetch state of
switches and ranges of absolute axis, and even non-multitouch ABS values
(due to the fact that some input devices, like sliders, may stay in a
certain position for long periods of time), but I expect multitouch data
to be "refreshed" very quickly.

Thanks.

-- 
Dmitry
