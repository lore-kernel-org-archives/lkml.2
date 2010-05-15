Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754232Ab0EOOho (ORCPT <rfc822;w@1wt.eu>);
	Sat, 15 May 2010 10:37:44 -0400
Received: from smtp-out.google.com ([74.125.121.35]:8644 "EHLO
	smtp-out.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753235Ab0EOOhm convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 15 May 2010 10:37:42 -0400
DomainKey-Signature: a=rsa-sha1; s=beta; d=google.com; c=nofws; q=dns;
	h=mime-version:in-reply-to:references:date:message-id:subject:from:to:
	cc:content-type:content-transfer-encoding:x-system-of-record;
	b=bCEmxbzyN926xvg4wj4gdHFU9ith3yeYw4dyQdI6K43+pLpBlP+/WSeY4pzWOlsFz
	0xKaM5p2E86nst4Nc5jRg==
MIME-Version: 1.0
In-Reply-To: <AANLkTinw8yj6IqmxvpTgq95RRxxh7OvXCJKqDzyTGvNp@mail.gmail.com>
References: <1273887635-27610-1-git-send-email-venki@google.com>
	 <AANLkTinw8yj6IqmxvpTgq95RRxxh7OvXCJKqDzyTGvNp@mail.gmail.com>
Date: Sat, 15 May 2010 07:37:37 -0700
Message-ID: <AANLkTikmT1ZBcke7QFdL3feI5aKKTt97OzcBclUtye7R@mail.gmail.com>
Subject: Re: [PATCH] x86: Export tsc related information in sysfs
From: Venkatesh Pallipadi <venki@google.com>
To: Jaswinder Singh Rajput <jaswinderlinux@gmail.com>
Cc: Ingo Molnar <mingo@elte.hu>, Thomas Gleixner <tglx@linutronix.de>,
       "H. Peter Anvin" <hpa@zytor.com>, Chris Mason <chris.mason@oracle.com>,
       linux-kernel@vger.kernel.org,
       Dan Magenheimer <dan.magenheimer@oracle.com>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8BIT
X-System-Of-Record: true
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sat, May 15, 2010 at 5:35 AM, Jaswinder Singh Rajput
<jaswinderlinux@gmail.com> wrote:
> Hello,
>> +
>> +static int __init init_tsc_sysfs(void)
>> +{
>> +       int err, i = 0;
>> +
>> +       err = sysdev_class_register(&tsc_sysclass);
>> +       if (err)
>> +               return err;
>> +
>> +       err = sysdev_register(&device_tsc);
>> +       if (err)
>> +               goto fail;
>
> fail will call sysdev_unregister(&device_tsc) which is not
> appropriate, please fix this goto.
>

Thanks for catching this. Will fix this in the patch refresh.

Thanks,
Venki
