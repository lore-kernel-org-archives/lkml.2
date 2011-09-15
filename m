Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933931Ab1IOOs1 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 15 Sep 2011 10:48:27 -0400
Received: from oproxy6-pub.bluehost.com ([67.222.54.6]:35699 "HELO
	oproxy6-pub.bluehost.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with SMTP id S933524Ab1IOOsZ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 15 Sep 2011 10:48:25 -0400
Message-ID: <4E721033.8060201@tao.ma>
Date: Thu, 15 Sep 2011 22:48:19 +0800
From: Tao Ma <tm@tao.ma>
User-Agent: Mozilla/5.0 (X11; U; Linux x86_64; en-US; rv:1.9.2.21) Gecko/20110831 Thunderbird/3.1.13
MIME-Version: 1.0
To: Jens Axboe <jaxboe@fusionio.com>
CC: Christoph Hellwig <hch@infradead.org>, Shaohua Li <shli@kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH RESEND] block: Don't check QUEUE_FLAG_SAME_COMP in __blk_complete_request.
References: <1315984992-5158-1-git-send-email-tm@tao.ma> <1315984992-5158-2-git-send-email-tm@tao.ma> <CANejiEWa5um5LtRkL3NcbNgBnUCG1Ud8qw-hfXW3X3GPfHv4iQ@mail.gmail.com> <4E715FE2.7040004@tao.ma> <20110915111728.GA6275@infradead.org> <4E71E15F.1050507@fusionio.com>
In-Reply-To: <4E71E15F.1050507@fusionio.com>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
X-Identified-User: {1390:box585.bluehost.com:colyli:tao.ma} {sentby:smtp auth 221.217.44.169 authed with tm@tao.ma}
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 09/15/2011 07:28 PM, Jens Axboe wrote:
> On 2011-09-15 13:17, Christoph Hellwig wrote:
>> On Thu, Sep 15, 2011 at 10:16:02AM +0800, Tao Ma wrote:
>>>> why not delete bio_set_completion_cpu()?
>>> Not sure. It is added in commit c7c22e4d from the very beginning, and in
>>> the commit log Jens described it as:
>>> A bio helper (bio_set_completion_cpu()) is also added, so that queuers
>>> can ask for completion on that specific CPU. Maybe it is obsolete.
>>> Anyway, I am fine to generate a patch to remove it if you prefer.
>>>> 1. nobody uses it in my search
>>> yes, but it may be designed for someone to use it. The same goes with
>>> BIO_CPU_AFFINE.
>>
>> This code is unused, and from the all the discussions lately pretty
>> obviously broken.  The only thing keeping it serves is creating more
>> confusion and possibly more bugs.
> 
> We can kill bio_set_completion_cpu(). I'm fine with leaving cpu control
> to the request based drivers, they are the only ones that can toggle the
> setting anyway.
So we should remove bio_comp_cpu and BIO_CPU_AFFINE also if we have
decided to only leave cpu control to the request based drivers, right?

I will generate a patch for it later.

Thanks
Tao
