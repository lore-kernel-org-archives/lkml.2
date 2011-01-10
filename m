Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752455Ab1AJNwL (ORCPT <rfc822;w@1wt.eu>);
	Mon, 10 Jan 2011 08:52:11 -0500
Received: from mx1.redhat.com ([209.132.183.28]:6219 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751066Ab1AJNwJ (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 10 Jan 2011 08:52:09 -0500
Date: Mon, 10 Jan 2011 11:50:53 -0200
From: Marcelo Tosatti <mtosatti@redhat.com>
To: Zachary Amsden <zamsden@redhat.com>, Juan Quintela <quintela@redhat.com>
Cc: kvm@vger.kernel.org, Avi Kivity <avi@redhat.com>,
        Glauber Costa <glommer@redhat.com>, linux-kernel@vger.kernel.org
Subject: Re: [KVM TSC trapping / migration 2/2] Add TSC KHZ MSR
Message-ID: <20110110135053.GA12991@amt.cnet>
References: <1294308645-31113-1-git-send-email-zamsden@redhat.com>
 <1294308645-31113-3-git-send-email-zamsden@redhat.com>
 <20110107104859.GA12056@amt.cnet>
 <4D277B24.5000409@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <4D277B24.5000409@redhat.com>
User-Agent: Mutt/1.5.20 (2009-08-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Jan 07, 2011 at 10:44:20AM -1000, Zachary Amsden wrote:
> On 01/07/2011 12:48 AM, Marcelo Tosatti wrote:
> >On Thu, Jan 06, 2011 at 12:10:45AM -1000, Zachary Amsden wrote:
> >>Use an MSR to allow "soft" migration to hosts which do not support
> >>TSC trapping.  Rather than make this a required element of any
> >>migration protocol, we allow the TSC rate to be exported as a data
> >>field (useful in its own right), but we also allow a one time write
> >>of the MSR during VM creation.  The result is that for the common
> >>use case, no protocol change is required to communicate TSC rate
> >>to the receiving host.
> >Migration to hosts which do not support the feature can be achieved by
> >saving/restoring the TSC rate + flags in a subsection. A subsection
> >seems more appropriate than an MSR for this.
> 
> Yes, I looked at that, but it looked to me like a subsection was
> intended for an optional feature which MUST be present on the
> destination if the source is using the feature.  This way, newer
> hosts without the feature enabled can migrate to older hosts which
> do not support the feature.

Right. But you can use a subsection to achieve the same effect. Just
consider that the source is not using the feature if you want to migrate
to an older host without support for it. Juan, is there a problem to
use subsections in this fashion?

With the MSR scheme, there is no way for management to enforce support
of the feature on the destination (at least not that i can see). And 
you create an MSR that does not exist on real hardware.

> 
> The TSC rate migration is slightly different; we may wish to migrate
> from a host with the TSC rate feature enabled to a host which does
> not support the TSC rate feature.  This is exactly the current
> behavior, the TSC rate will change on that migration, and I wanted
> to preserve that behavior.  I don't advise that mode of usage, but
> there may be use cases for it and it should be decided by policy,
> not dictated by our feature set.
> 
> That said, I'm happy to remove the MSR if we truly don't want to
> support that mode of usage.

