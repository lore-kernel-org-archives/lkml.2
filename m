Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757501Ab2CETdw (ORCPT <rfc822;w@1wt.eu>);
	Mon, 5 Mar 2012 14:33:52 -0500
Received: from terminus.zytor.com ([198.137.202.10]:33701 "EHLO mail.zytor.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1757481Ab2CETdv (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 5 Mar 2012 14:33:51 -0500
Message-ID: <4F551504.5010401@zytor.com>
Date: Mon, 05 Mar 2012 11:33:24 -0800
From: "H. Peter Anvin" <hpa@zytor.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:10.0.1) Gecko/20120209 Thunderbird/10.0.1
MIME-Version: 1.0
To: wharms@bfs.de
CC: Dan Carpenter <dan.carpenter@oracle.com>,
        Thomas Gleixner <tglx@linutronix.de>, Ingo Molnar <mingo@redhat.com>,
        x86@kernel.org, Matt Fleming <matt.fleming@intel.com>,
        Maarten Lankhorst <m.b.lankhorst@gmail.com>,
        linux-kernel@vger.kernel.org, kernel-janitors@vger.kernel.org
Subject: Re: [patch v2] x86, efi: fix pointer math issue in handle_ramdisks()
References: <20120305180614.GA26880@elgon.mountain> <4F550917.9020508@bfs.de>
In-Reply-To: <4F550917.9020508@bfs.de>
X-Enigmail-Version: 1.3.5
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 03/05/2012 10:42 AM, walter harms wrote:
> 
> 
> Am 05.03.2012 19:06, schrieb Dan Carpenter:
>> "filename" is a efi_char16_t string so this check for reaching the end
>> of the array doesn't work.  We need to cast the pointer to (u8 *) before
>> doing the math.
>>
>> This patch changes the "filename" to "filename_16" to avoid confusion in
>> the future.
>>
> 
> maybe it is a bit late,  but ...
> is efi_char16_t a generic requirement for EFI ? perhaps we can use wchar_t
> since it is intended for such cases. additional we would get an api for free.
> 

wchar_t is typically 32 bits on Linux.  16-bit anything is a major fail
since Unicode doesn't actually fit in 16 bits.

	-hpa

