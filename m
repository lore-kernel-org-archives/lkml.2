Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932150Ab2AQXs2 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 17 Jan 2012 18:48:28 -0500
Received: from mail-tul01m020-f174.google.com ([209.85.214.174]:56750 "EHLO
	mail-tul01m020-f174.google.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S932113Ab2AQXs0 convert rfc822-to-8bit
	(ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 17 Jan 2012 18:48:26 -0500
MIME-Version: 1.0
In-Reply-To: <20120117135921.3f68701e.akpm@linux-foundation.org>
References: <20120107171516.GE2618@outflux.net>
	<20120117135921.3f68701e.akpm@linux-foundation.org>
Date: Tue, 17 Jan 2012 15:48:25 -0800
X-Google-Sender-Auth: SPZbnxRNUZ4JiUmhkt-rHy4pOww
Message-ID: <CAGXu5jJ_RWNKC7QgGXYgLFv6QCmkjw4z11WVcB=8BFacye0a3Q@mail.gmail.com>
Subject: Re: [PATCH v4] ramoops: use pstore interface
From: Kees Cook <keescook@chromium.org>
To: Andrew Morton <akpm@linux-foundation.org>
Cc: Tony Luck <tony.luck@intel.com>,
        Marco Stornelli <marco.stornelli@gmail.com>,
        Arnd Bergmann <arnd@arndb.de>, Greg Kroah-Hartman <greg@kroah.com>,
        Randy Dunlap <rdunlap@xenotime.net>, linux-doc@vger.kernel.org,
        linux-kernel@vger.kernel.org
X-System-Of-Record: true
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Jan 17, 2012 at 1:59 PM, Andrew Morton
<akpm@linux-foundation.org> wrote:
> On Sat, 7 Jan 2012 09:15:16 -0800
> Kees Cook <keescook@chromium.org> wrote:
>
>> Instead of using /dev/mem directly, use the common pstore infrastructure
>> to handle Oops gathering and extraction.
>
> um, why?  This changelog provides no reason for anyone to apply the
> patch!

Good point; this was lost as the patch cycled. I will expand this.

>> +     struct ramoops_context *cxt = (struct ramoops_context *)psi->data;
>
> Unneeded and undesirable cast of void*.  Multiple instances of this.

Ah yes; I will fix this.

>> +     /* TODO(kees): Bogus time for the moment. */
>
> Is this hard to fix now?

I felt it was out of scope for the moment. There was enough change
happening for bolting it to pstore that adding a header with magic
values, etc, seemed like a logically separate task. As such, I left
this as TODO.

> Note that pstore_get_records() will treat the -ve errno returns from
> ->read() in the same manner as EOF.  IOW, your error codes will be
> dropped on the floor.  This appears to be a bug in pstore_get_records().

Well, IIUC, it just means the file doesn't get populated at all; there
is no userspace interface to finding out why a file didn't appear in
the pstore fliesystem. But yes, the specifics of the error are ignored
by pstore_get_records(). It didn't seem wrong to produce meaningful
codes in ramoops, though.

>> +     /* Only store dmesg dumps. */
>> +     if (type != PSTORE_TYPE_DMESG)
>> +             return -EINVAL;
>> +
>> +     /* Only store crash dumps. */
>>       if (reason != KMSG_DUMP_OOPS &&
>> -         reason != KMSG_DUMP_PANIC &&
>> -         reason != KMSG_DUMP_KEXEC)
>> -             return;
>> +         reason != KMSG_DUMP_PANIC)
>> +             return -EINVAL;
>>
>>       /* Only dump oopses if dump_oops is set */
>>       if (reason == KMSG_DUMP_OOPS && !cxt->dump_oops)
>
> The above three comments describe what the code does, which was
> obvious.  They failed to describe why it does this, which was
> unobvious.  Sigh.

They were terse; I will attempt to expand on them.

Thanks for the review! I will send v5 shortly...

-Kees

-- 
Kees Cook
ChromeOS Security
