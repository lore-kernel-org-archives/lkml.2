Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754232Ab2A0LAY (ORCPT <rfc822;w@1wt.eu>);
	Fri, 27 Jan 2012 06:00:24 -0500
Received: from mail-iy0-f174.google.com ([209.85.210.174]:50350 "EHLO
	mail-iy0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753607Ab2A0LAW (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 27 Jan 2012 06:00:22 -0500
MIME-Version: 1.0
X-Originating-IP: [93.173.166.112]
In-Reply-To: <20120127102608.GK19255@amd.com>
References: <1327603257-17028-1-git-send-email-joerg.roedel@amd.com>
 <1327603257-17028-3-git-send-email-joerg.roedel@amd.com> <CAK=WgbbZB0hGRr84JV4a7c0KvW7VbVzsnCx1PGg=wjoB0OSrYw@mail.gmail.com>
 <20120127102608.GK19255@amd.com>
From: Ohad Ben-Cohen <ohad@wizery.com>
Date: Fri, 27 Jan 2012 13:00:02 +0200
Message-ID: <CAK=WgbZQB+76FuJXK82x09CieDmF23zLQ8KbHbEtjnQsc_4axg@mail.gmail.com>
Subject: Re: [PATCH 2/6] iommu/amd: Implement DOMAIN_ATTR_GEOMETRY attribute
To: Joerg Roedel <joerg.roedel@amd.com>
Cc: iommu@lists.linux-foundation.org, linux-kernel@vger.kernel.org,
        David Woodhouse <dwmw2@infradead.org>,
        David Brown <davidb@codeaurora.org>, Tony Lindgren <tony@atomide.com>,
        Laurent Pinchart <laurent.pinchart@ideasonboard.com>,
        Stuart Yoder <b08248@gmail.com>, Scott Wood <scottwood@freescale.com>,
        Hiroshi Doyu <hdoyu@nvidia.com>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Jan 27, 2012 at 12:26 PM, Joerg Roedel <joerg.roedel@amd.com> wrote:
> I fell also uncomfortable with the missing type-safety of this
> interface. But the alternative is to have dedicated functions for
> set/get each attribute. Well, it depends on how many attributes we have
> in the end, but given that the PAMU guys already have need for a number
> of hardware specific attributes it is likely that having individual
> functions makes the api too complex in the end.
>
> But probably we can replace the 'void *data' with a 'union
> domain_attr'? This will give us some type-safety.
>

I was thinking that since the geometry concept is actually handled by
the core itself, it could probably have its own dedicated function.

Not sure how many other functions like that we might end up having
eventually, but I personally prefer the dedicated API over a single
multiplexer which is prone to error and (somewhat) harder to
debug/read.

Real vendor-specific attributes do probably justifies an all-catch
attribute API, I agree. Though we should probably try to minimize
them, and where possible, implement them in the core too, for the
benefit of everyone.

Thanks,
Ohad.
