Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752188Ab1HJCB7 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 9 Aug 2011 22:01:59 -0400
Received: from mail7.hitachi.co.jp ([133.145.228.42]:40181 "EHLO
	mail7.hitachi.co.jp" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751622Ab1HJCB4 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 9 Aug 2011 22:01:56 -0400
X-AuditID: b753bd60-a50b1ba0000019f4-33-4e41e69143d0
X-AuditID: b753bd60-a50b1ba0000019f4-33-4e41e69143d0
Message-ID: <4E41E68E.2030806@hitachi.com>
Date: Wed, 10 Aug 2011 11:01:50 +0900
From: Masami Hiramatsu <masami.hiramatsu.pt@hitachi.com>
Organization: Systems Development Lab., Hitachi, Ltd., Japan
User-Agent: Mozilla/5.0 (Windows NT 5.1; rv:5.0) Gecko/20110624 Thunderbird/5.0
MIME-Version: 1.0
To: Borislav Petkov <bp@amd64.org>, Frederic Weisbecker <fweisbec@gmail.com>
Cc: Kay Sievers <kay.sievers@vrfy.org>,
        James Bottomley <James.Bottomley@hansenpartnership.com>,
        Greg KH <greg@kroah.com>, Nao Nishijima <nao.nishijima.xt@hitachi.com>,
        linux-kernel@vger.kernel.org, linux-scsi@vger.kernel.org,
        jcm@redhat.com, dle-develop@lists.sourceforge.net,
        yrl.pp-manager.tt@hitachi.com, dgilbert@interlog.com,
        stefanr@s5r6.in-berlin.de, hare@suse.de, Ingo Molnar <mingo@elte.hu>,
        Peter Zijlstra <peterz@infradead.org>, Tony Luck <tony.luck@intel.com>,
        yoshihiro.hayashi.cd@hitachi.com
Subject: Re: [RFC PATCH 0/4] Persistent device name using alias name
References: <20110708084547.2091.55262.stgit@ltc197.sdl.hitachi.co.jp> <20110708145408.GA2283@kroah.com> <CAPXgP10gThuxOsrxH8_wOddeRB5f2ABypW7EQui-F1hOE97dHQ@mail.gmail.com> <20110708154736.GA7320@kroah.com> <1310140451.3282.85.camel@mulgrave> <CAPXgP12dA72a3ja659GH6uW+ZCMfL6iECaY6ORXwOQ6S5eTvaQ@mail.gmail.com> <4E17F121.3030601@hitachi.com> <20110803171608.GA16116@gere.osrc.amd.com>
In-Reply-To: <20110803171608.GA16116@gere.osrc.amd.com>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
X-Brightmail-Tracker: AAAAAA==
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

(2011/08/04 2:16), Borislav Petkov wrote:
> On Sat, Jul 09, 2011 at 03:11:45PM +0900, Masami Hiramatsu wrote:
>> BTW, I'm also interested in that structured error events, from the long
>> term view and viewpoint of tracers :)
>
> Let me chime in a "mee too" from the HW errors perspective.

Of course, :) and I guess this may be related to Fredrdic's work.


>> I think we could expand current TRACE_EVENT macro to define those
>> error events.
>
> Concerning structure, we can use the format file in debugfs which
> currently describes the fields of a tracepoint:
>
> /sys/kernel/debug/tracing/events/../../format
>
> and expand those to generic kernel events. Userspace parses the format
> and knows exactly at what data it is looking at. Also, the idea is to
> move that events hierarchy into sysfs so it will be present on every
> system.

Yeah, that is exactly what I've thought. Current trace events
strongly depends on ftrace and perf. And both of them are not
enough for handling events as error monitoring. Maybe we have to
prepare another monitor for this purpose, because, usually,
error monitoring should be run always on the machine, separately
from (and concurrently with) performance tuning or debugging tools.

Even though, I think the trace-event macros (include/trace/events/)
are good starting point.

Thank you,

-- 
Masami HIRAMATSU
Software Platform Research Dept. Linux Technology Center
Hitachi, Ltd., Yokohama Research Laboratory
E-mail: masami.hiramatsu.pt@hitachi.com
