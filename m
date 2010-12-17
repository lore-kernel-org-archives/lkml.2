Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754884Ab0LQOGd (ORCPT <rfc822;w@1wt.eu>);
	Fri, 17 Dec 2010 09:06:33 -0500
Received: from mga09.intel.com ([134.134.136.24]:24049 "EHLO mga09.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754813Ab0LQOGc (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 17 Dec 2010 09:06:32 -0500
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.59,361,1288594800"; 
   d="scan'208";a="688167036"
Subject: Re: [BUG]x86: relocatable doesn't work with new binutils
From: Shaohua Li <shaohua.li@intel.com>
To: =?ISO-8859-1?Q?Am=E9rico?= Wang <xiyou.wangcong@gmail.com>
Cc: "H. Peter Anvin" <hpa@zytor.com>, lkml <linux-kernel@vger.kernel.org>,
        Andrew Morton <akpm@linux-foundation.org>,
        "Lu, Hongjiu" <hongjiu.lu@intel.com>,
        "Huang, Ying" <ying.huang@intel.com>
In-Reply-To: <20101217100559.GB8413@cr0.nay.redhat.com>
References: <1292553726.2323.482.camel@sli10-conroe>
	 <4D0AD1F9.7030704@zytor.com> <1292556114.2323.484.camel@sli10-conroe>
	 <20101217100559.GB8413@cr0.nay.redhat.com>
Content-Type: text/plain; charset="UTF-8"
Date: Fri, 17 Dec 2010 22:06:13 +0800
Message-ID: <1292594773.1746.2.camel@shli-laptop>
Mime-Version: 1.0
X-Mailer: Evolution 2.28.3 
Content-Transfer-Encoding: 8bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, 2010-12-17 at 18:05 +0800, Américo Wang wrote:
> On Fri, Dec 17, 2010 at 11:21:54AM +0800, Shaohua Li wrote:
> >On Fri, 2010-12-17 at 10:59 +0800, H. Peter Anvin wrote:
> >> On 12/16/2010 06:42 PM, Shaohua Li wrote:
> >> > We can easily workaround this issue by moving jiffies to a section or at
> >> > least warn people if such binutils are using. what should we do?
> >> 
> >> I think we should do the workaround, but still get distros to update the
> >> broken binutils.
> >Here is my workaround.
> >The problem is a lot of kernel versions are affected by this, fix all?
> >
> >
> >
> >The CONFIG_RELOCATABLE is broken with new binutils, which will make boot
> >panic. According to Lu Hongjiu, the affected binutils are from
> >2.20.51.0.12 to 2.21.51.0.3, which are release since Oct 22 this year.
> >At least ubuntu 10.10 is using such binutils. see:
> >http://sourceware.org/bugzilla/show_bug.cgi?id=12327
> >The reason of boot panic is we have 'jiffies = jiffies_64;' in
> >vmlinux.lds.S. The jiffies isn't in any section. In kernel build, there
> >is warning saying jiffies is an absolute address and can't be
> >relocatable. At runtime, jiffies will have virtual address 0.
> >
> 
> Just curious, what change in binutils caused this?
I'm not familiar with binutils, please check the bugzilla.

>  And what build
> warning did you see? Section mismatch warning?
Something like this: WARNING: Absolute relocations present

Thanks,
Shaohua

