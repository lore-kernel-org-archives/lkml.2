Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757608Ab2CIP2j (ORCPT <rfc822;w@1wt.eu>);
	Fri, 9 Mar 2012 10:28:39 -0500
Received: from mx1.redhat.com ([209.132.183.28]:41567 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1757221Ab2CIP2h (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 9 Mar 2012 10:28:37 -0500
Date: Fri, 9 Mar 2012 16:21:22 +0100
From: Oleg Nesterov <oleg@redhat.com>
To: Cyrill Gorcunov <gorcunov@openvz.org>
Cc: Matt Helsley <matthltc@us.ibm.com>,
        KOSAKI Motohiro <kosaki.motohiro@jp.fujitsu.com>,
        Pavel Emelyanov <xemul@parallels.com>,
        Kees Cook <keescook@chromium.org>, Tejun Heo <tj@kernel.org>,
        Andrew Morton <akpm@linux-foundation.org>,
        LKML <linux-kernel@vger.kernel.org>
Subject: Re: [RFC] c/r: prctl: Add ability to set new mm_struct::exe_file v3
Message-ID: <20120309152122.GA7802@redhat.com>
References: <20120308192504.GH21812@moon> <20120308192559.GA20782@redhat.com> <20120308214817.GO21812@moon> <20120309124811.GA610@redhat.com> <20120309125735.GB13346@moon> <20120309133555.GA23040@moon> <20120309134732.GA3696@redhat.com> <20120309141349.GC13346@moon> <20120309142620.GA5334@redhat.com> <20120309144239.GD13346@moon>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20120309144239.GD13346@moon>
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 03/09, Cyrill Gorcunov wrote:
>
> OK, Oleg, can't argue, you've convinced me ;) I'll drop this WARN_ON.

Yes, yes, I am a troll!

> Would it be enough for your Reviewed-by tag? /me hides

Yes.

But, when you send the patch to Andrew, please remind that he
should remove the evidence of my ignorance from -mm first.


Just one note for the record, prctl_set_mm_exe_file() does

	if (mm->num_exe_file_vmas)
		return -EBUSY;

We could do

	if (mm->exe_file)
		return -EBUSY;

This way "because this feature is a special to C/R" becomes
really true. IOW, you can't do PR_SET_MM_EXE_FILE twice.

I am fine either way, just I want to ensure you really want
the current version.

Oleg.

