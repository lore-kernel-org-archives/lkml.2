Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752612Ab2GZTTz (ORCPT <rfc822;w@1wt.eu>);
	Thu, 26 Jul 2012 15:19:55 -0400
Received: from wolverine01.qualcomm.com ([199.106.114.254]:14528 "EHLO
	wolverine01.qualcomm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752312Ab2GZTTy (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 26 Jul 2012 15:19:54 -0400
X-IronPort-AV: E=McAfee;i="5400,1158,6784"; a="214873497"
Message-ID: <50119856.2020206@codeaurora.org>
Date: Thu, 26 Jul 2012 15:19:50 -0400
From: Christopher Covington <cov@codeaurora.org>
User-Agent: Mozilla/5.0 (X11; U; Linux x86_64; en-US; rv:1.9.2.13) Gecko/20101208 Thunderbird/3.1.7
MIME-Version: 1.0
To: Stefano Stabellini <stefano.stabellini@eu.citrix.com>
CC: linux-kernel@vger.kernel.org, xen-devel@lists.xensource.com,
        linaro-dev@lists.linaro.org, Ian.Campbell@citrix.com, arnd@arndb.de,
        konrad.wilk@oracle.com, catalin.marinas@arm.com, tim@xen.org,
        linux-arm-kernel@lists.infradead.org
Subject: Re: [PATCH 02/24] xen/arm: hypercalls
References: <alpine.DEB.2.02.1207251741470.26163@kaball.uk.xensource.com> <1343316846-25860-2-git-send-email-stefano.stabellini@eu.citrix.com>
In-Reply-To: <1343316846-25860-2-git-send-email-stefano.stabellini@eu.citrix.com>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Stefano,

On 07/26/2012 11:33 AM, Stefano Stabellini wrote:
> Use r12 to pass the hypercall number to the hypervisor.
> 
> We need a register to pass the hypercall number because we might not
> know it at compile time and HVC only takes an immediate argument.

You're not going to JIT assemble the appropriate HVC instruction? Darn.

How many call numbers are there, though? 8? It seems like it'd be
reasonable to take the approach that seems to be favored for MRC/MCR
instructions, using a function containing switch statement that chooses
between several inline assembly instructions based off an enum passed to
the function. See for example arch_timer_reg_read in
arch/arm/kernel/arch_timer.c.

Regards,
Christopher

-- 
Employee of Qualcomm Innovation Center, Inc.
Qualcomm Innovation Center, Inc. is a member of Code Aurora Forum
