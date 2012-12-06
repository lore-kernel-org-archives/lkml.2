Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754666Ab2LFHCZ (ORCPT <rfc822;w@1wt.eu>);
	Thu, 6 Dec 2012 02:02:25 -0500
Received: from mail-qa0-f53.google.com ([209.85.216.53]:64203 "EHLO
	mail-qa0-f53.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752361Ab2LFHCZ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 6 Dec 2012 02:02:25 -0500
MIME-Version: 1.0
In-Reply-To: <20121206062836.GH10867@opensource.wolfsonmicro.com>
References: <CAM4voa=X_rBkSXRHd=oEOnXhgyfSAeD8LmYnsTeQtd-SYKWwPg@mail.gmail.com>
	<20121206062836.GH10867@opensource.wolfsonmicro.com>
Date: Thu, 6 Dec 2012 12:32:24 +0530
Message-ID: <CAM4voakrYQYrj2do0sYr_h0ZsRifAaLnDgeSxp6Z2e_F+_23uQ@mail.gmail.com>
Subject: Re: Regulator suspend state dt question
From: Abhilash Kesavan <kesavan.abhilash@gmail.com>
To: Mark Brown <broonie@opensource.wolfsonmicro.com>
Cc: devicetree-discuss@lists.ozlabs.org, linux-kernel@vger.kernel.org,
        grant.likely@secretlab.ca, lrg@ti.com,
        Doug Anderson <dianders@chromium.org>,
        Olof Johansson <olofj@google.com>,
        Thomas Abraham <thomas.abraham@linaro.org>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Mark,

On Thu, Dec 6, 2012 at 11:58 AM, Mark Brown
<broonie@opensource.wolfsonmicro.com> wrote:
> On Thu, Dec 06, 2012 at 11:55:11AM +0530, Abhilash Kesavan wrote:
>
>> As of now there is no support in the regulator core to specify the suspend state
>> (mode, enabled/disabled) using dt. I can add new properties specifying
>> the intial_state,
>> mode, enable/disable but I am not too sure if it is appropriate to add
>> such bindings to
>> the device tree as they are not actually describing the hardware.
>
> Well, it does depend on the hardware a bit - some hardware is hard wired
> to only have one possible suspend state due to power up requirements.
> But for a lot of hardware it's flexible...
So, adding such new properties to the drivers/regulator/of_regulator.c
file would
not be acceptable right ?
>
>> Is calling regulator_suspend_prepare from a machine specific file an option ?
>
> This is not really relevant, it's an orthogonal thing about when we
> trigger the state transition in the regulator.
OK
>
> It's not clear what a good solution is here, sorry.
Would it be acceptable that I add a new optional "op_mode" property
for max77686 ?
If the property is found in dt then assign the value to
max77686->opmode[i] else use
enable_mask. I'll be doing this in probe for all the regulators.

Thanks for your help.

Abhilash
