Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752731Ab0EQDQJ (ORCPT <rfc822;w@1wt.eu>);
	Sun, 16 May 2010 23:16:09 -0400
Received: from opensource.wolfsonmicro.com ([80.75.67.52]:35930 "EHLO
	opensource2.wolfsonmicro.com" rhost-flags-OK-OK-OK-FAIL)
	by vger.kernel.org with ESMTP id S1752279Ab0EQDQG (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 16 May 2010 23:16:06 -0400
Date: Sun, 16 May 2010 20:16:16 -0700
From: Mark Brown <broonie@opensource.wolfsonmicro.com>
To: Sundar <sunder.svit@gmail.com>
Cc: Deepak Sikri <deepak.sikri79@gmail.com>, viresh.kumar@st.com,
       rajeev-dlh.kumar@st.com, armando.visconti@st.com,
       linux-kernel@vger.kernel.org, vipin.kumar@st.com, shiraz.hashim@st.com,
       linux-pm@lists.linux-foundation.org, linus.walleij@stericsson.com
Subject: Re: [linux-pm] Power Domain Framework
Message-ID: <20100517031613.GA3130@opensource.wolfsonmicro.com>
References: <AANLkTinZU1D1rMOBQDi47tRhXrOXwduQIdni7bCXdce0@mail.gmail.com>
 <20100510140527.GG5199@sirena.org.uk>
 <AANLkTikyqnKDNz7FIUvLDAvBReHskHvRCrEz2qBBqseH@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <AANLkTikyqnKDNz7FIUvLDAvBReHskHvRCrEz2qBBqseH@mail.gmail.com>
X-Cookie: Don't read everything you believe.
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sun, May 16, 2010 at 04:43:52PM +0530, Sundar wrote:

Please don't top post, it breaks the thread of discussion.

> However, for working with power domains within the framework, I feel that,
> - support must be added to allow additional domain-specific states
> like retention, idle etc.

I'm really not convinced that this is a good idea.  Generally I suspect
the implementations of these concepts that I've seen would introduce
layering violations if done via the regulator API - from what I've seen
the power domains can end up knowing rather more about the things that
are being powered than is healthy for the regulator API and...

> - controlling operating points for regulators, unlike setting optimal modes.
> - controlling regulator modes via constraints enforced by clients and
> managing transition to various states through the client requests and
> pushing the client states up to the parent regulator.

...knowing a lot about the specifics of the internal structures of the
device you're trying to model.  Cross talk with the clock API also seems
fairly common here.

I do think it's likely that you'll want something that looks like the
regulator API at the edges, but that a separate implementation that
avoids having to shoehorn through the abstractions of the regulator API
for the on-chip work seems much more sensible (and is what OMAP and SH
are already doing).  This is fairly similar to the relationship between
the clock and regulator APIs - they look a lot alike, especially from a
user point of view, but they are separate because there are enough
differences in what they are trying to represent to make it sensible to
keep them apart.

However, if you have patches it's probably easier to talk about those
than architecture astronauting; perhaps your implementation avoids my
concerns.
