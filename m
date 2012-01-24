Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755259Ab2AXIrG (ORCPT <rfc822;w@1wt.eu>);
	Tue, 24 Jan 2012 03:47:06 -0500
Received: from out03.mta.xmission.com ([166.70.13.233]:52409 "EHLO
	out03.mta.xmission.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754315Ab2AXIrE (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 24 Jan 2012 03:47:04 -0500
From: ebiederm@xmission.com (Eric W. Biederman)
To: KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>
Cc: Cyrill Gorcunov <gorcunov@gmail.com>, "H. Peter Anvin" <hpa@zytor.com>,
        linux-kernel@vger.kernel.org,
        Andrew Morton <akpm@linux-foundation.org>,
        Pavel Emelyanov <xemul@parallels.com>,
        Serge Hallyn <serge.hallyn@canonical.com>,
        Kees Cook <keescook@chromium.org>, Tejun Heo <tj@kernel.org>,
        Andrew Vagin <avagin@openvz.org>,
        Alexey Dobriyan <adobriyan@gmail.com>,
        KOSAKI Motohiro <kosaki.motohiro@gmail.com>,
        Ingo Molnar <mingo@elte.hu>, Thomas Gleixner <tglx@linutronix.de>,
        Glauber Costa <glommer@parallels.com>,
        Andi Kleen <andi@firstfloor.org>, Matt Helsley <matthltc@us.ibm.com>,
        Pekka Enberg <penberg@kernel.org>,
        Eric Dumazet <eric.dumazet@gmail.com>,
        Vasiliy Kulikov <segoon@openwall.com>, Valdis.Kletnieks@vt.edu
Subject: Re: [patch 2/4] [RFC] syscalls, x86: Add __NR_kcmp syscall v4
References: <20120123142036.025893883@openvz.org>
	<20120123142436.258631438@openvz.org>
	<20120124111655.b29264d2.kamezawa.hiroyu@jp.fujitsu.com>
	<20120124064719.GA29735@moon> <4F1E57F3.6020607@zytor.com>
	<20120124071716.GC29735@moon>
	<20120124162031.a3956058.kamezawa.hiroyu@jp.fujitsu.com>
Date: Tue, 24 Jan 2012 00:49:27 -0800
In-Reply-To: <20120124162031.a3956058.kamezawa.hiroyu@jp.fujitsu.com>
	(KAMEZAWA Hiroyuki's message of "Tue, 24 Jan 2012 16:20:31 +0900")
Message-ID: <m1fwf5mqnc.fsf@fess.ebiederm.org>
User-Agent: Gnus/5.13 (Gnus v5.13) Emacs/23.2 (gnu/linux)
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
X-XM-SPF: eid=;;;mid=;;;hst=in01.mta.xmission.com;;;ip=98.207.153.68;;;frm=ebiederm@xmission.com;;;spf=neutral
X-XM-AID: U2FsdGVkX1+atukDsuTJEOSLZI8446WM4d4gQse+uU8=
X-SA-Exim-Connect-IP: 98.207.153.68
X-SA-Exim-Mail-From: ebiederm@xmission.com
X-SA-Exim-Scanned: No (on in01.mta.xmission.com); SAEximRunCond expanded to false
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com> writes:

> On Tue, 24 Jan 2012 11:17:16 +0400
> Cyrill Gorcunov <gorcunov@gmail.com> wrote:
>
>> On Mon, Jan 23, 2012 at 11:04:19PM -0800, H. Peter Anvin wrote:
>> > On 01/23/2012 10:47 PM, Cyrill Gorcunov wrote:
>> > >>
>> > >> Why under /arch ?
>> > >>
>> > > 
>> > > Hi Kame,
>> > > 
>> > > because I've tested it under x86 only. Once someone
>> > > confirm it's needed on some else arch and does work
>> > > as expected -- it wont be a problem to make it system
>> > > wide. Until then -- I think better to stick with
>> > > at least tested case.
>> > > ...
>> > 
>> > That's not a reason to put it in arch/ ... that's possibly a reason to
>> > not map the system call on other architectures yet.
>> > 
>> 
>> Where it should live then? In kernel/ or mm/ ?
>> 
>
> kernel/checkpoint_restart ?
>
> gathering related changes to a directory may help developpers joins later....
> To me, this makes seeing git log easy ;)

kernel/

The dominant use may be checkpoint restart but the code is not at all
checkpoint restart specific.

Eric
