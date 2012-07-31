Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755641Ab2GaQZo (ORCPT <rfc822;w@1wt.eu>);
	Tue, 31 Jul 2012 12:25:44 -0400
Received: from mga03.intel.com ([143.182.124.21]:42199 "EHLO mga03.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755558Ab2GaQZn (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 31 Jul 2012 12:25:43 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.71,315,1320652800"; 
   d="scan'208";a="175339310"
Subject: Re: [patch] x86, avx: don't use avx instructions with "noxsave"
 boot param
From: Suresh Siddha <suresh.b.siddha@intel.com>
Reply-To: Suresh Siddha <suresh.b.siddha@intel.com>
To: "H. Peter Anvin" <hpa@zytor.com>
Cc: NeilBrown <neilb@suse.de>, james.t.kukunas@linux.intel.com,
        LKML <linux-kernel@vger.kernel.org>
Date: Tue, 31 Jul 2012 09:27:01 -0700
In-Reply-To: <7b101443-b8d7-4474-ab54-03692d232469@email.android.com>
References: <1343688375.3696.597.camel@sbsiddha-desk.sc.intel.com>
	 <20120731142049.7d0ab5f9@notabene.brown>
	 <7b101443-b8d7-4474-ab54-03692d232469@email.android.com>
Organization: Intel Corp
Content-Type: text/plain; charset="UTF-8"
X-Mailer: Evolution 3.0.3 (3.0.3-1.fc15) 
Content-Transfer-Encoding: 7bit
Message-ID: <1343752022.3696.602.camel@sbsiddha-desk.sc.intel.com>
Mime-Version: 1.0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 2012-07-30 at 21:33 -0700, H. Peter Anvin wrote:
> I'm wondering if we shouldn't just kill the affected CPUID bits if osxsave is off...

Yes, I considered clearing AVX bit (and any future xsave feature bits)
as part of the parsing "noxsave" parameter in x86_xsave_setup().

But thought checking for osxsave was more explicit and there are not
many places using avx code. Also, this follows the SDM guidelines and
sets a nice precedent for someone (app's) to follow in future.

I am ok either way!

thanks,
suresh



