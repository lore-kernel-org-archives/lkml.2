Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760512Ab0I1ByY (ORCPT <rfc822;w@1wt.eu>);
	Mon, 27 Sep 2010 21:54:24 -0400
Received: from mga11.intel.com ([192.55.52.93]:29616 "EHLO mga11.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1757071Ab0I1ByX (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 27 Sep 2010 21:54:23 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.57,244,1283756400"; 
   d="scan'208";a="611038263"
Subject: Re: [PATCH -v2 6/7] x86, NMI, Add support to notify hardware error
 with unknown NMI
From: Huang Ying <ying.huang@intel.com>
To: Don Zickus <dzickus@redhat.com>
Cc: Ingo Molnar <mingo@elte.hu>, "H. Peter Anvin" <hpa@zytor.com>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        Andi Kleen <andi@firstfloor.org>
In-Reply-To: <20100927153804.GC26290@redhat.com>
References: <1285549026-5008-1-git-send-email-ying.huang@intel.com>
	 <1285549026-5008-6-git-send-email-ying.huang@intel.com>
	 <20100927153804.GC26290@redhat.com>
Content-Type: text/plain; charset="UTF-8"
Date: Tue, 28 Sep 2010 09:54:21 +0800
Message-ID: <1285638861.20791.153.camel@yhuang-dev>
Mime-Version: 1.0
X-Mailer: Evolution 2.30.2 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 2010-09-27 at 23:38 +0800, Don Zickus wrote:
> Hi Huang,
> 
> On Mon, Sep 27, 2010 at 08:57:05AM +0800, Huang Ying wrote:
> > @@ -360,6 +362,14 @@ io_check_error(unsigned char reason, str
> >  static notrace __kprobes void
> >  unknown_nmi_error(unsigned char reason, struct pt_regs *regs)
> >  {
> > +	/*
> > +	 * On some platforms, hardware errors may be notified via
> > +	 * unknown NMI
> > +	 */
> > +	if (unknown_nmi_for_hwerr)
> > +		panic("NMI for hardware error without error record: "
> > +		      "Not continuing");
> 
> Can you modify this to let users know to check the BIOS/BMC for further
> messages?  Otherwise people just file bugzillas asking what the problem
> is, and the first thing we have to respond with is check the BIOS/BMC.

Sorry, forget about that. Will change it in next version.

Best Regards,
Huang Ying


