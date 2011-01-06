Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753316Ab1AFLca (ORCPT <rfc822;w@1wt.eu>);
	Thu, 6 Jan 2011 06:32:30 -0500
Received: from novprvlin0050.provo.novell.com ([137.65.248.33]:37461 "EHLO
	novprvlin0050.provo.novell.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752915Ab1AFLc2 (ORCPT
	<rfc822;groupwise-jlee@novell.com:6:1>);
	Thu, 6 Jan 2011 06:32:28 -0500
Message-Id: <4D2642F40200002300026856@novprvlin0050.provo.novell.com>
X-Mailer: Novell GroupWise Internet Agent 8.0.2 
Date: Thu, 06 Jan 2011 04:32:20 -0700
From: "Joey Lee" <jlee@novell.com>
To: <kangkai.yin@linux.intel.com>
Cc: <corentin.chary@gmail.com>, <bing.wei.liu@intel.com>,
        <yong.y.wang@intel.com>, "Gary Lin" <GLin@novell.com>,
        <mjg@redhat.com>, <linux-kernel@vger.kernel.org>,
        <platform-driver-x86@vger.kernel.org>
Subject: Re: [PATCH] platform-driver-x86: ACPI EC Extra driver for
 Oaktrail
References: <20110106025949.GJ9496@kai-debian>
 <AANLkTi=B1XeBTogjVPWqOSFgJMD72gTpNZgg4znAR0t3@mail.gmail.com>
 <20110106105003.GO9496@kai-debian>
 <AANLkTimyz5VQPwRucrmfKsQtC3sA58mCZKWJNJrZLGhq@mail.gmail.com>
In-Reply-To: <AANLkTimyz5VQPwRucrmfKsQtC3sA58mCZKWJNJrZLGhq@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Content-Disposition: inline
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Yin Kangkai, 

於 四，2011-01-06 於 11:54 +0100，Corentin Chary 提到：
> On Thu, Jan 6, 2011 at 11:50 AM, Yin Kangkai
> <kangkai.yin@linux.intel.com> wrote:
> > On 2011-01-06, 08:29 +0100, Corentin Chary wrote:
> >> > + * gps - GPS subsystem enabled: contains either 0 or 1. (rw)
> >> > + * wifi - WiFi subsystem enabled: contains either 0 or 1. (rw)
> >> > + * wwan - WWAN (3G) subsystem enabled: contains either 0 or 1. (rw)
> >>
> >> Is there a reason do add these files in /sys/devices/platform while the
> >> functionality is already provided by rfkill ?
> >
> > This is not the same functionality.
> >
> > enable/disable using files in /sys/devices/platform will completely
> > cut power of those components. For example, if disabled, you can not
> > list out those components using lsusb. Can we achieve this using
> > rfkill?
> >
> 
> oh, sorry then, I didn't understood that.
> 
> So, you're lucky, you can control both the device and the radio. I'm
> not sure what's
> the best thing to do here, you can probably keep these files here.
> 
> CCing Matthew, he may have something to say about that.
> 
> 

We should used rfkill to provide interface to userland for
enable/disable wlan/bluetooth/wwan. You can set the killswitch state to
soft block when your driver call EC function to disable devices.

Udev/HAL will forward the killswitch change event to userland, then
userland application can do some response, e.g. show up OSD.
And, userland app also can control killswitch by /dev/rfkill.

There also have a urfkill daemon to provide DBus to userland app for
control killswitch:
 http://freedesktop.org/wiki/Software/urfkill

Use rfkill interface is more standard then create special sysfs file
in /sys/devices/platform/intel_oaktrail. 


Thank's a lot!
Joey Lee


