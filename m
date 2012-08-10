Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753905Ab2HJFfK (ORCPT <rfc822;w@1wt.eu>);
	Fri, 10 Aug 2012 01:35:10 -0400
Received: from mail-pb0-f46.google.com ([209.85.160.46]:58579 "EHLO
	mail-pb0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753023Ab2HJFfH (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 10 Aug 2012 01:35:07 -0400
MIME-Version: 1.0
Date: Fri, 10 Aug 2012 11:05:06 +0530
Message-ID: <CAHdPZaOHNW3gBHFdfkg==mQVOTdoCKiURqt=J+bWPJn=_no4LQ@mail.gmail.com>
Subject: Q: pinctrl: freeing out the allocated map in tegra_pinctrl_dt_node_to_map
From: "devendra.aaru" <devendra.aaru@gmail.com>
To: linux-kernel@vger.kernel.org
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Aug 10, 2012 at 11:02 AM, devendra.aaru <devendra.aaru@gmail.com> wrote:
> Hi,
>
> In function tegra_pinctrl_dt_node_to_map the num_maps the num_maps
> counter must be incremented for each child node?
>
>
> Actually we are doing free until num_maps if tegra_pinctrl_dt_subnode_to_map,
>
> not only that if num_maps == 0, we wont free up the maps, and also i
> think the for_each_of_node checks whether we have a next child node,
> so its safe to do num_maps++ as it wont get incremented endlessly,
>
> Please correct me if i am wrong.
>
> Thanks,
>
>
> diff --git a/drivers/pinctrl/pinctrl-tegra.c b/drivers/pinctrl/pinctrl-tegra.c
> index ae52e4e..33ae918 100644
> --- a/drivers/pinctrl/pinctrl-tegra.c
> +++ b/drivers/pinctrl/pinctrl-tegra.c
> @@ -303,6 +303,7 @@ int tegra_pinctrl_dt_node_to_map(struct
> pinctrl_dev *pctldev,
>         *num_maps = 0;
>
>         for_each_child_of_node(np_config, np) {
> +               num_maps++;
>                 ret = tegra_pinctrl_dt_subnode_to_map(pctldev->dev, np, map,
>                                                       &reserved_maps, num_maps);
>                 if (ret < 0) {


Sorry all, I forgot to add the subject line.
