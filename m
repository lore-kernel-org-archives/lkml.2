Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755190Ab2G3W0h (ORCPT <rfc822;w@1wt.eu>);
	Mon, 30 Jul 2012 18:26:37 -0400
Received: from avon.wwwdotorg.org ([70.85.31.133]:45832 "EHLO
	avon.wwwdotorg.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754758Ab2G3W0e (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 30 Jul 2012 18:26:34 -0400
Message-ID: <50170A14.6000201@wwwdotorg.org>
Date: Mon, 30 Jul 2012 16:26:28 -0600
From: Stephen Warren <swarren@wwwdotorg.org>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:13.0) Gecko/20120615 Thunderbird/13.0.1
MIME-Version: 1.0
To: Rob Herring <robherring2@gmail.com>
CC: Alexandre Courbot <acourbot@nvidia.com>,
        Stephen Warren <swarren@nvidia.com>,
        Thierry Reding <thierry.reding@avionic-design.de>,
        Simon Glass <sjg@chromium.org>,
        Grant Likely <grant.likely@secretlab.ca>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Mark Brown <broonie@opensource.wolfsonmicro.com>,
        Arnd Bergmann <arnd@arndb.de>, linux-tegra@vger.kernel.org,
        linux-kernel@vger.kernel.org, linux-fbdev@vger.kernel.org,
        devicetree-discuss@lists.ozlabs.org
Subject: Re: [RFC][PATCH v3 1/3] runtime interpreted power sequences
References: <1343390750-3642-1-git-send-email-acourbot@nvidia.com> <1343390750-3642-2-git-send-email-acourbot@nvidia.com> <5016ABDD.5010809@gmail.com>
In-Reply-To: <5016ABDD.5010809@gmail.com>
X-Enigmail-Version: 1.4.2
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 07/30/2012 09:44 AM, Rob Herring wrote:
> On 07/27/2012 07:05 AM, Alexandre Courbot wrote:
>> Some device drivers (panel backlights especially) need to follow precise
>> sequences for powering on and off, involving gpios, regulators, PWMs
>> with a precise powering order and delays to respect between each steps.
>> These sequences are board-specific, and do not belong to a particular
>> driver - therefore they have been performed by board-specific hook
>> functions to far.
>>
>> With the advent of the device tree and of ARM kernels that are not
>> board-tied, we cannot rely on these board-specific hooks anymore but
>> need a way to implement these sequences in a portable manner. This patch
>> introduces a simple interpreter that can execute such power sequences
>> encoded either as platform data or within the device tree.
>>
> 
> Why not? We'll always have some amount of board code. The key is to
> limit parts that are just data. I'm not sure this is something that
> should be in devicetree.
> 
> Perhaps what is needed is a better way to hook into the driver like
> notifiers?

I would answer that by asking the reverse question - why should we have
to put some data in DT, and some data into board files still?

I'd certainly argue that the sequence of which GPIOs/regulators/PWMs to
manipulate is just data.

To be honest, if we're going to have to put some parts of a board's
configuration into board files anyway, then the entirety of DT seems
useless; I'd far rather see all the configuration in one cohesive place
than arbitrarily split into two/n different locations - that would make
everything harder to maintain.
