Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754493Ab0IPXXS (ORCPT <rfc822;w@1wt.eu>);
	Thu, 16 Sep 2010 19:23:18 -0400
Received: from smtp-outbound-2.vmware.com ([65.115.85.73]:3789 "EHLO
	smtp-outbound-2.vmware.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752542Ab0IPXXR (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 16 Sep 2010 19:23:17 -0400
From: Dmitry Torokhov <dtor@vmware.com>
Organization: VMware, Inc.
To: Chetan Loke <chetanloke@gmail.com>
Subject: Re: [PATCH] VMware Balloon: rename module
Date: Thu, 16 Sep 2010 16:23:14 -0700
User-Agent: KMail/1.13.5 (Linux/2.6.36-rc4+; KDE/4.4.5; x86_64; ; )
Cc: Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        "pv-drivers@vmware.com" <pv-drivers@vmware.com>,
        "akpm@linux-foundation.org" <akpm@linux-foundation.org>
References: <AANLkTikWmwVvWzRMK7yvtyqYbd4OeeR1nLsP1OAxbnJg@mail.gmail.com>
In-Reply-To: <AANLkTikWmwVvWzRMK7yvtyqYbd4OeeR1nLsP1OAxbnJg@mail.gmail.com>
MIME-Version: 1.0
Content-Type: Text/Plain;
  charset="utf-8"
Content-Transfer-Encoding: 7bit
Message-Id: <201009161623.14722.dtor@vmware.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Chetan,

On Thursday, September 16, 2010 04:05:28 pm Chetan Loke wrote:
> > From: linux-kernel-owner@vger.kernel.org [mailto:linux-kernel-
> > owner@vger.kernel.org] On Behalf Of Dmitry Torokhov
> > Sent: September 16, 2010 6:01 PM
> > To: linux-kernel@vger.kernel.org
> > Cc: pv-drivers@vmware.com; Andrew Morton
> > Subject: [PATCH] VMware Balloon: rename module
> > 
> > 
> > 
> > In an effort to minimize customer confusion we want to unify naming
> > convention for VMware-provided kernel modules. This change renames
> > the balloon driver from vmware_ballon to vmw_balloon.
> 
> What will vmtools name its vmware_balloon driver to? vmw_balloon, correct?

That is the plan.

> 
> > +	vmballoon_wq = create_freezeable_workqueue("vmmemctl");
> 
> minor change - vmware_vmmemctl?

I do not think this needs to be changed; it does not have to match
the module name, plus, given Tejun's changes, it will all be generic
[worker/u:X] soon anyway.

> 
> I might've seen a debugfs entry too.

I still plan on keeping it as "vmmemctl" so we do not have to change
scripts too often. The move in module names prompted by complaints
that name changes when user requests tools to clobber distribution-
provided modules.

> 
> 
> side note - is it possible to extend the balloon driver to get a
> notification on other events? like CPUs, NICs? Just an event is what
> I'm looking for. No action need to be taken in the guest.

No, balloon driver should be limited to ballooning. I think the data
you are looking for can be retrieved via GuestSDK (and I believe we
are adding balloon_target to the available data).

Thanks.

-- 
Dmitry
