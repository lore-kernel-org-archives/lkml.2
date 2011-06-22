Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754849Ab1FVJQc (ORCPT <rfc822;w@1wt.eu>);
	Wed, 22 Jun 2011 05:16:32 -0400
Received: from mail-ww0-f44.google.com ([74.125.82.44]:54928 "EHLO
	mail-ww0-f44.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754399Ab1FVJQa (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 22 Jun 2011 05:16:30 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=sender:date:from:to:cc:subject:message-id:references:mime-version
         :content-type:content-disposition:in-reply-to:user-agent;
        b=s8GUzjPZwOqS4w4s5QFPxsIuMf5oLE9WosIOkHxF64kZlmz13eBRWZ8qqHpqNmSTry
         yqep2F1P73SX/uz67f9xAkFhfmqmsF5S90gbMoWHvHFc2rj6fNh+BBMryxjeww0Qiy9R
         FCtGFp3ItlF7alUARdEZttSaXoea4iShdw/ZA=
Date: Wed, 22 Jun 2011 10:17:27 +0100
From: Catalin Marinas <catalin.marinas@arm.com>
To: Stephen Boyd <sboyd@codeaurora.org>
Cc: Vincent Guittot <vincent.guittot@linaro.org>, linaro-dev@lists.linaro.org,
        linux-kernel@vger.kernel.org, linux-arm-kernel@lists.infradead.org
Subject: Re: [RFC] Add Arm cpu topology definition
Message-ID: <20110622091727.GA1195@1n450.cable.virginmedia.net>
References: <BANLkTinRGRUxKB=C_2Y2F93czWScEUo+Jw@mail.gmail.com>
 <4DFA5C2E.40507@codeaurora.org>
 <BANLkTi=ik=iRtDb3K__CPxSH_8GusoBHKA@mail.gmail.com>
 <4E0100BF.6080500@codeaurora.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <4E0100BF.6080500@codeaurora.org>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Jun 21, 2011 at 01:36:15PM -0700, Stephen Boyd wrote:
> On 06/16/2011 11:54 PM, Vincent Guittot wrote:
> > On 16 June 2011 21:40, Stephen Boyd <sboyd@codeaurora.org> wrote:
> >> The ARM ARM says these fields are IMPLEMENTATION DEFINED meaning that
> >> different vendors may attribute different meaning to these fields if
> >> they wish. Does that mean this should be a platform_*() function?
> >>
> > The ARM ARM also provides a recommended use of the fields of this
> > register and the TRM of each Cortex adds some details. On the cortex
> > A9, each platform can only set the value of the Cluster ID with the
> > CLUSTERID pins. I have tried to consolidate the value of MPIDR  across
> > several platforms and they all match with the description.
> >
> > Have you got an example of a MPIDR register which doesn't match with
> > the implementation ?
> 
> Not that I know of. I'm more concerned with how the ARM ARM has two
> recommended usages for these fields depending on virtualization or not.
> I suppose we can handle that issue when it arises (or does your
> implementation already handle that?)

According to the ARM ARM:

	MPIDR provides a mechanism with up to three levels of affinity
	information, but the meaning of those levels of affinity is
	entirely IMPLEMENTATION DEFINED.

So we can't really tell the meaning of the affinity bits. There are two
recommended ways indeed (with or without virtualisation) which are not
that different with regards to the topology (just introducing another
level for virtual CPUs).

But I think a more general solution would be for the CPU topology to be
provided via the FDT.

-- 
Catalin
