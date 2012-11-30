Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756251Ab2K3Iue (ORCPT <rfc822;w@1wt.eu>);
	Fri, 30 Nov 2012 03:50:34 -0500
Received: from ns.km20343-01.keymachine.de ([84.19.182.79]:48805 "EHLO
	km20343-01.keymachine.de" rhost-flags-OK-OK-OK-FAIL)
	by vger.kernel.org with ESMTP id S1755879Ab2K3Iub (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 30 Nov 2012 03:50:31 -0500
Message-ID: <1354265429.1479.187.camel@tellur>
Subject: Re: [RFC v2 1/8] video: tegra: Add nvhost driver
From: Lucas Stach <dev@lynxeye.de>
To: Stephen Warren <swarren@wwwdotorg.org>
Cc: Thierry Reding <thierry.reding@avionic-design.de>,
        Terje =?ISO-8859-1?Q?Bergstr=F6m?= <tbergstrom@nvidia.com>,
        "linux-tegra@vger.kernel.org" <linux-tegra@vger.kernel.org>,
        "dri-devel@lists.freedesktop.org" <dri-devel@lists.freedesktop.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Date: Fri, 30 Nov 2012 09:50:29 +0100
In-Reply-To: <50B7AB93.5060207@wwwdotorg.org>
References: <1353935954-13763-1-git-send-email-tbergstrom@nvidia.com>
	 <1353935954-13763-2-git-send-email-tbergstrom@nvidia.com>
	 <20121128212301.GA25531@avionic-0098.adnet.avionic-design.de>
	 <50B73710.2040102@nvidia.com>
	 <20121129114704.GB6150@avionic-0098.adnet.avionic-design.de>
	 <50B7AB93.5060207@wwwdotorg.org>
Content-Type: text/plain; charset="UTF-8"
X-Mailer: Evolution 3.4.4 (3.4.4-2.fc17) 
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Am Donnerstag, den 29.11.2012, 11:38 -0700 schrieb Stephen Warren:
> On 11/29/2012 04:47 AM, Thierry Reding wrote:
> > I agree. But I also fear that there will be changes eventually and 
> > having both go in via different tree requires those trees to be
> > merged in a specific order to avoid breakage should the API change.
> > This will be particularly ugly in linux-next.
> > 
> > That's why I explicitly proposed to take this into
> > drivers/gpu/drm/tegra for the time being, until we can be
> > reasonably sure that the API is fixed. Then I'm fine with moving it
> > wherever seems the best fit. Even then there might be the
> > occasional dependency, but they should get fewer and fewer as the
> > code matures.
> 
> It is acceptable for one maintainer to ack patches, and another
> maintainer to merge a series that touches both "their own" code and
> code owned by another tree. This should of course only be needed when
> inter-module APIs change; changes to code within a module shouldn't
> require this.
> 

I'm with Thierry here. I think there is a fair chance that we won't get
the API right from the start, even when trying to come up with something
that sounds sane to everyone. It's also not desirable to delay gr2d
going into mainline until we are all completely satisfied with the API.

I also fail to see how host1x module being in the DRM directory hinders
any downstream development. So I'm in favour of keeping host1x besides
the other DRM components to lower the burden for API changes and move it
out into some more generic directory, once we feel confident that the
API is reasonable stable.

Regards,
Lucas 

