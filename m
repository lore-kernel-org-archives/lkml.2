Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S934060Ab1ETCNz (ORCPT <rfc822;w@1wt.eu>);
	Thu, 19 May 2011 22:13:55 -0400
Received: from gate.crashing.org ([63.228.1.57]:60118 "EHLO gate.crashing.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754851Ab1ETCNy (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 19 May 2011 22:13:54 -0400
Subject: Re: [bg-linux] [PATCH 5/7] [RFC] force 32-byte aligned kmallocs
From: Benjamin Herrenschmidt <benh@kernel.crashing.org>
To: Kazutomo Yoshii <kazutomo.yoshii@gmail.com>
Cc: Eric Van Hensbergen <ericvh@gmail.com>, linuxppc-dev@lists.ozlabs.org,
        linux-kernel@vger.kernel.org, bg-linux@lists.anl-external.org
In-Reply-To: <1305857301.7481.121.camel@pasglop>
References: <1305753895-24845-1-git-send-email-ericvh@gmail.com>
	 <1305753895-24845-5-git-send-email-ericvh@gmail.com>
	 <1305851769.7481.90.camel@pasglop>  <4DD5C49E.4050103@gmail.com>
	 <1305857301.7481.121.camel@pasglop>
Content-Type: text/plain; charset="UTF-8"
Date: Fri, 20 May 2011 12:13:30 +1000
Message-ID: <1305857610.7481.124.camel@pasglop>
Mime-Version: 1.0
X-Mailer: Evolution 2.30.3 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, 2011-05-20 at 12:08 +1000, Benjamin Herrenschmidt wrote:
> On Thu, 2011-05-19 at 20:32 -0500, Kazutomo Yoshii wrote:
> > 
> > Actually DMA sends invalidate requests to the snoop unit(L2 level).
> > BGP SoC is a bit different from other 4xx base. 
> 
> Well, some other 44x also have a snooping L2 (more or less), but L1 is
> usually the problem.

Hrm... looking at the doco you pointed me to, it looks like the L1 -is-
coherent, it gets snoop kills from the L2.

Ok so we do need to make this non-coherent cache stuff a runtime option
(well, we need that for 440+476 too anyways so may as well do it now).

As for the alignment of kmalloc, it looks like a hack that should be
done in the torus code itself.

Cheers,
Ben.

