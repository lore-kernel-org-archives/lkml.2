Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757883Ab2AKR0c (ORCPT <rfc822;w@1wt.eu>);
	Wed, 11 Jan 2012 12:26:32 -0500
Received: from mx1.redhat.com ([209.132.183.28]:17843 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S933643Ab2AKR01 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 11 Jan 2012 12:26:27 -0500
Date: Wed, 11 Jan 2012 12:25:44 -0500
From: Don Zickus <dzickus@redhat.com>
To: Chen Gong <gong.chen@linux.intel.com>
Cc: Seiji Aguchi <seiji.aguchi@hds.com>, "Luck, Tony" <tony.luck@intel.com>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        Matthew Garrett <mjg@redhat.com>, Vivek Goyal <vgoyal@redhat.com>,
        "Chen, Gong" <gong.chen@intel.com>,
        "akpm@linux-foundation.org" <akpm@linux-foundation.org>,
        "Brown, Len" <len.brown@intel.com>,
        "'ying.huang@intel.com'" <'ying.huang@intel.com'>,
        "'ak@linux.intel.com'" <'ak@linux.intel.com'>,
        "'hughd@chromium.org'" <'hughd@chromium.org'>,
        "'mingo@elte.hu'" <'mingo@elte.hu'>,
        "jmorris@namei.org" <jmorris@namei.org>,
        "a.p.zijlstra@chello.nl" <a.p.zijlstra@chello.nl>,
        "namhyung@gmail.com" <namhyung@gmail.com>,
        "dle-develop@lists.sourceforge.net" 
	<dle-develop@lists.sourceforge.net>,
        Satoru Moriya <satoru.moriya@hds.com>
Subject: Re: [RFC][PATCH v4 -next 1/4] Move kmsg_dump(KMSG_DUMP_PANIC) below
 smp_send_stop()
Message-ID: <20120111172544.GS5650@redhat.com>
References: <5C4C569E8A4B9B42A84A977CF070A35B2C5827AF7F@USINDEVS01.corp.hds.com>
 <5C4C569E8A4B9B42A84A977CF070A35B2C5827AF81@USINDEVS01.corp.hds.com>
 <3908561D78D1C84285E8C5FCA982C28FBB21@ORSMSX104.amr.corp.intel.com>
 <5C4C569E8A4B9B42A84A977CF070A35B2C5827B01D@USINDEVS01.corp.hds.com>
 <20120105210123.GI5650@redhat.com>
 <5C4C569E8A4B9B42A84A977CF070A35B2C5827BBD8@USINDEVS01.corp.hds.com>
 <4F0BAB33.2090201@linux.intel.com>
 <5C4C569E8A4B9B42A84A977CF070A35B2C583163B0@USINDEVS01.corp.hds.com>
 <4F0D3A0B.4090709@linux.intel.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <4F0D3A0B.4090709@linux.intel.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Jan 11, 2012 at 03:28:11PM +0800, Chen Gong wrote:
> 于 2012/1/11 4:29, Seiji Aguchi 写道:
> >
> >>I agree with you. How about adding macros or something like WARN_ON(XX_ARCH) or
> >>Kconfig to limit its scope?
> >
> >Thank you for giving me your idea.
> >Your suggestions above will work for me because I'm a x86 user.
> >If Tony agrees to it, I can update my patch.
> >
> >But, I'm hesitating to add WARN_ON() or change Kconfig only for specific arch
> >because pstore aims for generic interface and this is related to its design.
> >Also, ramoops is going to use pstore now. It doesn't depend on x86.
> >I'm worried that ramoops users will complain about this change.
> >
> >So, I think a reasonable solution at this time is just adding some explanations
> >about smp_send_stop() to documentation as follows.
> >
> >Users can use pstore with their own responsibility and ask developers
> >if smp_send_stop() is reliable enough in panic situation on architecture they want to run.
> >
> >What do you think?
> >
> >---
> >  Documentation/ABI/testing/pstore |    8 ++++++++
> >  1 files changed, 8 insertions(+), 0 deletions(-)
> >
> >diff --git a/Documentation/ABI/testing/pstore b/Documentation/ABI/testing/pstore
> >index ff1df4e..5583729 100644
> >--- a/Documentation/ABI/testing/pstore
> >+++ b/Documentation/ABI/testing/pstore
> >@@ -11,6 +11,14 @@ Description:	Generic interface to platform dependent persistent storage.
> >  		of the console log is captured, but other interesting
> >  		data can also be saved.
> >
> >+		In case of panic, pstore is invoked after smp_send_stop()
> >+		,a function call stopping other cpus, so that we can get
> >+		logs simpler and cleaner with just one running cpu.
> >+
> >+		As for x86, smp_send_stop() is reliable enough to work in
> >+		panic situation. But we are not guaranteed that it works
> >+		reliably on other architectures.
> >+
> >  		# mount -t pstore -o kmsg_bytes=8000 - /dev/pstore
> >
> >  		$ ls -l /dev/pstore
> 
> The explanation is great. but In my opinion, I still insist that
> a WARN_ON() is necessary. What do you think, Tony and Don?

I guess I still don't understand why.  Who uses kmsg_dump besides x86?  It
seems like there was only 3 or 4 subsystems that were registering.

Cheers,
Don

