Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1030835Ab2CFTzo (ORCPT <rfc822;w@1wt.eu>);
	Tue, 6 Mar 2012 14:55:44 -0500
Received: from mail-pz0-f52.google.com ([209.85.210.52]:48576 "EHLO
	mail-pz0-f52.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S965199Ab2CFTzl convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 6 Mar 2012 14:55:41 -0500
Authentication-Results: mr.google.com; spf=pass (google.com: domain of paul.gortmaker@gmail.com designates 10.68.130.193 as permitted sender) smtp.mail=paul.gortmaker@gmail.com; dkim=pass header.i=paul.gortmaker@gmail.com
MIME-Version: 1.0
In-Reply-To: <1331050578.17099.13.camel@deneb.redhat.com>
References: <1331048540.17099.9.camel@deneb.redhat.com>
	<201203061602.23512.arnd@arndb.de>
	<1331050578.17099.13.camel@deneb.redhat.com>
Date: Tue, 6 Mar 2012 14:55:40 -0500
X-Google-Sender-Auth: A4Ogy9xP2vjWJvJloBSA0p5nN-o
Message-ID: <CAP=VYLpwBth3YyHQ17Gs_GbfQHBWfcJO+VHLNnD=oBXgtCK0wQ@mail.gmail.com>
Subject: Re: lib/string.h build failure in linux-next
From: Paul Gortmaker <paul.gortmaker@windriver.com>
To: Mark Salter <msalter@redhat.com>
Cc: Arnd Bergmann <arnd@arndb.de>, linux-kernel <linux-kernel@vger.kernel.org>,
        linux-next <linux-next@vger.kernel.org>,
        linux-arch <linux-arch@vger.kernel.org>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Mar 6, 2012 at 11:16 AM, Mark Salter <msalter@redhat.com> wrote:
> On Tue, 2012-03-06 at 16:02 +0000, Arnd Bergmann wrote:
>> On Tuesday 06 March 2012, Mark Salter wrote:
>> > I'm seeing a build failure in lib/string.h in linux-next:
>> >
>> > /es/linux/linux-next/lib/string.c: In function 'strlcat':
>> > /es/linux/linux-next/lib/string.c:225:2: error: implicit declaration of function 'printk'
>> > /es/linux/linux-next/lib/string.c:225:2: error: implicit declaration of function 'panic'
>> >
>> > Commit e2950c2b6ecb928bfd3a13dd237df1f29f712704 removed an include of
>> > linux/module.h which triggered the problem for arch/c6x and probably
>> > other architectures using the asm-generic BUG macro.
>> >
>> > I think this needs fixing in asm-generic/bug.h which should include
>> > linux/kernel.h for panic and linux/printk.h for printk.
>>
>> I think you cannot do that as long as linux/kernel.h includes asm/bug.h,
>> or you will get a lot of other build failures.
>
> It didn't for my build, but to tell the truth, I really wasn't too keen
> on adding an include of kernel.h to asm/bug.h since kernel.h pulls in so
> much other stuff.
>
>>
>> The safer option is probably to add the two missing headers separately
>> to string.c.
>
> Okay, I can put together a patch that does that.

I can deal with this, since it is interaction between my bug commits and my
module commits that trigger it.  Can you tell me what config you are using, so
I can double check I have it sorted properly?

Thanks.
Paul.

>
> --Mark
>
>
> --
> To unsubscribe from this list: send the line "unsubscribe linux-kernel" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
> Please read the FAQ at  http://www.tux.org/lkml/
