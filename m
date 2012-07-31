Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753050Ab2GaRU6 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 31 Jul 2012 13:20:58 -0400
Received: from avon.wwwdotorg.org ([70.85.31.133]:36844 "EHLO
	avon.wwwdotorg.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751710Ab2GaRU4 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 31 Jul 2012 13:20:56 -0400
Message-ID: <501813F5.6020607@wwwdotorg.org>
Date: Tue, 31 Jul 2012 11:20:53 -0600
From: Stephen Warren <swarren@wwwdotorg.org>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:13.0) Gecko/20120615 Thunderbird/13.0.1
MIME-Version: 1.0
To: Mark Brown <broonie@opensource.wolfsonmicro.com>
CC: Samuel Ortiz <sameo@linux.intel.com>, linux-kernel@vger.kernel.org,
        Stephen Warren <swarren@nvidia.com>
Subject: Re: [PATCH] mfd: arizona: convert to regmap_add_irq_chips
References: <1343415776-27176-1-git-send-email-swarren@wwwdotorg.org> <20120729203854.GF4384@opensource.wolfsonmicro.com> <5016BEC4.5000600@wwwdotorg.org> <20120730180352.GR4468@opensource.wolfsonmicro.com>
In-Reply-To: <20120730180352.GR4468@opensource.wolfsonmicro.com>
X-Enigmail-Version: 1.4.2
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 07/30/2012 12:03 PM, Mark Brown wrote:
> On Mon, Jul 30, 2012 at 11:05:08AM -0600, Stephen Warren wrote:
>> On 07/29/2012 02:38 PM, Mark Brown wrote:
>>> On Fri, Jul 27, 2012 at 01:02:56PM -0600, Stephen Warren wrote:
> 
>>>> 1) regmap_add_irq_chips() calls regmap_add_irq_chip() with irq==0 rather
>>>>    than -1, so in turn irq_domain_add_linear() is called rather than
>>>>    irq_domain_add_legacy(). This change could be avoided by providing an
>>>>    irq_bases array to regmap_add_irq_chips().
> 
>>> This is a problem.
> 
>> OK, can you explain why? Is the problem the difference between the two
>> types of IRQ domain? I would have assumed this was an internal detail of
>> the driver hence not an issue. I assume there's no issue with
>> known/static IRQ numbers, since both 0 and -1 end up dynamically
>> allocating the IRQ bases IIRC.
> 
> We have GPIOs we might want to do interrupts on, if the API doesn't
> support providing a base we've got an issue.

I agree in general, but I don't see how this is a regression in this
change - the arizona pdata doesn't specify an IRQ base anywhere, and
hence the IRQ base is already dynamically allocated...

The (regmap-irq) API (in the patch I sent) does support optionally
specifying a base if you want, it's just that the arizona-irq.c patch I
sent didn't specify a base, since the original code didn't.
