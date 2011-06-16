Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753092Ab1FPFmw (ORCPT <rfc822;w@1wt.eu>);
	Thu, 16 Jun 2011 01:42:52 -0400
Received: from mail-vw0-f46.google.com ([209.85.212.46]:56606 "EHLO
	mail-vw0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751771Ab1FPFmt convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 16 Jun 2011 01:42:49 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=mime-version:sender:in-reply-to:references:date
         :x-google-sender-auth:message-id:subject:from:to:cc:content-type
         :content-transfer-encoding;
        b=qrf/NmA0IcLWDorQplnR4msiIyjmDp1Ay+zUIfznOSz6Gg7JKZsG1wS4pni8q9guP6
         /mlsOp+g4VXd0GgkWxFtd2eU66jPt055ysOursiJxRPJo3vGC9Zat2ewelbfmGIyUumN
         unPOO7ihW04iyM3Xk/wTCvxM5pruETt2mHL1w=
MIME-Version: 1.0
In-Reply-To: <BANLkTimmnUAywjHbkSoepBdyCHPHy-B3pw@mail.gmail.com>
References: <1308153214.7566.6.camel@jaguar>
	<4DF8DE26.1070301@redhat.com>
	<BANLkTi=SHENDBHdtFY_7_qtfqJb_+qKJSw@mail.gmail.com>
	<BANLkTinMDz-sqaX0cyWEoLXt70dowxofvg@mail.gmail.com>
	<4DF92C80.3030106@codemonkey.ws>
	<BANLkTimmnUAywjHbkSoepBdyCHPHy-B3pw@mail.gmail.com>
Date: Thu, 16 Jun 2011 08:42:48 +0300
X-Google-Sender-Auth: 5vicn9-fGum3u8gL0xdbRTaV38I
Message-ID: <BANLkTinuKCdghD68gp5SY3tgSz9yXLC24w@mail.gmail.com>
Subject: Re: [ANNOUNCE] Native Linux KVM tool v2
From: Pekka Enberg <penberg@kernel.org>
To: Stefan Hajnoczi <stefanha@gmail.com>
Cc: Prasad Joshi <prasadjoshi124@gmail.com>, Avi Kivity <avi@redhat.com>,
        linux-kernel@vger.kernel.org, kvm@vger.kernel.org,
        Andrew Morton <akpm@linux-foundation.org>,
        Linus Torvalds <torvalds@linux-foundation.org>,
        Ingo Molnar <mingo@elte.hu>, Sasha Levin <levinsasha928@gmail.com>,
        Cyrill Gorcunov <gorcunov@gmail.com>, Asias He <asias.hejun@gmail.com>,
        Jens Axboe <jaxboe@fusionio.com>,
        Anthony Liguori <anthony@codemonkey.ws>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Jun 16, 2011 at 8:29 AM, Stefan Hajnoczi <stefanha@gmail.com> wrote:
> On Wed, Jun 15, 2011 at 11:04 PM, Anthony Liguori <anthony@codemonkey.ws> wrote:
>> On 06/15/2011 03:13 PM, Prasad Joshi wrote:
>>>
>>> On Wed, Jun 15, 2011 at 6:10 PM, Pekka Enberg<penberg@kernel.org>  wrote:
>>>>
>>>> On Wed, Jun 15, 2011 at 7:30 PM, Avi Kivity<avi@redhat.com>  wrote:
>>>>>
>>>>> On 06/15/2011 06:53 PM, Pekka Enberg wrote:
>>>>>>
>>>>>> - Fast QCOW2 image read-write support beating Qemu in fio benchmarks.
>>>>>> See
>>>>>> the
>>>>>>   following URL for test result details:
>>>>>> https://gist.github.com/1026888
>>>>>
>>>>> This is surprising.  How is qemu invoked?
>>>>
>>>> Prasad will have the details. Please note that the above are with Qemu
>>>> defaults which doesn't use virtio. The results with virtio are little
>>>> better but still in favor of tools/kvm.
>>>>
>>>
>>> The qcow2 image used for testing was copied on to /dev/shm to avoid
>>> the disk delays in performance measurement.
>>>
>>> QEMU was invoked with following parameters
>>>
>>> $ qemu-system-x86_64 -hda<disk image on hard disk>  -hdb
>>> /dev/shm/test.qcow2 -m 1024M
>>
>> Looking more closely at native KVM tools, you would need to use the
>> following invocation to have an apples-to-apples comparison:
>>
>> qemu-system-x86_64 -drive file=/dev/shm/test.qcow2,cache=writeback,if=virtio
>
> In addition to this it is important to set identical guest RAM sizes
> (QEMU's -m <ram_mb>) option.

Right.

> If you are comparing with qemu.git rather than qemu-kvm.git then you
> need to ./configure --enable-io-thread and launch with QEMU's
> -enable-kvm option.

I think Prasad is testing qemu-kvm.git.
