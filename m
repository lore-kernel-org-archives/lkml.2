Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753939Ab0K1SZr (ORCPT <rfc822;w@1wt.eu>);
	Sun, 28 Nov 2010 13:25:47 -0500
Received: from opensource.wolfsonmicro.com ([80.75.67.52]:38741 "EHLO
	opensource2.wolfsonmicro.com" rhost-flags-OK-OK-OK-FAIL)
	by vger.kernel.org with ESMTP id S1752796Ab0K1SZo convert rfc822-to-8bit
	(ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 28 Nov 2010 13:25:44 -0500
Subject: Re: [RFC/PATCH v6 05/12] media: Reference count and power handling
Mime-Version: 1.0 (Apple Message framework v1082)
Content-Type: text/plain; charset=us-ascii
From: Mark Brown <broonie@opensource.wolfsonmicro.com>
In-Reply-To: <201011281333.39214.laurent.pinchart@ideasonboard.com> (sfid-20101128_154847_234366_292E6E7B)
Date: Sun, 28 Nov 2010 18:25:39 +0000
Cc: Sakari Ailus <sakari.ailus@maxwell.research.nokia.com>,
        linux-media@vger.kernel.org, linux-omap@vger.kernel.org,
        linux-kernel@vger.kernel.org, lrg@slimlogic.co.uk,
        lennart@poettering.net
Content-Transfer-Encoding: 8BIT
Message-Id: <6C806F24-FF45-4BF6-ACB0-1EE10AC584BD@opensource.wolfsonmicro.com>
References: <1290652099-15102-1-git-send-email-laurent.pinchart@ideasonboard.com> <4CEEA191.1000706@maxwell.research.nokia.com> <20101125214633.GC25162@opensource.wolfsonmicro.com> <201011281333.39214.laurent.pinchart@ideasonboard.com> (sfid-20101128_154847_234366_292E6E7B)
To: Laurent Pinchart <laurent.pinchart@ideasonboard.com>
X-Mailer: Apple Mail (2.1082)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 28 Nov 2010, at 12:33, Laurent Pinchart wrote:

> Throwing an idea here, what about making power management modular ? The MC 
> core would then call back to drivers to handle use count changes. The 
> media_entity_use_change() function would be exported (and renamed), so that 
> drivers could use it if they want graph-based power management. ALSA would 
> have its own use count handler.

We need more than just the count handler - we need a complete list of everything that has been changed in the whole system. The graph walk itself is fine but we need to be able to do postprocessing of the delta that is generated. Like I said pre- and post- callbacks may well cover it.

Note that this is specifically for ASoC, not ALSA in general.