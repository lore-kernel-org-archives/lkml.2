Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758548Ab1DNNGU (ORCPT <rfc822;w@1wt.eu>);
	Thu, 14 Apr 2011 09:06:20 -0400
Received: from opensource.wolfsonmicro.com ([80.75.67.52]:36154 "EHLO
	opensource2.wolfsonmicro.com" rhost-flags-OK-OK-OK-FAIL)
	by vger.kernel.org with ESMTP id S1758438Ab1DNNGT (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 14 Apr 2011 09:06:19 -0400
Date: Thu, 14 Apr 2011 06:06:26 -0700
From: Mark Brown <broonie@opensource.wolfsonmicro.com>
To: Antonio Ospite <ospite@studenti.unina.it>
Cc: Johannes Berg <johannes@sipsolutions.net>, linux-wireless@vger.kernel.org,
        openezx-devel@lists.openezx.org,
        "John W . Linville" <linville@tuxdriver.com>,
        linux-kernel@vger.kernel.org, Marek Vasut <marek.vasut@gmail.com>,
        Guiming Zhuo <gmzhuo@gmail.com>
Subject: Re: [PATCH v3] rfkill: Regulator consumer driver for rfkill
Message-ID: <20110414130626.GA7890@opensource.wolfsonmicro.com>
References: <1302686356.3731.1.camel@jlt3.sipsolutions.net>
 <1302723645-5286-1-git-send-email-ospite@studenti.unina.it>
 <1302724383.3731.19.camel@jlt3.sipsolutions.net>
 <20110414123912.71e4bd52.ospite@studenti.unina.it>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20110414123912.71e4bd52.ospite@studenti.unina.it>
X-Cookie: You will be married within a year.
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Apr 14, 2011 at 12:39:12PM +0200, Antonio Ospite wrote:
> Johannes Berg <johannes@sipsolutions.net> wrote:

> > Should remove do platform_set_drvdata(pdev, NULL)?

> AFAICS this is not strictly necessary because we never check for NULL
> here and we are setting drvdata again in _probe() each time the module
> is loaded anyways. If it is considered a good practice for symmetry
> reasons then I'll add it, no problem. Does anyone has comments on that?

We went round this loop with I2C - anything peering at driver data that
it didn't originally set is buggy anyway so no need to reset to zero.
If there was a need the platform bus or driver core should do it since
all devices would need it.
