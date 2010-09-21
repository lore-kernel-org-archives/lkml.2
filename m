Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757659Ab0IUAWc (ORCPT <rfc822;w@1wt.eu>);
	Mon, 20 Sep 2010 20:22:32 -0400
Received: from mga09.intel.com ([134.134.136.24]:42710 "EHLO mga09.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755400Ab0IUAWb (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 20 Sep 2010 20:22:31 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.56,396,1280732400"; 
   d="scan'208";a="556459650"
Subject: Re: [RFC 3/6] x86, NMI, Rename memory parity error to PCI SERR
 error
From: Huang Ying <ying.huang@intel.com>
To: Borislav Petkov <borislav.petkov@amd.com>
Cc: Robert Richter <robert.richter@amd.com>, Ingo Molnar <mingo@elte.hu>,
        "H. Peter Anvin" <hpa@zytor.com>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        Andi Kleen <andi@firstfloor.org>, Doug Thompson <norsk5@yahoo.com>
In-Reply-To: <20100920125929.GA5349@kryptos.osrc.amd.com>
References: <1284087065-32722-1-git-send-email-ying.huang@intel.com>
	 <1284087065-32722-3-git-send-email-ying.huang@intel.com>
	 <20100913010248.GH21909@erda.amd.com>
	 <1284343326.3269.70.camel@yhuang-dev.sh.intel.com>
	 <20100916081806.GV13563@erda.amd.com>
	 <1284682105.32373.11.camel@yhuang-dev>
	 <20100917091454.GL13563@erda.amd.com>
	 <1284855635.32373.298.camel@yhuang-dev>
	 <20100920080010.GM13563@erda.amd.com>
	 <20100920125929.GA5349@kryptos.osrc.amd.com>
Content-Type: text/plain; charset="UTF-8"
Date: Tue, 21 Sep 2010 08:22:28 +0800
Message-ID: <1285028548.21059.43.camel@yhuang-dev>
Mime-Version: 1.0
X-Mailer: Evolution 2.30.2 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 2010-09-20 at 20:59 +0800, Borislav Petkov wrote:
> From: Robert Richter <robert.richter@amd.com>
> Date: Mon, Sep 20, 2010 at 10:00:10AM +0200
> 
> (adding Doug to CC)
> 
> > On 18.09.10 20:20:35, Huang Ying wrote:
> > > > If I am not wrong the only real functional change is to rip out the
> > > > edac handler. So, just introduce the final names with your renaming in
> > > > patch #1 (and maybe make a comment in the commit message or change
> > > > patch order).
> > > 
> > > If I merge the 1/6 and 3/6, can you suggest a patch subject, "Add symbol
> > > definition for NMI magic constants and rename memory parity to PCI
> > > SERR"?
> > 
> > Yes, maybe we make the edac change a separate one.
> 
> What is more, there are a bunch of edac drivers using the PCI SERR nmi
> as a means to check for PCI errors so we shouldn't be removing it now,
> should we?

After checking the source, I found in mem_parity_error (will renamed to
pci_serr_error), edac_atomic_assert_error() is called, which increase
edac_err_assert, edac_err_assert is used in
edac_mc_assert_error_check_and_clear(), which is used in
edac_mc_workq_function for memory error only, not for PCI errors.

Do we really need PCI SERR NMI for memory errors?

Best Regards,
Huang Ying


