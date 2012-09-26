Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753003Ab2IZGzY (ORCPT <rfc822;w@1wt.eu>);
	Wed, 26 Sep 2012 02:55:24 -0400
Received: from mail-pb0-f46.google.com ([209.85.160.46]:61406 "EHLO
	mail-pb0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752861Ab2IZGzX (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 26 Sep 2012 02:55:23 -0400
MIME-Version: 1.0
In-Reply-To: <5062938F.2080703@hitachi.com>
References: <CANFS6bZtOPe8XbsgC0V0encVLssFShWGhNLZQkCvEhKcNT946w@mail.gmail.com>
	<5062938F.2080703@hitachi.com>
Date: Wed, 26 Sep 2012 15:55:23 +0900
Message-ID: <CANFS6bYRS24woCsuqKdfZxTNFzNNS-honfKPyPPGLTiP1fnBEQ@mail.gmail.com>
Subject: Re: [QUESTION] Can uprobe_event support @ADDR, $retval, offs(FETCHARG)?
From: Hyeoncheol Lee <hyc.lee@gmail.com>
To: Masami Hiramatsu <masami.hiramatsu.pt@hitachi.com>
Cc: srikar@linux.vnet.ibm.com, linux-kernel@vger.kernel.org,
        yrl.pp-manager.tt@hitachi.com
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi,

2012/9/26 Masami Hiramatsu <masami.hiramatsu.pt@hitachi.com>:
> (2012/09/26 11:52), Hyeoncheol Lee wrote:
>> Hi,
>>
>> uprobe_event only supports %REG arguments. I think that memory fetch,
>> return value fetch, memory dereference functions in
>> kernel/trace/trace_probe.c are good for uprobe_event. So with a little
>> modification of parse_probe_arg(), uprobe_event can support @ADDR,
>> $retval, offs(FETCHARGS) except @SYM, $stack, $stackN. Is it right?
>
> Hi Hyeoncheol,
>
> Perhaps, it is not so small things, but at least, we can try.
> In the userspace, memories(pages) can be paged out on swap or
> files. In that case, memory dereference function needs to track
> down the data on the disk and it causes I/O. This means we will
> see the visible performance degradation with tracing.
> And also, sometime a pointer value (address) is broken, in that
> case we have to ensure the address is actually valid before
> accessing it.
>
> Of cause, without tracking paged-out data, it is easy
> to support, because that is already done in kprobe event.
> I'm not sure how it is useful, because sometimes it will
> fail to access gather the data.
> However it is good for the first step, I think.

Yes, we should consider paged-out data. I forgot this.

>
> Srikar, what would you think?
>
> BTW, if we can support offs(FETCHARGS), $stack and $stackN
> are also available. ;)

Yes, but we should check whether the given address is in an user stack
or not. and these require CPU architecture dependent codes.

>
> Thank you,
>
> --
> Masami HIRAMATSU
> Software Platform Research Dept. Linux Technology Center
> Hitachi, Ltd., Yokohama Research Laboratory
> E-mail: masami.hiramatsu.pt@hitachi.com
>
>

Thanks for your answer. It is very help to me. ;)

Hyeoncheol
