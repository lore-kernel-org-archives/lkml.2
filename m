Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754215Ab2AZXIF (ORCPT <rfc822;w@1wt.eu>);
	Thu, 26 Jan 2012 18:08:05 -0500
Received: from shards.monkeyblade.net ([198.137.202.13]:35768 "EHLO
	shards.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751257Ab2AZXID (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 26 Jan 2012 18:08:03 -0500
Date: Thu, 26 Jan 2012 18:07:54 -0500 (EST)
Message-Id: <20120126.180754.679593869814492219.davem@davemloft.net>
To: ebiederm@xmission.com
Cc: eric.dumazet@gmail.com, xemul@parallels.com,
        sjur.brandeland@stericsson.com, levinsasha928@gmail.com,
        netdev@vger.kernel.org, linux-kernel@vger.kernel.org, davej@redhat.com,
        sjurbren@gmail.com
Subject: Re: [PATCH] netns: fix net_alloc_generic()
From: David Miller <davem@davemloft.net>
In-Reply-To: <m1zkdacbsx.fsf@fess.ebiederm.org>
References: <4F212E7E.2040801@parallels.com>
	<1327575108.2500.24.camel@edumazet-HP-Compaq-6005-Pro-SFF-PC>
	<m1zkdacbsx.fsf@fess.ebiederm.org>
X-Mailer: Mew version 6.4 on Emacs 23.3 / Mule 6.0 (HANACHIRUSATO)
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
X-Greylist: Sender succeeded SMTP AUTH, not delayed by milter-greylist-4.2.6 (shards.monkeyblade.net [198.137.202.13]); Thu, 26 Jan 2012 15:07:57 -0800 (PST)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: ebiederm@xmission.com (Eric W. Biederman)
Date: Thu, 26 Jan 2012 14:57:02 -0800

> It is not a chicken and egg problem.  It is a bug in caif.
> caif is claiming to be a network device when it is acting as a subsytem.
> That means it is being initialized too late.
> 
> Untested but this should trivially fix the problem, and a bunch
> of others of the same ilk.
> 
> It is not safe to shutdown subsystems until all of the devices
> are gone, otherwise there will be problems with packets in flight.

If you guys can agree that this is the better fix, and we can
get testing showing that it works, I'll revert Eric D.'s patch
and apply the final version of this one.

Thanks.
