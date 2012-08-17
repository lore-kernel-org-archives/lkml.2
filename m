Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755095Ab2HQH0Y (ORCPT <rfc822;w@1wt.eu>);
	Fri, 17 Aug 2012 03:26:24 -0400
Received: from mail.x86-64.org ([217.9.48.20]:55151 "EHLO mail.x86-64.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751642Ab2HQH0W (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 17 Aug 2012 03:26:22 -0400
Date: Fri, 17 Aug 2012 09:26:13 +0200
From: Borislav Petkov <bp@amd64.org>
To: Steven Rostedt <rostedt@goodmis.org>
Cc: Peter Zijlstra <peterz@infradead.org>, Ingo Molnar <mingo@kernel.org>,
        Frederic Weisbecker <fweisbec@gmail.com>,
        LKML <linux-kernel@vger.kernel.org>,
        Borislav Petkov <borislav.petkov@amd.com>
Subject: Re: [RFC PATCH -v2 1/4] trace events: Interface to add files to
 debugfs
Message-ID: <20120817072613.GA20591@aftab.osrc.amd.com>
References: <1345139123-15212-1-git-send-email-bp@amd64.org>
 <1345139123-15212-2-git-send-email-bp@amd64.org>
 <1345154808.3708.15.camel@gandalf.local.home>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1345154808.3708.15.camel@gandalf.local.home>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Aug 16, 2012 at 06:06:48PM -0400, Steven Rostedt wrote:
> > /mnt/dbg/tracing/events/mce/mce_record/
> > |-- enable
> > |-- filter
> > |-- format
> > |-- id
> > `-- persistent
> 
> This looks rather hacky :-/

Ya think?! :-)

Well, this whole machinery is only for telling to userspace which is the
file descriptor of the persistent event. And yes, it could probably be
done with a lot less code.

Hell, I'm even fine with issuing it in dmesg and userspace parsing the
output - talk about efficient implementation.

> Can't this be added to the perf syscall, and have the user query the
> event instead?

Do you mean perf_ioctl? For that to work I need to have a file
descriptor of the "normal" event first and then query it to get the
persistent file descriptor... Or do you mean something easier?

> Note, this code will change drastically soon, and this change will
> break. I'll talk more about what will change at plumbers.

I'll try to get a video or something... :)

-- 
Regards/Gruss,
Boris.

Advanced Micro Devices GmbH
Einsteinring 24, 85609 Dornach
GM: Alberto Bozzo
Reg: Dornach, Landkreis Muenchen
HRB Nr. 43632 WEEE Registernr: 129 19551
