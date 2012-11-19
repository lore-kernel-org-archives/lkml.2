Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753585Ab2KSX4Z (ORCPT <rfc822;w@1wt.eu>);
	Mon, 19 Nov 2012 18:56:25 -0500
Received: from terminus.zytor.com ([198.137.202.10]:35509 "EHLO mail.zytor.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753268Ab2KSX4Y (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 19 Nov 2012 18:56:24 -0500
User-Agent: K-9 Mail for Android
In-Reply-To: <CAE9FiQVMsBS-c+H7+q3hi5hdvcZ8_AYqm5RV_dOVbV9L1UnxTA@mail.gmail.com>
References: <1353222571-31544-1-git-send-email-yinghai@kernel.org> <1353222571-31544-4-git-send-email-yinghai@kernel.org> <50AAB5E8.5070807@zytor.com> <CAE9FiQV=G=5zAqv7EiUnb=O7znxuieiCawfgomv9aPNwVAV4uQ@mail.gmail.com> <50AABD15.1050809@zytor.com> <CAE9FiQVMsBS-c+H7+q3hi5hdvcZ8_AYqm5RV_dOVbV9L1UnxTA@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain;
 charset=UTF-8
Content-Transfer-Encoding: 8bit
Subject: Re: [PATCH v2 03/13] x86: Add macro for 64bit entry startup_64
From: "H. Peter Anvin" <hpa@zytor.com>
Date: Mon, 19 Nov 2012 15:55:45 -0800
To: Yinghai Lu <yinghai@kernel.org>
CC: Thomas Gleixner <tglx@linutronix.de>, Ingo Molnar <mingo@elte.hu>,
        "Eric W. Biederman" <ebiederm@xmission.com>,
        linux-kernel@vger.kernel.org, Matt Fleming <matt.fleming@intel.com>
Message-ID: <41603b4d-cd34-4c6e-9e1f-ac78816b5097@email.android.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

We probably should add a flag for those, but that is more of a boot_flag...

Yinghai Lu <yinghai@kernel.org> wrote:

>On Mon, Nov 19, 2012 at 3:13 PM, H. Peter Anvin <hpa@zytor.com> wrote:
>> On 11/19/2012 02:53 PM, Yinghai Lu wrote:
>>>
>>> any other field, in header struct field that we can use to tell
>>> bzImage could be used that
>>> 0x200 directly?
>>>
>>> hardware_subarch?
>>>
>>
>> There isn't one... this dates back all the way to the original x86-64
>> kernels.
>>
>> Are you asking if we can tell this is a 64-bit kernel (as opposed to
>a
>> 32-bit kernel, which obviously doesn't have a 64-bit entry point)?
>> Unfortunately there isn't an intentional one that I know of.  There
>> might be an accidental such indicator, but we'd have to go back to
>look
>> at 8+ years of kernels.  We can't even rely on a jmp instruction at
>the
>> address...
>
>So we could add one field to tell that bzImage could be used with
>64bit?
>
>current in this patchset, I added
>
>0268/4  2.12+   ext_ramdisk_image ramdisk_image 32 bits
>026C/4  2.12+   ext_ramdisk_size ramdisk_size high 32 bits
>0270/4  2.12+   code64_start_offset 64bit start offset for bzImage
>0274/4  2.12+   ext_cmd_line_ptr cmd_line_ptr high 32 bits
>
>so you don't like code64_start_offset.
>
>how about other three?
>
>can we use bits 31 of hardware_subarch to tell it is bzImage for
>x86_64?
>
>Thanks
>
>Yinghai

-- 
Sent from my mobile phone. Please excuse brevity and lack of formatting.
