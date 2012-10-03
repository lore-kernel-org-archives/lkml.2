Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755525Ab2JCLGv (ORCPT <rfc822;w@1wt.eu>);
	Wed, 3 Oct 2012 07:06:51 -0400
Received: from opensource.wolfsonmicro.com ([80.75.67.52]:49883 "EHLO
	opensource.wolfsonmicro.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1750773Ab2JCLGu (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 3 Oct 2012 07:06:50 -0400
Date: Wed, 3 Oct 2012 12:06:47 +0100
From: Mark Brown <broonie@opensource.wolfsonmicro.com>
To: Paul Bolle <pebolle@tiscali.nl>
Cc: Valdis.Kletnieks@vt.edu, Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH] regmap: silence GCC warning
Message-ID: <20121003110646.GD4360@opensource.wolfsonmicro.com>
References: <1349000155.1553.27.camel@x61.thuisdomein>
 <20121001100321.GB4360@opensource.wolfsonmicro.com>
 <64681.1349223065@turing-police.cc.vt.edu>
 <1349249016.1414.55.camel@x61.thuisdomein>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1349249016.1414.55.camel@x61.thuisdomein>
X-Cookie: You look tired.
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Oct 03, 2012 at 09:23:36AM +0200, Paul Bolle wrote:
> On Tue, 2012-10-02 at 20:11 -0400, Valdis.Kletnieks@vt.edu wrote:
> > On Mon, 01 Oct 2012 11:03:21 +0100, Mark Brown said:

> > > > That implies that 'ret' will be set in the if-branch. ('val_count' could
> > > > be zero if 'val_len' is, for example, zero. That would be useless input,
> > > > however.)

> > But gcc doesn't know what "useless input" means, semantically.

> Correct. When this function is compiled gcc has to take into account
> that 'val_len' will be called with useless input, like zero.

> By the way, GCC doesn't warn if I add an early check whether 'val_count'
> is non-zero:

That's a much more useful fix, bodging things by just forcing things to
be assigned (especially with the way you were converting the immediate
returns) is generally terrible - it's just shutting up the errors
without actually fixing any issues that really exist and means that if
the compiler ever notices actual issues we won't see them.
