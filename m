Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756803Ab1H3VO5 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 30 Aug 2011 17:14:57 -0400
Received: from wolverine02.qualcomm.com ([199.106.114.251]:64852 "EHLO
	wolverine02.qualcomm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756672Ab1H3VOy (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 30 Aug 2011 17:14:54 -0400
X-IronPort-AV: E=McAfee;i="5400,1158,6454"; a="113915621"
Date: Tue, 30 Aug 2011 16:14:49 -0500
From: "Linas Vepstas (Code Aurora)" <linas@codeaurora.org>
To: Pavel Machek <pavel@ucw.cz>
Cc: Richard Kuo <rkuo@codeaurora.org>, linux-kernel@vger.kernel.org,
        linux-hexagon@vger.kernel.org
Subject: ARM assembly syntax  (was Re: [patch 03/36] Hexagon: Add bitops
 support)
Message-ID: <20110830211449.GC7047@codeaurora.org>
References: <20110817163457.878854582@codeaurora.org>
 <20110817163520.145693358@codeaurora.org>
 <20110826203410.GB6630@ucw.cz>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20110826203410.GB6630@ucw.cz>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Aug 26, 2011 at 10:34:10PM +0200, Pavel Machek wrote:
> Hi!
> 
> > +	__asm__ __volatile__ (
> > +	"	{R10 = %1; R11 = asr(%2,#5); }\n"
> > +	"	{R10 += asl(R11,#2); R11 = and(%2,#0x1f)}\n"
> > +	"1:	R12 = memw_locked(R10);\n"
> > +	"	{ P0 = tstbit(R12,R11); R12 = clrbit(R12,R11); }\n"
> > +	"	memw_locked(R10,P1) = R12;\n"
> > +	"	{if !P1 jump 1b; %0 = mux(P0,#1,#0);}\n"
> 
> Nice assembly syntax, btw. I can only wish architectures such as arm
> used something as readable...

Yes, I, too, was very pleasantly surprised when I first saw this.

Of course, one *could* alter binutils to accept something similar
for ARM, and then alter gcc to spit it out. Whether anyone would use
this isn't clear .. and I can already almost hear certain maintainers
telling us how much of a bad idea this is from the maintainership
point-of-view ....

--linas

-- 
Sent by an employee of the Qualcomm Innovation Center, Inc.
The Qualcomm Innovation Center, Inc. is a member of the Code Aurora Forum.
