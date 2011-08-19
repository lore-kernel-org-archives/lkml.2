Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753747Ab1HSRtY (ORCPT <rfc822;w@1wt.eu>);
	Fri, 19 Aug 2011 13:49:24 -0400
Received: from mail-qw0-f46.google.com ([209.85.216.46]:53205 "EHLO
	mail-qw0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752123Ab1HSRtW convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 19 Aug 2011 13:49:22 -0400
MIME-Version: 1.0
In-Reply-To: <op.v0g1r5pu3l0zgt@mnazarewicz-glaptop>
References: <1313764105-28437-1-git-send-email-per.forlin@stericsson.com>
	<op.v0gvr6sv3l0zgt@mnazarewicz-glaptop>
	<CAJ0pr190skvT3Zee3Mm1pkS5JJ1Abxjti0t_XxZBKE7tFj4avA@mail.gmail.com>
	<op.v0g1r5pu3l0zgt@mnazarewicz-glaptop>
Date: Fri, 19 Aug 2011 19:49:20 +0200
Message-ID: <CAJ0pr190Lh74P_sj+BLm3-rwEJ64p+E0wtEU9JRev9TXYwo5FA@mail.gmail.com>
Subject: Re: [PATCH v5] usb: gadget: storage: make FSG_NUM_BUFFERS variable size
From: Per Forlin <per.forlin@linaro.org>
To: Michal Nazarewicz <mina86@mina86.com>
Cc: Felipe Balbi <balbi@ti.com>, Alan Stern <stern@rowland.harvard.edu>,
        Per Forlin <per.forlin@stericsson.com>, linux-usb@vger.kernel.org,
        linux-kernel@vger.kernel.org, linaro-dev@lists.linaro.org,
        Greg Kroah-Hartman <gregkh@suse.de>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

2011/8/19 Michal Nazarewicz <mina86@mina86.com>:
> On Fri, 19 Aug 2011 19:15:32 +0200, Per Forlin <per.forlin@linaro.org>
> wrote:
>
>> 2011/8/19 Michal Nazarewicz <mina86@mina86.com>:
>>>
>>> On Fri, 19 Aug 2011 16:28:25 +0200, Per Forlin
>>> <per.forlin@stericsson.com>
>>> wrote:
>>>>
>>>> @@ -3605,6 +3608,9 @@ static int __init fsg_init(void)
>>>>       int             rc;
>>>>       struct fsg_dev  *fsg;
>>>> +       if (!FSG_NUM_BUFFERS_IS_VALID(fsg_num_buffers))
>>>
>>> Care to add pr_err() here?  Or better yet, change
>>> fsg_num_buffers_is_valid()
>>> to a function, eg.:
>>>
>>> static inline int fsg_num_buffers_validate()
>>> {
>>>       if (fsg_num_buffers && fsg_num_buffers <= 4)
>>>               return 0;
>>>       pr_err("fsg_num_buffers too high: %u\n", fsg_num_buffers);
>>>       return -EINVAL;
>>> }
>>>
>> Look good.
>> This will permit only 1 buffer to be used. Is this intentionally? I'm
>> fine with it.
>> In Kconfig the range is 2 to 4. For debug purposes there may be a
>> point of permitting range 1 to 4.
>
> Ah, sorry, no.  I meant >= 2.  Whether we want to allow a single buffer
> is another story (we might, why not?).
>
I stick with 2 to 4 in this patch. There may be other reasons for
permitting only 1 but for this patch it isn't relevant.

Thanks,
Per

> Best regards,                                         _     _
> .o. | Liege of Serenely Enlightened Majesty of      o' \,=./ `o
> ..o | Computer Science,  Michal "mina86" Nazarewicz    (o o)
> ooo +-----<email/xmpp: mnazarewicz@google.com>-----ooO--(_)--Ooo--
>
