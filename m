Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752562Ab2F2V4i (ORCPT <rfc822;w@1wt.eu>);
	Fri, 29 Jun 2012 17:56:38 -0400
Received: from mga01.intel.com ([192.55.52.88]:29887 "EHLO mga01.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751054Ab2F2V4h convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 29 Jun 2012 17:56:37 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.71,315,1320652800"; 
   d="scan'208";a="186767582"
From: "Boie, Andrew P" <andrew.p.boie@intel.com>
To: NeilBrown <neilb@suse.de>
CC: "gregkh@linuxfoundation.org" <gregkh@linuxfoundation.org>,
        "ccross@android.com" <ccross@android.com>,
        "arve@android.com" <arve@android.com>,
        "rebecca@android.com" <rebecca@android.com>,
        "devel@driverdev.osuosl.org" <devel@driverdev.osuosl.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Subject: RE: [PATCH] bcb: Android bootloader control block driver
Thread-Topic: [PATCH] bcb: Android bootloader control block driver
Thread-Index: AQHNVi6IYvF8HUl+QUidlx/DSCdfp5cSRFmA//+O1YA=
Date: Fri, 29 Jun 2012 21:56:36 +0000
Message-ID: <2E57EB624252DB47AFBC064A9AFBA980077EE18B@ORSMSX105.amr.corp.intel.com>
References: <1340998590-23042-1-git-send-email-andrew.p.boie@intel.com>
 <20120630072519.71835f43@notabene.brown>
In-Reply-To: <20120630072519.71835f43@notabene.brown>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
x-originating-ip: [10.22.254.139]
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 8BIT
MIME-Version: 1.0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

> From: NeilBrown [mailto:neilb@suse.de]
> Sent: Friday, June 29, 2012 2:25 PM
> 
> On Fri, 29 Jun 2012 12:36:30 -0700 Andrew Boie <andrew.p.boie@intel.com>
> wrote:
> 
> > Android userspace tells the kernel that it wants to boot into recovery
> > or some other non-default OS environment by passing a string argument
> > to reboot(). It is left to the OEM to hook this up to their specific
> > bootloader.

> Maybe I'm missing something obvious, but why does this need to be
> implemented
> in the kernel?  Can't some user-space process just write to that partition
> using open/read/seek/write/close before calling 'reboot'.

Thanks for reviewing. The way Android is currently designed, all calls to reboot the system into an alternate target go into android_reboot() in libcutils which then make the reboot() system call with a string argument. How this is actually done on a particular board is not specified in the Android Open Source Project as far as I can see. The particular bootloader is not specified either, many different ones are being used in practice.

Not  every architecture is going to be using the Bootloader Control Block to handle these boots into alternate targets. For example, I worked on one Android-based device that didn't have a traditional bootloader at all and the reboot hook in the kernel was radically different. In this case the BCB ended up only being used by the recovery console to stash its command line arguments.

 If this were all done in userspace, then I think there would have to be separate code paths in libcutils for different board implementations of this policy. As of right now libcutils doesn't have any hardware-specific stuff in it and the mechanism to effect these policies is left to the kernel, libcutils works everywhere without modification.

Regards,
Andrew
