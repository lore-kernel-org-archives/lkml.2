Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755482Ab0IQPr1 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 17 Sep 2010 11:47:27 -0400
Received: from smtp-outbound-1.vmware.com ([65.115.85.69]:19750 "EHLO
	smtp-outbound-1.vmware.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1754133Ab0IQPr0 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 17 Sep 2010 11:47:26 -0400
From: Dmitry Torokhov <dtor@vmware.com>
Organization: VMware, Inc.
To: Chetan Loke <chetanloke@gmail.com>
Subject: Re: additional esx events (was Re: [PATCH] VMware Balloon: rename module)
Date: Fri, 17 Sep 2010 08:47:26 -0700
User-Agent: KMail/1.13.5 (Linux/2.6.36-rc4+; KDE/4.4.5; x86_64; ; )
Cc: "pv-drivers@vmware.com" <pv-drivers@vmware.com>
References: <AANLkTimFUgZoKBXk_weOG_AMtW8Y0g6Q8-QvH8hnfv8z@mail.gmail.com>
In-Reply-To: <AANLkTimFUgZoKBXk_weOG_AMtW8Y0g6Q8-QvH8hnfv8z@mail.gmail.com>
MIME-Version: 1.0
Content-Type: Text/Plain;
  charset="utf-8"
Content-Transfer-Encoding: 7bit
Message-Id: <201009170847.26491.dtor@vmware.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

[BCC-ing akpm and LKML since they are probably not interested in ESX too much]

On Thursday, September 16, 2010 07:37:24 pm Chetan Loke wrote:
> On Thu, Sep 16, 2010 at 8:31 PM, Dmitry Torokhov <dtor@vmware.com> wrote:
> 
> > There is vSphere SDK that shoudl allow you to connect to the hostd and
> > get more information about the host/VC:
> > 
> > http://www.vmware.com/support/developer/viperltoolkit/
> 
> perl API? why? vmware_balloon driver already has the hooks. So a
> parallel driver can have the same
> basic implementation. I'm not looking for any fancy notifications.
> Even if we emit sysfs nodes, it's
> perfectly fine. It will be a one-way read only channel.I am willing to test
> it.

I do not understand why we should try jamming into the kernel something that
can be implemented in userspace. Balloon is in the kernel because it is
privileged operation that affects correctness of the VM handling (if we are
told that certain page can be ballooned and it was a lie VM may crash), but
monitoring-type application can and should use different communication
channels.

Thanks.

-- 
Dmitry
