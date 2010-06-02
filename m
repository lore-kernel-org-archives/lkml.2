Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932701Ab0FBS7c (ORCPT <rfc822;w@1wt.eu>);
	Wed, 2 Jun 2010 14:59:32 -0400
Received: from mga11.intel.com ([192.55.52.93]:49851 "EHLO mga11.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S932629Ab0FBS7a convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 2 Jun 2010 14:59:30 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.53,348,1272870000"; 
   d="scan'208";a="804181742"
From: "Williams, Mitch A" <mitch.a.williams@intel.com>
To: Frank Pan <frankpzh@gmail.com>
CC: Greg KH <greg@kroah.com>, Andrew Morton <akpm@linux-foundation.org>,
       Jesse Barnes <jbarnes@virtuousgeek.org>,
       Kenji Kaneshige <kaneshige.kenji@jp.fujitsu.com>,
       Yu Zhao <yu.zhao@intel.com>, Chris Wright <chrisw@sous-sol.org>,
       "Rafael J. Wysocki" <rjw@sisk.pl>,
       "David S. Miller" <davem@davemloft.net>,
       Matt Carlson <mcarlson@broadcom.com>,
       "linux-pci@vger.kernel.org" <linux-pci@vger.kernel.org>,
       "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Date: Wed, 2 Jun 2010 12:59:26 -0600
Subject: RE: Add a helper function in PCI IOV to get VF device
Thread-Topic: Add a helper function in PCI IOV to get VF device
Thread-Index: AcsCGqMYp5CmHsEmSSW87HSkBTw4dwAaRNAA
Message-ID: <EA929A9653AAE14F841771FB1DE5A1365FF3F8D431@rrsmsx501.amr.corp.intel.com>
References: <AANLkTimTm57fvumRXo9pegOY2M78mduBsClwYlmAOzpo@mail.gmail.com>
 	<20100601183920.GB19955@kroah.com>
 <EA929A9653AAE14F841771FB1DE5A1365FF3EC130E@rrsmsx501.amr.corp.intel.com>
 <AANLkTinmxW5gQUOYJgK67Dc1FdakeXSmuu1hExKKL1qk@mail.gmail.com>
In-Reply-To: <AANLkTinmxW5gQUOYJgK67Dc1FdakeXSmuu1hExKKL1qk@mail.gmail.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
acceptlanguage: en-US
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 8BIT
MIME-Version: 1.0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

>-----Original Message-----
>From: Frank Pan [mailto:frankpzh@gmail.com]

>
>I'm not talking about PF's pci device, because PF
>driver knows it. I'm talking about VF's.
>The root cause is PF cannot get VF's bdf, so it has
>no idea where VF is. IMO it's abnormal.
>
>Make symlinks is just a use case. When a userspace
>app only knows VF's bdf, it has no idea how to get
>into the VF's interface-like directories.
>(/sys/class/net/ethX/vf[1-7])
>Because of:
>1. Userspace app cannot get PF's bdf from VF's bdf
>2. Userspace app cannot guess the interface name of
>pf(ethX)
>So a symlink from /sys/bus/pci/devices/xxxxx to
>/sys/class/net/ethX/vf[1-7] is useful.
>This is a real issue.
>

Frank, I'm not sure what you're trying to accomplish here. All of the information you need is already in sysfs. Given the PF device, you can look at /sys/class/net/ethX/device/virtfnX to get the bus/device/function of each of the VF devices.

If the VF driver is loaded in your kernel, then given the bus/device/function of the vf device, you can look at /sys/class/net/ethX/device/virtfnX/net to see which interface corresponds to that VF.

Furthermore, if the VF driver is loaded, you can find the PF device by looking at /sys/class/net/ethX/device/physfn, and you can find out which interface it is by looking at /sys/class/net/ethX/device/physfn/net

So it's all there. You don't need anything else.

The current PF drivers (both ixgbe and igb) do not directly manipulate sysfs at all, so there is no /sys/class/net/ethX/vfX. If you see this setup, you are using a very, very old version of the igb driver, which is not supported at all. Please upgrade to a recent kernel/driver combination.

-Mitch


>Thanks for reply.
>
>--
>Frank Pan
>
>Computer Science and Technology
>Tsinghua University
