Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751467Ab2K3FGy (ORCPT <rfc822;w@1wt.eu>);
	Fri, 30 Nov 2012 00:06:54 -0500
Received: from LGEMRELSE1Q.lge.com ([156.147.1.111]:52924 "EHLO
	LGEMRELSE1Q.lge.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751357Ab2K3FGx (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 30 Nov 2012 00:06:53 -0500
X-AuditID: 9c93016f-b7b86ae000003a75-00-50b83eeb25ed
From: Namhyung Kim <namhyung@kernel.org>
To: Jiri Olsa <jolsa@redhat.com>
Cc: linux-kernel@vger.kernel.org,
        Arnaldo Carvalho de Melo <acme@ghostprotocols.net>,
        Peter Zijlstra <a.p.zijlstra@chello.nl>, Ingo Molnar <mingo@elte.hu>,
        Paul Mackerras <paulus@samba.org>,
        Corey Ashford <cjashfor@linux.vnet.ibm.com>,
        Frederic Weisbecker <fweisbec@gmail.com>
Subject: Re: [PATCH 10/14] perf tool: Centralize default columns init in perf_hpp__init
References: <1354110769-2998-1-git-send-email-jolsa@redhat.com>
	<1354110769-2998-11-git-send-email-jolsa@redhat.com>
	<87ehjcoc70.fsf@sejong.aot.lge.com>
	<20121129121319.GD1096@krava.brq.redhat.com>
Date: Fri, 30 Nov 2012 14:06:51 +0900
In-Reply-To: <20121129121319.GD1096@krava.brq.redhat.com> (Jiri Olsa's message
	of "Thu, 29 Nov 2012 13:13:19 +0100")
Message-ID: <87624nof10.fsf@sejong.aot.lge.com>
User-Agent: Gnus/5.13 (Gnus v5.13) Emacs/24.1 (gnu/linux)
MIME-Version: 1.0
Content-Type: text/plain
X-Brightmail-Tracker: AAAAAA==
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Jiri,

On Thu, 29 Nov 2012 13:13:19 +0100, Jiri Olsa wrote:
> On Thu, Nov 29, 2012 at 08:55:47PM +0900, Namhyung Kim wrote:
>> On Wed, 28 Nov 2012 14:52:45 +0100, Jiri Olsa wrote:
>> > Now when diff command is separated from other standard outputs,
>> > we can use perf_hpp__init to initialize all standard columns.
>> >
>> > Moving PERF_HPP__OVERHEAD column init back to perf_hpp__init,
>> > and removing extra enable calls.
>> 
>> Why was this needed in the first place?  AFAIK it's already there and
>> didn't used only for perf diff.
>
> hm, I think PERF_HPP__OVERHEAD wasn't part of perf_hpp__init and every
> report except for diff command is using it.. so I think it makes sense
> to move it to perf_hpp__init.. maybe I'm missing something.

You're right.  The _OVERHEAD column was enabled by default but wasn't
part of the _init function - sorry for the confusion.  But what I try to
say was that it can be folded into the patch 1.

Thanks,
Namhyung
