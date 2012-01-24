Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751649Ab2AXWAO (ORCPT <rfc822;w@1wt.eu>);
	Tue, 24 Jan 2012 17:00:14 -0500
Received: from mail.linuxfoundation.org ([140.211.169.12]:38145 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751410Ab2AXWAM (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 24 Jan 2012 17:00:12 -0500
Date: Tue, 24 Jan 2012 14:00:11 -0800
From: Andrew Morton <akpm@linux-foundation.org>
To: "H. Peter Anvin" <hpa@zytor.com>
Cc: Cyrill Gorcunov <gorcunov@gmail.com>,
        "Eric W. Biederman" <ebiederm@xmission.com>,
        KOSAKI Motohiro <kosaki.motohiro@gmail.com>,
        KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>,
        linux-kernel@vger.kernel.org, Pavel Emelyanov <xemul@parallels.com>,
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
Message-Id: <20120124140011.60b6488c.akpm@linux-foundation.org>
In-Reply-To: <4F1F26B7.2010209@zytor.com>
References: <20120124064719.GA29735@moon>
	<4F1E57F3.6020607@zytor.com>
	<20120124071716.GC29735@moon>
	<20120124162031.a3956058.kamezawa.hiroyu@jp.fujitsu.com>
	<20120124073842.GE29735@moon>
	<20120124164008.aa1714bd.kamezawa.hiroyu@jp.fujitsu.com>
	<20120124084823.GF29735@moon>
	<CAHGf_=r=zwj4=yjCekYZVRsTwjohJ8F8cP4rnZx6UL9kKNTc+g@mail.gmail.com>
	<20120124202606.GC2546@moon>
	<m18vkwj0dw.fsf@fess.ebiederm.org>
	<20120124205039.GB2278@moon>
	<20120124132222.d78bc0d4.akpm@linux-foundation.org>
	<20120124134510.75f2c63f.akpm@linux-foundation.org>
	<4F1F26B7.2010209@zytor.com>
X-Mailer: Sylpheed 3.0.2 (GTK+ 2.20.1; x86_64-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 24 Jan 2012 13:46:31 -0800
"H. Peter Anvin" <hpa@zytor.com> wrote:

> On 01/24/2012 01:45 PM, Andrew Morton wrote:
> > On Tue, 24 Jan 2012 13:22:22 -0800
> > Andrew Morton <akpm@linux-foundation.org> wrote:
> > 
> >> static int kcmp_task_pointers(void *task1, void *task2, size_t field_offset,
> >> 				enum you_forgot_to_name_the_enum type)
> >> {
> >> 	void **field1 = t1 + field_offset;	/* points to a pointer in the task_struct */
> >> 	void **field2 = t1 + field_offset;
> > 
> > On reflection, this was being too cute.  It would be better to make the
> > function type-safer and just put up with the local typecasts:
> > 
> > static int kcmp_task_pointers(struct task_struct *task1,
> > 			struct task_struct *task2, size_t field_offset,
> > 			enum you_forgot_to_name_the_enum type)
> > {
> > 	void **field1 = (void *)t1 + field_offset;
> > 	void **field2 = (void *)t2 + field_offset;
> > 
> 
> Arithmetic on void pointers?
> 

All the world is gcc!
