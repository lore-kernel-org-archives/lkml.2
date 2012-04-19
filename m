Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932705Ab2DSWKD (ORCPT <rfc822;w@1wt.eu>);
	Thu, 19 Apr 2012 18:10:03 -0400
Received: from mx1.redhat.com ([209.132.183.28]:32525 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S932375Ab2DSWKA (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 19 Apr 2012 18:10:00 -0400
Date: Fri, 20 Apr 2012 00:09:19 +0200
From: Oleg Nesterov <oleg@redhat.com>
To: Cyrill Gorcunov <gorcunov@openvz.org>
Cc: Konstantin Khlebnikov <khlebnikov@openvz.org>,
        "akpm@linux-foundation.org" <akpm@linux-foundation.org>,
        "keescook@chromium.org" <keescook@chromium.org>,
        "kosaki.motohiro@jp.fujitsu.com" <kosaki.motohiro@jp.fujitsu.com>,
        "matthltc@us.ibm.com" <matthltc@us.ibm.com>,
        "tj@kernel.org" <tj@kernel.org>, Pavel Emelianov <xemul@parallels.com>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Subject: Re: +
	c-r-prctl-add-ability-to-set-new-mm_struct-exe_file-update-after-mm-
	num_exe_file_vmas-removal.patch added to -mm tree
Message-ID: <20120419220918.GA5474@redhat.com>
References: <20120419185221.E8ED6A055E@akpm.mtv.corp.google.com> <20120419192005.GA13558@redhat.com> <20120419210033.GO1893@moon> <20120419211216.GA2200@redhat.com> <4F9087D0.60709@openvz.org> <20120419215109.GA4896@redhat.com> <20120419220201.GR1893@moon>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20120419220201.GR1893@moon>
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 04/20, Cyrill Gorcunov wrote:
>
> Guys, while I more-less agree with Matt about single-shot behaviour
>
> [ let me copy my and his email
>
>   >> With mm->exe_file this prctl option become a one-shot
>   >> only, and while at moment our user-space tool can perfectly
>   >> live with that I thought that there is no strict need to
>   >> limit the option this way from the very beginning.
>   >>
>   > As far as backward compatibility, isn't it better to lift that restriction
>   > later rather than add it? I think the latter would very likely "break"
>   > things whereas the former would not.
>   >
>   > I also prefer that restriction because it establishes a bound on how
>   > frequently the symlink can change. Keeping it a one-shot deal makes the
>   > values that show up in tools like top more reliable for admins.
> ]
>
> I guess maybe it's time to drop one-shot requirement and as result
> we can drop MMF_EXE_FILE_CHANGED bit completely,

Plus perhaps we can remove this for_each_vma check?

> making overall code
> simplier?

Personally I'd certainly prefer this ;)



But let me repeat to avoid the confusion. I am fine either way,
I am not going to discuss this again unless I see something which
looks technically wrong. And the current MMF_EXE_FILE_CHANGED
doesn't look right even if the problem is minor.

Oleg.

