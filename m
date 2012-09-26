Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752010Ab2IZFdP (ORCPT <rfc822;w@1wt.eu>);
	Wed, 26 Sep 2012 01:33:15 -0400
Received: from mail9.hitachi.co.jp ([133.145.228.44]:36010 "EHLO
	mail9.hitachi.co.jp" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751393Ab2IZFdO (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 26 Sep 2012 01:33:14 -0400
X-AuditID: b753bd60-96850ba000002f78-d8-50629397f062
X-AuditID: b753bd60-96850ba000002f78-d8-50629397f062
Message-ID: <5062938F.2080703@hitachi.com>
Date: Wed, 26 Sep 2012 14:33:03 +0900
From: Masami Hiramatsu <masami.hiramatsu.pt@hitachi.com>
Organization: Hitachi, Ltd., Japan
User-Agent: Mozilla/5.0 (Windows NT 5.2; rv:13.0) Gecko/20120614 Thunderbird/13.0.1
MIME-Version: 1.0
To: Hyeoncheol Lee <hyc.lee@gmail.com>
Cc: srikar@linux.vnet.ibm.com, linux-kernel@vger.kernel.org,
        yrl.pp-manager.tt@hitachi.com
Subject: Re: [QUESTION] Can uprobe_event support @ADDR, $retval, offs(FETCHARG)?
References: <CANFS6bZtOPe8XbsgC0V0encVLssFShWGhNLZQkCvEhKcNT946w@mail.gmail.com>
In-Reply-To: <CANFS6bZtOPe8XbsgC0V0encVLssFShWGhNLZQkCvEhKcNT946w@mail.gmail.com>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
X-Brightmail-Tracker: AAAAAA==
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

(2012/09/26 11:52), Hyeoncheol Lee wrote:
> Hi,
> 
> uprobe_event only supports %REG arguments. I think that memory fetch,
> return value fetch, memory dereference functions in
> kernel/trace/trace_probe.c are good for uprobe_event. So with a little
> modification of parse_probe_arg(), uprobe_event can support @ADDR,
> $retval, offs(FETCHARGS) except @SYM, $stack, $stackN. Is it right?

Hi Hyeoncheol,

Perhaps, it is not so small things, but at least, we can try.
In the userspace, memories(pages) can be paged out on swap or
files. In that case, memory dereference function needs to track
down the data on the disk and it causes I/O. This means we will
see the visible performance degradation with tracing.
And also, sometime a pointer value (address) is broken, in that
case we have to ensure the address is actually valid before
accessing it.

Of cause, without tracking paged-out data, it is easy
to support, because that is already done in kprobe event.
I'm not sure how it is useful, because sometimes it will
fail to access gather the data.
However it is good for the first step, I think.

Srikar, what would you think?

BTW, if we can support offs(FETCHARGS), $stack and $stackN
are also available. ;)

Thank you,

-- 
Masami HIRAMATSU
Software Platform Research Dept. Linux Technology Center
Hitachi, Ltd., Yokohama Research Laboratory
E-mail: masami.hiramatsu.pt@hitachi.com


