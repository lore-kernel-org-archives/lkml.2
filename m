Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752701Ab0GYUiA (ORCPT <rfc822;w@1wt.eu>);
	Sun, 25 Jul 2010 16:38:00 -0400
Received: from mail-gx0-f174.google.com ([209.85.161.174]:64122 "EHLO
	mail-gx0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750850Ab0GYUh7 convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 25 Jul 2010 16:37:59 -0400
MIME-Version: 1.0
In-Reply-To: <20100725130723.a5192793.sfr@canb.auug.org.au>
References: <20100724154331.22701.3409.stgit@angua> <20100725130723.a5192793.sfr@canb.auug.org.au>
From: Grant Likely <grant.likely@secretlab.ca>
Date: Sun, 25 Jul 2010 14:37:38 -0600
X-Google-Sender-Auth: mGRRWS6F1Tq-oCgwasPaq_MEMdg
Message-ID: <AANLkTinE4X0iAJAiatc7Qtj2QP6dhyBKo9fqxqUt40Y6@mail.gmail.com>
Subject: Re: [PATCH] of: Provide default of_node_to_nid() when CONFIG_NUMA is 
	not set
To: Stephen Rothwell <sfr@canb.auug.org.au>
Cc: monstr@monstr.eu, microblaze-uclinux@itee.uq.edu.au,
        devicetree-discuss@lists.ozlabs.org, linux-kernel@vger.kernel.org,
        linuxppc-dev@ozlabs.org, benh@kernel.crashing.org,
        sparclinux@vger.kernel.org, davem@davemloft.net
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sat, Jul 24, 2010 at 9:07 PM, Stephen Rothwell <sfr@canb.auug.org.au> wrote:
> Hi Grant,
>
> On Sat, 24 Jul 2010 09:43:31 -0600 Grant Likely <grant.likely@secretlab.ca> wrote:
>>
>> of_node_to_nid() is only relevant for NUMA.  Don't force architectures to
>> implement it if CONFIG_NUMA is not set.
>
> Why not just do:
>
> #ifndef of_node_to_nid
> static inline int of_node_to_nid(struct device_node *device) { return 0; }
> #define of_node_to_nid  of_node_to_nid
> #endif
>
> in include/linux/of.h
>
> and then add:
>
> #define of_node_to_nid  of_node_to_nid
>
> Where it is declared/defined for each arch ...
> (it would be nice if all the archs were consistent in where it was
> declared).

Two reasons; I had started doing that in topology.h, but it caused a
bunch of collateral damage with files missing the include, so I punted
and took the easy way out.  Also, I didn't know if that was an
acceptable or safe pattern for override symbols.

I'll spin it again with this pattern and see what it looks.

g.


> --
> Cheers,
> Stephen Rothwell                    sfr@canb.auug.org.au
> http://www.canb.auug.org.au/~sfr/
>



-- 
Grant Likely, B.Sc., P.Eng.
Secret Lab Technologies Ltd.
