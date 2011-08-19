Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752226Ab1HSMtw (ORCPT <rfc822;w@1wt.eu>);
	Fri, 19 Aug 2011 08:49:52 -0400
Received: from mail-yi0-f46.google.com ([209.85.218.46]:39307 "EHLO
	mail-yi0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751090Ab1HSMtv (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 19 Aug 2011 08:49:51 -0400
Subject: Re: [RFC 0/0] Introducing a generic socket offload framework
From: jamal <hadi@cyberus.ca>
Reply-To: jhs@mojatatu.com
To: San Mehat <san@google.com>
Cc: davem@davemloft.net, mst@redhat.com, rusty@rustcorp.com.au,
        linux-kernel@vger.kernel.org,
        virtualization@lists.linux-foundation.org, netdev@vger.kernel.org,
        digitaleric@google.com, mikew@google.com, miche@google.com,
        maccarro@google.com
In-Reply-To: <20110818220756.5C93E5C80B@san.sea.corp.google.com>
References: <20110818220756.5C93E5C80B@san.sea.corp.google.com>
Content-Type: text/plain; charset="UTF-8"
Date: Fri, 19 Aug 2011 08:49:45 -0400
Message-ID: <1313758185.16299.43.camel@mojatatu>
Mime-Version: 1.0
X-Mailer: Evolution 2.28.3
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 2011-08-18 at 15:07 -0700, San Mehat wrote:
> TL;DR
> -----
> In this RFC we propose the introduction of the concept of hardware socket
> offload to the Linux kernel. Patches will accompany this RFC in a few days,
> but we felt we had enough on the design to solicit constructive discussion
> from the community at-large.
> 

[..]

> ALTERNATIVE STRATEGIES
> ----------------------
> 
> An alternative strategy for providing similar functionality involves either
> modifying glibc or using LD_PRELOAD tricks to intercept socket calls. We were
> forced to rule this out due to the complexity (and fragility) involved with
> attempting to maintain a general solution compatible across various
> distributions where platform-libraries differ.

Above should have been in your TL;DR;->

LD_PRELOAD is also horrible because of the granularity of the socket
calls;
Having things in the kernel and specifically tagging socket as needing
this feature is much much more manageable.

Tying things to virtualization may miss the big picture because there
are many other use cases for intercepting socket calls, example:
Samir Bellabes <sam@synack.fr> has been trying to get what he refers to
as "personal firewall" (equivalent to the silly windows firewall) which
prompts the user "ping from blah, do you want to allow a response?"
That requires intercepting send/recv calls, prompt the user in possibly
some pop-up and act based on response. It requires looking at content.
He is trying to use selinux for that interface,
but i think this would be the right abstraction.
I hope you plan to support send/recv.
I also hope you add support for SOCK_RAW (and maybe SOCK_PACKET).

Q: If you want this to be transparent to the apps, who/what is doing
the tagging of SOCK_HWASSIST? clearly not the app if you dont want to
change it.

I like the uri abstraction if it doesnt come at the expense of the
app transparency.

cheers,
jamal

