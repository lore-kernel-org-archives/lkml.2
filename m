Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752092Ab0EJOyr (ORCPT <rfc822;w@1wt.eu>);
	Mon, 10 May 2010 10:54:47 -0400
Received: from cam-admin0.cambridge.arm.com ([217.140.96.50]:34126 "EHLO
	cam-admin0.cambridge.arm.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751878Ab0EJOyp (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 10 May 2010 10:54:45 -0400
Subject: Re: [PATCH] Handle instruction cache maintenance fault properly
From: Catalin Marinas <catalin.marinas@arm.com>
To: Valdis.Kletnieks@vt.edu
Cc: "Kirill A. Shutemov" <kirill@shutemov.name>,
       Russell King - ARM Linux <linux@arm.linux.org.uk>,
       Siarhei Siamashka <siarhei.siamashka@nokia.com>,
       linux-arm-kernel@lists.infradead.org, linux-kernel@vger.kernel.org,
       Aaro Koskinen <aaro.koskinen@nokia.com>
In-Reply-To: <7529.1273503128@localhost>
References: <AANLkTikIbI6hKoYSZlo6QDlyi2Qjxg287i-ilHpz1FF9@mail.gmail.com>
	 <20100510131519.GB7796@n2100.arm.linux.org.uk>
	 <AANLkTint0f2Ow2FM3jVAqGfPjolHvF-oBTGCmY7Jx7_d@mail.gmail.com>
	 <7529.1273503128@localhost>
Content-Type: text/plain; charset="UTF-8"
Organization: ARM Limited
Date: Mon, 10 May 2010 15:54:35 +0100
Message-ID: <1273503275.10282.63.camel@e102109-lin.cambridge.arm.com>
Mime-Version: 1.0
X-Mailer: Evolution 2.28.1 
Content-Transfer-Encoding: 7bit
X-OriginalArrivalTime: 10 May 2010 14:54:36.0665 (UTC) FILETIME=[B580D690:01CAF050]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 2010-05-10 at 15:52 +0100, Valdis.Kletnieks@vt.edu wrote:
> On Mon, 10 May 2010 16:34:57 +0300, "Kirill A. Shutemov" said:
> 
> > It looks like cache maintenance fault was introduced in ARMv6.
> > 
> > So, what is the right way to fix it? Something like:
> > 
> > #if __LINUX_ARM_ARCH__ < 6
> >         { do_bad,               SIGBUS,  0,             "external
> 
> This would need to be a runtime test, no?  Or does LINUX_ARM_ARCH not allow
> it to run on other arch levels? (i.e. can an ARM kernel boot for v5 and v6?)

v6 and v7 probably but I doubt v5 and v6 would work. There are other
#ifdefs in arch/arm/include/asm/system.h like barriers.

-- 
Catalin

