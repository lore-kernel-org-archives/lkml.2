Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753388Ab2KSXNs (ORCPT <rfc822;w@1wt.eu>);
	Mon, 19 Nov 2012 18:13:48 -0500
Received: from terminus.zytor.com ([198.137.202.10]:35238 "EHLO mail.zytor.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752502Ab2KSXNr (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 19 Nov 2012 18:13:47 -0500
Message-ID: <50AABD15.1050809@zytor.com>
Date: Mon, 19 Nov 2012 15:13:25 -0800
From: "H. Peter Anvin" <hpa@zytor.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:16.0) Gecko/20121029 Thunderbird/16.0.2
MIME-Version: 1.0
To: Yinghai Lu <yinghai@kernel.org>
CC: Thomas Gleixner <tglx@linutronix.de>, Ingo Molnar <mingo@elte.hu>,
        "Eric W. Biederman" <ebiederm@xmission.com>,
        linux-kernel@vger.kernel.org, Matt Fleming <matt.fleming@intel.com>
Subject: Re: [PATCH v2 03/13] x86: Add macro for 64bit entry startup_64
References: <1353222571-31544-1-git-send-email-yinghai@kernel.org> <1353222571-31544-4-git-send-email-yinghai@kernel.org> <50AAB5E8.5070807@zytor.com> <CAE9FiQV=G=5zAqv7EiUnb=O7znxuieiCawfgomv9aPNwVAV4uQ@mail.gmail.com>
In-Reply-To: <CAE9FiQV=G=5zAqv7EiUnb=O7znxuieiCawfgomv9aPNwVAV4uQ@mail.gmail.com>
X-Enigmail-Version: 1.4.6
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 11/19/2012 02:53 PM, Yinghai Lu wrote:
>>
>> We can't change the 0x200 value, ever, because there are already things
>> that use the 64-bit entry point.  As such, these macros and the bzImage
>> fields are pointless; let's not bother and instead document the 0x200 as
>> the permanently fixed address of the 64-bit entry point.
> 
> ok,
> 
> any other field, in header struct field that we can use to tell
> bzImage could be used that
> 0x200 directly?
> 
> hardware_subarch?
> 

There isn't one... this dates back all the way to the original x86-64
kernels.

Are you asking if we can tell this is a 64-bit kernel (as opposed to a
32-bit kernel, which obviously doesn't have a 64-bit entry point)?
Unfortunately there isn't an intentional one that I know of.  There
might be an accidental such indicator, but we'd have to go back to look
at 8+ years of kernels.  We can't even rely on a jmp instruction at the
address...

	-hpa

