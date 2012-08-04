Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752926Ab2HDKEu (ORCPT <rfc822;w@1wt.eu>);
	Sat, 4 Aug 2012 06:04:50 -0400
Received: from opensource.wolfsonmicro.com ([80.75.67.52]:34834 "EHLO
	opensource.wolfsonmicro.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751640Ab2HDKEr (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 4 Aug 2012 06:04:47 -0400
Date: Sat, 4 Aug 2012 11:00:47 +0100
From: Mark Brown <broonie@opensource.wolfsonmicro.com>
To: anish kumar <anish198519851985@gmail.com>
Cc: Chanwoo Choi <cw00.choi@samsung.com>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        MyungJoo Ham <myungjoo.ham@samsung.com>,
        patches@opensource.wolfsonmicro.com, linux-kernel@vger.kernel.org
Subject: Re: [PATCH] extcon: arizona: Implement button detection support
Message-ID: <20120804100046.GB9248@opensource.wolfsonmicro.com>
References: <1342800449-10328-1-git-send-email-broonie@opensource.wolfsonmicro.com>
 <500F8DB4.30401@samsung.com>
 <1344062254.1525.239.camel@anish-Inspiron-N5050>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1344062254.1525.239.camel@anish-Inspiron-N5050>
X-Cookie: Stay the curse.
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sat, Aug 04, 2012 at 12:07:34PM +0530, anish kumar wrote:

> According to my discussion with Mr. Myunjoo Ham.He said that single
> driver should not be used for communicating with both extcon and input
> subsystem and that is the reason he suggested that I split the samsung
> jack driver into two separate drivers.

> First driver to communicate with extcon about headset insertion/removal.
> Second driver is to communicate with input subsystem to report headset
> button press/release.

> I have followed this approach and coded and it seems to be working fine,
> but looking at this patch I feel there is no need to separate as
> both insertion/removal and button press/release is reported using a
> single driver.
> I am good with any approach but just wanted to let you know what I am
> going to post soon.

For this hardware splitting really isn't practical - the hardware and
state machine for button interaction and basic detection are the same,
I think all we could do with separate drivers is have a core which
called back into subdrivers which have the sole purpose of propagating
reports up the stack.
