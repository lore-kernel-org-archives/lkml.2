Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755366Ab1HBVFI (ORCPT <rfc822;w@1wt.eu>);
	Tue, 2 Aug 2011 17:05:08 -0400
Received: from terminus.zytor.com ([198.137.202.10]:37689 "EHLO mail.zytor.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754803Ab1HBVFE (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 2 Aug 2011 17:05:04 -0400
Message-ID: <4E38667D.4000901@zytor.com>
Date: Tue, 02 Aug 2011 14:05:01 -0700
From: "H. Peter Anvin" <hpa@zytor.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:5.0) Gecko/20110707 Thunderbird/5.0
MIME-Version: 1.0
To: "Luck, Tony" <tony.luck@intel.com>
CC: linux-kernel@vger.kernel.org, Mike Waychison <mikew@google.com>,
        Matthew Garrett <mjg@redhat.com>
Subject: Re: [PATCH] efivars: fix warnings when CONFIG_PSTORE=n
References: <4e3864a227625bd7d6@agluck-desktop.sc.intel.com>
In-Reply-To: <4e3864a227625bd7d6@agluck-desktop.sc.intel.com>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 08/02/2011 01:57 PM, Luck, Tony wrote:
>  
> +#ifdef CONFIG_PSTORE
>  static unsigned long
>  utf16_strlen(efi_char16_t *s)
>  {
>  	return utf16_strnlen(s, ~0UL);
>  }
> +#endif
>  

Unless this is actually called via an indirect function pointer, it can
just be changed to "static inline", which shuts up the warning, too.

	-hpa

