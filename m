Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933051Ab2AKGP7 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 11 Jan 2012 01:15:59 -0500
Received: from LGEMRELSE7Q.lge.com ([156.147.1.151]:46365 "EHLO
	LGEMRELSE7Q.lge.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932943Ab2AKGP5 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 11 Jan 2012 01:15:57 -0500
X-AuditID: 9c930197-b7bf2ae000001470-8e-4f0d291ac8ec
Message-ID: <4F0D291A.8030205@lge.com>
Date: Wed, 11 Jan 2012 15:15:54 +0900
From: Namhyung Kim <namhyung.kim@lge.com>
User-Agent: Mozilla/5.0 (Windows NT 6.1; rv:8.0) Gecko/20111105 Thunderbird/8.0
MIME-Version: 1.0
To: Tejun Heo <tj@kernel.org>
CC: axboe@kernel.dk, mingo@redhat.com, rostedt@goodmis.org, fweisbec@gmail.com,
        teravest@google.com, slavapestov@google.com, ctalbott@google.com,
        dhsharp@google.com, linux-kernel@vger.kernel.org, winget@google.com,
        Chanho Park <chanho61.park@samsung.com>, namhyung@gmail.com
Subject: Re: [PATCH RESEND 9/9] block, trace: implement ioblame - IO tracer
 with origin tracking
References: <1326220106-5765-1-git-send-email-tj@kernel.org> <1326220106-5765-10-git-send-email-tj@kernel.org> <20120111013212.GA6843@dhcp-172-17-108-109.mtv.corp.google.com>
In-Reply-To: <20120111013212.GA6843@dhcp-172-17-108-109.mtv.corp.google.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-Brightmail-Tracker: AAAAAA==
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

2012-01-11 10:32 AM, Tejun Heo wrote:
> Implement ioblame, which can attribute each IO to its origin and
> export the information using a tracepoint.
>
> Operations which may eventually cause IOs and IO operations themselves
> are identified and tracked primarily by their stack traces along with
> the task and the target file (dev:ino:gen).  On each IO completion,
> ioblame knows why that specific IO happened and exports the
> information via ioblame:ioblame_io tracepoint.
>
> While ioblame adds fields to a few fs and block layer objects, all
> logic is well insulated inside ioblame proper and all hooking goes
> through well defined tracepoints and doesn't add any significant
> maintenance overhead.
>
> For details, please read Documentation/trace/ioblame.txt.
>
> -v2: Namhyung pointed out that all the information available at IO
>       completion can be exported via tracepoint and letting userland do
>       whatever it wants to do with that would be better.  Stripped out
>       in-kernel statistics gathering.
>
>       Now that everything is exported through tracepoint, iolog and
>       counters_pipe[_pipe] are unnecessary.  Removed.  intents_bin too
>       is removed.
>
>       As data collection no longer requires polling, ioblame/intents is
>       updated to generate inotify IN_MODIFY event after a new intent is
>       created.
>

Hi Tejun,

How about adding another tracepoint for intent creation to provide raw 
data as well, somewhere in iob_get_intent() or iob_intent_create() 
maybe? It can be useful to get those data for further processing IMHO.

Thanks,
Namhyung Kim
