Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753002Ab2A1Uoo (ORCPT <rfc822;w@1wt.eu>);
	Sat, 28 Jan 2012 15:44:44 -0500
Received: from mail-iy0-f174.google.com ([209.85.210.174]:50436 "EHLO
	mail-iy0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752054Ab2A1Uon (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 28 Jan 2012 15:44:43 -0500
MIME-Version: 1.0
X-Originating-IP: [93.173.166.112]
In-Reply-To: <20120127130329.GM19255@amd.com>
References: <1327603257-17028-1-git-send-email-joerg.roedel@amd.com>
 <1327603257-17028-3-git-send-email-joerg.roedel@amd.com> <CAK=WgbbZB0hGRr84JV4a7c0KvW7VbVzsnCx1PGg=wjoB0OSrYw@mail.gmail.com>
 <20120127102608.GK19255@amd.com> <CAK=WgbZQB+76FuJXK82x09CieDmF23zLQ8KbHbEtjnQsc_4axg@mail.gmail.com>
 <20120127130329.GM19255@amd.com>
From: Ohad Ben-Cohen <ohad@wizery.com>
Date: Sat, 28 Jan 2012 22:44:22 +0200
Message-ID: <CAK=WgbY+aBwTno4YxGLaxS7Y-R=CS1604+c5j-6EMQSfJeGvTA@mail.gmail.com>
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

On Fri, Jan 27, 2012 at 3:03 PM, Joerg Roedel <joerg.roedel@amd.com> wrote:
> Note that only the read-side is handled by the core. An IOMMU driver may
> decide to implement a write-side for the geometry which would be not in
> the core then. Having a dedicated function for the write-side does not
> make sense because (for now) there is only one upcoming driver requiring
> this.

I'd still go with a type-safe interface here, but maybe it's only me.

> I think dedicated functions also make the API harder to use because a
> developer first needs to find out if a property is read/written by a
> dedicated function or the set/get-attr interface.

I'm not so sure how would drivers use these "hardware-specific api
attr extensions" in general.

Is the intention that only hardware-specific drivers will use them ? I
guess that generic drivers won't be able to use them, because their
behavior will not be well-defined across all hardware implementations.

Thanks,
Ohad.
