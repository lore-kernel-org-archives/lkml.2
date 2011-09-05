Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753082Ab1IERoA (ORCPT <rfc822;w@1wt.eu>);
	Mon, 5 Sep 2011 13:44:00 -0400
Received: from mailhost.informatik.uni-hamburg.de ([134.100.9.70]:44573 "EHLO
	mailhost.informatik.uni-hamburg.de" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752677Ab1IERny (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 5 Sep 2011 13:43:54 -0400
Message-ID: <4E650A3A.5050807@metafoo.de>
Date: Mon, 05 Sep 2011 19:43:22 +0200
From: Lars-Peter Clausen <lars@metafoo.de>
User-Agent: Mozilla/5.0 (X11; U; Linux x86_64; en-US; rv:1.9.1.16) Gecko/20110818 Icedove/3.0.11
MIME-Version: 1.0
To: Mark Brown <broonie@opensource.wolfsonmicro.com>
CC: Liam Girdwood <lrg@ti.com>, alsa-devel@alsa-project.org,
        device-drivers-devel@blackfin.uclinux.org,
        uclinux-dist-devel@blackfin.uclinux.org, linux-kernel@vger.kernel.org,
        Scott Jiang <scott.jiang.linux@gmail.com>
Subject: Re: [PATCH 2/3] ASoC: Allow codecs to provide their own regmap configuration
References: <1315228682-1097-1-git-send-email-lars@metafoo.de> <1315228682-1097-2-git-send-email-lars@metafoo.de> <20110905172916.GG3889@opensource.wolfsonmicro.com>
In-Reply-To: <20110905172916.GG3889@opensource.wolfsonmicro.com>
X-Enigmail-Version: 1.0.1
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 09/05/2011 07:29 PM, Mark Brown wrote:
> On Mon, Sep 05, 2011 at 03:18:01PM +0200, Lars-Peter Clausen wrote:
>> Currently a codec can either do the whole regmap initialization on its own or
>> provide only the register and value bit size and let the core handle
>> initialization. This patch allows a codec to provide a complete regmap
>> configuration while still letting ASoC core handle the regmap initialization
>> and setup.
> 
> I'd rather not do this, the only value is the copying of the word size
> setup out of the regmap config is to allow us to use the ASoC cache code
> but the idea is to push the cache down out of ASoC into the regmap code
> so this function should just be a trivial indirection for the regmap
> init which isn't useful.
> 

I think it is useful, since we avoid duplicating that ugly switch statement
and we also have to wrap regmap_write and regmap_read, duplicating that in each
codec driver doesn't make sense.
