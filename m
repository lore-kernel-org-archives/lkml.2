Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754232Ab1KQSTO (ORCPT <rfc822;w@1wt.eu>);
	Thu, 17 Nov 2011 13:19:14 -0500
Received: from mail-iy0-f174.google.com ([209.85.210.174]:51936 "EHLO
	mail-iy0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753273Ab1KQSTM convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 17 Nov 2011 13:19:12 -0500
MIME-Version: 1.0
In-Reply-To: <201111171507.00699.arnd@arndb.de>
References: <1321478739-8978-1-git-send-email-keescook@chromium.org>
	<1321478739-8978-2-git-send-email-keescook@chromium.org>
	<201111171507.00699.arnd@arndb.de>
Date: Thu, 17 Nov 2011 10:19:11 -0800
X-Google-Sender-Auth: gQ7bbeDw6u1bdQjIKqmRswjbPrU
Message-ID: <CAGXu5jKb1csho4q2-1o8sXhFoqyVfRVOyjWH-F7n86fObHQkxQ@mail.gmail.com>
Subject: Re: [PATCH 1/2] ramoops: use pstore interface
From: Kees Cook <keescook@chromium.org>
To: Arnd Bergmann <arnd@arndb.de>
Cc: linux-kernel@vger.kernel.org, Greg Kroah-Hartman <gregkh@suse.de>,
        Andrew Morton <akpm@linux-foundation.org>,
        Nicolas Pitre <nicolas.pitre@linaro.org>,
        Ben Gardner <bgardner@wabtec.com>,
        Marco Stornelli <marco.stornelli@gmail.com>,
        Paul Gortmaker <paul.gortmaker@windriver.com>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8BIT
X-System-Of-Record: true
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Nov 17, 2011 at 7:07 AM, Arnd Bergmann <arnd@arndb.de> wrote:
> On Wednesday 16 November 2011, Kees Cook wrote:
>> Instead of using /dev/mem directly, use the common pstore infrastructure
>> to handle Oops gathering and extraction.
>>
>> Signed-off-by: Kees Cook <keescook@chromium.org>
>
> Sounds like a very good plan to me. It probably makes sense to move the
> entire driver into fs/pstore after this. Otherwise, I have only trivial
> style comments:
>
>> +static int ramoops_pstore_open(struct pstore_info *psi);
>> +static int ramoops_pstore_close(struct pstore_info *psi);
>> +static ssize_t ramoops_pstore_read(u64 *id, enum pstore_type_id *type,
>> +                                struct timespec *time,
>> +                                char **buf,
>> +                                struct pstore_info *psi);
>> +static int ramoops_pstore_write(enum pstore_type_id type,
>> +                             enum kmsg_dump_reason reason, u64 *id,
>> +                             unsigned int part,
>> +                             size_t size, struct pstore_info *psi);
>> +static int ramoops_pstore_erase(enum pstore_type_id type, u64 id,
>> +                             struct pstore_info *psi);
>
> Can you do it without forward declarations? Many people find code
> more readable if it is structure in the natural order that avoids
> these.

Actually, now that I look at it again, yeah, I can. When I did this
originally I hadn't noticed pstore_info.data. I'll use that to pass
cxt so I can avoid the forward declarations. Thanks!

>> +static int ramoops_pstore_close(struct pstore_info *psi)
>> +{
>> +     return 0;
>> +}
>
> Do you actually have to provide this if it's empty?

Yeah, though I suppose we could change pstore to DTRT in fs/pstore/platform.c:

        if (psi->close) psi->close(psi);

instead of the current:

        psi->close(psi);

> If yes, it might make sense to change the pstore code so that
> it works without a close function.

Yeah, I'll do that and send more patches. :)

Thanks!

-Kees

-- 
Kees Cook
ChromeOS Security
