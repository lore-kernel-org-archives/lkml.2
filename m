Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753674Ab2KTTUl (ORCPT <rfc822;w@1wt.eu>);
	Tue, 20 Nov 2012 14:20:41 -0500
Received: from mail-bk0-f46.google.com ([209.85.214.46]:49411 "EHLO
	mail-bk0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753269Ab2KTTUj (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 20 Nov 2012 14:20:39 -0500
MIME-Version: 1.0
In-Reply-To: <CAE9FiQVAxkS6AH6zDJAjuyiJtR2xztRG+raCk4L6yvKuskzBkg@mail.gmail.com>
References: <1353222571-31544-1-git-send-email-yinghai@kernel.org>
	<1353222571-31544-4-git-send-email-yinghai@kernel.org>
	<50AAB5E8.5070807@zytor.com>
	<CAE9FiQV=G=5zAqv7EiUnb=O7znxuieiCawfgomv9aPNwVAV4uQ@mail.gmail.com>
	<50AABD15.1050809@zytor.com>
	<CAE9FiQVMsBS-c+H7+q3hi5hdvcZ8_AYqm5RV_dOVbV9L1UnxTA@mail.gmail.com>
	<41603b4d-cd34-4c6e-9e1f-ac78816b5097@email.android.com>
	<CAE9FiQVAxkS6AH6zDJAjuyiJtR2xztRG+raCk4L6yvKuskzBkg@mail.gmail.com>
Date: Tue, 20 Nov 2012 11:20:37 -0800
X-Google-Sender-Auth: nprN7aiDZlFijXXN80e4-xDNt3A
Message-ID: <CAE9FiQVrjRvQYNDdJFcyDFrr88B6v-86Zdq5a15kdHN_byDG3g@mail.gmail.com>
Subject: Re: [PATCH v2 03/13] x86: Add macro for 64bit entry startup_64
From: Yinghai Lu <yinghai@kernel.org>
To: "H. Peter Anvin" <hpa@zytor.com>
Cc: Thomas Gleixner <tglx@linutronix.de>, Ingo Molnar <mingo@elte.hu>,
        "Eric W. Biederman" <ebiederm@xmission.com>,
        linux-kernel@vger.kernel.org, Matt Fleming <matt.fleming@intel.com>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Nov 19, 2012 at 4:39 PM, Yinghai Lu <yinghai@kernel.org> wrote:
> On Mon, Nov 19, 2012 at 3:55 PM, H. Peter Anvin <hpa@zytor.com> wrote:
>> We probably should add a flag for those, but that is more of a boot_flag...
>
> kernel_cap_bits:
> RAMDISK_ABOVE_4G  = (1<<0)
> KERNEL_ABOVE_4G =(1<<2)
> CMD_LINE_ABOVE 4G = (1<<1)
>                 .long   (RAMDISK_ABOVE_4G | CMD_LINE_ABOVE_4G | KERNEL_ABOVE_4G)

more complete version:

kernel_cap_bits:
RAMDISK_ABOVE_4G  = (1<<0)
KERNEL_ABOVE_4G =(1<<1)
BOOT_PARAMS_ABOVE_4G=(1<<2)
CMD_LINE_ABOVE 4G = (1<<3)
                .long   (RAMDISK_ABOVE_4G | BOOT_PARAMS_ABOVE_4G |
CMD_LINE_ABOVE_4G | KERNEL_ABOVE_4G)
