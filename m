Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753426Ab1GDC5t (ORCPT <rfc822;w@1wt.eu>);
	Sun, 3 Jul 2011 22:57:49 -0400
Received: from mail-iw0-f174.google.com ([209.85.214.174]:62846 "EHLO
	mail-iw0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753172Ab1GDC5r convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 3 Jul 2011 22:57:47 -0400
MIME-Version: 1.0
In-Reply-To: <20110702073625.GA3318@albatros>
References: <1308917362-4795-1-git-send-email-segoon@openwall.com>
	<BANLkTi=dTHGK1QVs+g2tA6WocQ64SPPF3g@mail.gmail.com>
	<20110629201718.GA11071@albatros>
	<20110702073625.GA3318@albatros>
Date: Mon, 4 Jul 2011 08:27:47 +0530
Message-ID: <CAKTCnzmjaddz-ihxJ_qme28S==BAPGRmC2j3iE5fqm8TPi0knA@mail.gmail.com>
Subject: Re: [PATCH 2/2] taskstats: restrict access to user
From: Balbir Singh <bsingharora@gmail.com>
To: Vasiliy Kulikov <segoon@openwall.com>
Cc: Linus Torvalds <torvalds@linux-foundation.org>,
        linux-kernel@vger.kernel.org,
        Andrew Morton <akpm@linux-foundation.org>,
        Al Viro <viro@zeniv.linux.org.uk>,
        David Rientjes <rientjes@google.com>,
        Stephen Wilson <wilsons@start.ca>,
        KOSAKI Motohiro <kosaki.motohiro@jp.fujitsu.com>, security@kernel.org,
        Eric Paris <eparis@redhat.com>, kernel-hardening@lists.openwall.com
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sat, Jul 2, 2011 at 1:06 PM, Vasiliy Kulikov <segoon@openwall.com> wrote:
> On Thu, Jun 30, 2011 at 00:17 +0400, Vasiliy Kulikov wrote:
>> On Wed, Jun 29, 2011 at 06:57 +0530, Balbir Singh wrote:
>> > On Fri, Jun 24, 2011 at 5:39 PM, Vasiliy Kulikov <segoon@openwall.com> wrote:
>> > > +               task = find_task_by_vpid(s->pid);
>> > > +               if (!task || __task_cred(task)->euid != cred->euid) {
>>
>> If consider this patch for inclusion, it also needs some check for
>> the listener root ability.  __task_cred(task)->euid == 0 or smth like
>> that.  But ptrace_task_may_access_current() is better.
>
> So...  What to do with this patch?  Should I resend it with euid==0 and
> rcu optimication, wait for the new ptrace interface or what?
>
>
Hi, Vasiliy,

Would it be possible to audit the entire taskstats structure to see
what fields should and should not be exposed. If a particular field
should not be exposed, we can fill it in with a special value
indicating additional permission is required to see it and fill in
those fields only when credentials match like you've shown

Does that make sense?
Balbir Singh
