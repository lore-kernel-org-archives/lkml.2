Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752817Ab0LLMSd (ORCPT <rfc822;w@1wt.eu>);
	Sun, 12 Dec 2010 07:18:33 -0500
Received: from opensource.wolfsonmicro.com ([80.75.67.52]:34935 "EHLO
	opensource2.wolfsonmicro.com" rhost-flags-OK-OK-OK-FAIL)
	by vger.kernel.org with ESMTP id S1752489Ab0LLMSb (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 12 Dec 2010 07:18:31 -0500
Date: Sun, 12 Dec 2010 12:18:42 +0000
From: Mark Brown <broonie@opensource.wolfsonmicro.com>
To: Saravana Kannan <skannan@codeaurora.org>
Cc: Liam Girdwood <lrg@slimlogic.co.uk>, linux-arm-msm@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH] regulator: Call into regulator driver only when
 voltage min/max really changes.
Message-ID: <20101212121842.GC15189@opensource.wolfsonmicro.com>
References: <1292151342-12970-1-git-send-email-skannan@codeaurora.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1292151342-12970-1-git-send-email-skannan@codeaurora.org>
X-Cookie: Your present plans will be successful.
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sun, Dec 12, 2010 at 02:55:40AM -0800, Saravana Kannan wrote:
> Even in cases where the consumer driver calls the regulator core with
> different voltage min/max values, the application of the various
> voltage constraints could result in the min/max voltage values passed
> to the regulator driver to be unchanged since the previous invocation.

Out of interest do we have any examples of consumers that do this
sufficiently often and/or in paths sufficiently performance critical for
it to be an issue?  Sounds like there might be room for optimisation in
those consumers.

> Optimize these cases by not calling into the regulator driver and not
> sending incorrect/unnecessary voltage change notifications.

Acked-by: Mark Brown <broonie@opensource.wolfsonmicro.com>

The down side of doing this is that if the regulator state changes
underneath us we've now got no way of recovering from that situation.
This is something that's only partially supported by the API at the
minute but it's nice to have a story about how drivers can work with
this.  I'll send a patch adding an explicit sync API.
