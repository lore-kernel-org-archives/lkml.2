Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758203Ab2IEI1d (ORCPT <rfc822;w@1wt.eu>);
	Wed, 5 Sep 2012 04:27:33 -0400
Received: from mail-ie0-f174.google.com ([209.85.223.174]:53630 "EHLO
	mail-ie0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757378Ab2IEI13 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 5 Sep 2012 04:27:29 -0400
MIME-Version: 1.0
In-Reply-To: <20120904122544.GC19396@mwanda>
References: <CAJKgH8Ah-aq=LfOWs2SBZnndzugNGxJbqYS11YVQLXJy6FZxkw@mail.gmail.com>
 <CAJKgH8CNJM2SyR7bD8nXae13-Fq1MP1Xn7+383YU-HPwKBe+Zg@mail.gmail.com> <20120904122544.GC19396@mwanda>
From: Manavendra Nath Manav <mnm.kernel@gmail.com>
Date: Wed, 5 Sep 2012 13:57:07 +0530
Message-ID: <CAJKgH8BkV0iRH8DN8-Y=LqvY90DHFOT_iqjTx1szgssPriThdg@mail.gmail.com>
Subject: Re: Why exported const value modified by another driver not updated
 in original driver
To: Dan Carpenter <dan.carpenter@oracle.com>
Cc: kernelnewbies@kernelnewbies.org, devel@driverdev.osuosl.org,
        Greg KH <gregkh@linuxfoundation.org>, linux-kernel@vger.kernel.org
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Sep 4, 2012 at 5:55 PM, Dan Carpenter <dan.carpenter@oracle.com> wrote:
> On Tue, Sep 04, 2012 at 03:58:20PM +0530, Manavendra Nath Manav wrote:
>> Is the above a genuine kernel bug, or i am missing something out here. Pls help.
>>
>
> When you declare something as const then the compiler assumes it
> really is const and uses a literal instead of reading from memory.
> I'm surprised the compiler doesn't print a warning message.
>
> It has to do with compilers, nothing to do with kernels.
>
> regards,
> dan carpenter

Thanks All,
I understood the problem and current gcc behaviour after looking at
output of objdump of driver.ko file when the variable is declared as
"const" and in second case as "const volatile". The compiler optimises
by directly passing the value in first case and the address of
variable in second case. Thanks for all the help and clarification.

push   $0x7b         // 123 in decimal
push   $0x0

-- 
Manavendra Nath Manav
