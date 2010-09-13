Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754221Ab0IMCTw (ORCPT <rfc822;w@1wt.eu>);
	Sun, 12 Sep 2010 22:19:52 -0400
Received: from mga02.intel.com ([134.134.136.20]:22934 "EHLO mga02.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753832Ab0IMCTv (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 12 Sep 2010 22:19:51 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.56,357,1280732400"; 
   d="scan'208";a="553864393"
Subject: Re: [RFC 5/6] x86, NMI, Add support to notify hardware error with
 unknown NMI
From: Huang Ying <ying.huang@intel.com>
To: Don Zickus <dzickus@redhat.com>
Cc: Andi Kleen <andi@firstfloor.org>, Ingo Molnar <mingo@elte.hu>,
        "H. Peter Anvin" <hpa@zytor.com>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
In-Reply-To: <20100910184039.GK4879@redhat.com>
References: <1284087065-32722-1-git-send-email-ying.huang@intel.com>
	 <1284087065-32722-5-git-send-email-ying.huang@intel.com>
	 <20100910160211.GH4879@redhat.com>
	 <20100910181929.4f35ab7c@basil.nowhere.org>
	 <20100910184039.GK4879@redhat.com>
Content-Type: text/plain; charset="UTF-8"
Date: Mon, 13 Sep 2010 10:19:49 +0800
Message-ID: <1284344389.3269.82.camel@yhuang-dev.sh.intel.com>
Mime-Version: 1.0
X-Mailer: Evolution 2.30.2 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sat, 2010-09-11 at 02:40 +0800, Don Zickus wrote:
> On Fri, Sep 10, 2010 at 06:19:29PM +0200, Andi Kleen wrote:
> > 
> > > I am grasping for straws here, but is there a register that APEI/HEST
> > > can poke to see if it generated the NMI?
> > 
> > HEST knows this yes.
> > 
> > But this is not about HEST errors, but about those without HEST
> > handling.
> 
> Don't most unknown NMIs fall into the same boat, that they were not being
> handled properly?

As far as I know, at least on some platforms, unknown NMIs are used for
hardware error reporting. They will cause "Blue Screen" in Windows.

> On the other hand could you use the die_notifier_chain(DIE_UNKNOWNNMI) for
> the same purpose and keep the unknown_nmi_error() handler a little
> cleaner?

I think explicit function call has better readability than notifier
chain.

Best Regards,
Huang Ying


