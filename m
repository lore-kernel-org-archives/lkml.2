Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933733Ab2AKSI2 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 11 Jan 2012 13:08:28 -0500
Received: from mail-iy0-f174.google.com ([209.85.210.174]:56027 "EHLO
	mail-iy0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S933586Ab2AKSIX (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 11 Jan 2012 13:08:23 -0500
Date: Wed, 11 Jan 2012 10:08:17 -0800
From: Tejun Heo <tj@kernel.org>
To: axboe@kernel.dk, mingo@redhat.com, rostedt@goodmis.org, fweisbec@gmail.com,
        teravest@google.com, slavapestov@google.com, ctalbott@google.com,
        dhsharp@google.com
Cc: linux-kernel@vger.kernel.org, winget@google.com, namhyung@gmail.com,
        Chanho Park <chanho61.park@samsung.com>
Subject: Re: [PATCH RESEND 9/9] block, trace: implement ioblame - IO tracer
 with origin tracking
Message-ID: <20120111180817.GJ26832@google.com>
References: <1326220106-5765-1-git-send-email-tj@kernel.org>
 <1326220106-5765-10-git-send-email-tj@kernel.org>
 <20120111013212.GA6843@dhcp-172-17-108-109.mtv.corp.google.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20120111013212.GA6843@dhcp-172-17-108-109.mtv.corp.google.com>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Jan 10, 2012 at 05:32:12PM -0800, Tejun Heo wrote:
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
>      completion can be exported via tracepoint and letting userland do
>      whatever it wants to do with that would be better.  Stripped out
>      in-kernel statistics gathering.
> 
>      Now that everything is exported through tracepoint, iolog and
>      counters_pipe[_pipe] are unnecessary.  Removed.  intents_bin too
>      is removed.
> 
>      As data collection no longer requires polling, ioblame/intents is
>      updated to generate inotify IN_MODIFY event after a new intent is
>      created.

One planned update is exporting issuer and dirtier separately.
Currently dirtier, if exists, simply overrides issuer as it wasn't
useful for in-kernel statistics anyway.  With that gone, I think it
makes much more sense to expose both of them.

Thanks.

-- 
tejun
