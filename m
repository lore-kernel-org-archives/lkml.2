Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755355Ab0IXLvc (ORCPT <rfc822;w@1wt.eu>);
	Fri, 24 Sep 2010 07:51:32 -0400
Received: from mail-qy0-f174.google.com ([209.85.216.174]:62145 "EHLO
	mail-qy0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752104Ab0IXLva (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 24 Sep 2010 07:51:30 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=sender:subject:from:reply-to:to:cc:in-reply-to:references
         :content-type:date:message-id:mime-version:x-mailer
         :content-transfer-encoding;
        b=vOy7Tmq2ghtP540ipY2oJQR1F71tSxO+AbFItYH3DZiQ8/oY0eqF2qVJWrW617anf5
         s3LjktyDZQAlCzNPY0Bg6Bu3zdMWhyCNDizCB6cR1GFp3dtLTX/3z3t1SvyPN2UCiXbE
         GzTFQleq/1jTQyGy4zmsJOc2aOddbZM1WAXoI=
Subject: Re: [PATCH 7/8] net: Allow setting the network namespace by fd
From: jamal <hadi@cyberus.ca>
Reply-To: hadi@cyberus.ca
To: David Lamparter <equinox@diac24.net>
Cc: "Eric W. Biederman" <ebiederm@xmission.com>, linux-kernel@vger.kernel.org,
        Linux Containers <containers@lists.osdl.org>, netdev@vger.kernel.org,
        netfilter-devel@vger.kernel.org, linux-fsdevel@vger.kernel.org,
        Daniel Lezcano <daniel.lezcano@free.fr>,
        Linus Torvalds <torvalds@linux-foundation.org>,
        Michael Kerrisk <mtk.manpages@gmail.com>,
        Ulrich Drepper <drepper@gmail.com>, Al Viro <viro@ZenIV.linux.org.uk>,
        David Miller <davem@davemloft.net>,
        "Serge E. Hallyn" <serge@hallyn.com>,
        Pavel Emelyanov <xemul@openvz.org>,
        Pavel Emelyanov <xemul@parallels.com>,
        Ben Greear <greearb@candelatech.com>,
        Matt Helsley <matthltc@us.ibm.com>, Jonathan Corbet <corbet@lwn.net>,
        Sukadev Bhattiprolu <sukadev@linux.vnet.ibm.com>,
        Jan Engelhardt <jengelh@medozas.de>, Patrick McHardy <kaber@trash.net>
In-Reply-To: <20100923145856.GB1160234@jupiter.n2.diac24.net>
References: <m1ocborgq7.fsf@fess.ebiederm.org>
	 <m1hbhgq1v1.fsf@fess.ebiederm.org> <1285240926.5036.7.camel@bigi>
	 <20100923145856.GB1160234@jupiter.n2.diac24.net>
Content-Type: text/plain
Date: Fri, 24 Sep 2010 07:51:24 -0400
Message-Id: <1285329084.13976.661.camel@bigi>
Mime-Version: 1.0
X-Mailer: Evolution 2.26.1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 2010-09-23 at 16:58 +0200, David Lamparter wrote:

> migrating route table entries makes no sense because
> a) they refer to devices and configuration that does not exist in the
>    target namespace; they only make sense within their netns context
> b) they are purely virtual and you get the same result from deleting and
>    recreating them.
> 
> Network devices are special because they may have something attached to
> them, be it hardware or some daemon.

Routes functionally reside on top of netdevices, point to nexthop
neighbors across these netdevices etc. Underlying assumption is you take
care of that dependency when migrating.
We are talking about FIB entries here not the route cache; moving a few
pointers within the kernel is a hell lot faster than recreating a subset
of BGP entries from user space. 

Eric, I didnt follow the exposed-races arguement: Why would it involve
more than just some basic locking only while you change the struct net
pointer to the new namespace for these sub-subsystems?

cheers,
jamal

