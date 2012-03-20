Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753579Ab2CTR6v (ORCPT <rfc822;w@1wt.eu>);
	Tue, 20 Mar 2012 13:58:51 -0400
Received: from acsinet15.oracle.com ([141.146.126.227]:50184 "EHLO
	acsinet15.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752271Ab2CTR6u (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 20 Mar 2012 13:58:50 -0400
Date: Tue, 20 Mar 2012 13:54:23 -0400
From: Konrad Rzeszutek Wilk <konrad.wilk@oracle.com>
To: Ingo Molnar <mingo@kernel.org>
Cc: Josh Boyer <jwboyer@redhat.com>, Suresh Siddha <suresh.b.siddha@intel.com>,
        Ingo Molnar <mingo@elte.hu>, "H. Peter Anvin" <hpa@zytor.com>,
        yinghai@kernel.org, linux-kernel@vger.kernel.org,
        kernel-team@fedoraproject.org, midgoon@gmail.com
Subject: Re: 3.2.1 Unable to reset IRR messages on boot
Message-ID: <20120320175423.GC30789@phenom.dumpdata.com>
References: <1327529048.2327.17.camel@sbsiddha-mobl2>
 <20120125231534.GL13655@zod.bos.redhat.com>
 <20120131142621.GA2136@zod.bos.redhat.com>
 <1328083230.3638.2.camel@sbsiddha-mobl2>
 <20120312132448.GA20204@zod.bos.redhat.com>
 <1331577393.31585.94.camel@sbsiddha-desk.sc.intel.com>
 <20120319133046.GB13093@zod.bos.redhat.com>
 <20120319193842.GA8123@phenom.dumpdata.com>
 <20120320094048.GC20079@phenom.dumpdata.com>
 <20120320095924.GA8377@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20120320095924.GA8377@gmail.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
X-Source-IP: ucsinet21.oracle.com [156.151.31.93]
X-CT-RefId: str=0001.0A090208.4F68C551.0049,ss=1,re=0.000,fgs=0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Mar 20, 2012 at 10:59:24AM +0100, Ingo Molnar wrote:
> 
> * Konrad Rzeszutek Wilk <konrad.wilk@oracle.com> wrote:
> 
> >  2). Make the Xen layer fake out an IOAPIC - so instead of 0xffffff, make sure to
> >      clear the three bits that Suresh' patch is testing for (Ewwwww, I don't actually
> >      like that - that stinks of a hack).
> 
> In what universe would a hardware virtualization layer emulating 
> actual hardware behavior be a 'hack'?

I think I didn't explain myself enough. The 2) "fix" would be basically the minimal work-around
around Suresh's patch so that the test his patch employs passes. That feels to me like a hack -
a band-aid solution. If his code employs more stringent tests in the next release, then I've got
to play catch-up and add more faking off the IOAPIC. That in long term might mean introducing
a pvops for the ioapic_read so that we can selectivity provide the "proper" IOAPIC entries.

The patch I posted thought tries to solve the existing baremetal problem Sureh's patch was for
and also not introduce a regression by only erasing the IOAPIC if there are no dependencies on it.
