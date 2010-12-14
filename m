Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757982Ab0LNQER (ORCPT <rfc822;w@1wt.eu>);
	Tue, 14 Dec 2010 11:04:17 -0500
Received: from hera.kernel.org ([140.211.167.34]:48636 "EHLO hera.kernel.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755345Ab0LNQEP (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 14 Dec 2010 11:04:15 -0500
Message-ID: <4D079541.3090405@kernel.org>
Date: Tue, 14 Dec 2010 17:03:13 +0100
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
References: <20101214152259.67896960@suzukikp> <AANLkTim3h2EBcEUP19S2Z0CKA7Oe3k5pB=4LjXsOR3F9@mail.gmail.com>
In-Reply-To: <AANLkTim3h2EBcEUP19S2Z0CKA7Oe3k5pB=4LjXsOR3F9@mail.gmail.com>
X-Enigmail-Version: 1.1.1
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-4.2.3 (hera.kernel.org [127.0.0.1]); Tue, 14 Dec 2010 16:03:15 +0000 (UTC)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hello,

On 12/14/2010 04:49 PM, Linus Torvalds wrote:
> On Tue, Dec 14, 2010 at 1:52 AM, Suzuki K. Poulose <suzuki@in.ibm.com> wrote:
>>
>> This is series of patches implementing an infrastructure for capturing the core
>> of an application without disrupting its process semantics.
>>
>> The infrastructure makes use of the freezer subsystem in kernel to freeze the
>> threads and then collect the information to generate  the core.
> 
> This seems to be a fundamentally flawed approach.
> 
>>From a security standpoint, it looks like a total disaster. A frozen
> process is really hard to get rid of, so it looks like an obvious DoS
> attack to just create lots of processes, then sneakily freeze them
> all, and then laugh at the poor system admin who has no idea what's
> going on. While frozen, the things are basically unkillable but look
> entirely normal, no?

I think a better way would be adding a ptrace attach which is nestable
and doesn't have the nasty side effect caused by the interactions
between the implicit SIGSTOP and group stop.  As a preparation step, I
posted a patchset to cleanup the interactions between ptrace and group
stop which is being reviewed.  Once we have a nestable ptrace attach,
we should be able to simply adapt gcore(1) to use it and write out
core dump from userland.

Thanks.

-- 
tejun
