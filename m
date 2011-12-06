Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933244Ab1LFNLP (ORCPT <rfc822;w@1wt.eu>);
	Tue, 6 Dec 2011 08:11:15 -0500
Received: from youngberry.canonical.com ([91.189.89.112]:50130 "EHLO
	youngberry.canonical.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754530Ab1LFNLL convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 6 Dec 2011 08:11:11 -0500
MIME-Version: 1.0
In-Reply-To: <201112061255.56136.arnd@arndb.de>
References: <1322817178-8931-1-git-send-email-ming.lei@canonical.com>
	<201112051437.27538.arnd@arndb.de>
	<CACVXFVMB+HuQDb+Pxo0d8x46P82-c-OPxaL0c661Wztyx3NWJA@mail.gmail.com>
	<201112061255.56136.arnd@arndb.de>
Date: Tue, 6 Dec 2011 21:11:08 +0800
Message-ID: <CACVXFVPYUY-vpeoKJKX2XN7-0w+=seW0u3EaP=hD9m1Sy7nkTQ@mail.gmail.com>
Subject: Re: [RFC PATCH v1 5/7] media: v4l2: introduce two IOCTLs for face detection
From: Ming Lei <ming.lei@canonical.com>
To: Arnd Bergmann <arnd@arndb.de>
Cc: linux-arm-kernel@lists.infradead.org,
        Mauro Carvalho Chehab <mchehab@infradead.org>,
        Tony Lindgren <tony@atomide.com>, Greg KH <greg@kroah.com>,
        linux-kernel@vger.kernel.org, Sylwester Nawrocki <snjw23@gmail.com>,
        Alan Cox <alan@lxorguk.ukuu.org.uk>, linux-omap@vger.kernel.org
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Dec 6, 2011 at 8:55 PM, Arnd Bergmann <arnd@arndb.de> wrote:
> On Tuesday 06 December 2011, Ming Lei wrote:
>> diff --git a/include/linux/videodev2.h b/include/linux/videodev2.h
>> index 073eb4d..8aeaa1e 100644
>> --- a/include/linux/videodev2.h
>> +++ b/include/linux/videodev2.h
>> @@ -2214,7 +2214,12 @@ struct v4l2_fd_result {
>>         __u32   buf_index;
>>         __u32   face_cnt;
>>         __u32   reserved[6];
>> -       struct v4l2_fd_detection *fd;
>> +
>> +       /*make 64/32 compatible*/
>> +       union {
>> +               struct v4l2_fd_detection *fd;
>> +               __u64   dummy;
>> +       };
>>  };
>>
>
> That's not compatible, at least not on any big-endian architecture.
> If you want to have an indirect pointer, you have to cast it to the
> __u64 member in user space and back in kernel space.

Looks like it is a bit ugly.

>
> Using an array added to the end of the v4l2_fd_result structure
> rather than a pointer would really make this easier IMHO.

I have tried to do this, but video_usercopy needs a few changes
to handle array args if no indirect pointer is passed to kernel.

I am not sure if media guys are happy to accept the changes, :-)

thanks,
--
Ming Lei
