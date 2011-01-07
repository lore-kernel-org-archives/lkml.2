Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754958Ab1AGABx (ORCPT <rfc822;w@1wt.eu>);
	Thu, 6 Jan 2011 19:01:53 -0500
Received: from mga02.intel.com ([134.134.136.20]:48524 "EHLO mga02.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753504Ab1AGABw (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 6 Jan 2011 19:01:52 -0500
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.60,285,1291622400"; 
   d="scan'208";a="694384958"
Date: Fri, 7 Jan 2011 08:01:48 +0800
From: Yin Kangkai <kangkai.yin@linux.intel.com>
To: Joey Lee <jlee@novell.com>, "corentin.chary" <corentin.chary@gmail.com>
Cc: bing.wei.liu@intel.com, yong.y.wang@intel.com, Gary Lin <GLin@novell.com>,
        mjg@redhat.com, linux-kernel@vger.kernel.org,
        platform-driver-x86@vger.kernel.org
Subject: Re: [PATCH] platform-driver-x86: ACPI EC Extra driver for Oaktrail
Message-ID: <20110107000148.GF30215@kai-debian>
References: <20110106025949.GJ9496@kai-debian>
 <AANLkTi=B1XeBTogjVPWqOSFgJMD72gTpNZgg4znAR0t3@mail.gmail.com>
 <20110106105003.GO9496@kai-debian>
 <AANLkTimyz5VQPwRucrmfKsQtC3sA58mCZKWJNJrZLGhq@mail.gmail.com>
 <4D2642F40200002300026856@novprvlin0050.provo.novell.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <4D2642F40200002300026856@novprvlin0050.provo.novell.com>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 2011-01-06, 04:32 -0700, Joey Lee wrote:
> Hi Yin Kangkai, 
> 
> 於 四，2011-01-06 於 11:54 +0100，Corentin Chary 提到：
> > On Thu, Jan 6, 2011 at 11:50 AM, Yin Kangkai
> > <kangkai.yin@linux.intel.com> wrote:
> > > On 2011-01-06, 08:29 +0100, Corentin Chary wrote:
> > >> > + * gps - GPS subsystem enabled: contains either 0 or 1. (rw)
> > >> > + * wifi - WiFi subsystem enabled: contains either 0 or 1. (rw)
> > >> > + * wwan - WWAN (3G) subsystem enabled: contains either 0 or 1. (rw)
> > >>
> > >> Is there a reason do add these files in /sys/devices/platform while the
> > >> functionality is already provided by rfkill ?
> > >
> > > This is not the same functionality.
> > >
> > > enable/disable using files in /sys/devices/platform will completely
> > > cut power of those components. For example, if disabled, you can not
> > > list out those components using lsusb. Can we achieve this using
> > > rfkill?

My fault. they are actually the same. As you can see from function
oaktrail_rfkill_set(), when you use rfkill to block a component, it
write the bit in EC space, just exactly the same as writing files in
/sys/devices/platform.. 

> > oh, sorry then, I didn't understood that.
> > 
> > So, you're lucky, you can control both the device and the radio. I'm
> > not sure what's
> > the best thing to do here, you can probably keep these files here.
> > 
> > CCing Matthew, he may have something to say about that.

Sorry Corentin Chary, for the confusion.

> We should used rfkill to provide interface to userland for
> enable/disable wlan/bluetooth/wwan. You can set the killswitch state to
> soft block when your driver call EC function to disable devices.
> 
> Udev/HAL will forward the killswitch change event to userland, then
> userland application can do some response, e.g. show up OSD.
> And, userland app also can control killswitch by /dev/rfkill.
> 
> There also have a urfkill daemon to provide DBus to userland app for
> control killswitch:
>  http://freedesktop.org/wiki/Software/urfkill
> 
> Use rfkill interface is more standard then create special sysfs file
> in /sys/devices/platform/intel_oaktrail. 

Yeah, thanks Joey and Corentin for the comments, I will remove the
interface (wifi, 3g, bt, gps) from /sys/devices/platform.

Kangkai
