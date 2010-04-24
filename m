Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753411Ab0DXPJG (ORCPT <rfc822;w@1wt.eu>);
	Sat, 24 Apr 2010 11:09:06 -0400
Received: from ganesha.gnumonks.org ([213.95.27.120]:50902 "EHLO
	ganesha.gnumonks.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753035Ab0DXPJE (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 24 Apr 2010 11:09:04 -0400
Date: Sat, 24 Apr 2010 15:53:16 +0200
From: Harald Welte <laforge@gnumonks.org>
To: Jonathan Corbet <corbet@lwn.net>
Cc: Florian Tobias Schandinat <FlorianSchandinat@gmx.de>,
       linux-kernel@vger.kernel.org, Deepak Saxena <dsaxena@laptop.org>,
       linux-fbdev@vger.kernel.org, JosephChan@via.com.tw,
       ScottFang@viatech.com.cn
Subject: Re: [PATCH 10/11] viafb: rework the I2C support in the VIA
 framebuffer driver
Message-ID: <20100424135316.GR24811@prithivi.gnumonks.org>
References: <1271614873-5952-1-git-send-email-corbet@lwn.net>
 <1271614873-5952-11-git-send-email-corbet@lwn.net>
 <4BD20D56.7080402@gmx.de>
 <20100423155725.7d3b2d2d@bike.lwn.net>
 <4BD221E7.7060705@gmx.de>
 <20100423165256.654ca5eb@bike.lwn.net>
 <4BD22B96.5020102@gmx.de>
 <4BD2CC46.4060908@gmx.de>
 <20100424073359.349b4397@bike.lwn.net>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20100424073359.349b4397@bike.lwn.net>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Jon,

On Sat, Apr 24, 2010 at 07:33:59AM -0600, Jonathan Corbet wrote:

> This patch creates an i2c bus on every port which could conceivably
> have one.  That's rather different from the original code, which
> created a single bus (in the kernel) then swapped it between ports 31
> and 2c in weird ways.  In particular, it takes over ports which,
> conceivably, somebody else could be using for GPIO.  So, perhaps, there
> is some contention going on there.
> 
> If my hypothesis is correct, this problem will go away with the
> application of the second series, which doesn't create i2c buses on
> ports used for GPIO.  But the problem should be fixed here so we don't
> have things broken in the middle.
> 
> Harald, does this reasoning make sense to you?  If so, what I should do
> is bring forward just enough of the via-core code to be able to
> configure which ports actually get i2c buses created on them.  Easily
> done.

It makes a lot of sense.  When I added all possible I2C busses, this was merely
the result of "let's try to make sure every possible configuration is
supported" rather than some kind of neccessity.

Simply converting the original two busses to the new code is definitely
the way to go.  Maybe we'll keep the code for the other two around, but
somehow keep them inactive and don't advertise them unless somebody explicitly
does so?

-- 
- Harald Welte <laforge@gnumonks.org>           http://laforge.gnumonks.org/
============================================================================
"Privacy in residential applications is a desirable marketing option."
                                                  (ETSI EN 300 175-7 Ch. A6)
