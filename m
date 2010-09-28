Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753426Ab0I1PjL (ORCPT <rfc822;w@1wt.eu>);
	Tue, 28 Sep 2010 11:39:11 -0400
Received: from mx1.redhat.com ([209.132.183.28]:34650 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751401Ab0I1PjK (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 28 Sep 2010 11:39:10 -0400
Date: Tue, 28 Sep 2010 11:38:54 -0400
From: Don Zickus <dzickus@redhat.com>
To: Huang Ying <ying.huang@intel.com>
Cc: Robert Richter <robert.richter@amd.com>, Ingo Molnar <mingo@elte.hu>,
        "H. Peter Anvin" <hpa@zytor.com>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        Andi Kleen <andi@firstfloor.org>
Subject: Re: [PATCH -v2 3/7] x86, NMI, Rename memory parity error to PCI SERR
 error
Message-ID: <20100928153854.GM26290@redhat.com>
References: <1285549026-5008-1-git-send-email-ying.huang@intel.com>
 <1285549026-5008-3-git-send-email-ying.huang@intel.com>
 <20100927080106.GA32222@erda.amd.com>
 <1285576760.20791.70.camel@yhuang-dev>
 <20100927090056.GJ13563@erda.amd.com>
 <20100927153315.GB26290@redhat.com>
 <20100927164502.GS13563@erda.amd.com>
 <1285637617.20791.146.camel@yhuang-dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1285637617.20791.146.camel@yhuang-dev>
User-Agent: Mutt/1.5.20 (2009-08-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Sep 28, 2010 at 09:33:37AM +0800, Huang Ying wrote:
> On Tue, 2010-09-28 at 00:45 +0800, Robert Richter wrote:
> > > > > Ok. I will add CPU ID in message. Because we know the reason, I don't
> > > > > think we need the reason in message.
> > > > 
> > > > You only know that bit 7 is set, not the rest. As this is an error
> > > > message we should provide as much information as possible.
> > > 
> > > Well, what other info do we know besides that bit being set?  (I wish we
> > > had more, but I don't think we do)
> > 
> > We should keep printing the reason byte as it did before.
> 
> The reason is printed before because mem_parity_error is treated as
> something like unknown reason. And iochk_error is treated as known
> reason and will not print the reason byte. Please the check the original
> code.
> 
> But now we treat pci_serr_error (renamed from mem_parity_error) as known
> reason. So it is not necessary to print the reason byte. I suggest to
> print the reason byte only if (!(reason & 0xc0) && reason), where the
> reason is really unknown.

So you are just matching the iochk_error.  I understand your reasoning.
Yesterday I thought you changed the unknown_nmi_error code.  I guess I
don't see it as a problem, but I'll let Robert chime in.

Cheers,
Don
