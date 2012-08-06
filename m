Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932295Ab2HFQQq (ORCPT <rfc822;w@1wt.eu>);
	Mon, 6 Aug 2012 12:16:46 -0400
Received: from avon.wwwdotorg.org ([70.85.31.133]:57086 "EHLO
	avon.wwwdotorg.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756429Ab2HFQQo (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 6 Aug 2012 12:16:44 -0400
Message-ID: <501FEDE7.1060202@wwwdotorg.org>
Date: Mon, 06 Aug 2012 10:16:39 -0600
From: Stephen Warren <swarren@wwwdotorg.org>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:14.0) Gecko/20120714 Thunderbird/14.0
MIME-Version: 1.0
To: Alex Courbot <acourbot@nvidia.com>
CC: Mark Brown <broonie@opensource.wolfsonmicro.com>,
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
References: <1343390750-3642-1-git-send-email-acourbot@nvidia.com> <1343390750-3642-2-git-send-email-acourbot@nvidia.com> <50170EA0.1010408@wwwdotorg.org> <501A338D.7080105@nvidia.com> <20120802082157.GA14866@avionic-0098.adnet.avionic-design.de> <20120802181111.GM4537@opensource.wolfsonmicro.com> <501B2642.4080805@nvidia.com> <20120804141155.GJ10523@opensource.wolfsonmicro.com> <501F2BAA.8000808@nvidia.com>
In-Reply-To: <501F2BAA.8000808@nvidia.com>
X-Enigmail-Version: 1.5a1pre
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 08/05/2012 08:27 PM, Alex Courbot wrote:
> On 08/04/2012 11:12 PM, Mark Brown wrote:
>> On Fri, Aug 03, 2012 at 10:15:46AM +0900, Alex Courbot wrote:
>>> On Fri 03 Aug 2012 03:11:12 AM JST, Mark Brown wrote:
>>
>>>> I missed some of the earlier bits of the thread here but why can't
>>>> we do
>>>> device based lookups?
...
> I think we only have two choices for this:
> 
> 1) Stick to the scheme where resources are declared at the device level,
> such as they can be referenced by name in the sub-nodes (basically what
> I did in this patch):
> 
> backlight {
>      compatible = "pwm-backlight";
>      ...
>      backlight-supply = <&backlight_reg>;
> 
>      power-on-sequence {
>          step@0 {
>              regulator = "backlight";
>              enable;
>          };
> 
> This would translate by a get_regulator(dev, "backlight") in the code
> which would be properly resolved.

Yes, upon reflection, that scheme does make sense. I withdraw the
comments I made re: whether it'd be better to just stick the phandles
into the steps.
