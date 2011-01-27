Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752657Ab1A0Quv (ORCPT <rfc822;w@1wt.eu>);
	Thu, 27 Jan 2011 11:50:51 -0500
Received: from mx1.redhat.com ([209.132.183.28]:3298 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752023Ab1A0Qut (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 27 Jan 2011 11:50:49 -0500
From: Steve Grubb <sgrubb@redhat.com>
Organization: Red Hat
To: "Andrew G. Morgan" <morgan@kernel.org>
Subject: Re: [PATCH] System Wide Capability Bounding Set
Date: Thu, 27 Jan 2011 11:50:16 -0500
User-Agent: KMail/1.13.5 (Linux/2.6.35.10-74.fc14.x86_64; KDE/4.5.5; x86_64; ; )
Cc: Eric Paris <eparis@redhat.com>, linux-kernel@vger.kernel.org,
        "Serge E. Hallyn" <serge@canonical.com>,
        "Serge E. Hallyn" <serge.hallyn@canonical.com>,
        linux-security-module@vger.kernel.org
References: <1294266337.3237.45.camel@localhost.localdomain> <201101270942.07689.sgrubb@redhat.com> <AANLkTi=k5QeE_-iNuW3-M5K3BnBtRxk-QYO5624HKrpE@mail.gmail.com>
In-Reply-To: <AANLkTi=k5QeE_-iNuW3-M5K3BnBtRxk-QYO5624HKrpE@mail.gmail.com>
MIME-Version: 1.0
Content-Type: Text/Plain;
  charset="iso-8859-15"
Content-Transfer-Encoding: 7bit
Message-Id: <201101271150.17120.sgrubb@redhat.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thursday, January 27, 2011 11:35:13 am Andrew G. Morgan wrote:
> > Today, people want to have multi-tenant hosting using virtual
> > machines whereby they give away root control of the guest VM.
> > If you were renting system space, you would expect root access.
> > That would make a nice juicy hacking target because you don't know
> > who else is sharing the physical machine with you and they might
> > have something in their VM worth stealing.
> 
> Which root filesystem (/) do kernel helpers run in in such a virtual setup?

I would assume that root in the VM could umount and mount anything. Or bind mount over 
it. We really want any change to a global bounding set done before initrd finishes 
doing its thing. This way there is no chance for mischief by the time control is 
turned over to /sbin/init - which root controls.

-Steve
