Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932092Ab2AQVi3 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 17 Jan 2012 16:38:29 -0500
Received: from out02.mta.xmission.com ([166.70.13.232]:52619 "EHLO
	out02.mta.xmission.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932069Ab2AQVi2 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 17 Jan 2012 16:38:28 -0500
From: ebiederm@xmission.com (Eric W. Biederman)
To: Cyrill Gorcunov <gorcunov@gmail.com>
Cc: "H. Peter Anvin" <hpa@zytor.com>, Alexey Dobriyan <adobriyan@gmail.com>,
        LKML <linux-kernel@vger.kernel.org>,
        Pavel Emelyanov <xemul@parallels.com>,
        Andrey Vagin <avagin@openvz.org>, Ingo Molnar <mingo@elte.hu>,
        Thomas Gleixner <tglx@linutronix.de>,
        Glauber Costa <glommer@parallels.com>,
        Andi Kleen <andi@firstfloor.org>, Tejun Heo <tj@kernel.org>,
        Matt Helsley <matthltc@us.ibm.com>, Pekka Enberg <penberg@kernel.org>,
        Eric Dumazet <eric.dumazet@gmail.com>,
        Vasiliy Kulikov <segoon@openwall.com>,
        Andrew Morton <akpm@linux-foundation.org>, Valdis.Kletnieks@vt.edu
Subject: Re: [RFC] syscalls, x86: Add __NR_kcmp syscall
References: <20120117142759.GE16213@moon>
	<CACVxJT8TJXopJ5-_0j=6CsWXJL8wMOFCerfvmhWa7wcYnejFEg@mail.gmail.com>
	<20120117144452.GG16213@moon> <4F15C249.3000602@zytor.com>
	<20120117211521.GP16213@moon>
Date: Tue, 17 Jan 2012 13:40:53 -0800
In-Reply-To: <20120117211521.GP16213@moon> (Cyrill Gorcunov's message of "Wed,
	18 Jan 2012 01:15:21 +0400")
Message-ID: <m1fwfe9fdm.fsf@fess.ebiederm.org>
User-Agent: Gnus/5.13 (Gnus v5.13) Emacs/23.2 (gnu/linux)
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
X-XM-SPF: eid=;;;mid=;;;hst=in01.mta.xmission.com;;;ip=98.207.153.68;;;frm=ebiederm@xmission.com;;;spf=neutral
X-XM-AID: U2FsdGVkX1/y9WS/29k5SAYbfu2r5JTMenln9ET7zVM=
X-SA-Exim-Connect-IP: 98.207.153.68
X-SA-Exim-Mail-From: ebiederm@xmission.com
X-SA-Exim-Scanned: No (on in01.mta.xmission.com); SAEximRunCond expanded to false
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Cyrill Gorcunov <gorcunov@gmail.com> writes:

> On Tue, Jan 17, 2012 at 10:47:37AM -0800, H. Peter Anvin wrote:
>> On 01/17/2012 06:44 AM, Cyrill Gorcunov wrote:
>> > On Tue, Jan 17, 2012 at 04:38:14PM +0200, Alexey Dobriyan wrote:
>> >> On 1/17/12, Cyrill Gorcunov <gorcunov@gmail.com> wrote:
>> >>> +#define KCMP_EQ		0
>> >>> +#define KCMP_LT		1
>> >>> +#define KCMP_GT		2
>> >>
>> >> LT and GT are meaningless.
>> >>
>> > 
>> > I found symbolic names better than open-coded values. But sure,
>> > if this is problem it could be dropped.
>> > 
>> > Or you mean that in general anything but 'equal' is useless?
>> > 
>> 
>> Why on Earth would user space need to know which order in memory certain
>> kernel objects are?
>> 
>> Keep in mind that this is *exactly* the kind of information which makes
>> rootkits easier.
>> 
>
> Hmm, indeed this might help narrow down the target address I fear. So
> after some conversation with Pavel I think we can try to live with just
> one result -- is objects are at same location in kernel memory or not.
> The updated version is below. Please review if you get a chance. Thanks
> a lot for comments!

Seriously?

Or is this a case where you get something in then when people start
seriously using it and the performance is sucks badly you go back to
something like the current system call?

How are you going to ensure the performance does not degrade badly when
looking across a large number of processes?

Eric
