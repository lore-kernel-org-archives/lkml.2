Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753974Ab2E2PUb (ORCPT <rfc822;w@1wt.eu>);
	Tue, 29 May 2012 11:20:31 -0400
Received: from mail-pb0-f46.google.com ([209.85.160.46]:50469 "EHLO
	mail-pb0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750860Ab2E2PUa convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 29 May 2012 11:20:30 -0400
MIME-Version: 1.0
In-Reply-To: <1338299104.2202.34.camel@joe2Laptop>
References: <1338289626-9021-1-git-send-email-devendra.aaru@gmail.com>
	<1338299104.2202.34.camel@joe2Laptop>
Date: Tue, 29 May 2012 20:50:30 +0530
Message-ID: <CAHdPZaPeGe6FtrU7u1JLCUKs5H3PruXBPA5zpHmEsy=w97bj2w@mail.gmail.com>
Subject: Re: [PATCH V3] [staging] bcm: Replace the BCM_DEBUG_* and BCM_SHOW_*
 macros with functions
From: "devendra.aaru" <devendra.aaru@gmail.com>
To: Joe Perches <joe@perches.com>
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Eric Dumazet <eric.dumazet@gmail.com>,
        Kevin McKinney <klmckinney1@gmail.com>, devel@driverdev.osuosl.org,
        linux-kernel@vger.kernel.org
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Joe,

On Tue, May 29, 2012 at 7:15 PM, Joe Perches <joe@perches.com> wrote:
>> diff --git a/drivers/staging/bcm/Debug.c b/drivers/staging/bcm/Debug.c
> []
>> +void bcm_debug_print(PMINI_ADAPTER Adapter, int Type, int SubType,
>> +                     int dbg_level, const char *fmt, ...)
>> +{
>> +     struct va_format vaf;
>> +     va_list args;
>> +     UINT debug_level = Adapter->stDebugState.debug_level;
>> +
>> +     va_start(args, fmt);
>> +
>> +     vaf.fmt = fmt;
>> +     vaf.va = &args;
>> +
>> +     if (DBG_TYPE_PRINTK == Type)
>> +             pr_info("%s: %pV", __func__, &vaf);
>
> func
>
>> +     else if (Adapter &&
>> +             (dbg_level & DBG_LVL_BITMASK) <= debug_level &&
>> +             (Type & Adapter->stDebugState.type) &&
>> +             (SubType & Adapter->stDebugState.subtype[Type])) {
>> +             if (dbg_level & DBG_NO_FUNC_PRINT)
>> +                     printk(KERN_DEBUG "%pV" , &vaf);
>> +             else
>> +                     printk(KERN_DEBUG "%s: %pV", __func__, &vaf);
>
> func
>
>> +     }
>> +
>> +     va_end(args);
>> +}
>> +
>> +void bcm_debug_print_buffer(PMINI_ADAPTER Adapter, int Type, int SubType,
>> +                         int dbg_level, const void *buffer, size_t bufferlen)
>> +{
>> +     if (DBG_TYPE_PRINTK == Type ||
>> +        (Adapter &&
>> +        (dbg_level & DBG_LVL_BITMASK) <= Adapter->stDebugState.debug_level &&
>> +        (Type & Adapter->stDebugState.type) &&
>> +        (SubType & Adapter->stDebugState.subtype[Type]))) {
>> +             printk(KERN_DEBUG "%s:\n", __func__);
>
> func
>
>> +             print_hex_dump(KERN_DEBUG, " ", DUMP_PREFIX_OFFSET,
>> +                            16, 1, buffer, bufferlen, false);
>> +     }
>> +}
>
> []
>
>> diff --git a/drivers/staging/bcm/Debug.h b/drivers/staging/bcm/Debug.h
> []
>> +struct _MINI_ADAPTER;
>> +
>> +__printf(5, 6)
>> +
>> +void bcm_debug_print(struct _MINI_ADAPTER *Adapter, int Type, int SubType,
>> +                     int dbg_level, const char *fmt, ...);
>
> No blank line between __printf and prototype
>
>> +void bcm_debug_print_buffer(struct _MINI_ADAPTER *Adapter, int Type, int SubType,
>> +                     int dbg_level, const void *buffer, size_t bufferlen);
>> +void bcm_show_debug_bitmap(struct _MINI_ADAPTER *Adapter);
>> +
>> +#define BCM_DEBUG_PRINT(Adapter, Type, SubType, dbg_level, fmt, ...) \
>> +     bcm_debug_print(Adapter, Type, SubType, dbg_level, fmt, ##__VA_ARGS__)
>> +
>> +#define BCM_DEBUG_PRINT_BUFFER(Adapter, Type, SubType, dbg_level,    \
>> +                             buffer, bufferlen)                      \
>> +     bcm_debug_print_buffer(Adapter, Type, SubType, dbg_level,       \
>> +                             buffer, bufferlen)
>> +#define BCM_SHOW_DEBUG_BITMAP(Adapter)                                       \
>> +     bcm_show_debug_bitmap(Adapter)
>
> Turns out to keep the same behavior, you need to add
> a const char *func argument to these functions and
> change the macros to pass __func__.
>
>
>
Ok. so what i am doing now is wrong as its a function, and __func__
gives the dbg function name, instead the called function since we
changed it to functions rather from Macros.

Ok, i will send out new changes.

Thanks,
Devendra.
