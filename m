Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757938Ab2HUQTY (ORCPT <rfc822;w@1wt.eu>);
	Tue, 21 Aug 2012 12:19:24 -0400
Received: from mail-gh0-f174.google.com ([209.85.160.174]:44270 "EHLO
	mail-gh0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752665Ab2HUQTS (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 21 Aug 2012 12:19:18 -0400
MIME-Version: 1.0
In-Reply-To: <20120821013958.GA27381@lizard>
References: <CACV3sbKA6pjcjc+Wr-w+JNtzJfrJS=6tcMKgDzWMaZ_AV1NQ3A@mail.gmail.com>
	<20120821013958.GA27381@lizard>
Date: Tue, 21 Aug 2012 09:19:15 -0700
X-Google-Sender-Auth: ucVLv0gvl0dUSBu0WU6gfixbJ_M
Message-ID: <CAGXu5j+KvkQV94D+kT4b5+UcCX1wZz_04STb3H4CmB1Em-fB3g@mail.gmail.com>
Subject: Re: [PATCH] pstore: add missed platform_device_unregister
From: Kees Cook <keescook@chromium.org>
To: Anton Vorontsov <cbouatmailru@gmail.com>
Cc: Jovi Zhang <bookjovi@gmail.com>, tony.luck@intel.com,
        Andrew Morton <akpm@linux-foundation.org>,
        LKML <linux-kernel@vger.kernel.org>, Colin Cross <ccross@android.com>
Content-Type: text/plain; charset=ISO-8859-1
X-System-Of-Record: true
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Aug 20, 2012 at 6:40 PM, Anton Vorontsov <cbouatmailru@gmail.com> wrote:
> On Mon, Aug 20, 2012 at 02:58:26PM +0800, Jovi Zhang wrote:
>> From 152373a6262045d19023cf45de84ad3c69316a45 Mon Sep 17 00:00:00 2001
>> From: Jovi Zhang <bookjovi@gmail.com>
>> Date: Mon, 20 Aug 2012 14:20:01 +0800
>> Subject: [PATCH] pstore: add missed platform_device_unregister
>>
>> we need unregister platform device when module exit, add it.
>>
>> Signed-off-by: Jovi Zhang <bookjovi@gmail.com>
>> ---
>>  fs/pstore/ram.c |    1 +
>>  1 file changed, 1 insertion(+)
>>
>> diff --git a/fs/pstore/ram.c b/fs/pstore/ram.c
>> index 0b311bc..adb218a 100644
>> --- a/fs/pstore/ram.c
>> +++ b/fs/pstore/ram.c
>> @@ -537,6 +537,7 @@ postcore_initcall(ramoops_init);
>>  static void __exit ramoops_exit(void)
>>  {
>>       platform_driver_unregister(&ramoops_driver);
>> +     platform_device_unregister(dummy);
>>       kfree(dummy_data);
>>  }
>>  module_exit(ramoops_exit);
>
> It looks OK to me. Unless there are objections I'll apply it to
> linux-pstore.git.

Yup, looks right.

Acked-by: Kees Cook <keescook@chromium.org>

-Kees

-- 
Kees Cook
Chrome OS Security
