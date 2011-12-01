Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753809Ab1LARQf (ORCPT <rfc822;w@1wt.eu>);
	Thu, 1 Dec 2011 12:16:35 -0500
Received: from hqemgate03.nvidia.com ([216.228.121.140]:14199 "EHLO
	hqemgate03.nvidia.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750732Ab1LARQd convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 1 Dec 2011 12:16:33 -0500
X-PGP-Universal: processed;
	by hqnvupgp08.nvidia.com on Thu, 01 Dec 2011 09:16:28 -0800
From: Stephen Warren <swarren@nvidia.com>
To: Linus Walleij <linus.walleij@linaro.org>
CC: Linus Walleij <linus.walleij@stericsson.com>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        Grant Likely <grant.likely@secretlab.ca>,
        Barry Song <21cnbao@gmail.com>, Shawn Guo <shawn.guo@freescale.com>,
        Thomas Abraham <thomas.abraham@linaro.org>,
        Dong Aisheng <dong.aisheng@linaro.org>,
        Rajendra Nayak <rajendra.nayak@linaro.org>
Date: Thu, 1 Dec 2011 09:16:21 -0800
Subject: RE: [PATCH 2/2 v4] pinctrl: introduce generic pin config
Thread-Topic: [PATCH 2/2 v4] pinctrl: introduce generic pin config
Thread-Index: AcywEZ0lTXXIGypAQ9qZQGr915rWiQAOsYRw
Message-ID: <74CDBE0F657A3D45AFBB94109FB122FF174FDB01F2@HQMAIL01.nvidia.com>
References: <1322160380-27711-1-git-send-email-linus.walleij@stericsson.com>
	<74CDBE0F657A3D45AFBB94109FB122FF174FDAFF30@HQMAIL01.nvidia.com>
 <CACRpkdZueyZkOq20qq_jDn27cfkChM58cR+TvPKfifSwFwiQ5w@mail.gmail.com>
In-Reply-To: <CACRpkdZueyZkOq20qq_jDn27cfkChM58cR+TvPKfifSwFwiQ5w@mail.gmail.com>
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

Linus Walleij wrote at Thursday, December 01, 2011 3:12 AM:
> On Wed, Nov 30, 2011 at 8:45 PM, Stephen Warren <swarren@nvidia.com> wrote:
> > Linus Walleij wrote at Thursday, November 24, 2011 11:46 AM:
> 
> >> diff --git a/include/linux/pinctrl/pinconf-generic.h b/include/linux/pinctrl/pinconf-generic.h
> >
> >> +/*
> >> + * You shouldn't even be able to compile with these enums etc unless you're
> >> + * using generic pin config. That is why this is defined out.
> >> + */
> >> +#ifdef CONFIG_GENERIC_PINCONF
> >
> > Hmm. I'd prefer to have drivers able to use both generic values and
> > extend them with custom values. Can't we just use the top bit of the
> > param value to indicate 0:standard (from the enum below) 1:custom
> > (something meaningful to only the individual pinctrl driver). This
> > could then trigger calling pinconf_generic_dump_pin() or not for
> > example.
> 
> Hm...
> 
> That will get messy when if I refactor this stuff, add new enums
> and whatever.

I don't understand what'd be difficult about that.

New standardized enums could be added with values without the top bit
set. No existing driver would need modification, since their switch(param)
would not have a case for that new value, and would just return an error.

> >> +#ifdef CONFIG_GENERIC_PINCONF
> >> +     bool is_generic;
> >> +#endif
> >
> > ... and get rid of that flag.
> 
> This is for the case wher you have both generic and non-generic
> config controllers onboard a system.
> 
> Like in the generic debugfs dump function:
> 
> 	if (!ops->is_generic)
> 		return;
> 
> If I take this out, the generic debugfs code will be used for
> everything.

I think that'd be fine; the generic code would do all the debug prints
for the standardized enums, then the core would call into the pinctrl
driver to perform any additional debug prints for any driver-defined
custom parameters.

> And then the generic sematics which you didn't like in the
> previous patch:
> 
> if (ret == -EINVAL || ret == -ENOTSUPP)
> 
> Need to go back in, else the generic debugfs stuff won't
> work.

That'd be fine, provided the loop only checked the standardized parameters,
or only enabled that special error-checking case for standardized parameters.

-- 
nvpublic

