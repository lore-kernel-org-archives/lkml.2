Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756278Ab0GBAIS (ORCPT <rfc822;w@1wt.eu>);
	Thu, 1 Jul 2010 20:08:18 -0400
Received: from wolverine01.qualcomm.com ([199.106.114.254]:41291 "EHLO
	wolverine01.qualcomm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756085Ab0GBAIN (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 1 Jul 2010 20:08:13 -0400
X-IronPort-AV: E=McAfee;i="5400,1158,6030"; a="46234397"
Subject: Re: Closed source userspace graphics drivers with an open source 
 kernel component
From: Daniel Walker <dwalker@codeaurora.org>
To: Dave Airlie <airlied@gmail.com>
Cc: LKML <linux-kernel@vger.kernel.org>,
       dri-devel <dri-devel@lists.freedesktop.org>,
       linux-arm-msm@vger.kernel.org, jcrouse@codeaurora.org
In-Reply-To: <AANLkTilGdNgWIprJ2XZ2gSv2d-DVybGmb9phcboi4fNL@mail.gmail.com>
References: <AANLkTikfYwkxF5CXgt-fGMIYTlcmt99lOz_VyA3Kr-4R@mail.gmail.com>
	 <AANLkTimgH-DiQyg0f-an5FS3Wyb2b6He3fxxB1L8Ziol@mail.gmail.com>
	 <1278024678.7738.54.camel@c-dwalke-linux.qualcomm.com>
	 <AANLkTinNrpcBg0TXTS78qaI5kPQKD-IbnLpDStu4_BIg@mail.gmail.com>
	 <1278026975.7738.89.camel@c-dwalke-linux.qualcomm.com>
	 <AANLkTilGdNgWIprJ2XZ2gSv2d-DVybGmb9phcboi4fNL@mail.gmail.com>
Content-Type: text/plain; charset="UTF-8"
Date: Thu, 01 Jul 2010 17:08:04 -0700
Message-ID: <1278029284.7738.116.camel@c-dwalke-linux.qualcomm.com>
Mime-Version: 1.0
X-Mailer: Evolution 2.28.3 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, 2010-07-02 at 09:37 +1000, Dave Airlie wrote:

> > Oh, man .. It seems like any driver model that straddles userspace and
> > kernel space is kind of asking for trouble (my opinion anyway)..
> >
> > Would you accept a userspace component that supported some subset of the
> > features ? You would have a kernel space driver, and userspace both open
> > source and GPL'd , but the userspace component wouldn't support ever
> > feature available .. Then the company would be free to make another
> > proprietary userspace with more features based off the open source one.
> >
> 
> That starts to get a bit more towards useful, except you still run
> into the problem of what happens if community developers start adding
> features to the open driver, that conflict with  features in the
> closed code. We'd also have to be very careful about what interfaces
> the kernel exposed had corresponding code in userspace. i.e. adding
> "special" ioctls for the closed bits would be a disaster, all such
> ioctls would need open users for verification and testing.

Ok .. The open userspace would just be like any other project, but
whatever company pushed the driver would likely maintain the userspace
component .. So the maintainer would have to handle the conflicts
between the proprietary vs. open source sides of it.

Actually , now that I think about it the biggest problem is the license
of the userspace side.. Whatever company makes this would have to be
able to relicense it and actually make a proprietary userspace.. So the
userspace license would be really critical.. Either that or no one
outside the company that pushed the driver could make code changes to
the userspace side..

> So for example, if you have a kernel KMS/DRM driver, and it set the
> hardware up, but then you had an open 2D driver and a closed 3D
> driver, you would have to make sure there was no functionality in the
> kernel that only the 3D driver used as it would become impossible to
> openly validate it.

Ok. I'm not sure how crazy that would be to setup, but it doesn't seem
like it would be that hard to just abstract the various components of
the driver.

> The other issue I see with a lot of these, is the driver are presented
> as this is the kernel driver, these APIs are set in stone as we have
> binary userspaces already deployed, this is even more unacceptable,
> since we need to be able to change the interface and do proper driver
> design before merging what looks like crap thrown together in a pile
> and made to stick.

This seems really wild to me .. Your talking about how you change the
kernel space side and you need to be able to change the userspace side
to match right ?

Where does the userspace side of these driver live? Not in the kernel
right?

Daniel

-- 
Sent by a consultant of the Qualcomm Innovation Center, Inc.
The Qualcomm Innovation Center, Inc. is a member of the Code Aurora Forum.

