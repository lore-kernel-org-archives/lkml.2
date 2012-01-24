Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932078Ab2AXUma (ORCPT <rfc822;w@1wt.eu>);
	Tue, 24 Jan 2012 15:42:30 -0500
Received: from out02.mta.xmission.com ([166.70.13.232]:55401 "EHLO
	out02.mta.xmission.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756446Ab2AXUm2 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 24 Jan 2012 15:42:28 -0500
From: ebiederm@xmission.com (Eric W. Biederman)
To: Cyrill Gorcunov <gorcunov@gmail.com>
Cc: KOSAKI Motohiro <kosaki.motohiro@gmail.com>,
        "H. Peter Anvin" <hpa@zytor.com>,
        KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>,
        linux-kernel@vger.kernel.org,
        Andrew Morton <akpm@linux-foundation.org>,
        Pavel Emelyanov <xemul@parallels.com>,
        Serge Hallyn <serge.hallyn@canonical.com>,
        Kees Cook <keescook@chromium.org>, Tejun Heo <tj@kernel.org>,
        Andrew Vagin <avagin@openvz.org>,
        Alexey Dobriyan <adobriyan@gmail.com>, Ingo Molnar <mingo@elte.hu>,
        Thomas Gleixner <tglx@linutronix.de>,
        Glauber Costa <glommer@parallels.com>,
        Andi Kleen <andi@firstfloor.org>, Matt Helsley <matthltc@us.ibm.com>,
        Pekka Enberg <penberg@kernel.org>,
        Eric Dumazet <eric.dumazet@gmail.com>,
        Vasiliy Kulikov <segoon@openwall.com>, Valdis.Kletnieks@vt.edu
Subject: Re: [patch 2/4] [RFC] syscalls, x86: Add __NR_kcmp syscall v4
References: <20120123142436.258631438@openvz.org>
	<20120124111655.b29264d2.kamezawa.hiroyu@jp.fujitsu.com>
	<20120124064719.GA29735@moon> <4F1E57F3.6020607@zytor.com>
	<20120124071716.GC29735@moon>
	<20120124162031.a3956058.kamezawa.hiroyu@jp.fujitsu.com>
	<20120124073842.GE29735@moon>
	<20120124164008.aa1714bd.kamezawa.hiroyu@jp.fujitsu.com>
	<20120124084823.GF29735@moon>
	<CAHGf_=r=zwj4=yjCekYZVRsTwjohJ8F8cP4rnZx6UL9kKNTc+g@mail.gmail.com>
	<20120124202606.GC2546@moon>
Date: Tue, 24 Jan 2012 12:44:59 -0800
In-Reply-To: <20120124202606.GC2546@moon> (Cyrill Gorcunov's message of "Wed,
	25 Jan 2012 00:26:06 +0400")
Message-ID: <m18vkwj0dw.fsf@fess.ebiederm.org>
User-Agent: Gnus/5.13 (Gnus v5.13) Emacs/23.2 (gnu/linux)
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
X-XM-SPF: eid=;;;mid=;;;hst=in02.mta.xmission.com;;;ip=98.207.153.68;;;frm=ebiederm@xmission.com;;;spf=neutral
X-XM-AID: U2FsdGVkX1+ER0XSepiIFS3OBav9I0EeUtMpP+Z4BUo=
X-SA-Exim-Connect-IP: 98.207.153.68
X-SA-Exim-Mail-From: ebiederm@xmission.com
X-SA-Exim-Scanned: No (on in02.mta.xmission.com); SAEximRunCond expanded to false
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Cyrill Gorcunov <gorcunov@gmail.com> writes:

> On Tue, Jan 24, 2012 at 03:20:26PM -0500, KOSAKI Motohiro wrote:
>> >> please do as you like.
>> >
>> > So it should be something like below I think...
>> 
>> Looks ok this version to me. So, if you fix other developers pointed
>> issue, I'll ack this.
>> 
>
> Thanks!
>
> Eric, so mm/ would be fine or I still should move it to kernel/
> instead? I've addressed other issues I hope.

The world won't fall apart if the code lands in mm.  I have a strong
preference for kernel/.  I just don't see anything at all memory
management like about that code.  Even the fact that you are
comparing pointers is an implementation detail.

Eric
