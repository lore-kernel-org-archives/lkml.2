Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759621Ab2HJPRy (ORCPT <rfc822;w@1wt.eu>);
	Fri, 10 Aug 2012 11:17:54 -0400
Received: from avon.wwwdotorg.org ([70.85.31.133]:53495 "EHLO
	avon.wwwdotorg.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1758616Ab2HJPRx (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 10 Aug 2012 11:17:53 -0400
Message-ID: <5025261C.4070509@wwwdotorg.org>
Date: Fri, 10 Aug 2012 09:17:48 -0600
From: Stephen Warren <swarren@wwwdotorg.org>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:14.0) Gecko/20120714 Thunderbird/14.0
MIME-Version: 1.0
To: "devendra.aaru" <devendra.aaru@gmail.com>
CC: linux-kernel@vger.kernel.org, Linus Walleij <linus.walleij@linaro.org>
Subject: Re: Q: pinctrl: freeing out the allocated map in tegra_pinctrl_dt_node_to_map
References: <CAHdPZaOHNW3gBHFdfkg==mQVOTdoCKiURqt=J+bWPJn=_no4LQ@mail.gmail.com>
In-Reply-To: <CAHdPZaOHNW3gBHFdfkg==mQVOTdoCKiURqt=J+bWPJn=_no4LQ@mail.gmail.com>
X-Enigmail-Version: 1.5a1pre
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 08/09/2012 11:35 PM, devendra.aaru wrote:
> On Fri, Aug 10, 2012 at 11:02 AM, devendra.aaru <devendra.aaru@gmail.com> wrote:
>> Hi,
>>
>> In function tegra_pinctrl_dt_node_to_map the num_maps the num_maps
>> counter must be incremented for each child node?

This I commented on below.

>> Actually we are doing free until num_maps if tegra_pinctrl_dt_subnode_to_map,
>>
>> not only that if num_maps == 0, we wont free up the maps, and also i
>> think the for_each_of_node checks whether we have a next child node,
>> so its safe to do num_maps++ as it wont get incremented endlessly,
>>
>> Please correct me if i am wrong.

I don't quite understand this part, sorry.

>> Thanks,

>> @@ -303,6 +303,7 @@ int tegra_pinctrl_dt_node_to_map(struct
>> pinctrl_dev *pctldev,
>>         *num_maps = 0;
>>
>>         for_each_child_of_node(np_config, np) {
>> +               num_maps++;
>>                 ret = tegra_pinctrl_dt_subnode_to_map(pctldev->dev, np, map,
>>                                                       &reserved_maps, num_maps);

That's wrong; tegra_pinctrl_dt_subnode_to_map() calls add_map_mux()
and/or add_map_configs() which increments *num_maps.

Besides, num_maps is a pointer to an integer, so if this was right, it
should be (*num_maps)++.

