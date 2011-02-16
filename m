Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756671Ab1BPCTQ (ORCPT <rfc822;w@1wt.eu>);
	Tue, 15 Feb 2011 21:19:16 -0500
Received: from opensource.wolfsonmicro.com ([80.75.67.52]:59324 "EHLO
	opensource2.wolfsonmicro.com" rhost-flags-OK-OK-OK-FAIL)
	by vger.kernel.org with ESMTP id S1756596Ab1BPCTJ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 15 Feb 2011 21:19:09 -0500
Date: Tue, 15 Feb 2011 18:19:26 -0800
From: Mark Brown <broonie@opensource.wolfsonmicro.com>
To: Abhijeet Dharmapurikar <adharmap@codeaurora.org>
Cc: dilinger@queued.net, Samuel Ortiz <sameo@linux.intel.com>,
        linux-kernel@vger.kernel.org, linux-arm-kernel@lists.infradead.org,
        Ian Lartey <ian@opensource.wolfsonmicro.com>,
        Dimitris Papastamos <dp@opensource.wolfsonmicro.com>,
        Linus Walleij <linus.walleij@stericsson.com>,
        Srinidhi Kasagar <srinidhi.kasagar@stericsson.com>,
        Michael Hennerich <michael.hennerich@analog.com>,
        linux-arm-msm@vger.kernel.org
Subject: Re: platform data and mfd design question
Message-ID: <20110216021925.GC3021@opensource.wolfsonmicro.com>
References: <4D5AF554.2030208@codeaurora.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <4D5AF554.2030208@codeaurora.org>
X-Cookie: Chess tonight.
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Feb 15, 2011 at 01:51:16PM -0800, Abhijeet Dharmapurikar wrote:

> This code can be found here (sorry for the long url - it is convinient to
> click on it),

I can't actually render this URL on a single line without fiddling with
the font size for my terminal...  When pasting gitweb URLs you almost
always want to edit out the head ID and just rely on the branch.

> This gives one the convenience of changing the mfd_cells and their
> platform data in the board file itself. There are boards where the
> platform data of some cells changes and in some cases we dont even
> add a particular cell.

My main question is why you're trying to do this.  Even if some features
aren't used on a given board one would strongly expect that the silicon
will be the same anyway - what's the goal in changing the devices?

> This design makes the core driver very light weight. All it does is
> calls mfd_add_devices on the cell array passed from its platform
> data.

The downside is that it then becomes impossible for the MFD to pass in
resources to the devices (IRQs being the most obvious example) and every
single board needs to replicate the definitions of all the subdevices
which gets tedious, especially if you want to change them for some
reason (eg, an IP becomes used in a wider range of chips so a rename is
appropriate).
