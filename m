Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755375Ab1A1STq (ORCPT <rfc822;w@1wt.eu>);
	Fri, 28 Jan 2011 13:19:46 -0500
Received: from mx1.redhat.com ([209.132.183.28]:58587 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755149Ab1A1STo (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 28 Jan 2011 13:19:44 -0500
Subject: Re: [PATCH] System Wide Capability Bounding Set
From: Eric Paris <eparis@redhat.com>
To: Steve Grubb <sgrubb@redhat.com>
Cc: "Andrew G. Morgan" <morgan@kernel.org>, linux-kernel@vger.kernel.org,
        "Serge E. Hallyn" <serge@canonical.com>,
        "Serge E. Hallyn" <serge.hallyn@canonical.com>,
        linux-security-module@vger.kernel.org
Date: Fri, 28 Jan 2011 13:19:27 -0500
In-Reply-To: <201101271150.17120.sgrubb@redhat.com>
References: <1294266337.3237.45.camel@localhost.localdomain>
	 <201101270942.07689.sgrubb@redhat.com>
	 <AANLkTi=k5QeE_-iNuW3-M5K3BnBtRxk-QYO5624HKrpE@mail.gmail.com>
	 <201101271150.17120.sgrubb@redhat.com>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 7bit
Message-ID: <1296238768.2567.18.camel@localhost.localdomain>
Mime-Version: 1.0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 2011-01-27 at 11:50 -0500, Steve Grubb wrote:
> On Thursday, January 27, 2011 11:35:13 am Andrew G. Morgan wrote:
> > > Today, people want to have multi-tenant hosting using virtual
> > > machines whereby they give away root control of the guest VM.
> > > If you were renting system space, you would expect root access.
> > > That would make a nice juicy hacking target because you don't know
> > > who else is sharing the physical machine with you and they might
> > > have something in their VM worth stealing.
> > 
> > Which root filesystem (/) do kernel helpers run in in such a virtual setup?
> 
> I would assume that root in the VM could umount and mount anything. Or bind mount over 
> it. We really want any change to a global bounding set done before initrd finishes 
> doing its thing. This way there is no chance for mischief by the time control is 
> turned over to /sbin/init - which root controls.

I feel like we are all starting to understand the problem.  It still
leaves me with the belief that the only 2 known ways to solve it are

1) global bounding set which bounds the pP = fI & pI rule, unlike the
per process bset

2) a mechanism to drop caps from the bset and pI of the kthread which
runs helper apps

Do others see another way?

-Eric

