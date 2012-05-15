Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753176Ab2EOFNg (ORCPT <rfc822;w@1wt.eu>);
	Tue, 15 May 2012 01:13:36 -0400
Received: from na3sys009aog104.obsmtp.com ([74.125.149.73]:49568 "EHLO
	na3sys009aog104.obsmtp.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752577Ab2EOFNe (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 15 May 2012 01:13:34 -0400
Message-ID: <4FB1E5F6.7070401@ti.com>
Date: Tue, 15 May 2012 10:43:26 +0530
From: Rajendra Nayak <rnayak@ti.com>
User-Agent: Mozilla/5.0 (X11; U; Linux i686; en-US; rv:1.9.2.20) Gecko/20110805 Thunderbird/3.1.12
MIME-Version: 1.0
To: Saravana Kannan <skannan@codeaurora.org>
CC: "Turquette, Mike" <mturquette@ti.com>,
        Mark Brown <broonie@opensource.wolfsonmicro.com>,
        linux-arm-kernel@lists.infradead.org, linux-kernel@vger.kernel.org,
        Sascha Hauer <s.hauer@pengutronix.de>, andrew@lunn.ch,
        "linux-arm-msm@vger.kernel.org" <linux-arm-msm@vger.kernel.org>
Subject: Re: [PATCH] clk: Constify struct clk_init_data
References: <1337004763-21250-1-git-send-email-broonie@opensource.wolfsonmicro.com> <20120514215304.GB3075@gmail.com> <4FB1AC79.7000901@codeaurora.org>
In-Reply-To: <4FB1AC79.7000901@codeaurora.org>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Saravana,

On Tuesday 15 May 2012 06:38 AM, Saravana Kannan wrote:
> Btw, I didn't follow up on the other thread we were having, but can you
> remind me again what was the reason that you thought that only
> __clk_init() would work for your static init code and __clk_register()
> won't work?

One of the main reason has been the platform implementation we have to
handle some complex mux/divider combo clocks in OMAP2/3 which rely on
'struct clk' pointers. Maybe we can do away with the existing
implementation and redo it so we don't have any such limitation, but the
quantum of change moving to common clk has been so much that we are
trying to minimize on the platform code changes for now. So while
we move to common clk it would still be useful to have __clk_init()
around for a while till we figure out how to get rid of it for OMAP.

regards,
Rajendra
