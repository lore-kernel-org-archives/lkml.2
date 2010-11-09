Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753780Ab0KITTO (ORCPT <rfc822;w@1wt.eu>);
	Tue, 9 Nov 2010 14:19:14 -0500
Received: from smtp.outflux.net ([198.145.64.163]:59707 "EHLO smtp.outflux.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753431Ab0KITTM (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 9 Nov 2010 14:19:12 -0500
Date: Tue, 9 Nov 2010 11:19:08 -0800
From: Kees Cook <kees.cook@canonical.com>
To: Pekka Enberg <penberg@kernel.org>
Cc: x86@kernel.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH 3/4] x86: call verify_cpu during 32bit CPU startup
Message-ID: <20101109191908.GO5876@outflux.net>
References: <20101109181157.GE5876@outflux.net>
 <20101109181525.GH5876@outflux.net>
 <AANLkTimzAaj1Z-jyCLBPKGzp_PWw2hwkYy_XeLo8CKPP@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <AANLkTimzAaj1Z-jyCLBPKGzp_PWw2hwkYy_XeLo8CKPP@mail.gmail.com>
Organization: Canonical
X-HELO: www.outflux.net
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Nov 09, 2010 at 09:09:18PM +0200, Pekka Enberg wrote:
> On Tue, Nov 9, 2010 at 8:15 PM, Kees Cook <kees.cook@canonical.com> wrote:
> > The XD_DISABLE-clearing side-effect needs to happen on 32bit CPU
> > start-up as well.
> >
> > Signed-off-by: Kees Cook <kees.cook@canonical.com>
> 
> The patch description here is pretty damn terse. Why do we need the
> clearing for? Does not clearing XD_DISABLE cause some problem?

The clearing needs to happen for both 32bit and 64bit, but the 32bit init
routines were not calling verify_cpu() yet. This adds that path to gain the
side-effect. (See patch 0 for why clearing XD_DISABLE is important.)

-- 
Kees Cook
Ubuntu Security Team
