Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753225Ab1KYIsw (ORCPT <rfc822;w@1wt.eu>);
	Fri, 25 Nov 2011 03:48:52 -0500
Received: from arkanian.console-pimps.org ([212.110.184.194]:54514 "EHLO
	arkanian.console-pimps.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752576Ab1KYIsv (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 25 Nov 2011 03:48:51 -0500
Subject: Re: [PATCH] x86, efi: Break up large initrd reads
From: Matt Fleming <matt@console-pimps.org>
To: Maarten Lankhorst <m.b.lankhorst@gmail.com>
Cc: "H. Peter Anvin" <hpa@linux.intel.com>, Matthew Garrett <mjg@redhat.com>,
        linux-kernel@vger.kernel.org, Ingo Molnar <mingo@elte.hu>,
        Thomas Gleixner <tglx@linutronix.de>, x86@kernel.org,
        Mike Waychison <mikew@google.com>, Andi Kleen <andi@firstfloor.org>,
        Peter Jones <pjones@redhat.com>
In-Reply-To: <4ECEF144.8020303@gmail.com>
References: <1318848017-12301-1-git-send-email-matt@console-pimps.org>
	 <1318848017-12301-11-git-send-email-matt@console-pimps.org>
	 <4E9C8AAC.7080803@gmail.com>
	 <1321383097.2657.9.camel@mfleming-mobl1.ger.corp.intel.com>
	 <4ECC4207.3010607@gmail.com>
	 <1322076468.24448.18.camel@mfleming-mobl1.ger.corp.intel.com>
	 <4ECE5803.3060203@gmail.com>
	 <1322168216.24448.61.camel@mfleming-mobl1.ger.corp.intel.com>
	 <4ECEF144.8020303@gmail.com>
Content-Type: text/plain; charset="UTF-8"
Date: Fri, 25 Nov 2011 08:48:19 +0000
Message-ID: <1322210899.24448.66.camel@mfleming-mobl1.ger.corp.intel.com>
Mime-Version: 1.0
X-Mailer: Evolution 2.32.3 (2.32.3-1.fc14) 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, 2011-11-25 at 02:37 +0100, Maarten Lankhorst wrote:
> The efi boot stub tries to read the entire initrd in 1 go,
> however some efi implementations hang if too much if asked
> to read too much data at the same time. After some
> experimentation I found out that my asrock p67 board will
> hang if asked to read chunks of 4mb, so use a safe value.
> 
> From elilo source code:
> /*
>  * We load by chunks rather than a single big read because
>  * early versions of EFI had troubles loading files
>  * from floppies in a single big request.  Breaking
>  * the read down into chunks of 4KB fixed that
>  * problem. While this problem has been fixed, we still prefer
>  * this method because it tells us whether or not we're making
>  * forward progress.
>  */
> 
> While the comment says 4KB, it's using 4 * EFI_PAGE_SIZE (16KB),
> so I went by the safest route of following elilo here.
> 
> Signed-off-by: Maarten Lankhorst <m.b.lankhorst@gmail.com>
> ---
>  arch/x86/boot/compressed/eboot.c |   20 ++++++++++++++------
>  1 files changed, 14 insertions(+), 6 deletions(-)

Thanks Maarten, applied!

-- 
Matt Fleming, Intel Open Source Technology Center

