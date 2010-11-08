Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755364Ab0KHSLj (ORCPT <rfc822;w@1wt.eu>);
	Mon, 8 Nov 2010 13:11:39 -0500
Received: from serrano.cc.columbia.edu ([128.59.29.6]:61385 "EHLO
	serrano.cc.columbia.edu" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753035Ab0KHSLi (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 8 Nov 2010 13:11:38 -0500
Message-ID: <4CD83DF4.4080009@cs.columbia.edu>
Date: Mon, 08 Nov 2010 13:14:12 -0500
From: Oren Laadan <orenl@cs.columbia.edu>
Organization: Columbia University
User-Agent: Mozilla/5.0 (X11; U; Linux x86_64; en-US; rv:1.9.1.15) Gecko/20101027 Lightning/1.0b1 Thunderbird/3.0.10
MIME-Version: 1.0
To: Gene Cooperman <gene@ccs.neu.edu>
CC: Kapil Arya <kapil@ccs.neu.edu>, Tejun Heo <tj@kernel.org>,
        ksummit-2010-discuss@lists.linux-foundation.org,
        linux-kernel@vger.kernel.org, hch@lst.de,
        Linux Containers <containers@lists.osdl.org>
Subject: Re: [Ksummit-2010-discuss] checkpoint-restart: naked patch
References: <AANLkTinOg6n3ZA+0gHzw9LouRuUmJ7DJwHtABRy5c=gM@mail.gmail.com> <4CD26948.7050009@kernel.org> <20101104164401.GC10656@sundance.ccs.neu.edu> <4CD3CE29.2010105@kernel.org> <AANLkTimDXKsBCxbsEOfgkYV2R8FK=bhFdmx9UQow5hqp@mail.gmail.com> <4CD5DCE3.3000109@cs.columbia.edu> <20101107194222.GG31077@sundance.ccs.neu.edu> <4CD71A6B.3020905@cs.columbia.edu> <20101107230516.GJ31077@sundance.ccs.neu.edu> <4CD774CA.8030004@cs.columbia.edu> <20101108162630.GN31077@sundance.ccs.neu.edu>
In-Reply-To: <20101108162630.GN31077@sundance.ccs.neu.edu>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
X-No-Spam-Score: Local
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi,

Ok, I'll bite the bullet for now - to be continued...

Just one important clarification:

>> Linux-cr can do live migration - e.g. VDI, move the desktop - in
>> which case skype's sockets' network stacks are reconstructed,
>> transparently to both skype (local apps) and the peer (remote apps).
>> Then, at the destination host and skype continues to work.
>
> That's a really cool thing to do, and it's definitely not part of what
> DMTCP does.  It might be possible to do userland live migration,
> but it's definitely not part of our current scope.  But if we're talking
> about live migration, have you also looked at the work of
> Andres Lagar Caviilla on SnowFlock?
>      http://andres.lagarcavilla.com/publications/LagarCavillaEurosys09.pdf
> He does live migration of entire virtual machines, again with very
> small delay.  Of course, the issue for any type of live migration is that
> if the rate of dirtying pages is very high (e.g. HPC), then there is
> still a delay or slow response, due to page faults to a remote host.

VMware, Xen and KVM already do live migration. However, VMs
are a separate beast.

We are concerned about _application_ level c/r and migration
(complete containers or individual applications). Many proven
techniques from the VM world apply to our context too (in your
example, post-copy migration).

Oren.
