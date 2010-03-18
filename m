Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752922Ab0CRPrw (ORCPT <rfc822;w@1wt.eu>);
	Thu, 18 Mar 2010 11:47:52 -0400
Received: from mail.dev.rtsoft.ru ([213.79.90.226]:49720 "HELO
	mail.dev.rtsoft.ru" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with SMTP id S1752158Ab0CRPru (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 18 Mar 2010 11:47:50 -0400
Date: Thu, 18 Mar 2010 18:47:47 +0300
From: Anton Vorontsov <avorontsov@ru.mvista.com>
To: Grant Likely <grant.likely@secretlab.ca>
Cc: davem@davemloft.net, benh@kernel.crashing.org,
       linux-kernel@vger.kernel.org, michal.simek@petalogix.com,
       linuxppc-dev@lists.ozlabs.org, sparclinux@vger.kernel.org,
       microblaze-uclinux@itee.uq.edu.au
Subject: Re: [V2 PATCH 08/10] arch/powerpc: Remove obsolete
 dev_archdata.of_node and of_devce.node
Message-ID: <20100318154747.GA7767@oksana.dev.rtsoft.ru>
Reply-To: avorontsov@ru.mvista.com
References: <20100318144836.21082.93040.stgit@angua>
 <20100318152250.21082.35352.stgit@angua>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
In-Reply-To: <20100318152250.21082.35352.stgit@angua>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Grant,

On Thu, Mar 18, 2010 at 09:22:50AM -0600, Grant Likely wrote:
> Both dev_archdata.of_node and of_device.node are duplications of the
> device.of_node value.  This patch removes them.

Yeah, they're plain duplications since you introduced dev.of_node.
I wonder what was the problem with using dev.archdata.of_node?
Why dev.of_node is better?

Also, by using dev.of_node directly you have to introduce ugly
#ifdefs in the non-OF code (as in i2c patch), which you don't
need with transparent archdata and accessors, which you've just
removed:

> -static inline void dev_archdata_set_node(struct dev_archdata *ad,
> -					 struct device_node *np)
> -{
> -	ad->of_node = np;
> -}
> -
> -static inline struct device_node *
> -dev_archdata_get_node(const struct dev_archdata *ad)
> -{
> -	return ad->of_node;
> -}

Thanks,

-- 
Anton Vorontsov
email: cbouatmailru@gmail.com
irc://irc.freenode.net/bd2
