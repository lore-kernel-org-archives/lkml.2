Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754224Ab0IPKl7 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 16 Sep 2010 06:41:59 -0400
Received: from opensource.wolfsonmicro.com ([80.75.67.52]:48070 "EHLO
	opensource2.wolfsonmicro.com" rhost-flags-OK-OK-OK-FAIL)
	by vger.kernel.org with ESMTP id S1752832Ab0IPKl5 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 16 Sep 2010 06:41:57 -0400
Date: Thu, 16 Sep 2010 11:41:55 +0100
From: Mark Brown <broonie@opensource.wolfsonmicro.com>
To: Andrew Morton <akpm@linux-foundation.org>
Cc: David Woodhouse <David.Woodhouse@intel.com>, linux-kernel@vger.kernel.org,
        patches@opensource.wolfsonmicro.com
Subject: Re: [PATCH] ihex: Add support for CS:IP/EIP records
Message-ID: <20100916104155.GB7837@rakim.wolfsonmicro.main>
References: <1284039626-30394-1-git-send-email-broonie@opensource.wolfsonmicro.com>
 <20100915142744.ee5bb928.akpm@linux-foundation.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20100915142744.ee5bb928.akpm@linux-foundation.org>
X-Cookie: Now I am depressed ...
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Sep 15, 2010 at 02:27:44PM -0700, Andrew Morton wrote:
> Mark Brown <broonie@opensource.wolfsonmicro.com> wrote:

> > +		data32 = &record->data[0];
> > +		*data32 = htonl(*data32);

> firmware/ihex2fw.c: In function 'process_ihex':
> firmware/ihex2fw.c:231: warning: assignment from incompatible pointer type

Which architecture are you using - my AMD64 system isn't noticing these
things for me?

> And afacit data[] isn't 32-bit aligned and I don't know that all
> architectures support htonl() against a misaligned pointer.

We're pretty much safe in userspace, if the hardware doesn't support it
then as far as I'm aware pretty much all OSs do a software fixup.  This
isn't great for performance but works.

> I'll drop the patch.

OK, I'll spin it later today.
