Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756367Ab2FHAJE (ORCPT <rfc822;w@1wt.eu>);
	Thu, 7 Jun 2012 20:09:04 -0400
Received: from mail-ob0-f174.google.com ([209.85.214.174]:58474 "EHLO
	mail-ob0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754762Ab2FHAJC convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 7 Jun 2012 20:09:02 -0400
MIME-Version: 1.0
Reply-To: axel.lin@gmail.com
In-Reply-To: <1339052552.5882.3.camel@phoenix>
References: <1339052505.5882.2.camel@phoenix> <1339052552.5882.3.camel@phoenix>
From: Axel Lin <axel.lin@gmail.com>
Date: Fri, 8 Jun 2012 08:08:41 +0800
Message-ID: <CAF+7xWnXw0UU+wc7fsoERi+YFn-p_rSrpzZS5uyDXPQWSfjLGA@mail.gmail.com>
Subject: Re: [PATCH RFC RESEND 2/3] regulator: isl6271a: Use
 regulator_[list|map]_voltage_linear for isl_fixed_ops
To: linux-kernel@vger.kernel.org
Cc: Marek Vasut <marek.vasut@gmail.com>, Liam Girdwood <lrg@ti.com>,
        Mark Brown <broonie@opensource.wolfsonmicro.com>,
        Eric Miao <eric.y.miao@gmail.com>, Mike Rapoport <mike@compulab.co.il>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

>
>  static struct regulator_ops isl_fixed_ops = {
>        .get_voltage    = isl6271a_get_fixed_voltage,
> -       .list_voltage   = isl6271a_list_fixed_voltage,
> +       .list_voltage   = regulator_list_voltage_linear,
> +       .map_voltage    = regulator_map_voltage_linear,
>  };

Oh. isl_fixed_ops does not implement set_voltage_sel callback, adding
map_voltage here
seems misleading. I'll send a v2 soon.
