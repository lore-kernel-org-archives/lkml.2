Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753736Ab2JIG1J (ORCPT <rfc822;w@1wt.eu>);
	Tue, 9 Oct 2012 02:27:09 -0400
Received: from opensource.wolfsonmicro.com ([80.75.67.52]:43912 "EHLO
	opensource.wolfsonmicro.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752791Ab2JIG1G (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 9 Oct 2012 02:27:06 -0400
Date: Tue, 9 Oct 2012 15:26:57 +0900
From: Mark Brown <broonie@opensource.wolfsonmicro.com>
To: Laxman Dewangan <ldewangan@nvidia.com>
Cc: lrg@ti.com, sameo@linux.intel.com, vbyravarasu@nvidia.com,
        axel.lin@gmail.com, linux-kernel@vger.kernel.org
Subject: Re: [PATCH 4/5] regulator: tps65090: Add voltage out level in
 platform data
Message-ID: <20121009062654.GK8237@opensource.wolfsonmicro.com>
References: <1349536671-31714-1-git-send-email-ldewangan@nvidia.com>
 <1349536671-31714-6-git-send-email-ldewangan@nvidia.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1349536671-31714-6-git-send-email-ldewangan@nvidia.com>
X-Cookie: Your present plans will be successful.
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sat, Oct 06, 2012 at 08:47:50PM +0530, Laxman Dewangan wrote:

> TPS65090's DCDCs and FETs act as switch and so output
> voltage can be enable or disable only. The output voltage
> of this regulators depends on the input voltage.
> Add the voltage parameter to tell the output voltage value
> of these rails.

This should be using the recently added bypass support - the regualtors
should arrange to always report themselves as bypass (in the case of the
FETs, I'm not 100% sure what you mean for the DCDCs...) and the
framework should be reporting the input voltage for regulators in bypass
mode.
