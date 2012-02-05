Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754631Ab2BETjV (ORCPT <rfc822;w@1wt.eu>);
	Sun, 5 Feb 2012 14:39:21 -0500
Received: from smtprelay-b12.telenor.se ([62.127.194.21]:35674 "EHLO
	smtprelay-b12.telenor.se" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753266Ab2BETjT (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 5 Feb 2012 14:39:19 -0500
X-SENDER-IP: [85.230.170.239]
X-LISTENER: [smtp.bredband.net]
X-IronPort-Anti-Spam-Filtered: true
X-IronPort-Anti-Spam-Result: AtRRAKfZLk9V5qrvPGdsb2JhbABEiVKlXhkBAQEBHhkNJYFyAQEEATocIwULCANGFCUKGogPA7heE4tXAgIJBQwHBgEEAQEJBBQHBA8GgnYCCwMEGgQCgQkSglZjBJUnhWiMdQ
X-IronPort-AV: E=Sophos;i="4.73,366,1325458800"; 
   d="scan'208";a="263904572"
From: "Henrik Rydberg" <rydberg@euromail.se>
Date: Sun, 5 Feb 2012 20:40:36 +0100
To: Chase Douglas <chasedouglas@gmail.com>
Cc: Dmitry Torokhov <dmitry.torokhov@gmail.com>, linux-input@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH v3] Input: Add EVIOC mechanism for MT slots
Message-ID: <20120205194036.GA2566@polaris.bitmath.org>
References: <1328036403-2827-1-git-send-email-rydberg@euromail.se>
 <4F2B24AC.1020408@gmail.com>
 <20120203072725.GA6914@polaris.bitmath.org>
 <4F2D7730.3090704@gmail.com>
 <20120205075906.GA7698@polaris.bitmath.org>
 <4F2EB8C8.9090102@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <4F2EB8C8.9090102@gmail.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

> > Besides leaving a possible giant stack crash in your code, it assumes
> > memory is somehow magically allocated. Not good practise in low-level
> > programming. You wouldn't use a template this way, would you?
> 
> No, which is why I think this interface is bad. I should be able to
> dynamically set the size of the array, but it's not possible with this
> interface.

It is possible (using num_slots == 0 or creating your own struct), but
not ideal, granted. The patch serves the purpose of definining the
binary interface, the rest is up to userland.

> I think the implementation is fine in terms of how the plumbing works. I
> just don't think this macro should be included. Make the user create the
> struct themselves:
> 
> In linux/input.h:
> 
> struct input_mt_request {
> 	__u32 code;
> 	__s32 values[];
> };

The above (the first) version is not ideal either, since it cannot be
used as it is.

> It could be argued that we should leave the macro around for people who
> want to statically define the size of the request, but I think that is
> leading them down the wrong path. It's easier, but it will lead to
> broken code if you pick the wrong size.

Rather than creating both a suboptimal static and a suboptimal dynamic
version, removing the struct altogether is tempting. All that is
really needed is a clear definition of the binary interface. The rest
can easily be set up in userland, using whatever method is preferred.

Thanks.
Henrik
