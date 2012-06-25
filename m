Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754213Ab2FYIaj (ORCPT <rfc822;w@1wt.eu>);
	Mon, 25 Jun 2012 04:30:39 -0400
Received: from LGEMRELSE1Q.lge.com ([156.147.1.111]:64448 "EHLO
	LGEMRELSE1Q.lge.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751539Ab2FYIai (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 25 Jun 2012 04:30:38 -0400
X-AuditID: 9c93016f-b7cbdae0000024ac-10-4fe821ac8e87
From: Namhyung Kim <namhyung@kernel.org>
To: Jovi Zhang <bookjovi@gmail.com>
Cc: LKML <linux-kernel@vger.kernel.org>
Subject: Re: perf support user-space hw_breakpoint?
References: <CACV3sb+EqVR0Z7qtCOpFtmRS+7xvv0b4S0Jrk7o7b__89_WVcA@mail.gmail.com>
Date: Mon, 25 Jun 2012 17:26:46 +0900
In-Reply-To: <CACV3sb+EqVR0Z7qtCOpFtmRS+7xvv0b4S0Jrk7o7b__89_WVcA@mail.gmail.com>
	(Jovi Zhang's message of "Mon, 25 Jun 2012 13:22:01 +0800")
Message-ID: <87bok7x0e1.fsf@sejong.aot.lge.com>
User-Agent: Gnus/5.13 (Gnus v5.13) Emacs/24.0.97 (gnu/linux)
MIME-Version: 1.0
Content-Type: text/plain
X-Brightmail-Tracker: AAAAAA==
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi, Jovi

On Mon, 25 Jun 2012 13:22:01 +0800, Jovi Zhang wrote:
> Hi guys,
>
> Does perf support user space hw_breakpoint based on per-task?
>
> perf already support kenerl space hw_breakpoint, but there don't have
> any example for
> user-space hw_breakpoint in code base(and never metion it).
> From perf api point of view, it should support per-task hw_breakpoint easily.
> but I still want to make sure that?(badly I don't have any linux
> machine to test it now:))
>

Here is my simple test:

namhyung@sejong:perf$ nm -nD /usr/bin/ls | grep D
0000000000619ce0 D quoting_style_args
000000000061a530 D ls_mode
000000000061a538 D Version
000000000061a540 D argmatch_die
000000000061a548 D exit_failure

namhyung@sejong:perf$ ./perf stat -e mem:0x61a530 -e mem:0x61a538 -- /usr/bin/ls > /dev/null

 Performance counter stats for '/usr/bin/ls':

                 1 mem:0x61a530:rw                                             
                 0 mem:0x61a538:rw                                             

       0.002213595 seconds time elapsed


So, it should work on user-space hw_breakpoints.

BTW, when I perf record on a hwbp, it failed with ENOSPC.
I guess it's because each per-task-per-cpu event tried to
create an event so it'd get more than supported by h/w.
The strace told me that the fifth call to perf_event_open
failed on my 6-core machine.

Thanks,
Namhyung
