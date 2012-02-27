Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755074Ab2B0VFL (ORCPT <rfc822;w@1wt.eu>);
	Mon, 27 Feb 2012 16:05:11 -0500
Received: from mail-qy0-f174.google.com ([209.85.216.174]:37941 "EHLO
	mail-qy0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754265Ab2B0VFJ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 27 Feb 2012 16:05:09 -0500
Authentication-Results: mr.google.com; spf=pass (google.com: domain of peter.maydell@linaro.org designates 10.224.185.207 as permitted sender) smtp.mail=peter.maydell@linaro.org
MIME-Version: 1.0
In-Reply-To: <1330360043.8557.302.camel@zakaz.uk.xensource.com>
References: <alpine.DEB.2.00.1202231714590.23091@kaball-desktop>
	<1330019314-20865-1-git-send-email-stefano.stabellini@eu.citrix.com>
	<1330360043.8557.302.camel@zakaz.uk.xensource.com>
Date: Mon, 27 Feb 2012 21:05:08 +0000
Message-ID: <CAFEAcA8PzT9mfnEz60CYvwQWX1OEvejrZvkpuPL2LpTPosp8cA@mail.gmail.com>
Subject: Re: [PATCH-WIP 01/13] xen/arm: use r12 to pass the hypercall number
 to the hypervisor
From: Peter Maydell <peter.maydell@linaro.org>
To: Ian Campbell <Ian.Campbell@citrix.com>
Cc: Stefano Stabellini <stefano.stabellini@eu.citrix.com>,
        "xen-devel@lists.xensource.com" <xen-devel@lists.xensource.com>,
        "linaro-dev@lists.linaro.org" <linaro-dev@lists.linaro.org>,
        "kvm@vger.kernel.org" <kvm@vger.kernel.org>,
        "arnd@arndb.de" <arnd@arndb.de>,
        "catalin.marinas@arm.com" <catalin.marinas@arm.com>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        David Vrabel <david.vrabel@citrix.com>,
        "linux-arm-kernel@lists.infradead.org" 
	<linux-arm-kernel@lists.infradead.org>
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 27 February 2012 16:27, Ian Campbell <Ian.Campbell@citrix.com> wrote:
> R12 is not accessible from the 16 bit "T1" Thumb encoding of mov
> immediate (which can only target r0..r7).
>
> Since we support only ARMv7+ there are "T2" and "T3" encodings available
> which do allow direct mov of an immediate into R12, but are 32 bit Thumb
> instructions.
>
> Should we use r7 instead to maximise instruction density for Thumb code?

r7 is (used by gcc as) the Thumb frame pointer; I don't know if this
makes it worth avoiding in this context.

-- PMM
