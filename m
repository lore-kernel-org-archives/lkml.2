Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753102Ab0IXH5q (ORCPT <rfc822;w@1wt.eu>);
	Fri, 24 Sep 2010 03:57:46 -0400
Received: from mail-ey0-f174.google.com ([209.85.215.174]:49523 "EHLO
	mail-ey0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750898Ab0IXH5p (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 24 Sep 2010 03:57:45 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-type:content-disposition:in-reply-to:user-agent;
        b=frojOboM2xRbmzrFwlHNE8Vo4GTgDyEGikx0QFoFOCygRtwxDTn5pgRcwTFoZNYTdR
         RhJdjaeZCiBeiLS+Nqs93+MMr9rtU92l7/KYbBaYry2tBUJWBQEwajamfSVZN99WesKn
         RcQByWto6cuUcYlm+kUGSd36+ej421TGP/amk=
Date: Fri, 24 Sep 2010 11:57:40 +0400
From: Anton Vorontsov <cbouatmailru@gmail.com>
To: LEROY Christophe <christophe.leroy@c-s.fr>
Cc: Grant Likely <grant.likely@secretlab.ca>,
        David Brownell <dbrownell@users.sourceforge.net>,
        spi-devel-general@lists.sourceforge.net, linux-kernel@vger.kernel.org,
        linuxppc-dev@lists.ozlabs.org, Kumar Gala <galak@kernel.crashing.org>
Subject: Re: [PATCH] spi_mpc8xxx: issue with using definition of pram in
 Device Tree
Message-ID: <20100924075740.GA20599@oksana.dev.rtsoft.ru>
References: <20100916070503.10046C7391@messagerie.si.c-s.fr>
 <20100924071006.GA21318@angua.secretlab.ca>
 <4C9C513B.40501@c-s.fr>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
In-Reply-To: <4C9C513B.40501@c-s.fr>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hello,

On Fri, Sep 24, 2010 at 09:20:27AM +0200, LEROY Christophe wrote:
> The issue is that cpm_muram_alloc_fixed() allocates memory from the
> general purpose muram area (from 0x0 to 0x1bff).
> Here we need to return a pointer to the parameter RAM, which is
> located somewhere starting at 0x1c00. It is not a dynamic allocation
> that is required here but only to point on the correct location in
> the parameter RAM.
> 
> For the CPM2, I don't know. I'm working with a MPC866.
> 
> Attached is a previous discussion on the subject where I explain a
> bit more in details the issue.

The patch looks OK, I think.

Doesn't explain why that worked on MPC8272 (CPM2) and MPC8560
(also CPM2) machines though. But here's my guess (I no longer
have these boards to test it):

On 8272 I used this node:

+                       spi@4c0 {
+                               #address-cells = <1>;
+                               #size-cells = <0>;
+                               compatible = "fsl,cpm2-spi", "fsl,spi";
+                               reg = <0x11a80 0x40 0x89fc 0x2>;

On that SOC there are two muram data regions 0x0..0x2000 and
0x9000..0x9100. Note that we actually don't want "data" regions,
and the only reason why that worked is that sysdev/cpm_common.c
maps muram(0)..muram(max).

Thanks,

-- 
Anton Vorontsov
email: cbouatmailru@gmail.com
irc://irc.freenode.net/bd2
