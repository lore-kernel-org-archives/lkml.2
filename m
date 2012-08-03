Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752609Ab2HCBN6 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 2 Aug 2012 21:13:58 -0400
Received: from hqemgate04.nvidia.com ([216.228.121.35]:14245 "EHLO
	hqemgate04.nvidia.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750905Ab2HCBN4 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 2 Aug 2012 21:13:56 -0400
X-PGP-Universal: processed;
	by hqnvupgp05.nvidia.com on Thu, 02 Aug 2012 18:13:55 -0700
Message-ID: <501B2642.4080805@nvidia.com>
Date: Fri, 3 Aug 2012 10:15:46 +0900
From: Alex Courbot <acourbot@nvidia.com>
Organization: NVIDIA
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:14.0) Gecko/20120717 Thunderbird/14.0
MIME-Version: 1.0
To: Mark Brown <broonie@opensource.wolfsonmicro.com>
CC: Stephen Warren <swarren@wwwdotorg.org>,
        Stephen Warren <swarren@nvidia.com>, Simon Glass <sjg@chromium.org>,
        Grant Likely <grant.likely@secretlab.ca>,
        Rob Herring <rob.herring@calxeda.com>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Arnd Bergmann <arnd@arndb.de>,
        "linux-tegra@vger.kernel.org" <linux-tegra@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "linux-fbdev@vger.kernel.org" <linux-fbdev@vger.kernel.org>,
        "devicetree-discuss@lists.ozlabs.org" 
	<devicetree-discuss@lists.ozlabs.org>,
        Thierry Reding <thierry.reding@avionic-design.de>
Subject: Re: [RFC][PATCH v3 1/3] runtime interpreted power sequences
References: <1343390750-3642-1-git-send-email-acourbot@nvidia.com> <1343390750-3642-2-git-send-email-acourbot@nvidia.com> <50170EA0.1010408@wwwdotorg.org> <501A338D.7080105@nvidia.com> <20120802082157.GA14866@avionic-0098.adnet.avionic-design.de> <20120802181111.GM4537@opensource.wolfsonmicro.com>
In-Reply-To: <20120802181111.GM4537@opensource.wolfsonmicro.com>
Content-Type: text/plain; charset="UTF-8"; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri 03 Aug 2012 03:11:12 AM JST, Mark Brown wrote:
> On Thu, Aug 02, 2012 at 10:21:57AM +0200, Thierry Reding wrote:
>> On Thu, Aug 02, 2012 at 05:00:13PM +0900, Alex Courbot wrote:
>
>>> The problem is, how do we turn these phandles into the resource of
>>> interest. The type of the resource can be infered by the name of the
>>> property. The hard part is resolving the resource from the phandle -
>>> it seems like the API just does not allow to do this. GPIO has
>>> of_get_named_gpio, but AFAIK there are no equivalent for regulator
>>> consumer and PWM: the only way to use the DT with them is through
>>> get_regulator and get_pwm which work at the device level.
>
>>> Or is there a way that I overlooked?
>
>> No, you are right. Perhaps we should add exported functions that do the
>> equivalent of of_pwm_request() or the regulator_dev_lookup() and
>> of_get_regulator() pair.
>
> I missed some of the earlier bits of the thread here but why can't we do
> device based lookups?

That is because the phandles would not be properties of the device node 
but rather of its sub-nodes:

backlight {
     compatible = "pwm-backlight";
     ...
     power-on-sequence {
         step@0 {
             regulator = <&backlight_reg>;
             enable;
         };


So here simply using regulator_get on the backlight device would not work.

Alex.
