Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753197Ab1BLWIi (ORCPT <rfc822;w@1wt.eu>);
	Sat, 12 Feb 2011 17:08:38 -0500
Received: from smtp.outflux.net ([198.145.64.163]:53058 "EHLO smtp.outflux.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753058Ab1BLWIb (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sat, 12 Feb 2011 17:08:31 -0500
Date: Sat, 12 Feb 2011 14:08:26 -0800
From: Kees Cook <kees.cook@canonical.com>
To: Corbin Simpson <mostawesomedude@gmail.com>
Cc: linux-kernel@vger.kernel.org, Dan Rosenberg <drosenberg@vsecurity.com>,
        Eugene Teo <eugeneteo@kernel.org>, dri-devel@lists.freedesktop.org
Subject: Re: [PATCH] drm: do not leak kernel addresses via /proc/dri/*/vma
Message-ID: <20110212220826.GA4135@outflux.net>
References: <20110212032944.GA24080@outflux.net>
 <AANLkTiniMPKD6EGpQ=TAbeS4tFVtZybcf-8kFuNbU7t_@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <AANLkTiniMPKD6EGpQ=TAbeS4tFVtZybcf-8kFuNbU7t_@mail.gmail.com>
Organization: Canonical
X-HELO: www.outflux.net
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Corbin,

On Sat, Feb 12, 2011 at 10:13:04AM -0800, Corbin Simpson wrote:
> On Fri, Feb 11, 2011 at 7:29 PM, Kees Cook <kees.cook@canonical.com> wrote:
> > In the continuing effort to avoid kernel addresses leaking to unprivileged
> > users, this patch switches to %pK for /proc/dri/*/vma.
> 
> This is a highly reasonable patch. Does 0x%pK show up as 0x0x0 in the
> log, or just 0x0? Other than that...
> Reviewed-by: Corbin Simpson <MostAwesomeDude@gmail.com>

Thanks! The default for %p (and %pK) is without the 0x prefix, and 0-padded to sizeof(void*)
character. So 0x%pK will show as 0x00000000 on 32bit to a regular user, etc.

-Kees

-- 
Kees Cook
Ubuntu Security Team
