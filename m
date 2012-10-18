Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755239Ab2JRXOv (ORCPT <rfc822;w@1wt.eu>);
	Thu, 18 Oct 2012 19:14:51 -0400
Received: from ogre.sisk.pl ([193.178.161.156]:53652 "EHLO ogre.sisk.pl"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754577Ab2JRXOt (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 18 Oct 2012 19:14:49 -0400
From: "Rafael J. Wysocki" <rjw@sisk.pl>
To: Nishanth Menon <nm@ti.com>
Cc: Kevin Hilman <khilman@deeprootsystems.com>, linux-pm@vger.kernel.org,
        MyungJoo Ham <myungjoo.ham@samsung.com>,
        Kyungmin Park <kyungmin.park@samsung.com>,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH] PM / OPP: predictable fail results for opp_find* functions
Date: Fri, 19 Oct 2012 01:18:34 +0200
Message-ID: <2693710.XDXEuG0qLO@vostro.rjw.lan>
User-Agent: KMail/4.8.5 (Linux/3.6.2-6-desktop; KDE/4.8.5; x86_64; ; )
In-Reply-To: <87obk0kapt.fsf@deeprootsystems.com>
References: <1349962803-19674-1-git-send-email-nm@ti.com> <87obk0kapt.fsf@deeprootsystems.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 7Bit
Content-Type: text/plain; charset="utf-8"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wednesday 17 of October 2012 15:14:22 Kevin Hilman wrote:
> Nishanth Menon <nm@ti.com> writes:
> 
> > Currently the opp_find* functions return -ENODEV when:
> > a) it cant find a device (e.g. request for an OPP search on device
> >    which was not registered)
> > b) When it cant find a match for the search strategy used
> >
> > This makes life a little in-efficient for users such as devfreq
> > to make reasonable judgement before switching search strategies.
> >
> > So, standardize the return results as following:
> >  -EINVAL for bad pointer parameters
> >  -ENODEV when device cannot be found
> >  -ERANGE when search fails
> >
> > This has the following benefit for devfreq implementation:
> >
> > Current code:
> > opp = opp_find_freq_floor(dev, freq);
> > /* Following search triggers even for un-registered device */
> > if (opp == ERR_PTR(-ENODEV))
> > 	opp = opp_find_freq_ceil(dev, freq);
> >
> > Vs (after this change):
> > opp = opp_find_freq_floor(dev, freq);
> > /* Will only be triggered if search logic fails: intended usage */
> > if (opp == ERR_PTR(-ERANGE))
> > 	opp = opp_find_freq_ceil(dev, freq);
> 
> I think the idea is fine but would prefer to see the benefits summarized
> in words, rather than code.
> 
> Also, the changelog should describe that the patch not only changes the
> meaning of return values, but also converts devfreq to use the new
> values.
> 
> Otherwise, implementation looks fine.
> 
> Reviewed-by: Kevin Hilman <khilman@ti.com>

Can you please update the patch as requested by Kevin?

Thanks,
Rafael


-- 
I speak only for myself.
Rafael J. Wysocki, Intel Open Source Technology Center.
