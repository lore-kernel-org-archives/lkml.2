Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755692Ab2ENQqb (ORCPT <rfc822;w@1wt.eu>);
	Mon, 14 May 2012 12:46:31 -0400
Received: from perches-mx.perches.com ([206.117.179.246]:53337 "EHLO
	labridge.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1752901Ab2ENQqa (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 14 May 2012 12:46:30 -0400
Message-ID: <1337013987.29436.16.camel@joe2Laptop>
Subject: Re: [PATCH 1/1] printk: Make it compile with !CONFIG_PRINTK
From: Joe Perches <joe@perches.com>
To: Kay Sievers <kay@vrfy.org>
Cc: Hiroshi DOYU <hdoyu@nvidia.com>, linux-tegra@vger.kernel.org,
        Peter Zijlstra <a.p.zijlstra@chello.nl>,
        Andrew Morton <akpm@linux-foundation.org>, Ingo Molnar <mingo@elte.hu>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        linux-kernel@vger.kernel.org
Date: Mon, 14 May 2012 09:46:27 -0700
In-Reply-To: <CAPXgP11SJQWkfAOidv2nFXAAWxOmjeBpd_uZSCgjX+7+qSH9nQ@mail.gmail.com>
References: <1337012284-18680-1-git-send-email-hdoyu@nvidia.com>
	 <CAPXgP11SJQWkfAOidv2nFXAAWxOmjeBpd_uZSCgjX+7+qSH9nQ@mail.gmail.com>
Content-Type: text/plain; charset="UTF-8"
X-Mailer: Evolution 3.2.2- 
Content-Transfer-Encoding: 7bit
Mime-Version: 1.0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 2012-05-14 at 18:20 +0200, Kay Sievers wrote:
> On Mon, May 14, 2012 at 6:18 PM, Hiroshi DOYU <hdoyu@nvidia.com> wrote:
> > Add missing prepend_timestamp() dummy.
> 
> That was fixed already last week:
> http://git.kernel.org/?p=linux/kernel/git/gregkh/driver-core.git;a=commitdiff;h=1fce677971e29ceaa7c569741fa9c685a7b1052a

Yup, but in my opinion, this particular fix shouldn't be
necessary because the CONFIG_PRINTK bits should have better
code separation.

None of the code that calls prepend_timestamp should
actually be compiled in when !CONFIG_PRINTK.

The same is true for unnecessary uses like the existing
per-cpu:

static DEFINE_PER_CPU(int, printk_pending);
static DEFINE_PER_CPU(char [PRINTK_BUF_SIZE], printk_sched_buf);
 
After this patchset is accepted into mainline, I'll revive
the modularization and move of kernel/printk.c and associated
files into -> kernel/printk/* patch I did awhile ago.

I'll follow-on to this message with the original patches
just as an fyi/rfc.

cheers, Joe

