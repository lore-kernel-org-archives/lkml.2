Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760164Ab2HJKti (ORCPT <rfc822;w@1wt.eu>);
	Fri, 10 Aug 2012 06:49:38 -0400
Received: from esgaroth.petrovitsch.at ([78.47.184.11]:4799 "EHLO
	esgaroth.petrovitsch.priv.at" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1755209Ab2HJKtf (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 10 Aug 2012 06:49:35 -0400
Subject: Re:
From: Bernd Petrovitsch <bernd@petrovitsch.priv.at>
To: "devendra.aaru" <devendra.aaru@gmail.com>
Cc: linux-kernel@vger.kernel.org, Linus Walleij <linus.walleij@linaro.org>
Date: Fri, 10 Aug 2012 12:47:28 +0200
In-Reply-To: <CAHdPZaM=Pytu3a1cm+FK=bGARZ8iZz3vaVZmtiBU6SFc5VfL3Q@mail.gmail.com>
References: <CAHdPZaM=Pytu3a1cm+FK=bGARZ8iZz3vaVZmtiBU6SFc5VfL3Q@mail.gmail.com>
Content-Type: text/plain; charset="UTF-8"
X-Mailer: Evolution 3.0.3 (3.0.3-1.fc15) 
Content-Transfer-Encoding: 7bit
Message-ID: <1344595650.3975.13.camel@thorin>
Mime-Version: 1.0
X-DCC-URT-Metrics: esgaroth.petrovitsch.priv.at; whitelist
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi!

On Fre, 2012-08-10 at 11:02 +0530, devendra.aaru wrote:
[...]
> In function tegra_pinctrl_dt_node_to_map the num_maps the num_maps
> counter must be incremented for each child node?
>
> Actually we are doing free until num_maps if tegra_pinctrl_dt_subnode_to_map,
> 
> not only that if num_maps == 0, we wont free up the maps, and also i
> think the for_each_of_node checks whether we have a next child node,
> so its safe to do num_maps++ as it wont get incremented endlessly,
[...]

Not that I looked into the source but ....

> diff --git a/drivers/pinctrl/pinctrl-tegra.c b/drivers/pinctrl/pinctrl-tegra.c
> index ae52e4e..33ae918 100644
> --- a/drivers/pinctrl/pinctrl-tegra.c
> +++ b/drivers/pinctrl/pinctrl-tegra.c
> @@ -303,6 +303,7 @@ int tegra_pinctrl_dt_node_to_map(struct
> pinctrl_dev *pctldev,
... num_maps appears to be a pointer to the counter here and ...
>         *num_maps = 0;
> 
>         for_each_child_of_node(np_config, np) {
... here you increment the pointer as such and where it points to (which
appears to be the counter).
> +               num_maps++;
>                 ret = tegra_pinctrl_dt_subnode_to_map(pctldev->dev, np, map,
>                                                       &reserved_maps, num_maps);
>                 if (ret < 0) {

Kinf regards,
	Bernd
-- 
Bernd Petrovitsch                  Email : bernd@petrovitsch.priv.at
                     LUGA : http://www.luga.at

