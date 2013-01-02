Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752683Ab3ABJoj (ORCPT <rfc822;w@1wt.eu>);
	Wed, 2 Jan 2013 04:44:39 -0500
Received: from mail1-relais-roc.national.inria.fr ([192.134.164.82]:3135 "EHLO
	mail1-relais-roc.national.inria.fr" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752422Ab3ABJog (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 2 Jan 2013 04:44:36 -0500
X-IronPort-AV: E=Sophos;i="4.84,394,1355094000"; 
   d="scan'208";a="188192289"
Date: Wed, 2 Jan 2013 10:44:32 +0100 (CET)
From: Julia Lawall <julia.lawall@lip6.fr>
X-X-Sender: jll@hadrien
To: Russell King - ARM Linux <linux@arm.linux.org.uk>
cc: Dan Carpenter <error27@gmail.com>,
        Sylwester Nawrocki <sylvester.nawrocki@gmail.com>,
        Tomasz Stanislawski <t.stanislaws@samsung.com>,
        Sergei Shtylyov <sshtylyov@mvista.com>,
        kernel-janitors@vger.kernel.org, linux-kernel@vger.kernel.org,
        Kyungmin Park <kyungmin.park@samsung.com>,
        linux-arm-kernel@lists.infradead.org, linux-media@vger.kernel.org
Subject: Re: [PATCH RESEND 6/6] clk: s5p-g2d: Fix incorrect usage of
 IS_ERR_OR_NULL
In-Reply-To: <20130102092638.GB2631@n2100.arm.linux.org.uk>
Message-ID: <alpine.DEB.2.02.1301021031490.1994@hadrien>
References: <1355852048-23188-1-git-send-email-linux@prisktech.co.nz> <1355852048-23188-7-git-send-email-linux@prisktech.co.nz> <50D62BC9.9010706@mvista.com> <50E32C06.5020104@gmail.com> <CA+_b7DK2zbBzbCh15ikEAeGP5h-V9gQ_YcX15O-RNvWxCk8Zfg@mail.gmail.com>
 <20130102092638.GB2631@n2100.arm.linux.org.uk>
User-Agent: Alpine 2.02 (DEB 1266 2009-07-14)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 2 Jan 2013, Russell King - ARM Linux wrote:

> On Wed, Jan 02, 2013 at 08:10:36AM +0300, Dan Carpenter wrote:
> > clk_get() returns NULL if CONFIG_HAVE_CLK is disabled.
> >
> > I told Tony about this but everyone has been gone with end of year
> > holidays so it hasn't been addressed.
> >
> > Tony, please fix it so people don't apply these patches until
> > clk_get() is updated to not return NULL.  It sucks to have to revert
> > patches.
>
> How about people stop using IS_ERR_OR_NULL for stuff which it shouldn't
> be used for?

Perhaps the cases where clk_get returns NULL could have a comment
indicating that NULL does not represent a failure?

In 3.7.1, it looks like it might have been possible for NULL to be
returned by clk_get in arch/mips/loongson1/common/clock.c, but that
definition seems to be gone in a recent linux-next.  The remaining
definitions look OK.

julia
