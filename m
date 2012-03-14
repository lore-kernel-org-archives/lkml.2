Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S964866Ab2CNAhe (ORCPT <rfc822;w@1wt.eu>);
	Tue, 13 Mar 2012 20:37:34 -0400
Received: from e4.ny.us.ibm.com ([32.97.182.144]:37430 "EHLO e4.ny.us.ibm.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1759925Ab2CNAha (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 13 Mar 2012 20:37:30 -0400
Date: Tue, 13 Mar 2012 17:36:42 -0700
From: Matt Helsley <matthltc@us.ibm.com>
To: Oleg Nesterov <oleg@redhat.com>
Cc: Cyrill Gorcunov <gorcunov@openvz.org>, Matt Helsley <matthltc@us.ibm.com>,
        KOSAKI Motohiro <kosaki.motohiro@jp.fujitsu.com>,
        Pavel Emelyanov <xemul@parallels.com>,
        Kees Cook <keescook@chromium.org>, Tejun Heo <tj@kernel.org>,
        Andrew Morton <akpm@linux-foundation.org>,
        LKML <linux-kernel@vger.kernel.org>
Subject: Re: [RFC] c/r: prctl: Add ability to set new mm_struct::exe_file v3
Message-ID: <20120314003642.GH19584@count0.beaverton.ibm.com>
References: <20120309152122.GA7802@redhat.com>
 <20120309154224.GE13346@moon>
 <20120309220244.GD19584@count0.beaverton.ibm.com>
 <20120309223932.GB725@moon>
 <20120309235901.GE19584@count0.beaverton.ibm.com>
 <20120310074854.GA3065@moon>
 <20120313024511.GF19584@count0.beaverton.ibm.com>
 <20120313062625.GA1912@moon>
 <20120313071812.GA6969@moon>
 <20120313154337.GA25711@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20120313154337.GA25711@redhat.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
X-Content-Scanned: Fidelis XPS MAILER
x-cbid: 12031400-3534-0000-0000-0000069372CE
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Mar 13, 2012 at 04:43:37PM +0100, Oleg Nesterov wrote:
> 
> Matt, is it really possible to hit mm->exe_file = NULL in
> removed_exe_file_vma ? Unless I missed something, this check just
> hides the potentional problem, no?
> 
> IOW, shouldn't it do
> 
> 	void removed_exe_file_vma(struct mm_struct *mm)
> 	{
> 		WARN_ON(!mm->exe_file);
> 		WARN_ON(mm->num_exe_file_vmas <= 0);
> 
> 		if (!--mm->num_exe_file_vmas) {
> 			fput(mm->exe_file);
> 			mm->exe_file = NULL;
> 		}
> 	}
> 
> ?

I think you're spot-on about hiding the problem. I'm not sure the
WARN_ON() would be welcome in the mm's VMA paths though.
Also, it's a nit but I'd keep the decrement out of the condition like in
the original.

Cheers,
	-Matt

