Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754657Ab2K2M5j (ORCPT <rfc822;w@1wt.eu>);
	Thu, 29 Nov 2012 07:57:39 -0500
Received: from mail-ea0-f174.google.com ([209.85.215.174]:36656 "EHLO
	mail-ea0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754608Ab2K2M5h convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 29 Nov 2012 07:57:37 -0500
MIME-Version: 1.0
In-Reply-To: <CAHp75VcDFG94wAhtf-4q699nuvFXwFrt=J94yD_c2EinjDTZdw@mail.gmail.com>
References: <1353508271-30646-1-git-send-email-andriy.shevchenko@linux.intel.com>
	<20121128155650.cd20d6bf.akpm@linux-foundation.org>
	<CAHp75VcDFG94wAhtf-4q699nuvFXwFrt=J94yD_c2EinjDTZdw@mail.gmail.com>
Date: Thu, 29 Nov 2012 14:57:36 +0200
Message-ID: <CAHp75VcF_F6BRjuGMsKu-u3aMHdXWGutd85jzzYcLRmSX6=8ow@mail.gmail.com>
Subject: Re: [PATCH, resend] kfifo: initialize fifo accordingly to C99 standard
From: Andy Shevchenko <andy.shevchenko@gmail.com>
To: Andrew Morton <akpm@linux-foundation.org>
Cc: Andy Shevchenko <andriy.shevchenko@linux.intel.com>,
        linux-kernel@vger.kernel.org, Stefani Seibold <stefani@seibold.net>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Nov 29, 2012 at 11:21 AM, Andy Shevchenko
<andy.shevchenko@gmail.com> wrote:
> On Thu, Nov 29, 2012 at 1:56 AM, Andrew Morton
> <akpm@linux-foundation.org> wrote:
>> On Wed, 21 Nov 2012 16:31:11 +0200
>> Andy Shevchenko <andriy.shevchenko@linux.intel.com> wrote:
>>
>>> When build a kernel with "make W=1" we will get a warning about missing
>>> initializer. It comes from kfifo usage style. The DEFINE_KFIFO macro doesn't
>>> initialize the buf[] field of the fifo structure. So, using C99 style helps in
>>> such case.
>>
>> I see no such warning.  When fixing warnings or compilation errors,
>> please always quote the compiler output in the changelog.
>
> Oh, I did wrong assumption. However, it looks like linux-stable 3.0.y
> is affected;
>
>   CC [M]  samples/kfifo/inttype-example.o
> samples/kfifo/inttype-example.c:44:506: warning: missing initializer
> [-Wmissing-field-initializers]
> samples/kfifo/inttype-example.c:44:506: warning: (near initialization
> for ‘(anonymous).buf’) [-Wmissing-field-initializers]
>
> And it seems that my solution not the one which is used in linux-next.

Okay. I found the commit f858ee8b8cd8c216ddbeefae6e047ce90cae9cca
("kbuild: disable -Wmissing-field-initializers for W=1") hides the
warning.
After reverting this one I get the same warning as before:

  CC [M]  samples/kfifo/inttype-example.o
samples/kfifo/inttype-example.c:44:506: warning: missing initializer
[-Wmissing-field-initializers]
samples/kfifo/inttype-example.c:44:506: warning: (near initialization
for ‘(anonymous).buf’) [-Wmissing-field-initializers]

> gcc (Debian 4.7.2-2) 4.7.2


-- 
With Best Regards,
Andy Shevchenko
