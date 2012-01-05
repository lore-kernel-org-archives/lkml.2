Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757334Ab2AEBez (ORCPT <rfc822;w@1wt.eu>);
	Wed, 4 Jan 2012 20:34:55 -0500
Received: from ozlabs.org ([203.10.76.45]:53243 "EHLO ozlabs.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751190Ab2AEBey (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 4 Jan 2012 20:34:54 -0500
From: Rusty Russell <rusty@rustcorp.com.au>
To: Tomi Valkeinen <tomi.valkeinen@ti.com>
Cc: lkml - Kernel Mailing List <linux-kernel@vger.kernel.org>,
        Pawel Moll <pawel.moll@arm.com>
Subject: Re: [PATCH 12/15] module_param: make bool parameters really bool (drivers & misc)
In-Reply-To: <1325661138.1875.6.camel@deskari>
References: <87ehw6sesk.fsf@rustcorp.com.au> <1325661138.1875.6.camel@deskari>
User-Agent: Notmuch/0.6.1-1 (http://notmuchmail.org) Emacs/23.3.1 (i686-pc-linux-gnu)
Date: Thu, 05 Jan 2012 10:33:53 +1030
Message-ID: <874nwbc8wm.fsf@rustcorp.com.au>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 04 Jan 2012 09:12:18 +0200, Tomi Valkeinen <tomi.valkeinen@ti.com> wrote:
Non-text part: multipart/signed
> Hi,
> 
> On Thu, 2011-12-15 at 13:48 +1030, Rusty Russell wrote:
> > module_param(bool) used to counter-intuitively take an int.  In
> > fddd5201 (mid-2009) we allowed bool or int/unsigned int using a messy
> > trick.
> > 
> > It's time to remove the int/unsigned int option.  For this version
> > it'll simply give a warning, but it'll break next kernel version.
> > 
> > Signed-off-by: Rusty Russell <rusty@rustcorp.com.au>
> 
> The changes below break compilation for omapdss and omapfb: dss_debug
> and omapfb_debug are declared in dss.h and omapfb.h, and those
> declarations are not changed, resulting in conflicting types error.
> 
> Perhaps extra care should be taken in cases where the variable in
> question is not declared as static.

Yes, after the first few hours I got lazy.  Obviously, linux-next
doesn't build with CONFIG_OMAP2_DSS_DEBUG_SUPPORT (or may not build OSS2
at all), so it didn't catch them either.

I've fixed it (probably tomorrow's linux-next), but hope that the
introduction of a 'bool' in that header doesn't break anything else.

Please post fix if it does.  Though I think the new hotness is dev_debug
and dynamic debugging.

Thanks!
Rusty.
