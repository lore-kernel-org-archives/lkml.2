Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933089Ab1ERMfg (ORCPT <rfc822;w@1wt.eu>);
	Wed, 18 May 2011 08:35:36 -0400
Received: from casper.infradead.org ([85.118.1.10]:58952 "EHLO
	casper.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S933012Ab1ERMff convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 18 May 2011 08:35:35 -0400
Subject: Re: [PATCH v1 5/5] KVM: Expose a version 1 architectural PMU to
 guests
From: Peter Zijlstra <a.p.zijlstra@chello.nl>
To: Avi Kivity <avi@redhat.com>
Cc: Ingo Molnar <mingo@elte.hu>, linux-kernel@vger.kernel.org,
        kvm@vger.kernel.org,
        Arnaldo Carvalho de Melo <acme@ghostprotocols.net>
In-Reply-To: <4DD3AF88.2040704@redhat.com>
References: <1305129333-7456-1-git-send-email-avi@redhat.com>
	 <1305129333-7456-6-git-send-email-avi@redhat.com>
	 <20110517194117.GA26184@elte.hu> <4DD38B57.2070904@redhat.com>
	 <20110518110759.GB16556@elte.hu> <1305718350.2466.7110.camel@twins>
	 <4DD3AF88.2040704@redhat.com>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 8BIT
Date: Wed, 18 May 2011 14:35:16 +0200
Message-ID: <1305722116.2466.7171.camel@twins>
Mime-Version: 1.0
X-Mailer: Evolution 2.30.3 
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 2011-05-18 at 14:37 +0300, Avi Kivity wrote:
> On 05/18/2011 02:32 PM, Peter Zijlstra wrote:
> > On Wed, 2011-05-18 at 13:07 +0200, Ingo Molnar wrote:
> > >
> > >  It does through raw events - which are indeed model specific.
> >
> > Which is exactly what is needed anyway, he gets a raw msr value.
> >
> > The only thing that is not exposed is the ANY bit, but since KVM doesn't
> > expose HT anyway that doesn't matter.
> 
> If I were to use raw events, I'd need to program AMD and Intel hosts 
> separately.  As it is, I just use the generic counters and the perf 
> backend does its thing.

But why exactly, from what I understood you emulate an actual hardware
PMU, that means the guest will be writing proper content to the relevant
MSRs, you can feed that directly into the raw config field (with
exception of the USR/OS/INT bits).

I'm fairly sure that emulating the intel arch bits on an cpu that
otherwise identifies itself as AMD is going to confuse things.


