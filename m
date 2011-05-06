Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753636Ab1EFMOA (ORCPT <rfc822;w@1wt.eu>);
	Fri, 6 May 2011 08:14:00 -0400
Received: from anchor-post-1.mail.demon.net ([195.173.77.132]:50405 "EHLO
	anchor-post-1.mail.demon.net" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751324Ab1EFMN7 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 6 May 2011 08:13:59 -0400
Subject: Re: [PATCH] RCU: remove alignment padding from rcu_data on 64 bit
 builds
From: Richard Kennedy <richard@rsk.demon.co.uk>
To: Eric Dumazet <eric.dumazet@gmail.com>
Cc: "Paul E. McKenney" <paulmck@linux.vnet.ibm.com>,
        lkml <linux-kernel@vger.kernel.org>,
        Dipankar Sarma <dipankar@in.ibm.com>
In-Reply-To: <1304662845.3131.23.camel@edumazet-laptop>
References: <1304610604.1984.6.camel@castor.rsk>
	 <1304662845.3131.23.camel@edumazet-laptop>
Content-Type: text/plain; charset="UTF-8"
Date: Fri, 06 May 2011 13:13:56 +0100
Message-ID: <1304684036.1998.10.camel@castor.rsk>
Mime-Version: 1.0
X-Mailer: Evolution 2.32.2 (2.32.2-1.fc14) 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, 2011-05-06 at 08:20 +0200, Eric Dumazet wrote:
...
> We could shrink this structure more, converting some 64bit fields to
> 32bit ones.
> 
> Rationale is the algo is working well on 32bit arches, no need to use
> 64bit fields.
> 
> candidates : completed, gpnum, passed_quiesc_completed, qlen,
> qlen_last_fqs_check, blimit.
> 
> Counters might be converted too.

I don't know the code well enough to make that decision ;)
Is it possible to shrink it enough to free up another cache line ?
(16 longs to ints).

CONFIG_NO_HZ adds 24 bytes so even for users with !CONFIG_NO_HZ the
variables you suggest are not enough to free a cache line.  

regards
Richard


