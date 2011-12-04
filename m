Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753584Ab1LDLSn (ORCPT <rfc822;w@1wt.eu>);
	Sun, 4 Dec 2011 06:18:43 -0500
Received: from youngberry.canonical.com ([91.189.89.112]:53978 "EHLO
	youngberry.canonical.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751361Ab1LDLSj convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 4 Dec 2011 06:18:39 -0500
MIME-Version: 1.0
In-Reply-To: <42689146.OPtqLboC2m@wuerfel>
References: <1322817178-8931-1-git-send-email-ming.lei@canonical.com>
	<1322817178-8931-6-git-send-email-ming.lei@canonical.com>
	<42689146.OPtqLboC2m@wuerfel>
Date: Sun, 4 Dec 2011 19:18:37 +0800
Message-ID: <CACVXFVO5Bu8vTfLN_WFsEkHW6JhQFmWPmEyNnrvTsDhoF-WVeA@mail.gmail.com>
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

Hi,

On Fri, Dec 2, 2011 at 8:33 PM, Arnd Bergmann <arnd@arndb.de> wrote:
> On Friday 02 December 2011 17:12:56 Ming Lei wrote:
>> +/**
>> + * struct v4l2_fd_result - VIDIOC_G_FD_RESULT argument
>> + * @buf_index: entry, index of v4l2_buffer for face detection
>> + * @face_cnt:  return, how many faces detected from the @buf_index
>> + * @fd:                return, result of faces' detection
>> + */
>> +struct v4l2_fd_result {
>> +       __u32   buf_index;
>> +       __u32   face_cnt;
>> +       __u32   reserved[6];
>> +       struct v4l2_fd_detection *fd;
>> +};
>
>
> This data structure is not 32/64 bit safe: running a 64 bit kernel with 32 bit
> user space will see an incompatible layout.

I agree that this is not 32/64 bit safe, but I understand lib32 can handle
this correctly, otherwise many 32bit applications can't run on current
64bit kernel
since many kernel structures used by user space contained pointer,
such as struct v4l2_buffer, struct v4l2_ext_controls in v4l2 ABI.

> One way to solve this is to remove the pointer and just start the array
> directly after the __u32 members. Alternatively, you can use a __u64
> to pass the pointer in an integer representation.

So I think this need not to be solved.

>
> A nicer interface from the data structure perspective would be to
> get rid of the array altogether and always return exactly one face.

I choose to return array to user space since v4l2 ioctl has provided
this kind of support, see video_usercopy().

thanks,
--
Ming Lei
