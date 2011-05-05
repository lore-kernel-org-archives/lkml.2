Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752797Ab1EELcz (ORCPT <rfc822;w@1wt.eu>);
	Thu, 5 May 2011 07:32:55 -0400
Received: from mail-bw0-f46.google.com ([209.85.214.46]:39138 "EHLO
	mail-bw0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751625Ab1EELcx (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 5 May 2011 07:32:53 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=sender:date:from:to:cc:subject:message-id:references:mime-version
         :content-type:content-disposition:in-reply-to:user-agent;
        b=qQr5NZqgf7ClGw5s2EHu96l3+zMX4IWuQVwqXZtYswJeSYbUKyH4FFLuORncYX69aL
         XOgpsplwSDSMFXMx9YSH125Q+Ujr0DWToDUOdLzljVG+QTixbb4/64xnS9YMcSyg76Yi
         C8IhBc+7oKeWWYPIO3zWN0ZM2RnAAMZWS8xpQ=
Date: Thu, 5 May 2011 15:32:45 +0400
From: Vasiliy Kulikov <segoon@openwall.com>
To: David Miller <davem@davemloft.net>
Cc: solar@openwall.com, linux-kernel@vger.kernel.org, netdev@vger.kernel.org,
        peak@argo.troja.mff.cuni.cz, kees.cook@canonical.com,
        dan.j.rosenberg@gmail.com, eugene@redhat.com, nelhage@ksplice.com,
        kuznet@ms2.inr.ac.ru, pekkas@netcore.fi, jmorris@namei.org,
        yoshfuji@linux-ipv6.org, kaber@trash.net
Subject: Re: [PATCH] net: ipv4: add IPPROTO_ICMP socket kind
Message-ID: <20110505113245.GA8959@albatros>
References: <20110412.142534.183049889.davem@davemloft.net>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20110412.142534.183049889.davem@davemloft.net>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Apr 12, 2011 at 14:25 -0700, David Miller wrote:
> Third, either we trust this code or we do not.  If we are OK with a
> user application spamming whatever they wish out of a datagram UDP
> socket, they can do no more harm with this thing unless there are
> bugs.

It is true in theory, but wrong in practice.  I have a cheap router
which can be made almost fully hang up with simple ping flood.  And I
almost sure many not very widespread implementations of IPv6 would
react not very clever way on non-echo ICMPv6 flood (I'd want to make
more than ICMPv6 Echo Request/Reply types available to nonroot).

> The group range thing I also consider hackish.

Why hackish?  We'd want to leave group range sysctl.  With this thing
you may restrict icmp according to different policies:

1) 0 4294967295 - We trust all users in the system.

2) 0 0 - We don't trust users, root only.

3) 101 4294967295 - We trust real users, but don't trust daemons.

4) 109 109 - We trust a signle group.  Either /sbin/ping is g+s and
owned by this group (like in Owl) or it is a group of "network admins"
who is allowed to flood.

5) 200 300 - We trust users in this range.  Little sense because of (4),
but possible.


Minor note about sgid'ed /sbin/ping: in case of a vulnerability in
this kernel code one has to find additional bug in ping binary to exploit
this vulnerability (unless it is somehow triggerable with ping arguments
overflow or remotely).


Thank you,

-- 
Vasiliy Kulikov
http://www.openwall.com - bringing security into open computing environments
