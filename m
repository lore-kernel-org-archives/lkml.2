Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755796Ab2GEICi (ORCPT <rfc822;w@1wt.eu>);
	Thu, 5 Jul 2012 04:02:38 -0400
Received: from mail-ee0-f46.google.com ([74.125.83.46]:42798 "EHLO
	mail-ee0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755392Ab2GEICb convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 5 Jul 2012 04:02:31 -0400
MIME-Version: 1.0
In-Reply-To: <1341414588.3627.42.camel@joe2Laptop>
References: <1341341280.2012.3.camel@joe2Laptop>
	<1341391552-4842-1-git-send-email-andriy.shevchenko@linux.intel.com>
	<1341391552-4842-2-git-send-email-andriy.shevchenko@linux.intel.com>
	<1341414588.3627.42.camel@joe2Laptop>
Date: Thu, 5 Jul 2012 11:02:28 +0300
Message-ID: <CAHp75VfOjRL3w-tFLkyWAy3eh-wUOmCd9i5BGscoW=noqjbmBA@mail.gmail.com>
Subject: Re: [PATCHv3 2/3] lib: printf: append support of '%*ph[CDN]'
From: Andy Shevchenko <andy.shevchenko@gmail.com>
To: Joe Perches <joe@perches.com>
Cc: Andy Shevchenko <andriy.shevchenko@linux.intel.com>,
        Andrew Morton <akpm@linux-foundation.org>, proski@gnu.org,
        Andrei Emeltchenko <andrei.emeltchenko@intel.com>,
        linux-wireless@vger.kernel.org, LKML <linux-kernel@vger.kernel.org>,
        Larry Finger <Larry.Finger@lwfinger.net>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Jul 4, 2012 at 6:09 PM, Joe Perches <joe@perches.com> wrote:
> On Wed, 2012-07-04 at 11:45 +0300, Andy Shevchenko wrote:
>> This patch adds a support of the variable width buffer to print it
>> as a hex string with a delimiter.

>> +     if (spec.field_width <= 0)
>> +             /* nothing to print */
>> +             return buf;
>
> It may be better to default to a 1 and add
>
>         if (addr == ZERO_OR_NULL_PTR)
>
> to avoid dereferencing a NULL or a pointer
> to a zero length object.
Good point.

>> +             for (p = hex_str; *p != '\0'; p++) {
>> +                     if (buf < end)
>> +                             *buf = *p;
>> +                     ++buf;
>> +             }
>
> why not just directly write to *buf as long as buf < end?
buf < end - 1, otherwise correct.
And yes, it eliminates hex_str array as well.

-- 
With Best Regards,
Andy Shevchenko
