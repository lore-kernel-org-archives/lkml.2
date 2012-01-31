Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753115Ab2AaBkP (ORCPT <rfc822;w@1wt.eu>);
	Mon, 30 Jan 2012 20:40:15 -0500
Received: from LGEMRELSE6Q.lge.com ([156.147.1.121]:47121 "EHLO
	LGEMRELSE6Q.lge.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752401Ab2AaBkO (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 30 Jan 2012 20:40:14 -0500
X-AuditID: 9c930179-b7bf0ae00000132b-71-4f27467bf809
Message-ID: <4F274679.4010402@gmail.com>
Date: Tue, 31 Jan 2012 10:40:09 +0900
From: Namhyung Kim <namhyung@gmail.com>
User-Agent: Mozilla/5.0 (Windows NT 6.1; rv:9.0) Gecko/20111222 Thunderbird/9.0.1
MIME-Version: 1.0
Newsgroups: gmane.linux.kernel
To: Arnaldo Carvalho de Melo <acme@ghostprotocols.net>
CC: Namhyung Kim <namhyung.kim@lge.com>,
        Peter Zijlstra <a.p.zijlstra@chello.nl>,
        Paul Mackerras <paulus@samba.org>, Ingo Molnar <mingo@elte.hu>,
        linux-kernel@vger.kernel.org, David Ahern <dsahern@gmail.com>
Subject: Re: [PATCH v2 2/2] perf: Add error message for EMFILE
References: <1327972517-5055-1-git-send-email-namhyung.kim@lge.com> <1327972517-5055-2-git-send-email-namhyung.kim@lge.com> <20120131013054.GB25293@infradead.org>
In-Reply-To: <20120131013054.GB25293@infradead.org>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-Brightmail-Tracker: AAAAAA==
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

2012-01-31 10:30 AM, Arnaldo Carvalho de Melo wrote:
> Em Tue, Jan 31, 2012 at 10:15:16AM +0900, Namhyung Kim escreveu:
>> When a user tries to open so many event on multiple tasks/cpus,
>> perf_event_open syscall may fail with EMFILE. Provide an advice
>> for that case.
>
> I'll apply this one, but can you investigate a way to share this error
> handling accross the tools?
>
> A helper routine that doesn't call exit, but returns failure that will
> then cause the tool to decide if it exits or what (TUI ones could
> continue and the user could then select some other operation that would
> work, etc).
>
> It should standardize on ui__warning(), that already takes into account
> if the UI is --stdio or --tui (in the future a GUI too), etc.
>
> Thanks a lot!
>
> - Arnaldo
>

Yep, I'll take a look at it.

Thanks,
Namhyung

