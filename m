Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755531Ab2FFJoN (ORCPT <rfc822;w@1wt.eu>);
	Wed, 6 Jun 2012 05:44:13 -0400
Received: from mtaout02-winn.ispmail.ntl.com ([81.103.221.48]:37167 "EHLO
	mtaout02-winn.ispmail.ntl.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752403Ab2FFJoL (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 6 Jun 2012 05:44:11 -0400
From: Steven Newbury <steve@snewbury.org.uk>
Reply-To: Steven Newbury <steve@snewbury.org.uk>
To: Yinghai Lu <yinghai@kernel.org>, Bjorn Helgaas <bhelgaas@google.com>
Cc: "H. Peter Anvin" <hpa@zytor.com>, David Miller <davem@davemloft.net>,
        Tony Luck <tony.luck@intel.com>,
        Linus Torvalds <torvalds@linux-foundation.org>,
        Andrew Morton <akpm@linux-foundation.org>, linux-pci@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH 02/11] PCI: Try to allocate mem64 above 4G at first
X-Mailer: Modest 3.90.7
References: <1337754877-19759-1-git-send-email-yinghai@kernel.org>
	 <CAE9FiQXx_x9M5ncLk4DyL8heYQTcsHZt2JofFMjPfUd4mympeA@mail.gmail.com>
	 <CAE9FiQX=ECg5BmKm7B2ua_rZ6bOsceeHNsfFQRWBbNZx+8sBfw@mail.gmail.com>
	 <20120525043651.GA1391@google.com>
	 <CAE9FiQXvYH4zCqp_uOb2nw7jvm8B=q3yx1tCjJUT+PkdymYEuw@mail.gmail.com>
	 <CAE9FiQW0rm2_sKdSCWs3TfatJB9yHwvmvt9_vBYMtOq_YBbmfw@mail.gmail.com>
	 <20120525193716.GA8817@google.com>
	 <CAE9FiQWrZaBpT1fzC_-mSBfDd4AKGrdGomPxVNSU-SFPrVNvOw@mail.gmail.com>
	 <CAErSpo7d+zn-qgWKcbro7yneXRtmZQCOHi+kiGzYUTfs+aiF4g@mail.gmail.com>
	 <CAE9FiQUWWO75WP3gYRwYbyO_ZiWwyjKnzMxOGhfjY4H98w2Hbw@mail.gmail.com>
	 <CAErSpo46fCCFCijNfMzGYP__pP6hkPFurMS=1=wSAZsg5z0-Lg@mail.gmail.com>
	 <CAE9FiQWUrkKEpLmEn9kzkKOtEtX7-R8shdVSKGgSyHezKpzJCw@mail.gmail.com>
	 <4FC50E09.4000204@zytor.com>
	 <CAE9FiQUtio=dut3A9+jCcsgUWEeNYcpqLP6RpqGOZUfPPAtHWw@mail.gmail.com>
	 <4FC51D79.6010804@zytor.com>
	 <CAE9FiQUWMAdU5jtKfq1_=1E-574gW-Afo8Pby49mUFQYFrs9Pw@mail.gmail.com>
	 <4FC536A5.6020600@zytor.com>
	 <CAE9FiQXi23-mY6p2Dr1EJmukhTSPxvBGtjvQ8wyJYPDS+6o5ZA@mail.gmail.com>
	 <CAErSpo67h_mdZtoEn-W_OOXZ8m7gs3g6Q25kte285ZX=2FKf+A@mail.gmail.com>
	 <CAE9FiQV7jpBWkcXy2vgixnxx2fhid28Wj0iHAhGkVVdQn6epNQ@mail.gmail.com>
	 <CAErSpo7ivA4NpTv8jT=sxe9qAEZZ89qm6km+WBGq1UZK1Uhz8A@mail.gmail.com>
	  <CAE9FiQWbET=awz9o=6JBwonv_obe5KzRPNXjowNtFWrN3_4T_w@mail.gmail.com>
In-Reply-To: <CAE9FiQWbET=awz9o=6JBwonv_obe5KzRPNXjowNtFWrN3_4T_w@mail.gmail.com>
Content-Type: text/plain; charset=utf-8
Content-ID: <1338975851.5858.1.camel@Nokia-N900>
Date: Wed, 06 Jun 2012 10:44:12 +0100
Message-Id: <1338975852.5858.2.camel@Nokia-N900>
Mime-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Cloudmark-Analysis: v=1.1 cv=JvdXmxIgLJv2/GthKqHpGJEEHukvLcvELVXUanXFreg= c=1 sm=0 a=btQ-OHYhoqkA:10 a=IkcTkHD0fZMA:10 a=xqWC_Br6kY4A:10 a=VwQbUJbxAAAA:8 a=36jSYyUSviaCCpPEuTUA:9 a=QEXdDO2ut3YA:10 a=LI9Vle30uBYA:10 a=HpAAvcLHHh0Zw7uRqdWCyQ==:117
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue,   5 Jun 2012, 06:04:57 BST, Yinghai Lu <yinghai@kernel.org> wrote:
> > Linux has a long history of allocating bottom-up.  Windows has a long
> > history of allocating top-down.  You're proposing a third alternative,
> > allocating bottom-up starting at 4GB for 64-bit BARs.  If we change
> > this area, I would prefer something that follows Windows because I
> > think it will be closer to what's been tested by Windows.  Do you
> > think your alternative is better?
> 
> hope we can figure out how windows is making it work.
> 
> Steve, Can you check if Windows is working with your test case ?
> 
> If it works, we may try do the same thing from Linux, so you will not
> need to append "pci=nocrs pci=alloc_high"...
> 
Unfortunately I don't have a 64 bit version of Windows to test with.  Vista(32 bit) fails to even boot when docked, hot-plugging fails to allocate resources, but at least doesn't crash.

>From what I've read about the (64 bit) Windows allocation stragegy it's closer to Yinghai's method than the Linux default, preferring 64 bit resources (>4G) when possible.  I'll try to find the specification document again.
