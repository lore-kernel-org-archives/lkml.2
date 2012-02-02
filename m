Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757564Ab2BBWHv (ORCPT <rfc822;w@1wt.eu>);
	Thu, 2 Feb 2012 17:07:51 -0500
Received: from terminus.zytor.com ([198.137.202.10]:52026 "EHLO mail.zytor.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751322Ab2BBWHu (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 2 Feb 2012 17:07:50 -0500
Message-ID: <4F2B090F.5020609@zytor.com>
Date: Thu, 02 Feb 2012 14:07:11 -0800
From: "H. Peter Anvin" <hpa@zytor.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:9.0) Gecko/20111222 Thunderbird/9.0
MIME-Version: 1.0
To: Steven Rostedt <rostedt@goodmis.org>
CC: Ingo Molnar <mingo@elte.hu>, linux-kernel@vger.kernel.org,
        Andrew Morton <akpm@linux-foundation.org>,
        Jason Baron <jbaron@redhat.com>,
        Frederic Weisbecker <fweisbec@gmail.com>
Subject: Re: [PATCH 0/5 v2] [GIT PULL] x86/jump label: Paranoid checks and
 2 or 5 byte nops
References: <20120128160925.275163704@goodmis.org>  <20120130144857.GA22013@elte.hu>  <1327936060.22710.165.camel@gandalf.stny.rr.com>  <20120131194813.GA12074@elte.hu>  <1328072925.5882.57.camel@gandalf.stny.rr.com>  <20120201080539.GA11770@elte.hu>  <1328109697.5882.65.camel@gandalf.stny.rr.com>  <20120202135154.GA10315@elte.hu> <4F2A9960.2090500@zytor.com>  <1328193068.5882.95.camel@gandalf.stny.rr.com> <1328220280.5882.122.camel@gandalf.stny.rr.com>
In-Reply-To: <1328220280.5882.122.camel@gandalf.stny.rr.com>
Content-Type: text/plain; charset=ISO-8859-15; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 02/02/2012 02:04 PM, Steven Rostedt wrote:
> commit 7bbd9688727dd30cd44b90b3c9c35f0f66af77ff
> Author: Steven Rostedt<srostedt@redhat.com>
> Date:   Thu Feb 2 16:55:43 2012 -0500
>
>      x86/jump labels: Handle initialization of enabled nops
>
>      When jump labels are initialized at boot up, they are compared
>      to the default_nop before switching to the ideal nop.
>
>      But if a jump label is enabled by default on start up, the
>      enabled code does not test against the default nop, only the
>      ideal nop. But as this jump label has not been converted to the
>      ideal nop, it fails the check, and will crash the box.
>
>      The enabled path needs to be aware of initialization too.
>
>      Reported-by: Ingo Molnar<mingo@elte.hu>
>      Signed-off-by: Steven Rostedt<rostedt@goodmis.org>
>

Would it make more sense to keep track of three states:

"Default"
"Enabled"
"Disabled"

	-?
