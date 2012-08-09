Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1031173Ab2HIPpA (ORCPT <rfc822;w@1wt.eu>);
	Thu, 9 Aug 2012 11:45:00 -0400
Received: from opensource.wolfsonmicro.com ([80.75.67.52]:49277 "EHLO
	opensource.wolfsonmicro.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1030969Ab2HIPo7 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 9 Aug 2012 11:44:59 -0400
Date: Thu, 9 Aug 2012 16:44:57 +0100
From: Mark Brown <broonie@opensource.wolfsonmicro.com>
To: Stephen Warren <swarren@wwwdotorg.org>
Cc: Liam Girdwood <lrg@ti.com>, Laxman Dewangan <ldewangan@nvidia.com>,
        linux-kernel@vger.kernel.org, Stephen Warren <swarren@nvidia.com>
Subject: Re: [PATCH V2 2/3] regulator: add regulator_get_voltage_fixed helper
 op
Message-ID: <20120809154456.GX24328@opensource.wolfsonmicro.com>
References: <1344460727-6243-1-git-send-email-swarren@wwwdotorg.org>
 <1344460727-6243-2-git-send-email-swarren@wwwdotorg.org>
 <20120809105910.GN24328@opensource.wolfsonmicro.com>
 <5023D5CF.1070402@wwwdotorg.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <5023D5CF.1070402@wwwdotorg.org>
X-Cookie: Be different: conform.
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Aug 09, 2012 at 09:22:55AM -0600, Stephen Warren wrote:

> I don't think there's a *get*_voltage_linear. All the existing
> get_voltage "standard" ops require reading a register, hence why I added
> this new standard op. I guess I'll look at converting all the existing
> users.

Hrm, right - the fact that you've not implemented get_voltage_sel() is
what I noticed here really.  I think the core should really cope with
this, if the driver has a list voltage operation but no way of reading
the voltage operation then we should just use the list voltage operation
to get the voltage back.  We want to be able to list since things that
check the range of available voltages might want to know.
