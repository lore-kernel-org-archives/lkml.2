Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751617Ab2G0G51 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 27 Jul 2012 02:57:27 -0400
Received: from nat28.tlf.novell.com ([130.57.49.28]:49511 "EHLO
	nat28.tlf.novell.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750922Ab2G0G50 convert rfc822-to-8bit (ORCPT
	<rfc822;groupwise-linux-kernel@vger.kernel.org:9:1>);
	Fri, 27 Jul 2012 02:57:26 -0400
Message-Id: <501257F30200007800090D9E@nat28.tlf.novell.com>
X-Mailer: Novell GroupWise Internet Agent 12.0.0 
Date: Fri, 27 Jul 2012 07:57:23 +0100
From: "Jan Beulich" <JBeulich@suse.com>
To: "Stefano Stabellini" <stefano.stabellini@eu.citrix.com>,
        <linux-kernel@vger.kernel.org>
Cc: <catalin.marinas@arm.com>, <arnd@arndb.de>, <Ian.Campbell@citrix.com>,
        <linux-arm-kernel@lists.infradead.org>, <linaro-dev@lists.linaro.org>,
        <xen-devel@lists.xensource.com>, <konrad.wilk@oracle.com>,
        <tim@xen.org>
Subject: Re: [Xen-devel] [PATCH 06/24] xen: missing includes
References: <alpine.DEB.2.02.1207251741470.26163@kaball.uk.xensource.com>
 <1343316846-25860-6-git-send-email-stefano.stabellini@eu.citrix.com>
In-Reply-To: <1343316846-25860-6-git-send-email-stefano.stabellini@eu.citrix.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 8BIT
Content-Disposition: inline
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

>>> On 26.07.12 at 17:33, Stefano Stabellini <stefano.stabellini@eu.citrix.com> wrote:
> --- a/include/xen/interface/xen.h
> +++ b/include/xen/interface/xen.h
> @@ -10,7 +10,10 @@
>  #define __XEN_PUBLIC_XEN_H__
>  
>  #include <asm/xen/interface.h>
> +#include <linux/types.h>
> +#ifdef CONFIG_X86
>  #include <asm/pvclock-abi.h>
> +#endif

Rather than hacking around this, why not clean it up:
asm/pvclock-abi.h clearly isn't intended to be included here
(from the perspective of the origin of xen/interface/xen.h, at
least), nor is linux/types.h.

Or if it is really needed to deviate from the original header in
this respect, then clearly the inclusion ought to not be arch
specific or be moved to an arch specific header.

Jan

>  
>  /*
>   * XEN "SYSTEM CALLS" (a.k.a. HYPERCALLS).


