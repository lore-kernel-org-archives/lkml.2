Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756653Ab0GaVD6 (ORCPT <rfc822;w@1wt.eu>);
	Sat, 31 Jul 2010 17:03:58 -0400
Received: from terminus.zytor.com ([198.137.202.10]:36140 "EHLO mail.zytor.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753300Ab0GaVD4 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sat, 31 Jul 2010 17:03:56 -0400
Message-ID: <4C548F7D.6000509@zytor.com>
Date: Sat, 31 Jul 2010 14:02:53 -0700
From: "H. Peter Anvin" <hpa@zytor.com>
User-Agent: Mozilla/5.0 (X11; U; Linux x86_64; en-US; rv:1.9.2.7) Gecko/20100720 Fedora/3.1.1-1.fc13 Thunderbird/3.1.1
MIME-Version: 1.0
To: Cyrill Gorcunov <gorcunov@gmail.com>
CC: Yinghai Lu <yinghai@kernel.org>, Ingo Molnar <mingo@elte.hu>,
        Thomas Gleixner <tglx@linutronix.de>,
        Pekka Enberg <penberg@cs.helsinki.fi>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH] x86,setup: add serial_console_port_base in boot_params
References: <4C3F8B46.7080809@kernel.org> <20100731083409.GC5859@lenovo> <4C5469AF.2010608@zytor.com> <20100731183211.GB29357@lenovo>
In-Reply-To: <20100731183211.GB29357@lenovo>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 07/31/2010 11:32 AM, Cyrill Gorcunov wrote:
>>
>> No, this is the internal part of the boot protocol, so it's not an issue.
>>
> 
> Peter, I didn't mean any issue here, I meant that bootloaders don't know about
> this field yet and they will have to update own sources to pass port value
> at proper place of boot params. Or I miss something?
> 

Boot loaders that use the 16-bit entry point are unaffected.

Boot loaders which use the 32-bit entry point but properly clears the
zero page simply will not have the feature.

Boot loaders which use the 32-bit entry point but doesn't clear the zero
page are broken.

	-hpa

-- 
H. Peter Anvin, Intel Open Source Technology Center
I work for Intel.  I don't speak on their behalf.

