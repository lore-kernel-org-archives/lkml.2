Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754662Ab1HUN2p (ORCPT <rfc822;w@1wt.eu>);
	Sun, 21 Aug 2011 09:28:45 -0400
Received: from mail6.webfaction.com ([74.55.86.74]:60241 "EHLO
	smtp.webfaction.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754216Ab1HUN2o (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 21 Aug 2011 09:28:44 -0400
Subject: Re: RFC: [Restatement] KBUS messaging subsystem
Mime-Version: 1.0 (Apple Message framework v1084)
Content-Type: text/plain; charset=us-ascii
From: Tony Ibbs <tibs@tonyibbs.co.uk>
In-Reply-To: <CAOJsxLEg-9hAQG99TkM+tqdTjZkpZwubOu1qM-6m7B5apZmh_w@mail.gmail.com>
Date: Sun, 21 Aug 2011 14:28:39 +0100
Cc: lkml <linux-kernel@vger.kernel.org>,
        Andrew Morton <akpm@linux-foundation.org>,
        Jonathan Corbet <corbet@lwn.net>,
        Florian Fainelli <florian@openwrt.org>,
        Grant Likely <grant.likely@secretlab.ca>,
        Linux-embedded <linux-embedded@vger.kernel.org>,
        Tibs at Kynesim <tibs@kynesim.co.uk>,
        Richard Watts <rrw@kynesim.co.uk>
Content-Transfer-Encoding: 7bit
Message-Id: <1825A697-7D60-44D0-8150-BC0E9F0DEB67@tonyibbs.co.uk>
References: <cover.1300450604.git.tibs@tonyibbs.co.uk> <201105171050.38903.florian@openwrt.org> <37F5AF18-99E5-4516-B31F-00F7BD348ADE@tonyibbs.co.uk> <201107061815.36294.florian@openwrt.org> <5F531701-B760-45F0-989D-669013409FE8@tonyibbs.co.uk> <CAOJsxLFSdPO2ebjM9W9JaNcX80COzn=Y3hFukXZjn+1yY4ivZQ@mail.gmail.com> <63D130AC-E6DF-4A61-BB69-30212D238F37@tonyibbs.co.uk> <CAOJsxLEg-9hAQG99TkM+tqdTjZkpZwubOu1qM-6m7B5apZmh_w@mail.gmail.com>
To: Pekka Enberg <penberg@kernel.org>
X-Mailer: Apple Mail (2.1084)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


On 15 Aug 2011, at 12:46, Pekka Enberg wrote:

> Hi Tony,

Hi. Thanks for your reply

> On Sun, Aug 7, 2011 at 11:24 PM, Tony Ibbs <tibs@tonyibbs.co.uk> wrote:
>> Real examples of usage that aren't the STB are a bit difficult to give
>> because they belong to customer projects that we're not allowed to
>> talk about.
> 
> That's part of the problem, I suppose. We usually don't merge new
> kernel facilities unless we're able to understand (and see) real
> applications that need them.

I understand. It is a bit of a chicken-and-egg problem.

> On Sun, Aug 7, 2011 at 11:24 PM, Tony Ibbs <tibs@tonyibbs.co.uk> wrote:
>> I assume the real point of your post is that I wrote about the reasons
>> why we made KBUS a kernel module, but did not really address the
>> reasons why KBUS might want to be a kernel module in general usage.
> 
> I simply don't see a convincing argument why existing IPC and other
> kernel mechanisms are not sufficient to implement what you need. I'm
> sure there is one but it's not apparent from your emails.

Our major concern, strongly based on experience, is that given the
existing kernel mechanisms, users do not build robust (or even
sometimes working!) solutions for inter-process communication.

This is in large part because they do not realise (at the start) how
difficult this is to do. Especially if they want to keep it small.

The only *sure* way of solving this is to provide a mechanism that is
"always there", and that really means a solution provided by the
kernel. This needs to be at a higher level than what is currently
available, but obviously what exactly is provided is then a matter for
discussion. We'd obviously argue that KBUS hits a "sweet spot" for the
needs we perceive, given our application areas.

> The whole thing feels more like "lets put a message broker into the
> kernel" rather than set of kernel APIs that make sense. I suppose the
> rather extensive ioctl() ABI is partly to blame here.

I'm not sure what you mean by "message broker", except that it's
plainly meant to be a bad thing - the wikipedia meaning doesn't seem
terribly applicable to KBUS, as it covers an awful lot more territory
(mind, the discussion page is amusing).

I'll freely admit we started with the idea of what functionality we
wanted and then chose a simple-to-implement API to make it happen.

*If* KBUS were in the kernel, with its current functionality, what API
would you expect? (not just "a sockety one", but what actual API?) If
one recasts as a sockety API, how is many new socket options better
than a set of ioctls? (or is that just one of those questions to which
the answer is "well, it is"?)

> I'm not saying you need to implement everything in userspace but I'm
> also not convinced we want _all of this_ in the kernel.

That's quite understandable. So, given the functionality we want, what
would you put in the kernel, and what in userspace? (I'm personally
sceptical about how much can be split this way, but still)

(I realise that both this and the previous question are asking you to
do work, but I'm honestly hoping that even if KBUS-as-is is not
applicable, we might figure out an irreducible set of higher level
constructs than those which are currently present which will attack
the problem we wrote KBUS to attack.)

Tibs

