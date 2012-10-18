Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756778Ab2JRPvd (ORCPT <rfc822;w@1wt.eu>);
	Thu, 18 Oct 2012 11:51:33 -0400
Received: from mailout2.w1.samsung.com ([210.118.77.12]:15092 "EHLO
	mailout2.w1.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756271Ab2JRPvb (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 18 Oct 2012 11:51:31 -0400
Message-id: <50802580.7090809@samsung.com>
Date: Thu, 18 Oct 2012 17:51:28 +0200
From: Sylwester Nawrocki <s.nawrocki@samsung.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:15.0) Gecko/20120912
 Thunderbird/15.0.1
MIME-version: 1.0
To: Ezequiel Garcia <elezegarcia@gmail.com>
Cc: Peter Senna Tschudin <peter.senna@gmail.com>, pawel@osciak.com,
        m.szyprowski@samsung.com, kyungmin.park@samsung.com,
        mchehab@infradead.org, linux-media@vger.kernel.org,
        linux-kernel@vger.kernel.org, kernel-janitors@vger.kernel.org
Subject: Re: [PATCH V2] drivers/media/v4l2-core/videobuf2-core.c: fix error
 return code
References: <5075AB4F.3030709@samsung.com>
 <1350571624-4666-1-git-send-email-peter.senna@gmail.com>
 <CALF0-+WPZ7b83Mg=b1KirHt39QE4fuO4MDGhNpQNxMY09O87HA@mail.gmail.com>
In-reply-to: <CALF0-+WPZ7b83Mg=b1KirHt39QE4fuO4MDGhNpQNxMY09O87HA@mail.gmail.com>
Content-type: text/plain; charset=ISO-8859-1
Content-transfer-encoding: 7bit
X-TM-AS-MML: No
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 10/18/2012 05:28 PM, Ezequiel Garcia wrote:
> On Thu, Oct 18, 2012 at 11:47 AM, Peter Senna Tschudin
> <peter.senna@gmail.com> wrote:
>> This patch fixes a NULL pointer dereference bug at __vb2_init_fileio().
>> The NULL pointer deference happens at videobuf2-core.c:
>>
>> static size_t __vb2_perform_fileio(struct vb2_queue *q, char __user *data, size_t count,
>>                 loff_t *ppos, int nonblock, int read)
>> {
>> ...
>>         if (!q->fileio) {
>>                 ret = __vb2_init_fileio(q, read);
>>                 dprintk(3, "file io: vb2_init_fileio result: %d\n", ret);
>>                 if (ret)
>>                         return ret;
>>         }
>>         fileio = q->fileio; // NULL pointer deference here
>> ...
>> }
>>
>> It was tested with vivi driver and qv4l2 for selecting read() as capture method.
>> The OOPS happened when I've artificially forced the error by commenting the line:
>>         if (fileio->bufs[i].vaddr == NULL)
>>
> 
> ... but if you manually changed the original source, how
> can this be a real BUG?
> 
> Or am I missing something here ?

He just commented out this line to trigger the bug, i.e. to simulate
a situation where fileio->bufs[i].vaddr is NULL. Which is now not
handled properly.

--
Thanks,
Sylwester
