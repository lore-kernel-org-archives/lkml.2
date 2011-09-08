Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932569Ab1IHMNo (ORCPT <rfc822;w@1wt.eu>);
	Thu, 8 Sep 2011 08:13:44 -0400
Received: from mail-wy0-f174.google.com ([74.125.82.174]:48115 "EHLO
	mail-wy0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932400Ab1IHMNn convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 8 Sep 2011 08:13:43 -0400
MIME-Version: 1.0
In-Reply-To: <20110908000614.GA3987@mtj.dyndns.org>
References: <201109072336.37300.vda.linux@googlemail.com> <20110908000614.GA3987@mtj.dyndns.org>
From: Denys Vlasenko <vda.linux@googlemail.com>
Date: Thu, 8 Sep 2011 14:13:22 +0200
Message-ID: <CAK1hOcMmwbSuDA2g4Tt7EO6sqjq-n-URTnMbr7RszqkMcs5jEA@mail.gmail.com>
Subject: Re: [PATCH] Simplify PTRACE_foo constants and PTRACE_SETOPTIONS code
To: Tejun Heo <tj@kernel.org>
Cc: Oleg Nesterov <oleg@redhat.com>, linux-kernel@vger.kernel.org
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Sep 8, 2011 at 2:06 AM, Tejun Heo <tj@kernel.org> wrote:
> Hello,
>
> Mostly looks good to me.  Just a small nit.
>
> On Wed, Sep 07, 2011 at 11:36:37PM +0200, Denys Vlasenko wrote:
>>  static int ptrace_setoptions(struct task_struct *child, unsigned long data)
>>  {
>> +     unsigned flags;
>>
>> +     if (data & ~(long)PTRACE_O_MASK) {
>
> Can we use (unsigned long) here?  Signed extensions have a nasty way
> of sneaking up on you.

Ok.

>> +             child->ptrace &= ~PT_TRACE_MASK; /* historical bug */
>
> And it would be great if it explains what the historical bug was and
> what the intended behavior is.

I'd rather nuke the bug in a follow-up patch (by deleting this line).

-- 
vda
