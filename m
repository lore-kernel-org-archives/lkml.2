Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754382Ab2FTHK7 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 20 Jun 2012 03:10:59 -0400
Received: from wolverine01.qualcomm.com ([199.106.114.254]:63833 "EHLO
	wolverine01.qualcomm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752367Ab2FTHK5 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 20 Jun 2012 03:10:57 -0400
X-IronPort-AV: E=McAfee;i="5400,1158,6747"; a="202783788"
X-IronPort-AV: E=Sophos;i="4.77,440,1336374000"; 
   d="scan'208";a="121435188"
Date: Wed, 20 Jun 2012 12:42:10 +0530
From: Rajkumar Manoharan <rmanohar@qca.qualcomm.com>
To: Michael Leun <lkml20120218@newton.leun.net>
CC: Mohammed Shafi <shafi.wireless@gmail.com>,
        <linux-wireless@vger.kernel.org>, <linux-kernel@vger.kernel.org>
Subject: Re: ath9k_htc: Every 2nd packet 1000ms delayed in recent kernels
Message-ID: <20120620071208.GA9619@vmraj-lnx.qca.qualcomm.com>
References: <20120619085137.337838c0@xenia.leun.net>
 <CAD2nsn1b6in_yA1b+o=SoXD3iJPddoF4PeCQ3qhFNWqfZxq8pQ@mail.gmail.com>
 <20120620003315.2eaf6460@xenia.leun.net>
 <20120620061303.GA8738@vmraj-lnx.qca.qualcomm.com>
 <20120620085515.421571e1@xenia.leun.net>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Disposition: inline
In-Reply-To: <20120620085515.421571e1@xenia.leun.net>
User-Agent: Mutt/1.5.21 (2010-09-15)
X-Originating-IP: [172.30.48.1]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Jun 20, 2012 at 08:55:15AM +0200, Michael Leun wrote:
> On Wed, 20 Jun 2012 11:43:05 +0530
> Rajkumar Manoharan <rmanohar@qca.qualcomm.com> wrote:
> 
> > On Wed, Jun 20, 2012 at 12:33:15AM +0200, Michael Leun wrote:
> > > On Tue, 19 Jun 2012 15:11:38 +0530
> > > Mohammed Shafi <shafi.wireless@gmail.com> wrote:
> > > 
> > > > Hi,
> > > > 
> > > > On Tue, Jun 19, 2012 at 12:21 PM, Michael Leun
> > > > <lkml20120218@newton.leun.net> wrote:
> > > > > Hi,
> > > > >
> > > > > ne-wlan1@elektra:/home/ml4> ping 192.168.2.1
> > > > > PING 192.168.2.1 (192.168.2.1) 56(84) bytes of data.
> > > > > 64 bytes from 192.168.2.1: icmp_seq=1 ttl=64 time=2010 ms
> > > > > 64 bytes from 192.168.2.1: icmp_seq=2 ttl=64 time=1011 ms
> > > > > 64 bytes from 192.168.2.1: icmp_seq=3 ttl=64 time=11.5 ms
> > > > > 64 bytes from 192.168.2.1: icmp_seq=4 ttl=64 time=1.12 ms
> > > > > 64 bytes from 192.168.2.1: icmp_seq=5 ttl=64 time=1002 ms
> > > > > 64 bytes from 192.168.2.1: icmp_seq=6 ttl=64 time=3.83 ms
> > > > > 64 bytes from 192.168.2.1: icmp_seq=7 ttl=64 time=1003 ms
> > > > > 64 bytes from 192.168.2.1: icmp_seq=8 ttl=64 time=4.10 ms
> > > > > 64 bytes from 192.168.2.1: icmp_seq=9 ttl=64 time=1003 ms
> > > > > 64 bytes from 192.168.2.1: icmp_seq=10 ttl=64 time=3.95 ms
> > > > > 64 bytes from 192.168.2.1: icmp_seq=11 ttl=64 time=1003 ms
> > > > > 64 bytes from 192.168.2.1: icmp_seq=12 ttl=64 time=3.78 ms
> > > > >
> > > > >
> > > > > Please note the additional delay of ~1000ms every 2nd packet.
> > > > > This is Kernel 3.4.3, have seen it in 3.4.2 also. Does NOT
> > > > > happen in 3.3.1.
> > > > >
> > > > > Is this Issue already known? If so, I can save the work
> > > > > bisecting...
> > > > 
> > > > looks like some one reported this bug in kernel bugzilla. would be
> > > > saving us lot of time
> > > > if you can bisect it!
> > > > 
> > > 
> > > 0775f9f90cdaf40fbf69b3192b3dddb2b3436f45 is the first bad commit
> > > commit 0775f9f90cdaf40fbf69b3192b3dddb2b3436f45
> > > Author: Johannes Berg <johannes.berg@intel.com>
> > > Date:   Thu Mar 8 15:02:06 2012 +0100
> > > 
> > >     mac80211: remove spurious BSSID change flag
> > > 
> > >     The BSSID has been set a lot earlier already and
> > >     didn't change again in ieee80211_set_associated().
> > > 
> > >     Signed-off-by: Johannes Berg <johannes.berg@intel.com>
> > >     Signed-off-by: John W. Linville <linville@tuxdriver.com>
> > > 
> > > :040000 040000 67a19a39e4b04c16921a3758ddd2362e02e81dd3
> > > 4a7cbd327b59345b83fa613f893770fbf44220bb M      net
> > > 
> > > Reverting 0775f9f90cdaf40fbf69b3192b3dddb2b3436f45 from 3.4.3 fixes
> > > the issue.
> > > 
> > Michael,
> > 
> > Thanks for the analysis. Can you please try with the attached patch
> > without reverting mac80211 change?
> 
> [forgotten attachment was added in later mail]
> 
> Yes, that also solves the issue. I guess, you will look into getting
> that into mainline and stable asap?
> 
Thanks Michael. I already posted the patch to l-w.
http://comments.gmane.org/gmane.linux.kernel.wireless.general/93099

-Rajkumar
