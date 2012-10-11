Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932722Ab2JKOl4 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 11 Oct 2012 10:41:56 -0400
Received: from mail-qa0-f53.google.com ([209.85.216.53]:60079 "EHLO
	mail-qa0-f53.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751069Ab2JKOlq (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 11 Oct 2012 10:41:46 -0400
Date: Thu, 11 Oct 2012 10:41:32 -0400
From: Konrad Rzeszutek Wilk <konrad@kernel.org>
To: Yinghai Lu <yinghai@kernel.org>
Cc: Thomas Gleixner <tglx@linutronix.de>, Ingo Molnar <mingo@elte.hu>,
        "H. Peter Anvin" <hpa@zytor.com>, Jacob Shin <jacob.shin@amd.com>,
        Tejun Heo <tj@kernel.org>,
        Stefano Stabellini <stefano.stabellini@eu.citrix.com>,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH 03/10] x86, mm: get early page table from BRK
Message-ID: <20121011144130.GB2408@localhost.localdomain>
References: <1349757558-10856-1-git-send-email-yinghai@kernel.org>
 <1349757558-10856-4-git-send-email-yinghai@kernel.org>
 <20121009160133.GF7639@phenom.dumpdata.com>
 <CAE9FiQW8ubsQmtJk=bvZ5yGdBaBQSNWPpuACku+8sbb6_CG+rA@mail.gmail.com>
 <20121010141707.GH4005@phenom.dumpdata.com>
 <CAE9FiQVTUsYZiU0rAjE645Pez1X5eLwHMhOF0W_EuR62KYdtQQ@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <CAE9FiQVTUsYZiU0rAjE645Pez1X5eLwHMhOF0W_EuR62KYdtQQ@mail.gmail.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Oct 10, 2012 at 08:49:05AM -0700, Yinghai Lu wrote:
> On Wed, Oct 10, 2012 at 7:17 AM, Konrad Rzeszutek Wilk
> <konrad@kernel.org> wrote:
> > On Tue, Oct 09, 2012 at 06:03:33PM -0700, Yinghai Lu wrote:
> 
> >> good point, i add one line comment to the revised patch.
> >>
> >> +/* need 3 4k for initial PMD_SIZE, 4k for 0-ISA_END_ADDRESS */
> >
> > Can you explain the math please? It sounds like this is based on
> > the assumption that this you are using huge pages. But what if you
> > are not? What if you can only do 4KB pages?
> 
> yes that is some extreme case:
> assume that 2M range is [2T-2M, 2T),

What is T in here? Terabyte? Is the '[' vs ')' a significance in your
explanation? Should it be '[2T-2M, 2T]' ?


> one page for PGD-[2T-512g, 2T), one for PUD - [2T-1G, 2T), and one for
> PMD -: [2T-2M, 2T)

