Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754511Ab1FSVM7 (ORCPT <rfc822;w@1wt.eu>);
	Sun, 19 Jun 2011 17:12:59 -0400
Received: from mga09.intel.com ([134.134.136.24]:65071 "EHLO mga09.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754267Ab1FSVM6 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 19 Jun 2011 17:12:58 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.65,390,1304319600"; 
   d="scan'208";a="16927017"
From: Andi Kleen <andi@firstfloor.org>
To: Jonas Bonn <jonas@southpole.se>
Cc: richard -rw- weinberger <richard.weinberger@gmail.com>,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH 10/19] OpenRISC: System calls
References: <1308483825-6023-1-git-send-email-jonas@southpole.se>
	<1308483825-6023-11-git-send-email-jonas@southpole.se>
	<BANLkTiniGVKrCJXcjBGdmQdqsbfOZ_-agw@mail.gmail.com>
	<1308498672.3017.240.camel@localhost>
Date: Sun, 19 Jun 2011 14:11:28 -0700
In-Reply-To: <1308498672.3017.240.camel@localhost> (Jonas Bonn's message of
	"Sun, 19 Jun 2011 17:51:12 +0200")
Message-ID: <m2k4chfrwf.fsf@firstfloor.org>
User-Agent: Gnus/5.13 (Gnus v5.13) Emacs/23.2 (gnu/linux)
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Jonas Bonn <jonas@southpole.se> writes:

> On Sun, 2011-06-19 at 17:09 +0200, richard -rw- weinberger wrote:
>> On Sun, Jun 19, 2011 at 1:43 PM, Jonas Bonn <jonas@southpole.se> wrote:
>> > +asmlinkage int _sys_vfork(struct pt_regs *regs)
>> > +{
>> > +       /* This doesn't seem to work */
>> > +//        return do_fork(CLONE_VFORK | CLONE_VM | SIGCHLD, regs->sp, regs, 0, NULL, NULL);
>> 
>> Just being curious, why does that not work?
>
> Something about the CLONE_VM flag is breaking things... not sure what,

When "breaking" is a kernel oops or similar then you have a security
hole because CLONE_VM can be specified directly by user space in
clone()

So most likely you need to fix that anyways.

-Andi

-- 
ak@linux.intel.com -- Speaking for myself only
