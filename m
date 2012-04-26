Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755500Ab2DZIyX (ORCPT <rfc822;w@1wt.eu>);
	Thu, 26 Apr 2012 04:54:23 -0400
Received: from mail-gy0-f174.google.com ([209.85.160.174]:35133 "EHLO
	mail-gy0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755219Ab2DZIyW (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 26 Apr 2012 04:54:22 -0400
MIME-Version: 1.0
Date: Thu, 26 Apr 2012 10:47:03 +0200
Message-ID: <CACRpkdZm0-sxmzUsHSiQUEDp71Nw=dsoaWCyP3yTUKwxkW53Fw@mail.gmail.com>
Subject: Some kerneldoc:s maybe?
From: Linus Walleij <linus.walleij@linaro.org>
To: Stephen Warren <swarren@wwwdotorg.org>
Cc: linux-kernel@vger.kernel.org
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Stephen,

could you have a look at this from <linux/pinctrl.h>:

/**
 * struct pinctrl_ops - global pin control operations, to be implemented by
 * pin controller drivers.
 * @get_groups_count: Returns the count of total number of groups registered.
 * @get_group_name: return the group name of the pin group
 * @get_group_pins: return an array of pins corresponding to a certain
 *      group selector @pins, and the size of the array in @num_pins
 * @pin_dbg_show: optional debugfs display hook that will provide per-device
 *      info for a certain pin in debugfs
 */
struct pinctrl_ops {
        int (*get_groups_count) (struct pinctrl_dev *pctldev);
        const char *(*get_group_name) (struct pinctrl_dev *pctldev,
                                       unsigned selector);
        int (*get_group_pins) (struct pinctrl_dev *pctldev,
                               unsigned selector,
                               const unsigned **pins,
                               unsigned *num_pins);
        void (*pin_dbg_show) (struct pinctrl_dev *pctldev, struct seq_file *s,
                          unsigned offset);
        int (*dt_node_to_map) (struct pinctrl_dev *pctldev,
                               struct device_node *np_config,
                               struct pinctrl_map **map, unsigned *num_maps);
        void (*dt_free_map) (struct pinctrl_dev *pctldev,
                             struct pinctrl_map *map, unsigned num_maps);
};

I'm missing kerneldoc for dt_node_to_map() and dt_free_map(), could
you file a patch with some doc? I think you're the only in-kernel user
and wrote them so you'd know what to put there.

Would be much appreaciated.

Yours,
Linus Walleij
