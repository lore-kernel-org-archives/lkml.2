Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755565Ab0ELLBk (ORCPT <rfc822;w@1wt.eu>);
	Wed, 12 May 2010 07:01:40 -0400
Received: from cam-admin0.cambridge.arm.com ([217.140.96.50]:58595 "EHLO
	cam-admin0.cambridge.arm.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1753408Ab0ELLBi (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 12 May 2010 07:01:38 -0400
Subject: Re: [PATCH v2] [RESEND] Handle instruction cache maintenance fault
 properly
From: Catalin Marinas <catalin.marinas@arm.com>
To: "Kirill A. Shutemov" <kirill@shutemov.name>
Cc: Russell King <linux@arm.linux.org.uk>,
       Siarhei Siamashka <siarhei.siamashka@nokia.com>,
       linux-arm-kernel@lists.infradead.org, linux-kernel@vger.kernel.org,
       Aaro Koskinen <aaro.koskinen@nokia.com>, Valdis.Kletnieks@vt.edu
In-Reply-To: <AANLkTilVp0xvAJNns3TEe4SzEUpN8hMC9DdwmwW7i9yX@mail.gmail.com>
References: <AANLkTilVp0xvAJNns3TEe4SzEUpN8hMC9DdwmwW7i9yX@mail.gmail.com>
Content-Type: text/plain; charset="UTF-8"
Organization: ARM Limited
Date: Wed, 12 May 2010 12:01:27 +0100
Message-ID: <1273662087.23818.63.camel@e102109-lin.cambridge.arm.com>
Mime-Version: 1.0
X-Mailer: Evolution 2.28.1 
Content-Transfer-Encoding: 7bit
X-OriginalArrivalTime: 12 May 2010 11:01:28.0303 (UTC) FILETIME=[789DAFF0:01CAF1C2]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 2010-05-11 at 11:33 +0100, Kirill A. Shutemov wrote:
> Between "clean D line..." and "invalidate I line" operations in
> v7_coherent_user_range(), the memory page may get swapped out.
> And the fault on "invalidate I line" could not be properly handled
> causing the oops.
> 
> In ARMv6 "external abort on linefetch" replaced by "instruction cache
> maintenance fault". Let's handle it as translation fault. It fixes the
> issue.
> 
> I'm not sure if it's reasonable to check arch version in run-time.
> Let's do it in compile time for now.
> 
> Signed-off-by: Siarhei Siamashka <siarhei.siamashka@nokia.com>
> Signed-off-by: Kirill A. Shutemov <kirill@shutemov.name>

FWIW:

Reviewed-by: Catalin Marinas <catalin.marinas@arm.com>

-- 
Catalin

