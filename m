Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753562Ab1HSMeJ (ORCPT <rfc822;w@1wt.eu>);
	Fri, 19 Aug 2011 08:34:09 -0400
Received: from mail-qy0-f174.google.com ([209.85.216.174]:57338 "EHLO
	mail-qy0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753252Ab1HSMeF convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 19 Aug 2011 08:34:05 -0400
MIME-Version: 1.0
In-Reply-To: <BANLkTikFLbU70uJO0yrf8HipcVEwbUHgsw@mail.gmail.com>
References: <1307984291-9774-1-git-send-email-linus.walleij@stericsson.com>
	<74CDBE0F657A3D45AFBB94109FB122FF04992C02AC@HQMAIL01.nvidia.com>
	<BANLkTinNmPVEM4Eu4efxkuwrCU_FVWFaAg@mail.gmail.com>
	<74CDBE0F657A3D45AFBB94109FB122FF04992C049D@HQMAIL01.nvidia.com>
	<BANLkTikFLbU70uJO0yrf8HipcVEwbUHgsw@mail.gmail.com>
Date: Fri, 19 Aug 2011 14:34:04 +0200
Message-ID: <CACRpkdbYvO4LfdTNGm3DJXKTKzS1_8cOXeqWfP3-yUikuxXTTA@mail.gmail.com>
Subject: Re: [PATCH 1/2] drivers: create a pinmux subsystem v3
From: Linus Walleij <linus.walleij@linaro.org>
To: Stephen Warren <swarren@nvidia.com>
Cc: Linus Walleij <linus.walleij@stericsson.com>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "linux-arm-kernel@lists.infradead.org" 
	<linux-arm-kernel@lists.infradead.org>,
        Grant Likely <grant.likely@secretlab.ca>,
        Lee Jones <lee.jones@linaro.org>, Joe Perches <joe@perches.com>,
        Russell King <linux@arm.linux.org.uk>,
        Linaro Dev <linaro-dev@lists.linaro.org>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Jun 16, 2011 at 2:47 PM, Linus Walleij <linus.walleij@linaro.org> wrote:

> So to summarize there are two related areas of discussion
> here:
>
> 1. Whether a pinmux map shall map one or 1..N functions
> 2. How to handle per-driver instance namespacing of functions
>
> In both cases I'm currently using simple strings and claiming
> that by namespacing these strings cleverly we can avoid
> complexity. So my answer to these are:
>
> 1. Use several functions with ovelapping maps, just name
>  them differently
> 2. Use a string convention and namespace by using
>  platform/machine/package data and string conventions
>  such as a "::" separator
>
> While I *think* (and DO correct me!) that you would argue:
>
> 1. Make it possible to map several functions to a single
>  device map
> 2. Namespace device instances by different map field
>  members referring to specific instances
>
> Is this correctly understood, even if we may not agree?

I have now after being massaged by Grant changed opinion
on (2) and each pin controller (e.g. pinmux) instance has it's
struct device * or pinctrl_dev_name field in the mapping
table, so I hope you will find that part solved in an acceptable
way in the v4 patch set. So we'd solved 50% of our
disagreements.

(Please verify!)

So remains (1). I hope you will ACK the patch set if I fix
this also...

I'm thinking about good ways to solve it, reading through
your old mails, new suggestions based on the new patch
set are welcome.

Thanks,
Linus Walleij
