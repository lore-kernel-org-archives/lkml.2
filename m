Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932431Ab1FVPlf (ORCPT <rfc822;w@1wt.eu>);
	Wed, 22 Jun 2011 11:41:35 -0400
Received: from out2.smtp.messagingengine.com ([66.111.4.26]:35825 "EHLO
	out2.smtp.messagingengine.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S932246Ab1FVPlc (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 22 Jun 2011 11:41:32 -0400
X-Sasl-enc: RnkKKRrYtdikgGXD5xi2tM+pu55x7AFi90dgdybOACle 1308757290
Date: Wed, 22 Jun 2011 08:40:22 -0700
From: Greg KH <greg@kroah.com>
To: David Miller <davem@davemloft.net>
Cc: linux-kernel@vger.kernel.org
Subject: Re: brcm80211 build busted on big-endian
Message-ID: <20110622154022.GB19027@kroah.com>
References: <20110621.193641.1605224831578508501.davem@davemloft.net>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20110621.193641.1605224831578508501.davem@davemloft.net>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Jun 21, 2011 at 07:36:41PM -0700, David Miller wrote:
> 
> It tries to do "xor" operations on pointers because of how the
> R_REG() and W_REG() macros are defined.
> 
> ====================
> #define R_REG(r) (\
>         SELECT_BUS_READ( \
>                 ({ \
>                         __typeof(*(r)) __osl_v; \
> 				       		switch (sizeof(*(r))) { \
>                         case sizeof(u8): \
>                                 __osl_v = \
>                                 readb((volatile u8*)((r)^3)); \
>                                 break; \
>                         case sizeof(u16): \
>                                 __osl_v = \
>                                 readw((volatile u16*)((r)^2)); \
>                                 break; \
>                         case sizeof(u32): \
>                                 __osl_v = readl((volatile u32*)(r)); \
>                                 break; \
>                         } \
>                         __osl_v; \
>                 }), \
>                 OSL_READ_REG(r)) \
> )
> ====================
> 
> This driver is a crap fest of volatile pointers and not-compile-tested
> code.

For big endian, I agree, which is why I thought I fixed this up so it
wouldn't build on other arches than MIPS for the moment.

Is this blowing up in -next or in Linus's tree right now?

thanks,

greg k-h
