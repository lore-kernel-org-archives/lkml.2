Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755545Ab0G1QQs (ORCPT <rfc822;w@1wt.eu>);
	Wed, 28 Jul 2010 12:16:48 -0400
Received: from va3ehsobe005.messaging.microsoft.com ([216.32.180.31]:3417 "EHLO
	VA3EHSOBE006.bigfish.com" rhost-flags-OK-OK-OK-FAIL)
	by vger.kernel.org with ESMTP id S1755513Ab0G1QQr convert rfc822-to-8bit
	(ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 28 Jul 2010 12:16:47 -0400
X-SpamScore: -20
X-BigFish: VS-20(zz1432N98dN9371Pzz1202hzzz2dh2a8h61h)
X-Spam-TCS-SCL: 0:0
Subject: Re: Please pull my perf.git urgent branch
MIME-Version: 1.0 (Apple Message framework v1081)
Content-Type: text/plain; charset="us-ascii"
From: Kumar Gala <kumar.gala@freescale.com>
In-Reply-To: <20100728044731.GA2408@brick.ozlabs.ibm.com>
Date: Wed, 28 Jul 2010 11:15:38 -0500
CC: Scott Wood <scottwood@freescale.com>,
        Peter Zijlstra <peterz@infradead.org>, linux-kernel@vger.kernel.org,
        linuxppc-dev@ozlabs.org, Ingo Molnar <mingo@elte.hu>
Content-Transfer-Encoding: 8BIT
Message-ID: <10DB64E9-7D7E-497C-9044-C2649D22981D@freescale.com>
References: <20100727124019.GB14947@brick.ozlabs.ibm.com> <20100727112854.7bf97d48@schlenkerla.am.freescale.net> <20100728044731.GA2408@brick.ozlabs.ibm.com>
To: Paul Mackerras <paulus@samba.org>
X-Mailer: Apple Mail (2.1081)
X-Reverse-DNS: az33egw02.freescale.net
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


On Jul 27, 2010, at 11:47 PM, Paul Mackerras wrote:

> On Tue, Jul 27, 2010 at 11:28:54AM -0500, Scott Wood wrote:
> 
>> Doesn't the setting of .period need to be maintained (it is in the other
>> powerpc perf_event implementation that this is derived from)?
> 
> Gah, yes it does.
> 
>> I don't see how this is a security fix -- the existing initializer above
>> should zero-fill the fields that are not explicitly initialized.  In fact,
>> it's taking other fields that were previously initialized to zero and is
>> making them uninitialized, since perf_sample_data_init only sets addr and
>> raw.
> 
> So I misunderstood how an initializer for an automatic struct works.
> Brown paper bag time for me... :(
> 
> Regarding the other fields, I assume Peter et al. have checked that
> they don't need to be cleared, so it's a microoptimization to not
> clear them.
> 
>> CCing linuxppc-dev on the original patch would have been nice...
> 
> True, but at least I can blame Peter Z. for that. :)
> 
> Kumar and Ben, how do you want to proceed on this one?

If we aren't concerned about an oops being generated lets just submit a patch for 2.6.36.

- k
