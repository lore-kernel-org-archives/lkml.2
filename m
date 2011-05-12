Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757431Ab1ELOBl (ORCPT <rfc822;w@1wt.eu>);
	Thu, 12 May 2011 10:01:41 -0400
Received: from 75.98.165.80.static.a2webhosting.com ([75.98.165.80]:45586 "EHLO
	greenroomsoftware.com" rhost-flags-OK-FAIL-OK-OK) by vger.kernel.org
	with ESMTP id S1752293Ab1ELOBk (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 12 May 2011 10:01:40 -0400
Message-ID: <4DCBE83C.2080403@greenroomsoftware.com>
Date: Thu, 12 May 2011 07:01:32 -0700
From: Robert Gordon <robert@greenroomsoftware.com>
User-Agent: Mozilla/5.0 (X11; U; Linux i686; en-US; rv:1.9.2.17) Gecko/20110424 Thunderbird/3.1.10
MIME-Version: 1.0
To: maximilian attems <max@stro.at>
CC: Nuno Subtil <subtil@gmail.com>, Michal Marek <mmarek@suse.cz>,
        linux-kbuild@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH 1/1] deb-pkg: fix cross-compile build
References: <1304488750-13606-1-git-send-email-subtil@gmail.com> <20110504204807.GB13293@sepie.suse.cz> <20110505090728.GC30678@vostochny.stro.at> <4DC2C568.9090803@greenroomsoftware.com> <BANLkTinjBun=TzjveEiJsEJYKH_+NRCP7Q@mail.gmail.com> <4DC2EB2B.1050203@greenroomsoftware.com> <BANLkTimApO4j-Hsvo2OCc=PnEdOhHu76OA@mail.gmail.com> <20110510124123.GE13278@vostochny.stro.at>
In-Reply-To: <20110510124123.GE13278@vostochny.stro.at>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
X-AntiAbuse: This header was added to track abuse, please include it with any abuse report
X-AntiAbuse: Primary Hostname - a2s60.a2hosting.com
X-AntiAbuse: Original Domain - vger.kernel.org
X-AntiAbuse: Originator/Caller UID/GID - [47 12] / [47 12]
X-AntiAbuse: Sender Address Domain - greenroomsoftware.com
X-Source: 
X-Source-Args: 
X-Source-Dir: 
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 05/10/2011 05:41 AM, maximilian attems wrote:
> On Mon, May 09, 2011 at 10:29:22PM -0700, Nuno Subtil wrote:
>> It looks like your patch duplicates the arch detection logic that's
>> already in create_package, except not completely. I think this is not
>> desirable.
>>
>> I modified your patch to isolate this logic into a separate function
>> and respect the KBUILD_DEBARCH override (which mostly means I moved
>> the original logic into a separate function). This should make your
>> case work as well, besides respecting the KBUILD_DEBARCH override.
>>
>> Maks, Michal, can you please take a look at this new patch?
> thanks doing right now.
>
> Michal please hold off until I have time to give it some runs.
>
I have tested this patch.  It builds fine for arm with the following
command:
fakeroot make ARCH=arm CROSS_COMPILE=arm-linux-gnueabi- deb-pkg

However x86_64 fails (when using an i386 machine).
fakeroot make ARCH=x86_64 deb-pkg

The error occurs in scripts/package/builddeb
+ forcearch=-DArchitecture=amd64
+ dpkg-gencontrol -isp -DArchitecture=amd64 -plinux-headers-2.6.39-rc7+
-P/opt/kernel-linus/linux-2.6/debian/hdrtmp
dpkg-gencontrol: error: current host architecture 'i386' does not appear
in package's architecture list (amd64)

The debian/control file is as follows:
cat debian/control
Source: linux-upstream
Section: kernel
Priority: optional
Maintainer: Anonymous <root@robert-VGN-Z690Y>
Standards-Version: 3.8.4
Homepage: http://www.kernel.org/

Package: linux-image-2.6.39-rc7+
Provides: linux-image, linux-image-2.6, linux-modules-2.6.39-rc7+
Suggests: linux-firmware-image
Architecture: any
Description: Linux kernel, version 2.6.39-rc7+
 This package contains the Linux kernel, modules and corresponding other
 files, version: 2.6.39-rc7+.

Package: linux-headers-2.6.39-rc7+
Provides: linux-headers, linux-headers-2.6
Architecture: amd64
Description: Linux kernel headers for 2.6.39-rc7+ on amd64
 This package provides kernel header files for 2.6.39-rc7+ on amd64
 .
 This is useful for people who need to build external modules



The debian/control file for an unpatched scripts/package/builddeb would
assign 'i386' instead of 'amd64'.

Regards,
Robert

