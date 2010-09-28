Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757631Ab0I1SYu (ORCPT <rfc822;w@1wt.eu>);
	Tue, 28 Sep 2010 14:24:50 -0400
Received: from claw.goop.org ([74.207.240.146]:48265 "EHLO claw.goop.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756030Ab0I1SYt (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 28 Sep 2010 14:24:49 -0400
Message-ID: <4CA232EF.3080906@goop.org>
Date: Tue, 28 Sep 2010 11:24:47 -0700
From: Jeremy Fitzhardinge <jeremy@goop.org>
User-Agent: Mozilla/5.0 (X11; U; Linux x86_64; en-US; rv:1.9.2.9) Gecko/20100907 Fedora/3.1.3-1.fc13 Lightning/1.0b3pre Thunderbird/3.1.3
MIME-Version: 1.0
To: "H. Peter Anvin" <hpa@zytor.com>
CC: Stefano Stabellini <stefano.stabellini@eu.citrix.com>,
        Ingo Molnar <mingo@elte.hu>, Thomas Gleixner <tglx@linutronix.de>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "xen-devel@lists.xensource.com" <xen-devel@lists.xensource.com>,
        Jeremy Fitzhardinge <Jeremy.Fitzhardinge@citrix.com>,
        "sct@redhat.com" <sct@redhat.com>
Subject: Re: [PATCH 12/12] xen/mtrr: Add mtrr_if support for Xen mtrr
References: <alpine.DEB.2.00.1009281217540.2864@kaball-desktop> <1285676218-26218-12-git-send-email-stefano.stabellini@eu.citrix.com> <20100928123925.GA18208@elte.hu> <alpine.DEB.2.00.1009281455300.2864@kaball-desktop> <4CA2223B.9040400@goop.org> <4CA22C3C.3020209@zytor.com> <4CA2302C.3000201@goop.org> <4CA231A8.5000100@zytor.com>
In-Reply-To: <4CA231A8.5000100@zytor.com>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

 On 09/28/2010 11:19 AM, H. Peter Anvin wrote:
> On 09/28/2010 11:13 AM, Jeremy Fitzhardinge wrote:
>>  On 09/28/2010 10:56 AM, H. Peter Anvin wrote:
>>> On 09/28/2010 10:13 AM, Jeremy Fitzhardinge wrote:
>>>> Yes, we could just mask out the MTRR CPU feature and rely entirely on PAT.
>>>>
>>>> The alternative would be to use the wrmsr hooks to emulate the Intel
>>>> MTRR registers by mapping them to hypercalls, but that seems needlessly
>>>> complex.
>>>>
>>> Indeed.  Relying on pure PAT is the Right Thing[TM].
>> Is there a plan to formally deprecate /proc/mtrr and the kernel
>> infrastructure behind it?
>>
> No, and we really can't do it for a couple of reasons:
>
> a) Pre-PAT hardware;
> b) MTRRs and PAT interact on hardware;
> c) MTRRs, but not PAT, interact with SMM.

What about pre-PAT software (ie, X servers which still use /proc/mtrr)?

> However, since a virtual machine like Xen doesn't have these issues, it
> doesn't apply

Well, we're specifically talking about a virtual machine which has
direct access to hardware, so it is concerned about the real physical
memory properties of real physical pages.  If we can assume that
BIOS/Xen will always set up MTRR correctly then there shouldn't be any
need for the kernel to modify the MTRR itself.  How true is that in
general?  I don't know, but if we could rely on BIOS then there'd never
be a need to touch MTRR, would there?

    J
