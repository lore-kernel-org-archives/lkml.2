Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756849Ab2JRPjn (ORCPT <rfc822;w@1wt.eu>);
	Thu, 18 Oct 2012 11:39:43 -0400
Received: from mail-we0-f174.google.com ([74.125.82.174]:38308 "EHLO
	mail-we0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753163Ab2JRPjl (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 18 Oct 2012 11:39:41 -0400
MIME-Version: 1.0
In-Reply-To: <CALF0-+WPZ7b83Mg=b1KirHt39QE4fuO4MDGhNpQNxMY09O87HA@mail.gmail.com>
References: <5075AB4F.3030709@samsung.com>
	<1350571624-4666-1-git-send-email-peter.senna@gmail.com>
	<CALF0-+WPZ7b83Mg=b1KirHt39QE4fuO4MDGhNpQNxMY09O87HA@mail.gmail.com>
Date: Thu, 18 Oct 2012 17:39:39 +0200
Message-ID: <CA+MoWDr3+T_xHjfBAo3SJKE=ZHGr8GArG3xbJE+mULDjmD2hcQ@mail.gmail.com>
Subject: Re: [PATCH V2] drivers/media/v4l2-core/videobuf2-core.c: fix error
 return code
From: Peter Senna Tschudin <peter.senna@gmail.com>
To: Ezequiel Garcia <elezegarcia@gmail.com>
Cc: pawel@osciak.com, m.szyprowski@samsung.com, kyungmin.park@samsung.com,
        mchehab@infradead.org, linux-media@vger.kernel.org,
        linux-kernel@vger.kernel.org, kernel-janitors@vger.kernel.org
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Oct 18, 2012 at 5:28 PM, Ezequiel Garcia <elezegarcia@gmail.com> wrote:
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

It is supposed that under some circumstances, (fileio->bufs[i].vaddr
== NULL) can be true. 'While testing', my change forced the scenario
in which (fileio->bufs[i].vaddr == NULL) is true...

>
> Or am I missing something here ?
>
>     Ezequiel



-- 
Peter
