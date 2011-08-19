Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755920Ab1HSO6f (ORCPT <rfc822;w@1wt.eu>);
	Fri, 19 Aug 2011 10:58:35 -0400
Received: from smtp-out.google.com ([216.239.44.51]:28729 "EHLO
	smtp-out.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754659Ab1HSO6b convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 19 Aug 2011 10:58:31 -0400
DomainKey-Signature: a=rsa-sha1; s=beta; d=google.com; c=nofws; q=dns;
	h=dkim-signature:mime-version:in-reply-to:references:date:
	message-id:subject:from:to:cc:content-type:
	content-transfer-encoding:x-system-of-record;
	b=PO9ozNRUMyOdsLyAZv5Q4auFVDNBAehz1YYoaBnVWnsvh3Id+WeiXckRLgE61u50V
	v0d1+Jqlmgkpr/59Kg7gg==
MIME-Version: 1.0
In-Reply-To: <1313758185.16299.43.camel@mojatatu>
References: <20110818220756.5C93E5C80B@san.sea.corp.google.com>
	<1313758185.16299.43.camel@mojatatu>
Date: Fri, 19 Aug 2011 07:58:29 -0700
Message-ID: <CAPi7mHp==JPA-0vNZ+xWRzOuJYUxsUL3UY=o=VtMUsB-YcFHwQ@mail.gmail.com>
Subject: Re: [RFC 0/0] Introducing a generic socket offload framework
From: San Mehat <san@google.com>
To: jhs@mojatatu.com
Cc: davem@davemloft.net, mst@redhat.com, rusty@rustcorp.com.au,
        linux-kernel@vger.kernel.org,
        virtualization@lists.linux-foundation.org, netdev@vger.kernel.org,
        digitaleric@google.com, mikew@google.com, miche@google.com,
        maccarro@google.com
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8BIT
X-System-Of-Record: true
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Aug 19, 2011 at 5:49 AM, jamal <hadi@cyberus.ca> wrote:
>
> On Thu, 2011-08-18 at 15:07 -0700, San Mehat wrote:
> > TL;DR
> > -----
> > In this RFC we propose the introduction of the concept of hardware socket
> > offload to the Linux kernel. Patches will accompany this RFC in a few days,
> > but we felt we had enough on the design to solicit constructive discussion
> > from the community at-large.
> >
>
> [..]
>
> > ALTERNATIVE STRATEGIES
> > ----------------------
> >
> > An alternative strategy for providing similar functionality involves either
> > modifying glibc or using LD_PRELOAD tricks to intercept socket calls. We were
> > forced to rule this out due to the complexity (and fragility) involved with
> > attempting to maintain a general solution compatible across various
> > distributions where platform-libraries differ.
>
> Above should have been in your TL;DR;->
>
> LD_PRELOAD is also horrible because of the granularity of the socket
> calls;
> Having things in the kernel and specifically tagging socket as needing
> this feature is much much more manageable.
>
> Tying things to virtualization may miss the big picture because there
> are many other use cases for intercepting socket calls, example:
> Samir Bellabes <sam@synack.fr> has been trying to get what he refers to
> as "personal firewall" (equivalent to the silly windows firewall) which
> prompts the user "ping from blah, do you want to allow a response?"
> That requires intercepting send/recv calls, prompt the user in possibly
> some pop-up and act based on response. It requires looking at content.
> He is trying to use selinux for that interface,
> but i think this would be the right abstraction.

I agree; there's no reason this needs to be tied to virtualization -
it was just the
driving force behind the design. I will generalize the backend interface types

> I hope you plan to support send/recv.

yes

> I also hope you add support for SOCK_RAW (and maybe SOCK_PACKET).

Can you explain a good use-case for SOCK_RAW in this type of
environment? We were noodling it around locally and couldn't come up
with one that we needed to support.

>
> Q: If you want this to be transparent to the apps, who/what is doing
> the tagging of SOCK_HWASSIST? clearly not the app if you dont want to
> change it.

The decision of whether to tag a socket or not is made by the 'hardware'

>
> I like the uri abstraction if it doesnt come at the expense of the
> app transparency.
>

Thank you

-san

> cheers,
> jamal
>



--
San Mehat | Staff Software Engineer | san@google.com | 415-366-6172
