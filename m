Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752152Ab2KTIZH (ORCPT <rfc822;w@1wt.eu>);
	Tue, 20 Nov 2012 03:25:07 -0500
Received: from mail-ie0-f174.google.com ([209.85.223.174]:34030 "EHLO
	mail-ie0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751440Ab2KTIZG (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 20 Nov 2012 03:25:06 -0500
MIME-Version: 1.0
In-Reply-To: <1353399661.20110.4.camel@smile>
References: <0ee5b74534a09d75c14b22c2d9330c4971ab30fb.1353386646.git.viresh.kumar@linaro.org>
	<1353399661.20110.4.camel@smile>
Date: Tue, 20 Nov 2012 13:55:03 +0530
Message-ID: <CAKohpokkiawgUZvTKncj_15XC5BTsbi0s=WfxPwk6ci8VpqHAw@mail.gmail.com>
Subject: Re: [PATCH] dt: add helper function to read u8 & u16 variables & arrays
From: Viresh Kumar <viresh.kumar@linaro.org>
To: "Shevchenko, Andriy" <andriy.shevchenko@intel.com>
Cc: "rob.herring@calxeda.com" <rob.herring@calxeda.com>,
        "grant.likely@secretlab.ca" <grant.likely@secretlab.ca>,
        "spear-devel@list.st.com" <spear-devel@list.st.com>,
        "devicetree-discuss@lists.ozlabs.org" 
	<devicetree-discuss@lists.ozlabs.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "linaro-dev@lists.linaro.org" <linaro-dev@lists.linaro.org>,
        "patches@linaro.org" <patches@linaro.org>,
        "swarren@wwwdotorg.org" <swarren@wwwdotorg.org>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 20 November 2012 13:51, Shevchenko, Andriy
<andriy.shevchenko@intel.com> wrote:
> You could at least create macro to do a precheck if you want to.
>
> Like
> #define CHECK_PROP(prop, sz, out)
>
> {
> if (!prop)
>                 return -EINVAL;
>         if (!prop->value)
>                 return -ENODATA;
>         if ((sz * sizeof(*out)) > prop->length)
>                 return -EOVERFLOW;
> }

Hi Andriy,

Initially i started with a macro for the complete routine, but later as types
started to play important role in it, i have to split it to routines.

I thought of this idea to do prop check in a macro, but then i thought
it might cover a bigger range of files and so thought of doing that separately.
For, simplicity left it this time.

--
viresh
