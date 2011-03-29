Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754715Ab1C2XjD (ORCPT <rfc822;w@1wt.eu>);
	Tue, 29 Mar 2011 19:39:03 -0400
Received: from opensource.wolfsonmicro.com ([80.75.67.52]:42590 "EHLO
	opensource2.wolfsonmicro.com" rhost-flags-OK-OK-OK-FAIL)
	by vger.kernel.org with ESMTP id S1751683Ab1C2XjC (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 29 Mar 2011 19:39:02 -0400
Date: Wed, 30 Mar 2011 08:39:10 +0900
From: Mark Brown <broonie@opensource.wolfsonmicro.com>
To: Liam Girdwood <lrg@slimlogic.co.uk>
Cc: David Collins <collinsd@codeaurora.org>, linux-kernel@vger.kernel.org,
        patches@opensource.wolfsonmicro.com
Subject: Re: [PATCH] regulator: When constraining modes fall back to higher
 power modes
Message-ID: <20110329233909.GN30482@opensource.wolfsonmicro.com>
References: <1301434152-16393-1-git-send-email-broonie@opensource.wolfsonmicro.com>
 <1301441364.3402.41.camel@odin>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1301441364.3402.41.camel@odin>
X-Cookie: You are standing on my toes.
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Mar 30, 2011 at 12:29:24AM +0100, Liam Girdwood wrote:

> It's late and I'm wondering if it's cleaner here just to :-
> 
> if (mask & *mode)
> 	return 0;

> *mode = fls(mask);
> if (*mode)
> 	return 0;

This will end up selecting the highest mode in mask, even if it's lower
than the one asked for, you'd need to recheck against the original mask.
There's a few ways I can think of to do that but they're none of them
exceptionally pretty.
