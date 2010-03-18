Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751379Ab0CRIrE (ORCPT <rfc822;w@1wt.eu>);
	Thu, 18 Mar 2010 04:47:04 -0400
Received: from mail-gy0-f174.google.com ([209.85.160.174]:53940 "EHLO
	mail-gy0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751043Ab0CRIq7 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 18 Mar 2010 04:46:59 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=subject:from:to:cc:content-type:date:message-id:mime-version
         :x-mailer:content-transfer-encoding;
        b=BmIKXvphG6WXnvBx2mbg32bCoDzc9ToHm1TAz2dZqaf5irTPR7hEx2AALjQA2iEnEI
         izbwTouR7ehAHy5/Xq4HMChRK6+2VuravRr1K/JH6Cf2tGJ6YR3ZNLgecSYB69CIj0eb
         ECIoxD701CaIdw5pN51JkwaKSEL6RnbvmADOs=
Subject: Re: [PATCH] drivers/net/wimax/i2400m/fw.c fix possible double free
From: Darren Jenkins <darrenrjenkins@gmail.com>
To: Inaky Perez-Gonzalez <inaky.perez-gonzalez@intel.com>
Cc: David Miller <davem@davemloft.net>, linux-wimax <linux-wimax@intel.com>,
       "kernel-janitors@vger.kernel.org" <kernel-janitors@vger.kernel.org>,
       "Kao, Cindy H" <cindy.h.kao@intel.com>,
       "Brandewie, Dirk J" <dirk.j.brandewie@intel.com>,
       "wimax@linuxwimax.org" <wimax@linuxwimax.org>,
       "netdev@vger.kernel.org" <netdev@vger.kernel.org>,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
Content-Type: text/plain; charset="UTF-8"
Date: Thu, 18 Mar 2010 19:46:48 +1100
Message-ID: <1268902008.10536.41.camel@ICE-BOX>
Mime-Version: 1.0
X-Mailer: Evolution 2.28.1 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


On Thu, Mar 18, 2010 at 9:10 AM, Inaky Perez-Gonzalez
<inaky.perez-gonzalez@intel.com> wrote:

> If krealloc() fails to aallocate a new pointer, the old block is
> unmodified, so by doing this you are leaking a buffer allocation.

It seems you are right.
So now understanding correctly how krealloc() works I can see that the
double kfree() can only actually happen if the el_size parameter to
i2400m_zrealloc_2x() is zero, and it isn't at the two call sites.

So this was a false positive and I am sorry for the noise.

Darren J.


