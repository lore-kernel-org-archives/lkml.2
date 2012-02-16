Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756075Ab2BPXlg (ORCPT <rfc822;w@1wt.eu>);
	Thu, 16 Feb 2012 18:41:36 -0500
Received: from hqemgate04.nvidia.com ([216.228.121.35]:17606 "EHLO
	hqemgate04.nvidia.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752775Ab2BPXlf convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 16 Feb 2012 18:41:35 -0500
X-PGP-Universal: processed;
	by hqnvupgp07.nvidia.com on Thu, 16 Feb 2012 15:41:31 -0800
From: Stephen Warren <swarren@nvidia.com>
To: Linus Walleij <linus.walleij@linaro.org>
CC: Linus Walleij <linus.walleij@stericsson.com>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        Arnd Bergmann <arnd@arndb.de>
Date: Thu, 16 Feb 2012 15:41:29 -0800
Subject: RE: [PATCH] pinctrl: Store mapping table as a list of chunks
Thread-Topic: [PATCH] pinctrl: Store mapping table as a list of chunks
Thread-Index: Aczs5MoxWY2991mcQLW4/gLe6FV6PQAH2JDg
Message-ID: <74CDBE0F657A3D45AFBB94109FB122FF1790EC88A5@HQMAIL01.nvidia.com>
References: <1329339646-19472-1-git-send-email-swarren@nvidia.com>
 <CACRpkdZT+wYopQOJ5Ody1kCgVuxZTTCxq-Q6DLg-uF-FW8bX6w@mail.gmail.com>
In-Reply-To: <CACRpkdZT+wYopQOJ5Ody1kCgVuxZTTCxq-Q6DLg-uF-FW8bX6w@mail.gmail.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
acceptlanguage: en-US
Content-Type: text/plain; charset="iso-8859-1"
Content-Transfer-Encoding: 8BIT
MIME-Version: 1.0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Linus Walleij wrote at Thursday, February 16, 2012 12:54 PM:
> On Wed, Feb 15, 2012 at 10:00 PM, Stephen Warren <swarren@nvidia.com> wrote:
> > arch/arm/mach-u300/core.c:
> > -static struct pinctrl_map __initdata u300_pinmux_map[] = {
> > +static struct pinctrl_map u300_pinmux_map[] = {
> 
> This was actually not tagged __initdata until last merge window.
> 
> The reason it was made discardable was for platform that needed
> to discard a large number of mappings after boot, since only a few
> of them got registered from the board files.

Ah right, yes I see that makes sense. I'll revert that and add back the
copy.

> (Yes, I know this will not be a problem in device tree configs...)

I'll create a helper function that doesn't do the copy for the DT case.

> Can we combine the best of two worlds by still making a
> shallow copy (like previously) and put that shallow copy into the
> list instead?
> 
> > +#define for_each_maps(_maps_node_, _i_, _map_) \
> > +       list_for_each_entry(_maps_node_, &pinctrl_maps, node) \
> > +               for (_i_ = 0, _map_ = &_maps_node_->maps[_i_]; \
> > +                       _i_ < _maps_node_->num_maps; \
> > +                       i++, _map_ = &_maps_node_->maps[_i_])
> 
> I really like this macro.

Checkpatch doesn't :-( but I think it's OK to ignore it in this case.

-- 
nvpublic

