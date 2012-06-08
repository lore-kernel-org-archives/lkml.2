Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933599Ab2FHFr1 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 8 Jun 2012 01:47:27 -0400
Received: from mail-ee0-f46.google.com ([74.125.83.46]:45161 "EHLO
	mail-ee0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S933363Ab2FHFrZ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 8 Jun 2012 01:47:25 -0400
Subject: Re: Deadlock, L2TP over IP are not working, 3.4.1
From: Eric Dumazet <eric.dumazet@gmail.com>
To: Francois Romieu <romieu@fr.zoreil.com>
Cc: Denys Fedoryshchenko <denys@visp.net.lb>, davem@davemloft.net,
        netdev@vger.kernel.org, linux-kernel@vger.kernel.org
In-Reply-To: <20120607223752.GA4475@electric-eye.fr.zoreil.com>
References: <7ed49f446365ac625437702d92946add@visp.net.lb>
	 <20120607205356.GA2491@electric-eye.fr.zoreil.com>
	 <1339104606.6001.4.camel@edumazet-glaptop>
	 <20120607223752.GA4475@electric-eye.fr.zoreil.com>
Content-Type: text/plain; charset="UTF-8"
Date: Fri, 08 Jun 2012 07:47:18 +0200
Message-ID: <1339134438.6001.13.camel@edumazet-glaptop>
Mime-Version: 1.0
X-Mailer: Evolution 2.28.3 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, 2012-06-08 at 00:37 +0200, Francois Romieu wrote:
> Eric Dumazet <eric.dumazet@gmail.com> :
> [...]
> > If LLTX is used, this means several cpus can execute this code at the
> > same time.
> > 
> > You need percpu stats, or use atomic primitives.
> 
> Would adding percpu stats not be frown upon ?
> 

I have no idea how many l2tp_eth devices are setup at once in typical
conf.

> As atomic will defeat the 64 bits stats on 32 bits, I should probably stick
> to plain bh disabling lock.
> 

Not sure what you mean by "atomic will defeat the 64 bits stats on 32
bits", since you also need atomic for "32 bits stats" or "64 bits stats
on 64 bit arches"

I personally would just use "unsigned long". If people want 64bit stats
for their l2tp_eth, they certainly can use a 64bit host.



