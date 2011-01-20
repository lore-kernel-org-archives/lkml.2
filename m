Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751516Ab1ATFAR (ORCPT <rfc822;w@1wt.eu>);
	Thu, 20 Jan 2011 00:00:17 -0500
Received: from mail-ww0-f44.google.com ([74.125.82.44]:36764 "EHLO
	mail-ww0-f44.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750715Ab1ATFAP convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 20 Jan 2011 00:00:15 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=mime-version:in-reply-to:references:from:date:message-id:subject:to
         :cc:content-type:content-transfer-encoding;
        b=EOD6oI9jmwiJDfmJd+9TRW6D/sGNldvylCLyIIy6rQtkUnFn/NqUttr/m4AzIafG5+
         A1PGT0jDOGyjiBmgUGZvEu7fShcc9zsvEd793YCsq6jnaqOjX9fzasOAyq+Z1ek+EnKr
         yoggU7/496Alc/Ig+fRbXVt7Ol2OBCCV+XU8A=
MIME-Version: 1.0
In-Reply-To: <20110119074902.GA1670@gentoo.trippels.de>
References: <AANLkTimajU0x1v6y3rH2+jr-bZ=tNLs1S_agXdGGAa3S@mail.gmail.com>
 <20110119073905.GA1652@gentoo.trippels.de> <20110119074902.GA1670@gentoo.trippels.de>
From: Alexandre Courbot <gnurou@gmail.com>
Date: Thu, 20 Jan 2011 13:59:52 +0900
Message-ID: <AANLkTimUGnM1CwYqAOkax-F163Msedi5Xd60jH3n6uU+@mail.gmail.com>
Subject: Re: Linux 2.6.38-rc1 doesn't boot
To: Markus Trippelsdorf <markus@trippelsdorf.de>
Cc: Linus Torvalds <torvalds@linux-foundation.org>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        Shaohua Li <shaohua.li@intel.com>, Ingo Molnar <mingo@elte.hu>,
        Sam Ravnborg <sam@ravnborg.org>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

>> Unfortunately 2.6.38-rc1 doesn't even boot on my machine (amd64).
>> This is caused by 86b1e8dd83cbb0f:
>>     x86: Make relocatable kernel work with new binutils
>>
>> Reverting the commit solves the problem.
>
> I'm running the latest binutils:
> GNU ld (Linux/GNU Binutils) 2.21.51.0.5.20110104

Same thing here on x86_64 with Binutils 2.21.0.20101217. Boot stops
after "Booting the kernel" message, regardless of whether
CONFIG_RELOCATABLE is set or not.

System.map has
ffffffff02c92880 D jiffies_64

Reverting the patch also solved the problem for me.

Alex.
