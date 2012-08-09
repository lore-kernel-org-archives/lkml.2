Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1030380Ab2HIO2A (ORCPT <rfc822;w@1wt.eu>);
	Thu, 9 Aug 2012 10:28:00 -0400
Received: from mail-bk0-f46.google.com ([209.85.214.46]:58026 "EHLO
	mail-bk0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1030204Ab2HIO16 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 9 Aug 2012 10:27:58 -0400
Subject: Re: NULL pointer dereference in selinux_ip_postroute_compat
From: Eric Dumazet <eric.dumazet@gmail.com>
To: Paul Moore <paul@paul-moore.com>
Cc: Casey Schaufler <casey@schaufler-ca.com>,
        Eric Paris <eparis@parisplace.org>, John Stultz <johnstul@us.ibm.com>,
        "Serge E. Hallyn" <serge@hallyn.com>,
        lkml <linux-kernel@vger.kernel.org>,
        James Morris <james.l.morris@oracle.com>, selinux@tycho.nsa.gov,
        Eric Dumazet <edumazet@google.com>, john.johansen@canonical.com,
        LSM <linux-security-module@vger.kernel.org>
In-Reply-To: <1695034.0lrQgQPOMT@sifl>
References: <50215A7E.8000701@linaro.org>
	 <1344462889.28967.328.camel@edumazet-glaptop>
	 <5022FD9A.4020603@schaufler-ca.com>  <1695034.0lrQgQPOMT@sifl>
Content-Type: text/plain; charset="UTF-8"
Date: Thu, 09 Aug 2012 16:27:52 +0200
Message-ID: <1344522472.28967.936.camel@edumazet-glaptop>
Mime-Version: 1.0
X-Mailer: Evolution 2.28.3 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 2012-08-09 at 09:30 -0400, Paul Moore wrote:

> In the case of a TCP syn-recv and timewait ACK things are a little less clear.  
> Eric (Dumazet), it looks like we have a socket in tcp_v4_reqsk_send_ack() and 
> tcp_v4_timewait_ack(), any reason why we can't propagate the socket down to 
> ip_send_unicast_reply()?
> 

timewait 'sockets' are not full blown sockets.

We need a socket (well, a good part of it) to build the IP frame and
send it.



