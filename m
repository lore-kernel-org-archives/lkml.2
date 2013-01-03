Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753231Ab3ACKAa (ORCPT <rfc822;w@1wt.eu>);
	Thu, 3 Jan 2013 05:00:30 -0500
Received: from caramon.arm.linux.org.uk ([78.32.30.218]:39117 "EHLO
	caramon.arm.linux.org.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753046Ab3ACKA1 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 3 Jan 2013 05:00:27 -0500
Date: Thu, 3 Jan 2013 10:00:01 +0000
From: Russell King - ARM Linux <linux@arm.linux.org.uk>
To: Dan Carpenter <dan.carpenter@oracle.com>
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
Message-ID: <20130103100000.GJ2631@n2100.arm.linux.org.uk>
References: <1355852048-23188-1-git-send-email-linux@prisktech.co.nz> <1355852048-23188-7-git-send-email-linux@prisktech.co.nz> <50D62BC9.9010706@mvista.com> <50E32C06.5020104@gmail.com> <CA+_b7DK2zbBzbCh15ikEAeGP5h-V9gQ_YcX15O-RNvWxCk8Zfg@mail.gmail.com> <1357104713.30504.8.camel@gitbox> <20130103090520.GC7247@mwanda>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20130103090520.GC7247@mwanda>
User-Agent: Mutt/1.5.19 (2009-01-05)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Jan 03, 2013 at 12:05:20PM +0300, Dan Carpenter wrote:
> On Wed, Jan 02, 2013 at 06:31:53PM +1300, Tony Prisk wrote:
> > Why should a _consumer_ of a clock care?  It is _very_ important that
> > people get this idea - to a consumer, the struct clk is just an opaque
> > cookie.  The fact that it appears to be a pointer does _not_ mean that
> > the driver can do any kind of dereferencing on that pointer - it should
> > never do so.
> > 
> > Thread can be viewed here:
> > https://lkml.org/lkml/2012/12/20/105
> > 
> 
> Ah.  Grand.  Thanks...
> 
> Btw. The documentation for clk_get() really should include some of
> this information.

It *does* contain this information.  The problem is that driver authors
_ARE_ stupid, lazy morons who don't bother to read documentation.

/**
 * clk_get - lookup and obtain a reference to a clock producer.
 * @dev: device for clock "consumer"
 * @id: clock consumer ID
 *
 * Returns a struct clk corresponding to the clock producer, or
 * valid IS_ERR() condition containing errno.  The implementation
 * uses @dev and @id to determine the clock consumer, and thereby
 * the clock producer.  (IOW, @id may be identical strings, but
 * clk_get may return different clock producers depending on @dev.)
 *
 * Drivers must assume that the clock source is not enabled.
 *
 * clk_get should not be called from within interrupt context.
 */

