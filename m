Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759424Ab1EMPEI (ORCPT <rfc822;w@1wt.eu>);
	Fri, 13 May 2011 11:04:08 -0400
Received: from mx1.redhat.com ([209.132.183.28]:23992 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753445Ab1EMPEH (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 13 May 2011 11:04:07 -0400
Date: Fri, 13 May 2011 10:59:28 -0400
From: Chuck Ebbert <cebbert@redhat.com>
To: Boris Ostrovsky <boris.ostrovsky@amd.com>
Cc: Hans Rosenfeld <hans.rosenfeld@amd.com>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "Petkov, Borislav" <Borislav.Petkov@amd.com>
Subject: Re: [PATCH] cpu, AMD: Fix another bug in the new errata checking
 code
Message-ID: <20110513105928.6216ddc8@katamari>
In-Reply-To: <4DCD2C3F.9070905@amd.com>
References: <20110512195938.1728ab52@katamari>
	<20110513102154.GB9270@escobedo.osrc.amd.com>
	<4DCD2C3F.9070905@amd.com>
Organization: Red Hat, Inc.
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, 13 May 2011 09:03:59 -0400
Boris Ostrovsky <boris.ostrovsky@amd.com> wrote:

> On 05/13/2011 06:21 AM, Hans Rosenfeld wrote:
> > On Thu, May 12, 2011 at 07:59:38PM -0400, Chuck Ebbert wrote:
> > The revision guide states that family 0x10 model 6 stepping 2 has E400.
> > So I would expect that OSVW length is>= 2 and that OSVW status has bit
> > 1 set, or that OSVW length is<  2. This indicates that the workaround is
> > necessary, without any need to check the family-model-stepping ranges.
> >
> > It would also be correct if the BIOS disabled C1E and cleared the
> > corresponding OSVW status bit. Anything else would probably be a very
> > nasty BIOS bug.
> >

> > Could you send me the contents of MSRs 0xc0010140, 0xc0010141 and
> > 0xc0010055?
> 
> Knowing whether any C state above C1 is declared could be useful too.
> 
rdmsr 0xc0010140 gives 2
rdmsr 0xc0010141 gives 0
rdmsr 0xc0010055 gives 0

And ARAT is definitely set where it wasn't before these updates.

BTW we now have multiple reports of this, one system is a Compaq Presario
CQ61 with an AMD Sempron M120 processor.

I'll check on the C-states next.
