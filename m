Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755191Ab1KUO3C (ORCPT <rfc822;w@1wt.eu>);
	Mon, 21 Nov 2011 09:29:02 -0500
Received: from mail-yx0-f174.google.com ([209.85.213.174]:44056 "EHLO
	mail-yx0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752371Ab1KUO3A convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 21 Nov 2011 09:29:00 -0500
MIME-Version: 1.0
X-Originating-IP: [212.179.42.66]
In-Reply-To: <CALKntY1i+NHE6HuDMME+WuAVmWG=tHuV=RsK9B3VnpVgcSJiRg@mail.gmail.com>
References: <CALKntY135akw4khsrbVdk2L-YgF0aYsaHw6Lhf7n4gU6MTrZuQ@mail.gmail.com>
	<CAOtvUMeHu_88Tye6CMaHpRwYY_vuz=9hE48DsJz0ARhMHYju-w@mail.gmail.com>
	<CALKntY1i+NHE6HuDMME+WuAVmWG=tHuV=RsK9B3VnpVgcSJiRg@mail.gmail.com>
Date: Mon, 21 Nov 2011 16:28:59 +0200
Message-ID: <CAOtvUMdQApbRCd-+kK8LPiVE6+uk=ERnM76z8UNoapCqV=jP6Q@mail.gmail.com>
Subject: Re: Running Application Inside Application
From: Gilad Ben-Yossef <gilad@benyossef.com>
To: Xin Tong <xerox.time.tech@gmail.com>
Cc: linux-kernel <linux-kernel@vger.kernel.org>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Nov 21, 2011 at 2:54 PM, Xin Tong <xerox.time.tech@gmail.com> wrote:
>
> Your method looks interesting and neat. I have another question, is there a way for me to preload a .so and hijack the startup32 function so that it does not call main, instead it calls some functions within the preloaded .so ?
>

Donno, on your constructor, locate the symbol for main and plant a
jump or call instruction there to your function in the .so? this gets
real hairy real quick...

At any rate, it is not Linux kernel mailing list stuff. Try StackOverflow... :-)

Gilad

> Thanks
>
>
> Xin
>
> On Mon, Nov 21, 2011 at 1:41 AM, Gilad Ben-Yossef <gilad@benyossef.com> wrote:
>>
>> On Mon, Nov 21, 2011 at 4:18 AM, Xin Tong <xerox.time.tech@gmail.com> wrote:
>>>
>>> I have applications that do not install signal handlers I need it to
>>> install. Therefore, I am thinking about having a light-weight run-time
>>> to load the application ELF file and install the needed signal handler
>>> in the run-time ? Is this doable ? What if it is not ELF-encoded ?
>>
>> There is a much easier way: create a dynamically linked library (let's call it libsig.so) with code like so:
>> int install_sig_handlers __attribute__((constructor)) {
>>    // Do what you need here
>> }
>> Then run your app like so:
>> LD_PRELOAD=/path/to/libsig.so /path/to/your/app
>> Unless your application is static and/or SUID the dynamic linker will load libsig.so into your app memory space and will run the constructor function where you can install signal handler at will
>> Gilad
>>
>>>
>>> Thanks
>>>
>>> Xin
>>> --
>>> To unsubscribe from this list: send the line "unsubscribe linux-kernel" in
>>> the body of a message to majordomo@vger.kernel.org
>>> More majordomo info at  http://vger.kernel.org/majordomo-info.html
>>> Please read the FAQ at  http://www.tux.org/lkml/
>>
>>
>>
>> --
>> Gilad Ben-Yossef
>> Chief Coffee Drinker
>> gilad@benyossef.com
>> Israel Cell: +972-52-8260388
>> US Cell: +1-973-8260388
>> http://benyossef.com
>>
>> "Unfortunately, cache misses are an equal opportunity pain provider."
>> -- Mike Galbraith, LKML
>



--
Gilad Ben-Yossef
Chief Coffee Drinker
gilad@benyossef.com
Israel Cell: +972-52-8260388
US Cell: +1-973-8260388
http://benyossef.com

"Unfortunately, cache misses are an equal opportunity pain provider."
-- Mike Galbraith, LKML
