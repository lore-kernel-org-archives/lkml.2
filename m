Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755377Ab1EEQDp (ORCPT <rfc822;w@1wt.eu>);
	Thu, 5 May 2011 12:03:45 -0400
Received: from 75.98.165.80.static.a2webhosting.com ([75.98.165.80]:57413 "EHLO
	greenroomsoftware.com" rhost-flags-OK-FAIL-OK-OK) by vger.kernel.org
	with ESMTP id S1751714Ab1EEQDo (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 5 May 2011 12:03:44 -0400
X-Greylist: delayed 1259 seconds by postgrey-1.27 at vger.kernel.org; Thu, 05 May 2011 12:03:44 EDT
Message-ID: <4DC2C568.9090803@greenroomsoftware.com>
Date: Thu, 05 May 2011 08:42:32 -0700
From: Robert Gordon <robert@greenroomsoftware.com>
User-Agent: Mozilla/5.0 (X11; U; Linux i686; en-US; rv:1.9.2.14) Gecko/20110223 Thunderbird/3.1.8
MIME-Version: 1.0
To: maximilian attems <max@stro.at>
CC: Michal Marek <mmarek@suse.cz>, Nuno Subtil <subtil@gmail.com>,
        linux-kbuild@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH 1/1] deb-pkg: fix cross-compile build
References: <1304488750-13606-1-git-send-email-subtil@gmail.com> <20110504204807.GB13293@sepie.suse.cz> <20110505090728.GC30678@vostochny.stro.at>
In-Reply-To: <20110505090728.GC30678@vostochny.stro.at>
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

On 05/05/2011 02:07 AM, maximilian attems wrote:
> On Wed, May 04, 2011 at 10:48:07PM +0200, Michal Marek wrote:
>> Adding Maks to CC.
> thanks, this one looks, good please disguard the other patch.
>  
>> On Tue, May 03, 2011 at 10:59:10PM -0700, Nuno Subtil wrote:
>>> When generating the header package, scripts/package/builddeb was inferring the
>>> target architecture by looking at the output of dpkg --print-architecture. This
>>> allows KBUILD_DEBARCH to override that.
>>>
>>> Signed-off-by: Nuno Subtil <subtil@gmail.com>
> Acked-by: maximilian attems <max@stro.at>
> --
> To unsubscribe from this list: send the line "unsubscribe linux-kbuild" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
Greetings,

Compile breaks when using the following command:
    fakeroot make ARCH=arm CROSS_COMPILE=arm-linux-gnueabi- deb-pkg

With 'set -x' in scripts/package/builddeb, the relevant output is:
    + '[' -n '' ']'
    ++ dpkg --print-architecture
    + arch=i386
This indicates that KBUILD_DEBARCH is not set.

The debian/control file is written with the following section:
    Package: linux-headers-2.6.39-rc5+
    Provides: linux-headers, linux-headers-2.6
    Architecture: i386
    Description: Linux kernel headers for 2.6.39-rc5+ on i386
     This package provides kernel header files for 2.6.39-rc5+ on i386

This produces the following error output:
    + forcearch=-DArchitecture=armel
    + dpkg-gencontrol -isp -DArchitecture=armel
-plinux-headers-2.6.39-rc5+ -P/opt/kernel-linus/linux-2.6/debian/hdrtmp
    dpkg-gencontrol: error: current host architecture 'armel' does not
appear in package's architecture list (i386)

Regards,
Robert

