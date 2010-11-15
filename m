Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752932Ab0KOJFE (ORCPT <rfc822;w@1wt.eu>);
	Mon, 15 Nov 2010 04:05:04 -0500
Received: from mail-iw0-f174.google.com ([209.85.214.174]:47980 "EHLO
	mail-iw0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751547Ab0KOJFB convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 15 Nov 2010 04:05:01 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=mime-version:in-reply-to:references:date:message-id:subject:from:to
         :cc:content-type:content-transfer-encoding;
        b=DcdDSOBxVqetra4YHQOaZ78eeHNg9aHSSKGoSFdSgRGQzie7U4xhdPZ7LJuqyDzr4T
         iMeUU5hcxbfklfQaeg+vn4Bzv1XYe2p6Kdwx00kmptuyji6IEPwXUEu97mpu235gfR3P
         l5ZgTpy5MKPzSfW0DxrOoFp6h2Nu68XarYV+0=
MIME-Version: 1.0
In-Reply-To: <1289810825.2109.469.camel@laptop>
References: <20101109162525.BC87.A69D9226@jp.fujitsu.com>
	<877hgmr72o.fsf@gmail.com>
	<20101114140920.E013.A69D9226@jp.fujitsu.com>
	<AANLkTim59Qx6TsvXnTBL5Lg6JorbGaqx3KsdBDWO04X9@mail.gmail.com>
	<1289810825.2109.469.camel@laptop>
Date: Mon, 15 Nov 2010 18:05:00 +0900
Message-ID: <AANLkTikibS1fDuk67RHk4SU14pJ9nPdodWba1T3Z_pWE@mail.gmail.com>
Subject: Re: fadvise DONTNEED implementation (or lack thereof)
From: Minchan Kim <minchan.kim@gmail.com>
To: Peter Zijlstra <peterz@infradead.org>
Cc: KOSAKI Motohiro <kosaki.motohiro@jp.fujitsu.com>,
        Ben Gamari <bgamari.foss@gmail.com>, linux-kernel@vger.kernel.org,
        rsync@lists.samba.org, linux-mm@kvack.org,
        Wu Fengguang <fengguang.wu@intel.com>, Rik van Riel <riel@redhat.com>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Nov 15, 2010 at 5:47 PM, Peter Zijlstra <peterz@infradead.org> wrote:
> On Mon, 2010-11-15 at 15:07 +0900, Minchan Kim wrote:
>> On Sun, Nov 14, 2010 at 2:09 PM, KOSAKI Motohiro
>> <kosaki.motohiro@jp.fujitsu.com> wrote:
>> >> On Tue,  9 Nov 2010 16:28:02 +0900 (JST), KOSAKI Motohiro <kosaki.motohiro@jp.fujitsu.com> wrote:
>> >> > So, I don't think application developers will use fadvise() aggressively
>> >> > because we don't have a cross platform agreement of a fadvice behavior.
>> >> >
>> >> I strongly disagree. For a long time I have been trying to resolve
>> >> interactivity issues caused by my rsync-based backup script. Many kernel
>> >> developers have said that there is nothing the kernel can do without
>> >> more information from user-space (e.g. cgroups, madvise). While cgroups
>> >> help, the fix is round-about at best and requires configuration where
>> >> really none should be necessary. The easiest solution for everyone
>> >> involved would be for rsync to use FADV_DONTNEED. The behavior doesn't
>> >> need to be perfectly consistent between platforms for the flag to be
>> >> useful so long as each implementation does something sane to help
>> >> use-once access patterns.
>> >>
>> >> People seem to mention frequently that there are no users of
>> >> FADV_DONTNEED and therefore we don't need to implement it. It seems like
>> >> this is ignoring an obvious catch-22. Currently rsync has no fadvise
>> >> support at all, since using[1] the implemented hints to get the desired
>> >> effect is far too complicated^M^M^M^Mhacky to be considered
>> >> merge-worthy. Considering the number of Google hits returned for
>> >> fadvise, I wouldn't be surprised if there were countless other projects
>> >> with this same difficulty. We want to be able to tell the kernel about
>> >> our useage patterns, but the kernel won't listen.
>> >
>> > Because we have an alternative solution already. please try memcgroup :)
>
> Using memcgroup for this is utter crap, it just contains the trainwreck,
> it doesn't solve it in any way.
>
>> I think memcg could be a solution of them but fundamental solution is
>> that we have to cure it in VM itself.
>> I feel it's absolutely absurd to enable and use memcg for amending it.
>
> Agreed..
>
>> I wonder what's the problem in Peter's patch 'drop behind'.
>> http://www.mail-archive.com/linux-kernel@vger.kernel.org/msg179576.html
>>
>> Could anyone tell me why it can't accept upstream?
>
> Read the thread, its quite clear nobody got convinced it was a good idea
> and wanted to fix the use-once policy, then Rik rewrote all of
> page-reclaim.
>

Thanks for the information.
I hope this is a chance to rethink about it.
Rik, Could you give us to any comment about this idea?



-- 
Kind regards,
Minchan Kim
