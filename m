Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932333Ab0LNQ3R (ORCPT <rfc822;w@1wt.eu>);
	Tue, 14 Dec 2010 11:29:17 -0500
Received: from hera.kernel.org ([140.211.167.34]:40801 "EHLO hera.kernel.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756683Ab0LNQ3O (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 14 Dec 2010 11:29:14 -0500
Message-ID: <4D079B19.4010606@kernel.org>
Date: Tue, 14 Dec 2010 17:28:09 +0100
From: Tejun Heo <tj@kernel.org>
User-Agent: Mozilla/5.0 (X11; U; Linux i686 (x86_64); en-US; rv:1.9.2.13) Gecko/20101207 Lightning/1.0b2 Thunderbird/3.1.7
MIME-Version: 1.0
To: Linus Torvalds <torvalds@linux-foundation.org>
CC: "Suzuki K. Poulose" <suzuki@in.ibm.com>, linux-kernel@vger.kernel.org,
        Jeremy Fitzhardinge <jeremy.fitzhardinge@citrix.com>,
        Christoph Hellwig <hch@lst.de>, Masami Hiramatsu <mhiramat@redhat.com>,
        Ananth N Mavinakayanahalli <ananth@in.ibm.com>,
        Daisuke HATAYAMA <d.hatayama@jp.fujitsu.com>,
        Andi Kleen <andi@firstfloor.org>, Roland McGrath <roland@redhat.com>,
        Amerigo Wang <amwang@redhat.com>,
        KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>,
        KOSAKI Motohiro <kosaki.motohiro@jp.fujitsu.com>,
        Oleg Nesterov <oleg@redhat.com>,
        Andrew Morton <akpm@linux-foundation.org>
Subject: Re: [RFC] [Patch 0/21] Non disruptive application core dump infrastructure
References: <20101214152259.67896960@suzukikp> <AANLkTim3h2EBcEUP19S2Z0CKA7Oe3k5pB=4LjXsOR3F9@mail.gmail.com> <4D079541.3090405@kernel.org> <AANLkTi=wBLRLpGw+DUHTNwdFPOTkkTRwMQ17agVY1UVV@mail.gmail.com>
In-Reply-To: <AANLkTi=wBLRLpGw+DUHTNwdFPOTkkTRwMQ17agVY1UVV@mail.gmail.com>
X-Enigmail-Version: 1.1.1
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-4.2.3 (hera.kernel.org [127.0.0.1]); Tue, 14 Dec 2010 16:28:11 +0000 (UTC)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hello, Linus.

On 12/14/2010 05:19 PM, Linus Torvalds wrote:
> On Tue, Dec 14, 2010 at 8:03 AM, Tejun Heo <tj@kernel.org> wrote:
>>
>> I think a better way would be adding a ptrace attach which is nestable
>> and doesn't have the nasty side effect caused by the interactions
>> between the implicit SIGSTOP and group stop.
> 
> Don't we already nest at least to some degree? At least you can strace
> a gdb session or another strace, no?

Yes, it depends on what the 'nesting' means.  I was thinking about
gcore'ing or attching gdb to an already strace'd process.  This might
not be strictly necessary but for ptrace attach to be transparent, we
need another PTRACE_* call anyway as PTRACE_ATTACH implies SIGSTOP and
having nestable attach would be beneficial in several use cases
including using debugging tools nested and allowing userland
checkpointing of debugging sessions.

Thanks.

-- 
tejun
