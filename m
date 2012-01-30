Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754154Ab2A3Ctv (ORCPT <rfc822;w@1wt.eu>);
	Sun, 29 Jan 2012 21:49:51 -0500
Received: from LGEMRELSE6Q.lge.com ([156.147.1.121]:54367 "EHLO
	LGEMRELSE6Q.lge.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753040Ab2A3Ctu (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 29 Jan 2012 21:49:50 -0500
X-AuditID: 9c930179-b7bf0ae00000132b-6b-4f26054b1ef8
Message-ID: <4F260547.1030405@gmail.com>
Date: Mon, 30 Jan 2012 11:49:43 +0900
From: Namhyung Kim <namhyung@gmail.com>
User-Agent: Mozilla/5.0 (Windows NT 6.1; rv:9.0) Gecko/20111222 Thunderbird/9.0.1
MIME-Version: 1.0
Newsgroups: gmane.linux.kernel,gmane.linux.kernel.device-mapper.devel
To: Tejun Heo <tj@kernel.org>
CC: Jens Axboe <axboe@kernel.dk>, linux-kernel@vger.kernel.org,
        Steven Rostedt <rostedt@goodmis.org>, dm-devel@redhat.com
Subject: Re: [PATCH] block: add missing block_bio_complete() tracepoint
References: <1327830093-12130-1-git-send-email-namhyung@gmail.com> <20120129192447.GB17211@htj.dyndns.org> <4F25F5F3.6060507@gmail.com> <20120130014703.GG17211@htj.dyndns.org> <4F25FEE5.5010309@gmail.com> <20120130023012.GH17211@htj.dyndns.org>
In-Reply-To: <20120130023012.GH17211@htj.dyndns.org>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-Brightmail-Tracker: AAAAAA==
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

2012-01-30 11:30 AM, Tejun Heo wrote:
> On Mon, Jan 30, 2012 at 11:22:29AM +0900, Namhyung Kim wrote:
>>> It's just that this patch as it stands will break the existing tools
>>> and is likely to cause some amount of head scratching for blktrace
>>> users upgrading to new kernel with existing userland, so yeah, I think
>>> it should be filtered in kernel from blktrace.c.
>>
>> Will it break blktrace? Looking at the code, not tested though, it
>> will just add one more 'C' line for bounced bio, and that's it? The
>> blktrace will get way more 'C' lines for normal request based
>> devices and it needs to be handled anyway. Am I missing something?
>
> Hmmm... maybe I'm confused.  Wouldn't it cause duplicate completions
> for all rq based drivers too?
>

Yes, blktrace will see both of completions for rq and bio's it contains 
from now on, and I thought it's your intention? For the bounced bio's, 
it'll see one more completion per bio.

The users of older blktrace might get confused by this, thus changing 
the tool is inevitable regardless of the bounced bio's.

Thanks,
Namhyung
