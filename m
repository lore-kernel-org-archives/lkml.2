Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932108Ab0I1Bdl (ORCPT <rfc822;w@1wt.eu>);
	Mon, 27 Sep 2010 21:33:41 -0400
Received: from mga09.intel.com ([134.134.136.24]:21234 "EHLO mga09.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754244Ab0I1Bdk (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 27 Sep 2010 21:33:40 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.57,244,1283756400"; 
   d="scan'208";a="558533319"
Subject: Re: [PATCH -v2 3/7] x86, NMI, Rename memory parity error to PCI
 SERR error
From: Huang Ying <ying.huang@intel.com>
To: Robert Richter <robert.richter@amd.com>
Cc: Don Zickus <dzickus@redhat.com>, Ingo Molnar <mingo@elte.hu>,
        "H. Peter Anvin" <hpa@zytor.com>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        Andi Kleen <andi@firstfloor.org>
In-Reply-To: <20100927164502.GS13563@erda.amd.com>
References: <1285549026-5008-1-git-send-email-ying.huang@intel.com>
	 <1285549026-5008-3-git-send-email-ying.huang@intel.com>
	 <20100927080106.GA32222@erda.amd.com>
	 <1285576760.20791.70.camel@yhuang-dev>
	 <20100927090056.GJ13563@erda.amd.com> <20100927153315.GB26290@redhat.com>
	 <20100927164502.GS13563@erda.amd.com>
Content-Type: text/plain; charset="UTF-8"
Date: Tue, 28 Sep 2010 09:33:37 +0800
Message-ID: <1285637617.20791.146.camel@yhuang-dev>
Mime-Version: 1.0
X-Mailer: Evolution 2.30.2 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 2010-09-28 at 00:45 +0800, Robert Richter wrote:
> > > > Ok. I will add CPU ID in message. Because we know the reason, I don't
> > > > think we need the reason in message.
> > > 
> > > You only know that bit 7 is set, not the rest. As this is an error
> > > message we should provide as much information as possible.
> > 
> > Well, what other info do we know besides that bit being set?  (I wish we
> > had more, but I don't think we do)
> 
> We should keep printing the reason byte as it did before.

The reason is printed before because mem_parity_error is treated as
something like unknown reason. And iochk_error is treated as known
reason and will not print the reason byte. Please the check the original
code.

But now we treat pci_serr_error (renamed from mem_parity_error) as known
reason. So it is not necessary to print the reason byte. I suggest to
print the reason byte only if (!(reason & 0xc0) && reason), where the
reason is really unknown.

Best Regards,
Huang Ying


