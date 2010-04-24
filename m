Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753626Ab0DXNeG (ORCPT <rfc822;w@1wt.eu>);
	Sat, 24 Apr 2010 09:34:06 -0400
Received: from tex.lwn.net ([70.33.254.29]:54608 "EHLO vena.lwn.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752664Ab0DXNeD (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sat, 24 Apr 2010 09:34:03 -0400
Date: Sat, 24 Apr 2010 07:33:59 -0600
From: Jonathan Corbet <corbet@lwn.net>
To: Florian Tobias Schandinat <FlorianSchandinat@gmx.de>
Cc: linux-kernel@vger.kernel.org, Harald Welte <laforge@gnumonks.org>,
       Deepak Saxena <dsaxena@laptop.org>, linux-fbdev@vger.kernel.org,
       JosephChan@via.com.tw, ScottFang@viatech.com.cn
Subject: Re: [PATCH 10/11] viafb: rework the I2C support in the VIA
 framebuffer driver
Message-ID: <20100424073359.349b4397@bike.lwn.net>
In-Reply-To: <4BD2CC46.4060908@gmx.de>
References: <1271614873-5952-1-git-send-email-corbet@lwn.net>
	<1271614873-5952-11-git-send-email-corbet@lwn.net>
	<4BD20D56.7080402@gmx.de>
	<20100423155725.7d3b2d2d@bike.lwn.net>
	<4BD221E7.7060705@gmx.de>
	<20100423165256.654ca5eb@bike.lwn.net>
	<4BD22B96.5020102@gmx.de>
	<4BD2CC46.4060908@gmx.de>
Organization: LWN.net
X-Mailer: Claws Mail 3.7.5 (GTK+ 2.20.0; x86_64-redhat-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 8bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sat, 24 Apr 2010 12:47:34 +0200
Florian Tobias Schandinat <FlorianSchandinat@gmx.de> wrote:

> I was able to narrow this issue down to the fourth bus. So with
> if (i == 4)
> 	continue;
> in the bus creation loop I'm able to get a working framebuffer which 
> does not have the issues mentioned. Any ideas what should be done now?

That is useful information indeed, thanks.

This patch creates an i2c bus on every port which could conceivably
have one.  That's rather different from the original code, which
created a single bus (in the kernel) then swapped it between ports 31
and 2c in weird ways.  In particular, it takes over ports which,
conceivably, somebody else could be using for GPIO.  So, perhaps, there
is some contention going on there.

If my hypothesis is correct, this problem will go away with the
application of the second series, which doesn't create i2c buses on
ports used for GPIO.  But the problem should be fixed here so we don't
have things broken in the middle.

Harald, does this reasoning make sense to you?  If so, what I should do
is bring forward just enough of the via-core code to be able to
configure which ports actually get i2c buses created on them.  Easily
done.

Thanks,

jon
