Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1031121Ab2HIPg5 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 9 Aug 2012 11:36:57 -0400
Received: from mail-bk0-f46.google.com ([209.85.214.46]:48422 "EHLO
	mail-bk0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1031060Ab2HIPgz (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 9 Aug 2012 11:36:55 -0400
Subject: Re: [PATCH] ipv4: tcp: security_sk_alloc() needed for unicast_sock
From: Eric Dumazet <eric.dumazet@gmail.com>
To: Paul Moore <paul@paul-moore.com>
Cc: David Miller <davem@davemloft.net>,
        Casey Schaufler <casey@schaufler-ca.com>,
        Eric Paris <eparis@parisplace.org>, John Stultz <johnstul@us.ibm.com>,
        "Serge E. Hallyn" <serge@hallyn.com>,
        lkml <linux-kernel@vger.kernel.org>,
        James Morris <james.l.morris@oracle.com>, selinux@tycho.nsa.gov,
        john.johansen@canonical.com,
        LSM <linux-security-module@vger.kernel.org>,
        netdev <netdev@vger.kernel.org>
In-Reply-To: <5799181.tjlnF0gIh2@sifl>
References: <50215A7E.8000701@linaro.org> <1695034.0lrQgQPOMT@sifl>
	 <1344523833.28967.996.camel@edumazet-glaptop>  <5799181.tjlnF0gIh2@sifl>
Content-Type: text/plain; charset="UTF-8"
Date: Thu, 09 Aug 2012 17:36:48 +0200
Message-ID: <1344526608.28967.1092.camel@edumazet-glaptop>
Mime-Version: 1.0
X-Mailer: Evolution 2.28.3 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 2012-08-09 at 11:07 -0400, Paul Moore wrote:

> Is is possible to do the call to security_sk_alloc() in the ip_init() function 
> or does the per-cpu nature of the socket make this a pain?
> 

Its a pain, if we want NUMA affinity.

Here, each cpu should get memory from its closest node.



