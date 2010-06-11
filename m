Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760068Ab0FKCLm (ORCPT <rfc822;w@1wt.eu>);
	Thu, 10 Jun 2010 22:11:42 -0400
Received: from mail-pv0-f174.google.com ([74.125.83.174]:48695 "EHLO
	mail-pv0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754499Ab0FKCLj convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 10 Jun 2010 22:11:39 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=mime-version:in-reply-to:references:date:message-id:subject:from:to
         :cc:content-type:content-transfer-encoding;
        b=Qyn9qcL6gjE+d5F7x/j4E7N4zMrx/QtWRsIfSFH+HSEVwfKUyrBre0697p1IoZYjSc
         ls5U8k21wYtGn3wgDQ1kyWjAH03LGehUKm0YIM4QVJJlrkFyZXIeD9TamCwIDEKueBO5
         APEFViIAp1RebTDv5N3n2ki+MLgTZqCtGXQSg=
MIME-Version: 1.0
In-Reply-To: <4C0C4491.80708@gmail.com>
References: <4C0C4491.80708@gmail.com>
Date: Thu, 10 Jun 2010 22:11:38 -0400
Message-ID: <AANLkTinkhXQfE9Ejcb3dJeMZWl6gxbO3-gzqPUBxei4N@mail.gmail.com>
Subject: Re: [PATCH 1/4 V2] [tip:x86/mm] Correcting improper large page 
	preservation
From: Siarhei Liakh <sliakh.lkml@gmail.com>
To: linux-kernel@vger.kernel.org, linux-security-module@vger.kernel.org,
       linux-next@vger.kernel.org
Cc: Arjan van de Ven <arjan@infradead.org>, James Morris <jmorris@namei.org>,
       Andrew Morton <akpm@linux-foundation.org>, Andi Kleen <ak@muc.de>,
       Thomas Gleixner <tglx@linutronix.de>, "H. Peter Anvin" <hpa@zytor.com>,
       Ingo Molnar <mingo@elte.hu>, Rusty Russell <rusty@rustcorp.com.au>,
       Stephen Rothwell <sfr@canb.auug.org.au>, Dave Jones <davej@redhat.com>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sun, Jun 6, 2010 at 9:00 PM, Siarhei Liakh <sliakh.lkml@gmail.com> wrote:
> This patch fixes a bug in try_preserve_large_page() which may result
> in improper large page preservation and improper application of page
> attributes to the memory area outside of the original change request.
> More specifically, the problem manifests itself when set_memory_*() is
> called for several pages at the beginning of the large page and
> try_preserve_large_page() erroneously concludes that the change can be
> applied to whole large page.
> The fix consists of 3 parts:
> 1. addition of "required" protection attributes in
> static_protections(), so .data and .bss can be guaranteed to stay "RW"
> 2. static_protections() is now called for every small page within
> large page to determine compatibility of new protection attributes
> (instead of just small pages within the requested range).
> 3. large page can be preserved only if attribute change is
> large-page-aligned and covers whole large page.
>
> V1:  try_preserve_large_page() patch for Linux 2.6.34-rc2
> V2:  replaced pfn check with address check for kernel rw-data
>
> Signed-off-by: Siarhei Liakh <sliakh.lkml@gmail.com>
> Signed-off-by: Xuxian Jiang <jiang@cs.ncsu.edu>
> Reviewed-by: Suresh Siddha <suresh.b.siddha@intel.com>
> ---

Does anyone have any feedback on this patch set?

Thank you.
