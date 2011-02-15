Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754043Ab1BOArw (ORCPT <rfc822;w@1wt.eu>);
	Mon, 14 Feb 2011 19:47:52 -0500
Received: from hqemgate04.nvidia.com ([216.228.121.35]:8662 "EHLO
	hqemgate04.nvidia.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753862Ab1BOArl convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 14 Feb 2011 19:47:41 -0500
X-PGP-Universal: processed;
	by hqnvupgp04.nvidia.com on Mon, 14 Feb 2011 16:47:39 -0800
From: Andrew Chew <AChew@nvidia.com>
To: "'Erik Gilling'" <konkers@android.com>
CC: "linux-tegra@vger.kernel.org" <linux-tegra@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "ccross@android.com" <ccross@android.com>,
        "olof@lixom.net" <olof@lixom.net>
Date: Mon, 14 Feb 2011 16:47:34 -0800
Subject: RE: [PATCH 1/1] [tegra] Make syncpt routines accessible by drivers
Thread-Topic: [PATCH 1/1] [tegra] Make syncpt routines accessible by drivers
Thread-Index: AcvMpmf2QItRyKQ7SJa1uVIFB7HRxQAAr/4Q
Message-ID: <643E69AA4436674C8F39DCC2C05F763816BD96CFB2@HQMAIL03.nvidia.com>
References: <1297726034-32762-1-git-send-email-achew@nvidia.com>
	<AANLkTinvpo=R1pjvykEZVXV08D+uXLJa=R8CDcMFWWpT@mail.gmail.com>
	<643E69AA4436674C8F39DCC2C05F763816BD96CFB1@HQMAIL03.nvidia.com>
 <AANLkTin+uxnM-u7N-+aXUzGVm7m2eXZKrenDbRPq1V-W@mail.gmail.com>
In-Reply-To: <AANLkTin+uxnM-u7N-+aXUzGVm7m2eXZKrenDbRPq1V-W@mail.gmail.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
acceptlanguage: en-US
Content-Type: text/plain; charset="iso-8859-1"
Content-Transfer-Encoding: 8BIT
MIME-Version: 1.0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

> Yeah, including the relative path was a bit of a hack since the nvhost
> drivers needs some serious work before it's upstreamable.  A "right"
> way to do this is to have the syncpt functions take an nvhost_device
> pointer (or create helper functions that do that,) then expose those
> functions in mach/nvhost.h.  This obviates the need for a global
> nvhost_sycpt pointer.
> 
> -Erik

You're right about that global nvhost_syncpt pointer.  That drives me nuts as well.  Nevertheless, I'm not sure I'm knowledgeable enough to do the required work to do this the "right" way.  As far as I know, nvhost is a guaranteed singleton in practice (not in implementation), so while this is ugly, it will work fine for existing projects.

Can we use nvmap as precedent and do it this way for now?  I'd like to get the V4L2 camera host driver up to the Tegra community as soon as possible.  When the problem is solved for the dc driver, I can adapt that to the V4L2 camera host driver.

> On Mon, Feb 14, 2011 at 4:08 PM, Andrew Chew <AChew@nvidia.com> wrote:
> >> If you want to use syncpts you should be an nvhost_driver 
> link the dc.
> >
> > Looking at drivers/video/tegra/dc, I notice that it gets 
> access to the syncpt functions by using a relative path 
> (../host/dev.h) to include dev.h, which in turn includes 
> nvhost_syncpt.h (in drivers/video/tegra/host).  Is this proper form?
> >
> > This syncpt access is for a Tegra V4L2 driver, which will 
> live in drivers/media/video.  I was trying to avoid using 
> relative paths for #includes.  I assumed that the header 
> files in drivers/video/tegra/host were not meant to be 
> publicly available to other drivers, which is why I looked 
> for some precedent in how nvhost functions were made 
> available to other kernel drivers, hence I modeled this after nvmap.
> 