Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754845Ab2A0UxQ (ORCPT <rfc822;w@1wt.eu>);
	Fri, 27 Jan 2012 15:53:16 -0500
Received: from out02.mta.xmission.com ([166.70.13.232]:40466 "EHLO
	out02.mta.xmission.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751834Ab2A0UxP (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 27 Jan 2012 15:53:15 -0500
From: ebiederm@xmission.com (Eric W. Biederman)
To: Andi Kleen <andi@firstfloor.org>
Cc: Cyrill Gorcunov <gorcunov@openvz.org>, LKML <linux-kernel@vger.kernel.org>,
        Andrew Morton <akpm@linux-foundation.org>,
        Pavel Emelyanov <xemul@openvz.org>,
        KOSAKI Motohiro <kosaki.motohiro@jp.fujitsu.com>,
        Pavel Emelyanov <xemul@parallels.com>,
        Andrey Vagin <avagin@openvz.org>,
        KOSAKI Motohiro <kosaki.motohiro@gmail.com>,
        Ingo Molnar <mingo@elte.hu>, "H. Peter Anvin" <hpa@zytor.com>,
        Thomas Gleixner <tglx@linutronix.de>,
        Glauber Costa <glommer@parallels.com>, Tejun Heo <tj@kernel.org>,
        Matt Helsley <matthltc@us.ibm.com>, Pekka Enberg <penberg@kernel.org>,
        Eric Dumazet <eric.dumazet@gmail.com>,
        Vasiliy Kulikov <segoon@openwall.com>,
        Alexey Dobriyan <adobriyan@gmail.com>, Valdis.Kletnieks@vt.edu
Subject: Re: [RFC c/r 2/4] [RFC] syscalls, x86: Add __NR_kcmp syscall v7
References: <20120127175342.273260614@openvz.org>
	<20120127175939.795551339@openvz.org>
	<20120127181525.GD11715@one.firstfloor.org>
	<20120127182403.GG11086@moon>
	<20120127183155.GE11715@one.firstfloor.org>
	<20120127184005.GH11086@moon>
	<20120127194058.GF11715@one.firstfloor.org>
Date: Fri, 27 Jan 2012 12:55:50 -0800
In-Reply-To: <20120127194058.GF11715@one.firstfloor.org> (Andi Kleen's message
	of "Fri, 27 Jan 2012 20:40:58 +0100")
Message-ID: <m1mx98zwyx.fsf@fess.ebiederm.org>
User-Agent: Gnus/5.13 (Gnus v5.13) Emacs/23.2 (gnu/linux)
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
X-XM-SPF: eid=;;;mid=;;;hst=in02.mta.xmission.com;;;ip=98.207.153.68;;;frm=ebiederm@xmission.com;;;spf=neutral
X-XM-AID: U2FsdGVkX1/wG+c0sRWz7dGgUr77mh4aK1Inqhj+xD8=
X-SA-Exim-Connect-IP: 98.207.153.68
X-SA-Exim-Mail-From: ebiederm@xmission.com
X-SA-Exim-Scanned: No (on in02.mta.xmission.com); SAEximRunCond expanded to false
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Andi Kleen <andi@firstfloor.org> writes:

>> > The basic problem is if this interface is at the right level of abstraction.
>> > I have some doubts on that. It seems like a long term maintenance nightmare to 
>> > me. It may be better to put the loop that would call this into the kernel.
>> > 
>> 
>> Hmm, ie selftest right in kenel?
>
> Not testing, but more the general stability of the interface. IMHO it exposes
> too many kernel internals. I know they are already exposed by clone/unshare, 
> but in those nothing breaks if the user program doesn't know about some new
> flags. But this looks like the user always has to be updated for every change.
> I think I would prefer if more of the user was in kernel to not expose
> that much.

Do you vote for putting the entire process serializer in one system call
then?

With the serializer in userspace you only need to update your userspace
code if something uses a new facility.  Which is the standard userspace
requirement.  Userspace does not need to be strictly in sync with the
kernel.

Personally I think all of this exporting extra state a little at a time
is horrible, but it seems to have a better chance of getting merged
because the pain comes a little at time.

Eric
