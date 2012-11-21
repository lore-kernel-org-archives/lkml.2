Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753905Ab2KUA2q (ORCPT <rfc822;w@1wt.eu>);
	Tue, 20 Nov 2012 19:28:46 -0500
Received: from terminus.zytor.com ([198.137.202.10]:45503 "EHLO mail.zytor.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752254Ab2KUA2p (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 20 Nov 2012 19:28:45 -0500
Message-ID: <50AC2022.5030207@zytor.com>
Date: Tue, 20 Nov 2012 16:28:18 -0800
From: "H. Peter Anvin" <hpa@zytor.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:16.0) Gecko/20121029 Thunderbird/16.0.2
MIME-Version: 1.0
To: Yinghai Lu <yinghai@kernel.org>
CC: Thomas Gleixner <tglx@linutronix.de>, Ingo Molnar <mingo@elte.hu>,
        "Eric W. Biederman" <ebiederm@xmission.com>,
        linux-kernel@vger.kernel.org, Matt Fleming <matt.fleming@intel.com>
Subject: Re: [PATCH v2 03/13] x86: Add macro for 64bit entry startup_64
References: <1353222571-31544-1-git-send-email-yinghai@kernel.org> <1353222571-31544-4-git-send-email-yinghai@kernel.org> <50AAB5E8.5070807@zytor.com> <CAE9FiQV=G=5zAqv7EiUnb=O7znxuieiCawfgomv9aPNwVAV4uQ@mail.gmail.com> <50AABD15.1050809@zytor.com> <CAE9FiQVMsBS-c+H7+q3hi5hdvcZ8_AYqm5RV_dOVbV9L1UnxTA@mail.gmail.com> <41603b4d-cd34-4c6e-9e1f-ac78816b5097@email.android.com> <CAE9FiQVAxkS6AH6zDJAjuyiJtR2xztRG+raCk4L6yvKuskzBkg@mail.gmail.com> <CAE9FiQVrjRvQYNDdJFcyDFrr88B6v-86Zdq5a15kdHN_byDG3g@mail.gmail.com> <23b6f8fe-37cd-4cbb-9c90-511dab4e5b5b@email.android.com> <CAE9FiQUjZG_UakYdpxEf8_EHQ4UBo6GK1E_g4wDY576MFcVL4Q@mail.gmail.com> <50ABF23A.7020305@zytor.com> <CAE9FiQUBz-QLAaeyOd7E_Gzpq3m0jZOPp4+hTfdo5PaDZHRerQ@mail.gmail.com>
In-Reply-To: <CAE9FiQUBz-QLAaeyOd7E_Gzpq3m0jZOPp4+hTfdo5PaDZHRerQ@mail.gmail.com>
X-Enigmail-Version: 1.4.6
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 11/20/2012 04:20 PM, Yinghai Lu wrote:
> 
> So will have
>   Bit 1 (read): LOADED_ABOVE_4G
>   - If 1, code, boot_param, cmdline, ramdisk could be loaded above 4G,
> 
> will update the patches accordingly.
> 

No, read the below.

>>
>> On the other hand, the read flags in loadflags has not been modified for a
>> very long time, and there is a serious risk that some broken bootloader
>> might be doing a full byte comparison.
>>
>> relocatable_kernel really should have been a flag, but it is now defined as
>> a comparison with zero.  As such, and in an effort to minimize the growth of
>> struct setup_header (it is limited to little over 128 bytes long) I suggest
>> we redefine the 16-byte field at offset 0x236 as a new flags field.  We
>> still only need one flag, though.
>>
>> Backwards compatibility is so much fun.
> 
> yes. try to make it ready for future is fun too.
> 
> are you going to have pointer for ext_header ?
> 

No, it doesn't help us much.

Overall, we need to keep growth of struct setup_header under some
control.  The highest usable offset is 0x280.

	-hpa

