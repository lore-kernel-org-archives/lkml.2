Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754185Ab2A3DZo (ORCPT <rfc822;w@1wt.eu>);
	Sun, 29 Jan 2012 22:25:44 -0500
Received: from mail-yw0-f46.google.com ([209.85.213.46]:44744 "EHLO
	mail-yw0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753062Ab2A3DZn (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 29 Jan 2012 22:25:43 -0500
Message-ID: <4F260DAE.4000008@gmail.com>
Date: Mon, 30 Jan 2012 11:25:34 +0800
From: Cong Wang <xiyou.wangcong@gmail.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:9.0) Gecko/20111222 Thunderbird/9.0
MIME-Version: 1.0
To: Michael Wang <wangyun@linux.vnet.ibm.com>
CC: Ingo Molnar <mingo@elte.hu>, Peter Zijlstra <a.p.zijlstra@chello.nl>,
        Xiaotian Feng <xtfeng@gmail.com>, LKML <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH v2] sched: Accelerate "pick_next_entity" under special
 condition
References: <4F13EFBE.1030002@linux.vnet.ibm.com> <1326707503.2442.219.camel@twins> <4F14DEAE.60702@linux.vnet.ibm.com> <CAJn8CcHhaSA5kF9KVjMorzt_2NM-dTPc5mTr3-A9GvR54VRo=A@mail.gmail.com> <4F14E54E.80904@linux.vnet.ibm.com> <1327506934.2614.87.camel@laptop> <20120126100429.GA3853@elte.hu> <4F21FC69.6040402@linux.vnet.ibm.com> <4F222B2B.6010602@gmail.com> <4F24E804.5090808@linux.vnet.ibm.com> <20120129163328.GC23408@elte.hu> <4F260BFE.2070503@linux.vnet.ibm.com>
In-Reply-To: <4F260BFE.2070503@linux.vnet.ibm.com>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 01/30/2012 11:18 AM, Michael Wang wrote:
> But the sched.o under ./arch/x86/kernel/cpu/ still not change...
> I think I may checking the wrong file, because this patch is for fair.c.
>
> And the fair.o changed after apply the patch, the size is a little
> bigger, and the gcc generated code changed.
>
> But I still don't know what can we get from this result? Bigger size is
> caused by additional code, but these additional code will help to step
> over some unnecessary code under special condition, looks like some
> balance between size and performance...

As your patch reduces the conditionals from 24 to 14, so it is possible 
that it also reduces the size of the code too. This is Ingo's point.

You need to check the diff to see why gcc actually generates bigger code.
