Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756623Ab1HSRer (ORCPT <rfc822;w@1wt.eu>);
	Fri, 19 Aug 2011 13:34:47 -0400
Received: from mail-fx0-f46.google.com ([209.85.161.46]:39198 "EHLO
	mail-fx0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756376Ab1HSReq (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 19 Aug 2011 13:34:46 -0400
Content-Type: text/plain; charset=utf-8; format=flowed; delsp=yes
To: "Per Forlin" <per.forlin@linaro.org>
Cc: "Felipe Balbi" <balbi@ti.com>, "Alan Stern" <stern@rowland.harvard.edu>,
        "Per Forlin" <per.forlin@stericsson.com>, linux-usb@vger.kernel.org,
        linux-kernel@vger.kernel.org, linaro-dev@lists.linaro.org,
        "Greg Kroah-Hartman" <gregkh@suse.de>
Subject: Re: [PATCH v5] usb: gadget: storage: make FSG_NUM_BUFFERS variable
 size
References: <1313764105-28437-1-git-send-email-per.forlin@stericsson.com>
 <op.v0gvr6sv3l0zgt@mnazarewicz-glaptop>
 <CAJ0pr190skvT3Zee3Mm1pkS5JJ1Abxjti0t_XxZBKE7tFj4avA@mail.gmail.com>
Date: Fri, 19 Aug 2011 19:34:43 +0200
MIME-Version: 1.0
Content-Transfer-Encoding: 7bit
From: "Michal Nazarewicz" <mina86@mina86.com>
Message-ID: <op.v0g1r5pu3l0zgt@mnazarewicz-glaptop>
In-Reply-To: <CAJ0pr190skvT3Zee3Mm1pkS5JJ1Abxjti0t_XxZBKE7tFj4avA@mail.gmail.com>
User-Agent: Opera Mail/11.50 (Linux)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, 19 Aug 2011 19:15:32 +0200, Per Forlin <per.forlin@linaro.org>  
wrote:

> 2011/8/19 Michal Nazarewicz <mina86@mina86.com>:
>> On Fri, 19 Aug 2011 16:28:25 +0200, Per Forlin  
>> <per.forlin@stericsson.com>
>> wrote:
>>>
>>> @@ -3605,6 +3608,9 @@ static int __init fsg_init(void)
>>>        int             rc;
>>>        struct fsg_dev  *fsg;
>>> +       if (!FSG_NUM_BUFFERS_IS_VALID(fsg_num_buffers))
>>
>> Care to add pr_err() here?  Or better yet, change  
>> fsg_num_buffers_is_valid()
>> to a function, eg.:
>>
>> static inline int fsg_num_buffers_validate()
>> {
>>        if (fsg_num_buffers && fsg_num_buffers <= 4)
>>                return 0;
>>        pr_err("fsg_num_buffers too high: %u\n", fsg_num_buffers);
>>        return -EINVAL;
>> }
>>
> Look good.
> This will permit only 1 buffer to be used. Is this intentionally? I'm
> fine with it.
> In Kconfig the range is 2 to 4. For debug purposes there may be a
> point of permitting range 1 to 4.

Ah, sorry, no.  I meant >= 2.  Whether we want to allow a single buffer
is another story (we might, why not?).

-- 
Best regards,                                         _     _
.o. | Liege of Serenely Enlightened Majesty of      o' \,=./ `o
..o | Computer Science,  Michal "mina86" Nazarewicz    (o o)
ooo +-----<email/xmpp: mnazarewicz@google.com>-----ooO--(_)--Ooo--
