Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758283Ab2COOWo (ORCPT <rfc822;w@1wt.eu>);
	Thu, 15 Mar 2012 10:22:44 -0400
Received: from mail-yw0-f46.google.com ([209.85.213.46]:51681 "EHLO
	mail-yw0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755527Ab2COOWn convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 15 Mar 2012 10:22:43 -0400
MIME-Version: 1.0
In-Reply-To: <201203152208.04168.petr@tesarici.cz>
References: <201203152208.04168.petr@tesarici.cz>
Date: Thu, 15 Mar 2012 14:22:43 +0000
Message-ID: <CAPM=9txpWe53bpWHJ5DGV8LjFq4j4aOz04=0yi_1K=LmkdLtwA@mail.gmail.com>
Subject: Re: inode->i_wb_list corruption.
From: Dave Airlie <airlied@gmail.com>
To: =?UTF-8?B?UGV0ciBUZXNhxZnDrWs=?= <petr@tesarici.cz>
Cc: Dave Jones <davej@redhat.com>, Yang Bai <hamo.by@gmail.com>,
        Fengguang Wu <fengguang.wu@intel.com>,
        Linux Kernel <linux-kernel@vger.kernel.org>,
        Fedora Kernel Team <kernel-team@fedoraproject.org>, kernel@tesarici.cz
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Mar 15, 2012 at 2:08 PM, Petr Tesařík <petr@tesarici.cz> wrote:
> Dne So 10. března 2012 02:00:15 Dave Jones napsal(a):
>> (trimmed cc)
>>
>> On Sat, Mar 10, 2012 at 12:14:37AM +0800, Yang Bai wrote:
>>  > On Fri, Mar 9, 2012 at 11:19 PM, Dave Jones <davej@redhat.com> wrote:
>>  > > And with that, this arrived..
>>  > > https://bugzilla.redhat.com/show_bug.cgi?id=788433#c3
>>  > >
>>  > > I'm leaning strongly towards believing this is yet another case of
>>  > > i915 corrupting memory on resume.
>>  >
>>  > Nice catch. I am wondering
>>  > 1) why all lists being affected and
>>  > 2) why all list_head's prev being set to NULL.
>>  >
>>  > Any ideas?
>>
>> This is probably the same bug:
>> https://bugzilla.kernel.org/show_bug.cgi?id=37142 Petr noticed that the
>> corruption is 32 bytes getting zeroed at the beginning of a page.
>>
>> I think this may be responsible for a lot of different bugs that we've
>> had reported.
>>
>> i915_drm_thaw is a deep nest of functions though, so this is going to be
>> hard to track down where that write is coming from. Because the corruption
>> seems to happen to pages that are already allocated, we probably can't
>> even rely on DEBUG_PAGEALLOC, though it might be worth trying.
>
> If it you believe it could be written by the CPU, I can try to catch the
> instruction that writes to this memory. My plan is as follows:
>
> Set up all the hardware debug registers to trap writes to the pages that are
> likely to get corrupted. Remember, I've seen the corruption happen always
> roughly in the same physical memory area.
>
> I know, there are only 4 registers I can use, and the potential corruption
> area is much larger than 4 pages, but with enough reboots, the chance is quite
> high that I'll be lucky.
>
> I haven't gone for that plan yet, because I thought the area was in fact
> written to by someone else on the PCI bus, not the CPU. If nothing else, I can
> verify that. ;-)

It would be interesting to maybe dump the GTT then and see where the
pages you see
corruption are in it, if they as in the fbcon object then that kinda
proves the CPU writes them.

Dave.
