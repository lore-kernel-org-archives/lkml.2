Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932808Ab1LFBSw (ORCPT <rfc822;w@1wt.eu>);
	Mon, 5 Dec 2011 20:18:52 -0500
Received: from na3sys009aog115.obsmtp.com ([74.125.149.238]:57126 "EHLO
	na3sys009aog115.obsmtp.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S932724Ab1LFBSu convert rfc822-to-8bit
	(ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 5 Dec 2011 20:18:50 -0500
MIME-Version: 1.0
In-Reply-To: <7fac345a60d692e55a6390bd3557b29d.squirrel@www.codeaurora.org>
References: <7fac345a60d692e55a6390bd3557b29d.squirrel@www.codeaurora.org>
From: "Menon, Nishanth" <nm@ti.com>
Date: Mon, 5 Dec 2011 19:18:28 -0600
Message-ID: <CAOMWX4f2ZtfiK35caboPdsq7a0hfn5vp282fE3OaKvK=xzrX8Q@mail.gmail.com>
Subject: Re: Extending OPP Functionality
To: khugans@codeaurora.org
Cc: linux-pm@vger.kernel.org, linux-kernel@vger.kernel.org,
        skannan@codeaurora.org, mattw@codeaurora.org, jchokshi@codeaurora.org,
        sboyd@codeaurora.org
Content-Type: text/plain; charset=windows-1252
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi,
On Mon, Dec 5, 2011 at 19:12, <khugans@codeaurora.org> wrote:
> We have a number of drivers that manage power/performance levels in their
> own ways and we are looking for a way to consolidate these similar
> implementations in one place.  We want to scale multiple voltage levels,
> clocks and bandwidth requests along with each other. For example our L2
> depends on two power rail voltages.
yes, most SoCs have independent voltage rails as well.

> We’ve observed that OPP tackles this for single voltage-frequency pair,
> but doesn’t manage additional data that may be associated with
> performance/power levels.  Would it make sense to extend OPP to handle
> implementation-specific data pointers to handle this generically?
Initial design of OPP library was to tackle the problem of having a generic
definition of an OPP. the wider question is do we want OPP library as purely
a data storage and retrieval entity or do we want to extend  the way devfreq
layer currently does forward and move regulators and others under OPP
library, my personal opinion of gluing that information should be in
higher levels
and not restrict based on what kind of framework is being used to represent
clock or voltage (not all SoCs might have regulator implementation for
voltage rails OR some might have extensions that are not completely scalable).

Just my 2 cents - but the extension by itself is trivial.

Regards,
Nishanth Menon
