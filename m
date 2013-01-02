Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752655Ab3ABJ3v (ORCPT <rfc822;w@1wt.eu>);
	Wed, 2 Jan 2013 04:29:51 -0500
Received: from caramon.arm.linux.org.uk ([78.32.30.218]:38540 "EHLO
	caramon.arm.linux.org.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752351Ab3ABJ3t (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 2 Jan 2013 04:29:49 -0500
Date: Wed, 2 Jan 2013 09:28:54 +0000
From: Russell King - ARM Linux <linux@arm.linux.org.uk>
To: Julia Lawall <julia.lawall@lip6.fr>
Cc: Tony Prisk <linux@prisktech.co.nz>,
        Tomasz Stanislawski <t.stanislaws@samsung.com>,
        Dan Carpenter <error27@gmail.com>,
        Sergei Shtylyov <sshtylyov@mvista.com>,
        kernel-janitors@vger.kernel.org, linux-kernel@vger.kernel.org,
        Kyungmin Park <kyungmin.park@samsung.com>,
        Sylwester Nawrocki <sylvester.nawrocki@gmail.com>,
        linux-arm-kernel@lists.infradead.org, linux-media@vger.kernel.org
Subject: Re: [PATCH RESEND 6/6] clk: s5p-g2d: Fix incorrect usage of
	IS_ERR_OR_NULL
Message-ID: <20130102092854.GC2631@n2100.arm.linux.org.uk>
References: <1355852048-23188-1-git-send-email-linux@prisktech.co.nz> <1355852048-23188-7-git-send-email-linux@prisktech.co.nz> <50D62BC9.9010706@mvista.com> <50E32C06.5020104@gmail.com> <CA+_b7DK2zbBzbCh15ikEAeGP5h-V9gQ_YcX15O-RNvWxCk8Zfg@mail.gmail.com> <1357104713.30504.8.camel@gitbox> <alpine.DEB.2.02.1301020827040.2241@localhost6.localdomain6>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <alpine.DEB.2.02.1301020827040.2241@localhost6.localdomain6>
User-Agent: Mutt/1.5.19 (2009-01-05)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Jan 02, 2013 at 08:29:57AM +0100, Julia Lawall wrote:
> There are dereferences to the result of clk_get a few times.  I tried the 
> following semantic patch:

And those are buggy; struct clk is _SUPPOSED_ to be an OPAQUE COOKIE
and no one other than the clk code should be dereferencing it.

I guess this is the danger of the common clk API - we now have a struct
clk that is exposed in a linux/*.h include which anyone can include, and
now anyone can get a definition for a struct clk and dereference it,
destroying opaqueness of this cookie.
