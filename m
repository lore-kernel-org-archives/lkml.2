Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1030453Ab2LGNo2 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 7 Dec 2012 08:44:28 -0500
Received: from mail-we0-f174.google.com ([74.125.82.174]:40859 "EHLO
	mail-we0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1030393Ab2LGNo1 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 7 Dec 2012 08:44:27 -0500
From: Grant Likely <grant.likely@secretlab.ca>
Subject: Re: [PATCH V5 2/2] mfd: stmpe: Update DT support in stmpe driver
To: Viresh Kumar <viresh.kumar@linaro.org>
Cc: Lee Jones <lee.jones@linaro.org>, Samuel Ortiz <sameo@linux.intel.com>,
        rabin.vincent@stericsson.com, shiraz.hashim@st.com,
        devicetree-discuss@lists.ozlabs.org, linux-kernel@vger.kernel.org,
        spear-devel@list.st.com, linus.walleij@linaro.org,
        Vipul Kumar Samar <vipulkumar.samar@st.com>
In-Reply-To: <CAKohponBkA+bg7B4TKaU6WbcVBNDHPe4AWqAEE6JGD7zctoULw@mail.gmail.com>
References: <2dcd7cb4c4022fa24b5328974e4226f5aaf89419.1354199865.git.viresh.kumar@linaro.org> <121653def4e985b0c1b59045637dd4518f97e73a.1354199865.git.viresh.kumar@linaro.org> <20121130105731.GN3176@sortiz-mobl> <20121130154542.GG23648@gmail.com> <CAKohpokLVEH+4F_VXh5auUm48cWWe0mumZME8yOCcAezcwJbCQ@mail.gmail.com> <20121205224203.691153E0E22@localhost> <CAKohponBkA+bg7B4TKaU6WbcVBNDHPe4AWqAEE6JGD7zctoULw@mail.gmail.com>
Date: Fri, 07 Dec 2012 13:44:22 +0000
Message-Id: <20121207134422.738A23E0B87@localhost>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 6 Dec 2012 08:06:20 +0530, Viresh Kumar <viresh.kumar@linaro.org> wrote:
> On 6 December 2012 04:12, Grant Likely <grant.likely@secretlab.ca> wrote:
> > On Sat, 1 Dec 2012 00:33:46 +0530, Viresh Kumar <viresh.kumar@linaro.org> wrote:
> >> This first tries to match the table my patch added, _BUT_ the string will
> >> never match as we had "st,stmpe810" in table and "stmpe810" in dev.
> >
> > of_driver_match_device() matches against the compatible list in
> > dev->of_node, not against the device name. So, if the compatible
> > property has a string that is in the table, then it really should match
> > against it.
> 
> Grant, but isn't it true that the final device's name would not be the DT
> way of names? It would simply be "stmpe810" for us and so if we have
> multiple instances of stmpe on a board, we need to distinguish them
> ourselves? One way for that was passing id for these instances, which
> would finally be used, when we create platform devices for sub-modules
> of stmpe (gpio, keypad, ts, etc).

of_modalias_node() is based on a *heruistic*. It is a best-effort
attempt to convert the node's compatible lists into a string that will
match against an existing driver. In the simple case it works because
historically i2c has used the chip name for the driver name. We get
lucky and a lot of drivers will work with DT without changes.

However, it is in no way guaranteed. Sometimes the strings won't line up
or a certain silicon vendor will have an extra errata or feature. In
that case it makes sense to use a DT match table that can parse the
entries in the compatible list. Or a driver can call of_ helper
functions. For example, it might call of_alias_get_id() to figure out
which device id it needs. That's why the full DT parsing exists. It's
the fallback when the simple heuristic fails. Only use it when you need
to.

g.
