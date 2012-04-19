Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933138Ab2DSVv4 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 19 Apr 2012 17:51:56 -0400
Received: from mx1.redhat.com ([209.132.183.28]:14456 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S933043Ab2DSVvx (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 19 Apr 2012 17:51:53 -0400
Date: Thu, 19 Apr 2012 23:51:09 +0200
From: Oleg Nesterov <oleg@redhat.com>
To: Konstantin Khlebnikov <khlebnikov@openvz.org>
Cc: Cyrill Gorcunov <gorcunov@openvz.org>,
        "akpm@linux-foundation.org" <akpm@linux-foundation.org>,
        "keescook@chromium.org" <keescook@chromium.org>,
        "kosaki.motohiro@jp.fujitsu.com" <kosaki.motohiro@jp.fujitsu.com>,
        "matthltc@us.ibm.com" <matthltc@us.ibm.com>,
        "tj@kernel.org" <tj@kernel.org>, Pavel Emelianov <xemul@parallels.com>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Subject: Re: +
	c-r-prctl-add-ability-to-set-new-mm_struct-exe_file-update-after-mm-
	num_exe_file_vmas-removal.patch added to -mm tree
Message-ID: <20120419215109.GA4896@redhat.com>
References: <20120419185221.E8ED6A055E@akpm.mtv.corp.google.com> <20120419192005.GA13558@redhat.com> <20120419210033.GO1893@moon> <20120419211216.GA2200@redhat.com> <4F9087D0.60709@openvz.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <4F9087D0.60709@openvz.org>
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 04/20, Konstantin Khlebnikov wrote:
>
> Oleg Nesterov wrote:
>>
>> You misunderstood. I am not arguing with "one-shot", I do not really
>> care.
>>
>> My question is: unless I missed something "it can't be changed again"
>> is not actually true. A task does PR_SET_MM_EXE_FILE, then it forks
>> the new child. The child can do PR_SET_MM_EXE_FILE again. Is this
>> by design?
>>
>> Oleg.
>>
>
> I found more weird case: child thread (with CLONE_THREAD and without CLONE_VM)
> changes its exe_file...

No. copy_process() does:

	if ((clone_flags & CLONE_THREAD) && !(clone_flags & CLONE_SIGHAND))
		return ERR_PTR(-EINVAL);

	if ((clone_flags & CLONE_SIGHAND) && !(clone_flags & CLONE_VM))
		return ERR_PTR(-EINVAL);

IOW, CLONE_THREAD => CLONE_SIGHAND => CLONE_VM

Oleg.

