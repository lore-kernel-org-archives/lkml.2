Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754046Ab2BEH5y (ORCPT <rfc822;w@1wt.eu>);
	Sun, 5 Feb 2012 02:57:54 -0500
Received: from smtprelay-b22.telenor.se ([195.54.99.213]:50457 "EHLO
	smtprelay-b22.telenor.se" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752765Ab2BEH5w (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 5 Feb 2012 02:57:52 -0500
X-SENDER-IP: [85.230.170.239]
X-LISTENER: [smtp.bredband.net]
X-IronPort-Anti-Spam-Filtered: true
X-IronPort-Anti-Spam-Result: AqlKAC42Lk9V5qrvPGdsb2JhbABCiValWhkBAQEBHhkNJYFyAQEEATocIwULCANGFCUKGogPA60QE4tXAgIJBQwHBgEEAQEJBBQHBA8GgnYCCwMEGgQCgQkSglZjBJUnhWiMdQ
X-IronPort-AV: E=Sophos;i="4.73,363,1325458800"; 
   d="scan'208";a="1803758023"
From: "Henrik Rydberg" <rydberg@euromail.se>
Date: Sun, 5 Feb 2012 08:59:06 +0100
To: Chase Douglas <chasedouglas@gmail.com>
Cc: Dmitry Torokhov <dmitry.torokhov@gmail.com>, linux-input@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH v3] Input: Add EVIOC mechanism for MT slots
Message-ID: <20120205075906.GA7698@polaris.bitmath.org>
References: <1328036403-2827-1-git-send-email-rydberg@euromail.se>
 <4F2B24AC.1020408@gmail.com>
 <20120203072725.GA6914@polaris.bitmath.org>
 <4F2D7730.3090704@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <4F2D7730.3090704@gmail.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

> > This is resolved on the preprocessor level, so C99 or not does not
> > enter the problem. Compile-time constant, as you can see in the code
> > example in the patch summary.
> 
> You're right, I didn't catch that. It will be compatible with all C
> compilers if you use a static number of slots.

Yes, but this statement is merely repeating something that has been
true since the sixties.

> However, it will break if you use a non-C99 C compiler and the code
> wants to do dynamic number of slots calculations.

Of course, which is why C99 cannot be used for portable code. And it
still has nothing to do with this patch.

> I imagine most callers would do:
> 
> EVIOCGABS call on ABS_MT_SLOT;
> int num_slots = ABS_MT_SLOT.max - ABS_MT_SLOT.min
> struct INPUT_MT_REQUEST(num_slots) req;

Besides leaving a possible giant stack crash in your code, it assumes
memory is somehow magically allocated. Not good practise in low-level
programming. You wouldn't use a template this way, would you?

> This will break on non-C99 C compilers and other language compilers.

Of course, since you use the C99 dynamic stack construct, which,
again, is not portable.

> It also will lead to head-scratcher bugs when someone compiles it
> just fine in their C99 project, copies the code to another project
> with a different compiler, and is confronted with the issue.

No, since people how know C do not do things like that.

> I think this issue should be enough to rethink the interface.

No, since your issues with C99 has nothing to do with this patch.

Henrik
