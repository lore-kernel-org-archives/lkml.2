Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752313Ab2FSCLd (ORCPT <rfc822;w@1wt.eu>);
	Mon, 18 Jun 2012 22:11:33 -0400
Received: from mail-pb0-f46.google.com ([209.85.160.46]:52564 "EHLO
	mail-pb0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751136Ab2FSCLb (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 18 Jun 2012 22:11:31 -0400
Message-ID: <4FDFDFCE.9010307@gmail.com>
Date: Tue, 19 Jun 2012 10:11:26 +0800
From: "gnehzuil.lzheng@gmail.com" <gnehzuil.lzheng@gmail.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:8.0) Gecko/20111124 Thunderbird/8.0
MIME-Version: 1.0
To: Jens Axboe <axboe@kernel.dk>
CC: Rob Landley <rob@landley.net>, linux-doc@vger.kernel.org,
        linux-kernel@vger.kernel.org, util-linux@vger.kernel.org
Subject: Re: Why does ionice(1) ban the user to set back to 'none' class?
References: <20120618114841.GA4855@gmail.com> <4FDF2D10.9050008@kernel.dk>
In-Reply-To: <4FDF2D10.9050008@kernel.dk>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

[CC'd to util-linux mailing list]

On 06/18/2012 09:28 PM, Jens Axboe wrote:

> On 06/18/2012 01:48 PM, Zheng Liu wrote:
>> Hi Jens,
>>
>> I meet a problem when I use ionice(1) to adjust a process's io priority.
>> I do the following operations:
>>
>> $ ionice -p${pid}
>> none: prio 0
>> $ ionice -p${pid} -c2 -n4
>> $ ionice -p${pid}
>> best-effort: prio 4
>> $ ionice -p${pid} -c0 -n0
>> $ ionice -p${pid}
>> best-effort: prio 0
>>
>> So I cannot set scheduling class back to 'none'.  If I call ioprio_set(2)
>> directly, it will be fine.  But if I use ionice(1), I cannot change it.  I
>> read the docs about ionice in [1].  I notice this code:
>>
>> switch (ioprio_class) {
>> 	case IOPRIO_CLASS_NONE:
>> 		ioprio_class = IOPRIO_CLASS_BE;
>>                                ^^^^^^^^^^^^^^^^
>>                                *It means that we cannot set back to none.*
>> 		break;
>> 	case IOPRIO_CLASS_RT:
>> 	case IOPRIO_CLASS_BE:
>> 		break;
>> 	case IOPRIO_CLASS_IDLE:
>> 		ioprio = 7;
>> 		break;
>> 	default:
>> 		printf("bad prio class %d\n", ioprio_class);
>> 		return 1;
>> }
>>
>> My question is why we need to ban the user to set back to 'none'.  Is there
>> some reasons?  Thank you.
> 
> The kernel code does allow it, so it's only in the tool that this
> restriction exists. I don't think we have a particularly good reason to
> have it there. This is a tools question, though, not a kernel issue. I
> suggest you take it up with the util-linux crew. I'm fine with removing
> this restriction from ionice, especially since you could just roll your
> own that did it.
> 


Thanks for your reply.  Hopefully we can get some feedbacks from
util-linux crew.

Regards,
Zheng
