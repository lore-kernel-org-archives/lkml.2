Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758198Ab1DZD0X (ORCPT <rfc822;w@1wt.eu>);
	Mon, 25 Apr 2011 23:26:23 -0400
Received: from mail-wy0-f174.google.com ([74.125.82.174]:64138 "EHLO
	mail-wy0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757979Ab1DZD0V (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 25 Apr 2011 23:26:21 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=mime-version:in-reply-to:references:date:message-id:subject:from:to
         :cc:content-type;
        b=u9/cj/aJZzw7wDnrjWYeLGTE09t9WsJQhSn6vPlxZuOUxb50wmZcZIzx9NGpfqIIBW
         sityuSxHBXe0Eykjl5qf6UElVt6oFe0C7ldttmxREQQsfQzZjqE6VWyBSNGdPoG5XHWT
         PQESlYtHX9uG59mQctifFEifPh5JKybsn2cyQ=
MIME-Version: 1.0
In-Reply-To: <20110426121719.95894bc5.kamezawa.hiroyu@jp.fujitsu.com>
References: <20110426115902.F374.A69D9226@jp.fujitsu.com>
	<BANLkTimpidn07YRmm0gNDice3xo-tC8kow@mail.gmail.com>
	<20110426121555.F378.A69D9226@jp.fujitsu.com>
	<BANLkTino+9_GEb28gfZYSu-R0JW44M1mqQ@mail.gmail.com>
	<20110426121719.95894bc5.kamezawa.hiroyu@jp.fujitsu.com>
Date: Tue, 26 Apr 2011 11:26:19 +0800
Message-ID: <BANLkTi=f3V8-2Fe85aooBTEYEq_Kb37Nxw@mail.gmail.com>
Subject: Re: [PATCH] use oom_killer_disabled in all oom pathes
From: Dave Young <hidave.darkstar@gmail.com>
To: KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>
Cc: KOSAKI Motohiro <kosaki.motohiro@jp.fujitsu.com>, linux-mm@kvack.org,
        linux-kernel@vger.kernel.org
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Apr 26, 2011 at 11:17 AM, KAMEZAWA Hiroyuki
<kamezawa.hiroyu@jp.fujitsu.com> wrote:
> On Tue, 26 Apr 2011 11:19:22 +0800
> Dave Young <hidave.darkstar@gmail.com> wrote:
>
>> On Tue, Apr 26, 2011 at 11:14 AM, KOSAKI Motohiro
>> <kosaki.motohiro@jp.fujitsu.com> wrote:
>> >> On Tue, Apr 26, 2011 at 10:57 AM, KOSAKI Motohiro
>> >> <kosaki.motohiro@jp.fujitsu.com> wrote:
>> >> >> oom_killer_disable should be a global switch, also fit for oom paths
>> >> >> other than __alloc_pages_slowpath
>> >> >>
>> >> >> Here add it to mem_cgroup_handle_oom and pagefault_out_of_memory as well.
>> >> >
>> >> > Can you please explain more? Why should? Now oom_killer_disabled is used
>> >> > only hibernation path. so, Why pagefault and memcg allocation will be happen?
>> >>
>> >> Indeed I'm using it in virtio balloon test, oom killer triggered when
>> >> memory pressure is high.
>> >>
>> >> literally oom_killer_disabled scope should be global, isn't it?
>> >
>> > ok. virtio baloon seems fair usage. if you add new usage of oom_killer_disabled
>> > into the patch description, I'll ack this one.
>>
>> Thanks, then I will resend the virtio balloon patch along with this.
>>
>
> Amount of free memory doesn't affect memory cgroup's OOM because it just works
> against the limit. So, the code for memcg isn't necessary.

Right, thanks for pointing out this, will remove the memcg part
>
>
> Thanks,
> -Kame
>
>



-- 
Regards
dave
