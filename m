Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756797Ab2DSW2f (ORCPT <rfc822;w@1wt.eu>);
	Thu, 19 Apr 2012 18:28:35 -0400
Received: from mail-lb0-f174.google.com ([209.85.217.174]:51841 "EHLO
	mail-lb0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756466Ab2DSW2e (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 19 Apr 2012 18:28:34 -0400
Message-ID: <4F90918E.3050202@openvz.org>
Date: Fri, 20 Apr 2012 02:28:30 +0400
From: Konstantin Khlebnikov <khlebnikov@openvz.org>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:10.0.2) Gecko/20120217 Firefox/10.0.2 Iceape/2.7.2
MIME-Version: 1.0
To: Oleg Nesterov <oleg@redhat.com>
CC: Cyrill Gorcunov <gorcunov@openvz.org>,
        "akpm@linux-foundation.org" <akpm@linux-foundation.org>,
        "keescook@chromium.org" <keescook@chromium.org>,
        "kosaki.motohiro@jp.fujitsu.com" <kosaki.motohiro@jp.fujitsu.com>,
        "matthltc@us.ibm.com" <matthltc@us.ibm.com>,
        "tj@kernel.org" <tj@kernel.org>, Pavel Emelianov <xemul@parallels.com>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Subject: Re: + c-r-prctl-add-ability-to-set-new-mm_struct-exe_file-update-after-mm-
 num_exe_file_vmas-removal.patch added to -mm tree
References: <20120419185221.E8ED6A055E@akpm.mtv.corp.google.com> <20120419192005.GA13558@redhat.com> <20120419210033.GO1893@moon> <20120419211216.GA2200@redhat.com> <4F9087D0.60709@openvz.org> <20120419215109.GA4896@redhat.com> <20120419220201.GR1893@moon> <20120419220918.GA5474@redhat.com>
In-Reply-To: <20120419220918.GA5474@redhat.com>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Oleg Nesterov wrote:
> On 04/20, Cyrill Gorcunov wrote:
>>
>> Guys, while I more-less agree with Matt about single-shot behaviour
>>
>> [ let me copy my and his email
>>
>>    >>  With mm->exe_file this prctl option become a one-shot
>>    >>  only, and while at moment our user-space tool can perfectly
>>    >>  live with that I thought that there is no strict need to
>>    >>  limit the option this way from the very beginning.
>>    >>
>>    >  As far as backward compatibility, isn't it better to lift that restriction
>>    >  later rather than add it? I think the latter would very likely "break"
>>    >  things whereas the former would not.
>>    >
>>    >  I also prefer that restriction because it establishes a bound on how
>>    >  frequently the symlink can change. Keeping it a one-shot deal makes the
>>    >  values that show up in tools like top more reliable for admins.
>> ]
>>
>> I guess maybe it's time to drop one-shot requirement and as result
>> we can drop MMF_EXE_FILE_CHANGED bit completely,
>
> Plus perhaps we can remove this for_each_vma check?
>
>> making overall code
>> simplier?
>
> Personally I'd certainly prefer this ;)
>
>
>
> But let me repeat to avoid the confusion. I am fine either way,
> I am not going to discuss this again unless I see something which
> looks technically wrong. And the current MMF_EXE_FILE_CHANGED
> doesn't look right even if the problem is minor.

Yeah, whole this protection does not protect anything and can be easily bypassed.
For example task can re-execute itself and change exe-file again and again.

>
> Oleg.
>
