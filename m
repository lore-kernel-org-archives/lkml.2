Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1762465Ab2EQXHu (ORCPT <rfc822;w@1wt.eu>);
	Thu, 17 May 2012 19:07:50 -0400
Received: from mail-pb0-f46.google.com ([209.85.160.46]:54390 "EHLO
	mail-pb0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1759429Ab2EQXHs (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 17 May 2012 19:07:48 -0400
Message-ID: <4FB584C0.6080807@gmail.com>
Date: Thu, 17 May 2012 16:07:44 -0700
From: David Daney <ddaney.cavm@gmail.com>
User-Agent: Mozilla/5.0 (X11; U; Linux x86_64; en-US; rv:1.9.1.15) Gecko/20101027 Fedora/3.0.10-1.fc12 Thunderbird/3.0.10
MIME-Version: 1.0
To: "H.J. Lu" <hjl.tools@gmail.com>, Ralf Baechle <ralf@linux-mips.org>,
        "H. Peter Anvin" <hpa@zytor.com>
CC: linux-kernel@vger.kernel.org, linux-arch@vger.kernel.org,
        torvalds@linux-foundation.org, hpa@zytor.com, mingo@kernel.org,
        tglx@linutronix.de
Subject: Re: [RFC PATCH 00/10] Use __kernel_[u]long_t for x32 user space compatibility
References: <1337292816-10839-1-git-send-email-hjl.tools@gmail.com>
In-Reply-To: <1337292816-10839-1-git-send-email-hjl.tools@gmail.com>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 05/17/2012 03:13 PM, H.J. Lu wrote:
> From: H.J. Lu<hjl.tools@gmail.com>
>
> This patch set changes a number of places where the kernel headers are
> exported to user space and currently use explicit "long" or "unsigned
> long" to use __kernel_[u]long_t in order to be compatible with the x32
> user space ABI.  These location are places where x32 uses the x86-64
> ABI.
>

Has anybody checked how this affects MIPS n32 userspace?

I think it totally breaks it.

In addition, 109a1f32 (sysinfo: Use explicit types in <linux/sysinfo.h>) 
is probably bad.  I think it may need to be reverted, or somebody should 
fix all the __kernel_{,u}long_t definitions for the ABI that may have 
been broken by the change.

> It is quite possible that some, or even all, of these locations should
> really use dedicated types, but in the meantime this gives the correct
> results which the current headers do not.
>
> --
> To unsubscribe from this list: send the line "unsubscribe linux-kernel" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
> Please read the FAQ at  http://www.tux.org/lkml/
>

