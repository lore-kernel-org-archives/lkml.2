Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757945Ab0I1SrL (ORCPT <rfc822;w@1wt.eu>);
	Tue, 28 Sep 2010 14:47:11 -0400
Received: from terminus.zytor.com ([198.137.202.10]:40297 "EHLO mail.zytor.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1757846Ab0I1SrJ (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 28 Sep 2010 14:47:09 -0400
Message-ID: <4CA23800.4020409@zytor.com>
Date: Tue, 28 Sep 2010 11:46:24 -0700
From: "H. Peter Anvin" <hpa@zytor.com>
User-Agent: Mozilla/5.0 (X11; U; Linux x86_64; en-US; rv:1.9.2.9) Gecko/20100907 Fedora/3.1.3-1.fc13 Thunderbird/3.1.3
MIME-Version: 1.0
To: Jeremy Fitzhardinge <jeremy@goop.org>
CC: Stefano Stabellini <stefano.stabellini@eu.citrix.com>,
        Ingo Molnar <mingo@elte.hu>, Thomas Gleixner <tglx@linutronix.de>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "xen-devel@lists.xensource.com" <xen-devel@lists.xensource.com>,
        Jeremy Fitzhardinge <Jeremy.Fitzhardinge@citrix.com>,
        "sct@redhat.com" <sct@redhat.com>
Subject: Re: [PATCH 12/12] xen/mtrr: Add mtrr_if support for Xen mtrr
References: <alpine.DEB.2.00.1009281217540.2864@kaball-desktop> <1285676218-26218-12-git-send-email-stefano.stabellini@eu.citrix.com> <20100928123925.GA18208@elte.hu> <alpine.DEB.2.00.1009281455300.2864@kaball-desktop> <4CA2223B.9040400@goop.org> <4CA22C3C.3020209@zytor.com> <4CA2302C.3000201@goop.org> <4CA231A8.5000100@zytor.com> <4CA232EF.3080906@goop.org>
In-Reply-To: <4CA232EF.3080906@goop.org>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 09/28/2010 11:24 AM, Jeremy Fitzhardinge wrote:
>>>
>> No, and we really can't do it for a couple of reasons:
>>
>> a) Pre-PAT hardware;
>> b) MTRRs and PAT interact on hardware;
>> c) MTRRs, but not PAT, interact with SMM.
> 
> What about pre-PAT software (ie, X servers which still use /proc/mtrr)?
> 

Fortunately going away... we have talked in the past about doing
"virtual MTRRs" in terms of PAT to deal with this kind of legacy
software, but the demand for it seems to be low enough to not be worth
bothering with.

>> However, since a virtual machine like Xen doesn't have these issues, it
>> doesn't apply
> 
> Well, we're specifically talking about a virtual machine which has
> direct access to hardware, so it is concerned about the real physical
> memory properties of real physical pages.  If we can assume that
> BIOS/Xen will always set up MTRR correctly then there shouldn't be any
> need for the kernel to modify the MTRR itself.  How true is that in
> general?  I don't know, but if we could rely on BIOS then there'd never
> be a need to touch MTRR, would there?

Well, in the past MTRRs were abused for device properties mainly by the
X server, but other than that, no, not really.  The other thing we do is
the MTRR cleanup (which doesn't involve /proc/mtrr) to deal with
brokenness in the BIOS setup, but that really belongs in the hypervisor
in your case since it fundamentally affects how memory is handled.

	-hpa
