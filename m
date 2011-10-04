Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932553Ab1JDPFR (ORCPT <rfc822;w@1wt.eu>);
	Tue, 4 Oct 2011 11:05:17 -0400
Received: from opensource.wolfsonmicro.com ([80.75.67.52]:59640 "EHLO
	opensource.wolfsonmicro.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S932466Ab1JDPFO (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 4 Oct 2011 11:05:14 -0400
Date: Tue, 4 Oct 2011 16:04:04 +0100
From: Mark Brown <broonie@opensource.wolfsonmicro.com>
To: Axel Lin <axel.lin@gmail.com>
Cc: linux-kernel@vger.kernel.org, Kenneth Kiraly <kiraly@lab126.com>,
        Liam Girdwood <lrg@ti.com>, alsa-devel@alsa-project.org
Subject: Re: [RFC][PATCH] ASoC: Avoid writing to WM8971_RESET in wm8971_resume
Message-ID: <20111004150403.GI6934@opensource.wolfsonmicro.com>
References: <1317685462.3640.2.camel@phoenix>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1317685462.3640.2.camel@phoenix>
X-Cookie: You are always busy.
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Oct 04, 2011 at 07:44:22AM +0800, Axel Lin wrote:

> While reading the code, I don't understand why we need to do (in wm8971_resume):
> 
> for (i = 0; i < ARRAY_SIZE(wm8971_reg); i++) {
>         if (i + 1 == WM8971_RESET)
>                 continue;
> 
> My understanding is that we want to avoid writing to WM8971_RESET on resume.

Yeah, this looks like a leftover from some older code which omitted
register zero from the cache for some small memory savings.  Now things
are using the standard cache code rather than custom cache code this
is buggy.

Applied, thanks.
