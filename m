Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751806Ab1ECIwu (ORCPT <rfc822;w@1wt.eu>);
	Tue, 3 May 2011 04:52:50 -0400
Received: from caramon.arm.linux.org.uk ([78.32.30.218]:56784 "EHLO
	caramon.arm.linux.org.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751638Ab1ECIws (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 3 May 2011 04:52:48 -0400
Date: Tue, 3 May 2011 09:52:20 +0100
From: Russell King - ARM Linux <linux@arm.linux.org.uk>
To: Arnd Bergmann <arnd@arndb.de>
Cc: linux-arm-kernel@lists.infradead.org, johnlinn@comcast.net,
        nicolas pitre <nicolas.pitre@linaro.org>,
        devicetree-discuss@lists.ozlabs.org, linux-kernel@vger.kernel.org,
        grant likely <grant.likely@secretlab.ca>,
        john linn <john.linn@xilinx.com>
Subject: Re: [RFC PATCH 4/4] ARM: Xilinx: Adding Xilinx board support
Message-ID: <20110503085220.GL28001@n2100.arm.linux.org.uk>
References: <90477150.2231869.1304372815517.JavaMail.root@sz0140a.emeryville.ca.mail.comcast.net> <1319927287.2232106.1304373011082.JavaMail.root@sz0140a.emeryville.ca.mail.comcast.net> <20110502230118.GE28001@n2100.arm.linux.org.uk> <201105030958.14698.arnd@arndb.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <201105030958.14698.arnd@arndb.de>
User-Agent: Mutt/1.5.19 (2009-01-05)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, May 03, 2011 at 09:58:14AM +0200, Arnd Bergmann wrote:
> On Tuesday 03 May 2011 01:01:18 Russell King - ARM Linux wrote:
> > It is preferable to use the same mapping, as it ensures that you're not
> > going to create incompatible aliases.
> 
> Is aliasing a problem for MMIO mappings? I would think that you can
> ioremap registers anywhere and as often as you want because they are
> never cacheable.

Provided the type and sharability is identical then there is no problem.
I wasn't referring to multiple ioremap()s of the same region - that
should be fine as the same attributes will be used.  If you mix ioremap()
and iotable_init() then you _could_ have problems if you don't use
MT_DEVICE in the iotable.

What I'm basically saying is that mixing the methods of creating these
mappings makes it much easier to get tripped up over these issues.
