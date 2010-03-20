Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752143Ab0CTVXx (ORCPT <rfc822;w@1wt.eu>);
	Sat, 20 Mar 2010 17:23:53 -0400
Received: from 74-93-104-97-Washington.hfc.comcastbusiness.net ([74.93.104.97]:60807
	"EHLO sunset.davemloft.net" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751273Ab0CTVXv (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 20 Mar 2010 17:23:51 -0400
Date: Sat, 20 Mar 2010 14:24:13 -0700 (PDT)
Message-Id: <20100320.142413.15249200.davem@davemloft.net>
To: darrenrjenkins@gmail.com
Cc: inaky.perez-gonzalez@intel.com, linux-wimax@intel.com,
       kernel-janitors@vger.kernel.org, cindy.h.kao@intel.com,
       dirk.j.brandewie@intel.com, wimax@linuxwimax.org,
       netdev@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH] drivers/net/wimax/i2400m/fw.c fix possible double free
From: David Miller <davem@davemloft.net>
In-Reply-To: <1268902008.10536.41.camel@ICE-BOX>
References: <1268902008.10536.41.camel@ICE-BOX>
X-Mailer: Mew version 6.3 on Emacs 23.1 / Mule 6.0 (HANACHIRUSATO)
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Darren Jenkins <darrenrjenkins@gmail.com>
Date: Thu, 18 Mar 2010 19:46:48 +1100

> 
> On Thu, Mar 18, 2010 at 9:10 AM, Inaky Perez-Gonzalez
> <inaky.perez-gonzalez@intel.com> wrote:
> 
>> If krealloc() fails to aallocate a new pointer, the old block is
>> unmodified, so by doing this you are leaking a buffer allocation.
> 
> It seems you are right.
> So now understanding correctly how krealloc() works I can see that the
> double kfree() can only actually happen if the el_size parameter to
> i2400m_zrealloc_2x() is zero, and it isn't at the two call sites.
> 
> So this was a false positive and I am sorry for the noise.

No problem, at least the code got audited :-)
