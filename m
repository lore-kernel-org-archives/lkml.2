Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754208Ab2AMHmA (ORCPT <rfc822;w@1wt.eu>);
	Fri, 13 Jan 2012 02:42:00 -0500
Received: from mail-tul01m020-f174.google.com ([209.85.214.174]:52726 "EHLO
	mail-tul01m020-f174.google.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752151Ab2AMHl6 convert rfc822-to-8bit
	(ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 13 Jan 2012 02:41:58 -0500
MIME-Version: 1.0
In-Reply-To: <1326436352.8294.22.camel@yhuang-dev>
References: <1326415001-2145-1-git-send-email-ying.huang@intel.com>
	<CA+8MBbJHsOHb-COG_y36VYDA9EeTs3KpLc86kw1OhVF9Z_p7Jw@mail.gmail.com>
	<1326436352.8294.22.camel@yhuang-dev>
Date: Thu, 12 Jan 2012 23:41:57 -0800
X-Google-Sender-Auth: STzlsMFpyaFJ5VjY8D_S_Cbosxs
Message-ID: <CA+8MBb+oqJZDYvmh8E6RB2MRp5fDj298Qjc4zs-rmyGkA4F3cw@mail.gmail.com>
Subject: Re: x86, mce, Use user return notifier in mce
From: Tony Luck <tony.luck@intel.com>
To: Huang Ying <ying.huang@intel.com>
Cc: linux-kernel@vger.kernel.org, Ingo Molnar <mingo@elte.hu>,
        Borislav Petkov <bp@amd64.org>, Chen Gong <gong.chen@linux.intel.com>,
        Hidetoshi Seto <seto.hidetoshi@jp.fujitsu.com>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Jan 12, 2012 at 10:32 PM, Huang Ying <ying.huang@intel.com> wrote:
> You are right.  User return notifier can not be used for SRAR.  I think
> that may be useful for SRAO.  Where we need a way to do notify earlier
> in case of the corresponding work_queue item is not executed in time.

OK - I've been so focused on SRAR that I didn't think of the SRAO case.
But even there it seems odd to use user return notifier. We'd like the
SRAO work item to be executed promptly - but we don't care where it
is executed. So the "execute on this cpu" part of user return notifiers
doesn't quite fit.

Is there a concept of "high priority work queue"?

-Tony
