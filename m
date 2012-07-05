Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752103Ab2GECfq (ORCPT <rfc822;w@1wt.eu>);
	Wed, 4 Jul 2012 22:35:46 -0400
Received: from hqemgate03.nvidia.com ([216.228.121.140]:1072 "EHLO
	hqemgate03.nvidia.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751418Ab2GECe4 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 4 Jul 2012 22:34:56 -0400
X-PGP-Universal: processed;
	by hqnvupgp06.nvidia.com on Wed, 04 Jul 2012 19:34:56 -0700
Message-ID: <4FF4FDC0.8020405@nvidia.com>
Date: Thu, 5 Jul 2012 11:36:48 +0900
From: Alex Courbot <acourbot@nvidia.com>
Organization: NVIDIA
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:13.0) Gecko/20120616 Thunderbird/13.0.1
MIME-Version: 1.0
To: Mark Brown <broonie@opensource.wolfsonmicro.com>
CC: Sascha Hauer <s.hauer@pengutronix.de>,
        Thierry Reding <thierry.reding@avionic-design.de>,
        "linux-tegra@vger.kernel.org" <linux-tegra@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "linux-fbdev@vger.kernel.org" <linux-fbdev@vger.kernel.org>
Subject: Re: [PATCH] pwm-backlight: add regulator and GPIO support
References: <1340976167-27298-1-git-send-email-acourbot@nvidia.com> <20120704104840.GJ24458@pengutronix.de> <4FF43692.2040805@nvidia.com> <20120704130056.GC30009@pengutronix.de> <4FF45DDF.9000306@nvidia.com> <20120704152451.GA7333@sirena.org.uk>
In-Reply-To: <20120704152451.GA7333@sirena.org.uk>
Content-Type: text/plain; charset="ISO-8859-1"; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 07/05/2012 12:24 AM, Mark Brown wrote:
> On Thu, Jul 05, 2012 at 12:14:39AM +0900, Alex Courbot wrote:
>> On Wed 04 Jul 2012 10:00:56 PM JST, Sascha Hauer wrote:
>
>>> Also please be aware that using a regulator in the pwm backlight will
>>> instantly break all existing users. That's hardly your fault though.
>
>> Sorry, I don't see why. Could you elaborate on this?
>
> All existing machines will start failing during probe as they won't be
> able to find the regulator - you should ideally make sure everyone in
> mainline gets an appropriate regulator set up.

Oh, that is a mistake of mine then. Driver probe should continue if no 
regulator is declared (but should fail if some other error occured). I 
want to maintain backward compatibility with current users of the 
driver, so regulator/gpio specification should be optional.

Thanks for all the feedback people - I will come back with a new version 
that addresses the points highlighted and also allows power on/off 
sequences to be specified in the device tree.

Alex.
