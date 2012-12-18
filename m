Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932243Ab2LRQSm (ORCPT <rfc822;w@1wt.eu>);
	Tue, 18 Dec 2012 11:18:42 -0500
Received: from terminus.zytor.com ([198.137.202.10]:58954 "EHLO mail.zytor.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S932093Ab2LRQSl (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 18 Dec 2012 11:18:41 -0500
Message-ID: <50D09733.3080502@zytor.com>
Date: Tue, 18 Dec 2012 08:17:55 -0800
From: "H. Peter Anvin" <hpa@zytor.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:17.0) Gecko/17.0 Thunderbird/17.0
MIME-Version: 1.0
To: stefani@seibold.net
CC: linux-kernel@vger.kernel.org, x86@kernel.org, tglx@linutronix.de,
        mingo@redhat.com, ak@linux.intel.com, aarcange@redhat.com,
        john.stultz@linaro.org, luto@amacapital.net, xemul@parallels.com,
        gorcunov@openvz.org, andriy.shevchenko@linux.intel.com
Subject: Re: [PATCH 6/6] Add 32 bit VDSO support for 32 and 64 bit kernels
References: <1355823656-13902-1-git-send-email-stefani@seibold.net> <1355823656-13902-7-git-send-email-stefani@seibold.net>
In-Reply-To: <1355823656-13902-7-git-send-email-stefani@seibold.net>
X-Enigmail-Version: 1.4.6
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 12/18/2012 01:40 AM, stefani@seibold.net wrote:
> From: Stefani Seibold <stefani@seibold.net>
> 
> This patch adds support for 32 bit VDSO.
> 
> For 32 bit programs running on a 32 bit kernel, the same mechanism is
> used as for 64 bit programs running on a 64 bit kernel.
> 
> For 32 bit programs running under a 64 bit IA32_EMULATION, it is a
> little bit more tricky. In this case the VVAR and HPET will be mapped
> into the 32 bit address space, by cutting of the upper 32 bit. So the
> address for this will not changed in the view of the 32 bit VDSO. The
> HPET will be mapped in this case at 0xff5fe000 and the VVAR at 0xff5ff000.
> 
> The transformation between the in 64 bit kernel representation and the 32 bit
> abi will be also provided.
> 
> So we have one VDSO Source for all.
> 

You seem to once again have disregarded the request to make the vvar and
hpet part of the vdso address space proper.  If this is not possible or
highly impractical, please extend a technical motivation why that is so,
rather than simply ignoring it.

	-hpa


