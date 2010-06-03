Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933745Ab0FCDLn (ORCPT <rfc822;w@1wt.eu>);
	Wed, 2 Jun 2010 23:11:43 -0400
Received: from mail-px0-f174.google.com ([209.85.212.174]:48896 "EHLO
	mail-px0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S933579Ab0FCDLl (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 2 Jun 2010 23:11:41 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=mime-version:in-reply-to:references:from:date:message-id:subject:to
         :cc:content-type;
        b=PZ+T1+lymmtkAoPgLKVI9iG27JMSZWixAgo9sA/loGOkIY9ygIXeQDBH4PExVNDZRT
         DUdgrkNVwevexbFfZ8VWGUKbbmuNNqSslgBreJuqBZYAUV4c2lUHVupISlnhhFPQvLtT
         CmOXp3pkNvCWZSw733DlJzVs9V1x/LFR8cJf0=
MIME-Version: 1.0
In-Reply-To: <AANLkTilDY61GMGNLezXYLbbe3B8-SvgMOK5L9Q6juETL@mail.gmail.com>
References: <AANLkTimTm57fvumRXo9pegOY2M78mduBsClwYlmAOzpo@mail.gmail.com> 
	<20100601183920.GB19955@kroah.com> <EA929A9653AAE14F841771FB1DE5A1365FF3EC130E@rrsmsx501.amr.corp.intel.com> 
	<AANLkTinmxW5gQUOYJgK67Dc1FdakeXSmuu1hExKKL1qk@mail.gmail.com> 
	<EA929A9653AAE14F841771FB1DE5A1365FF3F8D431@rrsmsx501.amr.corp.intel.com> 
	<AANLkTilDY61GMGNLezXYLbbe3B8-SvgMOK5L9Q6juETL@mail.gmail.com>
From: Frank Pan <frankpzh@gmail.com>
Date: Thu, 3 Jun 2010 11:11:21 +0800
Message-ID: <AANLkTilh4P9pcC53J7An3TioIPNk7LAwp9zq1R7jwiCx@mail.gmail.com>
Subject: Re: Add a helper function in PCI IOV to get VF device
To: "Williams, Mitch A" <mitch.a.williams@intel.com>
Cc: Greg KH <greg@kroah.com>, Andrew Morton <akpm@linux-foundation.org>,
       Jesse Barnes <jbarnes@virtuousgeek.org>,
       Kenji Kaneshige <kaneshige.kenji@jp.fujitsu.com>,
       Yu Zhao <yu.zhao@intel.com>, Chris Wright <chrisw@sous-sol.org>,
       "Rafael J. Wysocki" <rjw@sisk.pl>,
       "David S. Miller" <davem@davemloft.net>,
       Matt Carlson <mcarlson@broadcom.com>,
       "linux-pci@vger.kernel.org" <linux-pci@vger.kernel.org>,
       "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

> So, when VF has no interface, this path is also unavailable. That's
> why I say given vf's bdf, one cannot infer pf's.

Sorry I just missed something. Userspace can find pf's bdf by physfn.

So, the motivation is provide some information about vf from pf driver by sysfs.

I cannot avoid to create one directory for each vf, like vf0, vf1,
etc. Although userspace can find these directories, but it has no idea
about which one to use. Userspace just knows vf's bdf, it won't care
about/know vf's id. So I have the issue to create a symlink from each
vf's /sys/bus/pci/devices/xxxx/ to their corresponding directories.

And then comes the issue: PF cannot get VF's bdf in kernel space.

This is not a strange issue, hacking every SR-IOV device can met.

Thanks.

-- 
Frank Pan

Computer Science and Technology
Tsinghua University
