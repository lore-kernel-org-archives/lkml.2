Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932410Ab2JJRHg (ORCPT <rfc822;w@1wt.eu>);
	Wed, 10 Oct 2012 13:07:36 -0400
Received: from mailout1.w1.samsung.com ([210.118.77.11]:9065 "EHLO
	mailout1.w1.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932219Ab2JJRHb (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 10 Oct 2012 13:07:31 -0400
Message-id: <5075AB4F.3030709@samsung.com>
Date: Wed, 10 Oct 2012 19:07:27 +0200
From: Sylwester Nawrocki <s.nawrocki@samsung.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:15.0) Gecko/20120912
 Thunderbird/15.0.1
MIME-version: 1.0
To: Peter Senna Tschudin <peter.senna@gmail.com>
Cc: Mauro Carvalho Chehab <mchehab@infradead.org>,
        kernel-janitors@vger.kernel.org, Julia.Lawall@lip6.fr,
        linux-media@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH 4/14] drivers/media/v4l2-core/videobuf2-core.c: fix error
 return code
References: <1346945041-26676-10-git-send-email-peter.senna@gmail.com>
 <20121006081742.48d5e5e8@infradead.org>
 <CA+MoWDp6nMccVQxm93ht-4vxYN4HTACW+H-Xa9onaykwQFwyWw@mail.gmail.com>
In-reply-to: <CA+MoWDp6nMccVQxm93ht-4vxYN4HTACW+H-Xa9onaykwQFwyWw@mail.gmail.com>
Content-type: text/plain; charset=ISO-8859-1
Content-transfer-encoding: 7bit
X-TM-AS-MML: No
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Peter,

On 10/10/2012 06:47 PM, Peter Senna Tschudin wrote:
>>> diff --git a/drivers/media/v4l2-core/videobuf2-core.c b/drivers/media/v4l2-core/videobuf2-core.c
>>> index 4da3df6..f6bc240 100644
>>> --- a/drivers/media/v4l2-core/videobuf2-core.c
>>> +++ b/drivers/media/v4l2-core/videobuf2-core.c
>>> @@ -1876,8 +1876,10 @@ static int __vb2_init_fileio(struct vb2_queue *q, int read)
>>>        */
>>>       for (i = 0; i < q->num_buffers; i++) {
>>>               fileio->bufs[i].vaddr = vb2_plane_vaddr(q->bufs[i], 0);
>>> -             if (fileio->bufs[i].vaddr == NULL)
>>> +             if (fileio->bufs[i].vaddr == NULL) {
>>> +                     ret = -EFAULT;
>>>                       goto err_reqbufs;
>>> +             }
>>
>> Had you test this patch? I suspect it breaks the driver, as there are failures under
>> streaming handling that are acceptable, as it may indicate that userspace was not
>> able to handle all queued frames in time. On such cases, what the Kernel does is to
>> just discard the frame. Userspace is able to detect it, by looking inside the timestamp
>> added on each frame.
> 
> No, I have not tested it. This was the only place the function was
> returning non negative value for error path, so looked as a bug to me.
> May I add a comment about returning non-negative value is intended
> there?

There are several drivers depending on core modules like videobuf2. By making
random changes for something that _looks like_ a bug to you and not verifying
it by testing with at least one driver you are potentially causing trouble to
developers that are already busy fixing real bugs or working on new features.

I appreciate your help but I also don't want to see _any_ untested, not trivial
patches for core modules like videobuf2 being applied.

--
Thanks,
Sylwester

