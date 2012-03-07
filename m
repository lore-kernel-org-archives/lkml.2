Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759905Ab2CGTem (ORCPT <rfc822;w@1wt.eu>);
	Wed, 7 Mar 2012 14:34:42 -0500
Received: from mail-bk0-f46.google.com ([209.85.214.46]:41331 "EHLO
	mail-bk0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753540Ab2CGTej (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 7 Mar 2012 14:34:39 -0500
Date: Wed, 7 Mar 2012 23:34:33 +0400
From: Cyrill Gorcunov <gorcunov@openvz.org>
To: Oleg Nesterov <oleg@redhat.com>
Cc: akpm@linux-foundation.org, linux-kernel@vger.kernel.org,
        adobriyan@gmail.com, ebiederm@xmission.com, keescook@chromium.org,
        kosaki.motohiro@jp.fujitsu.com, matthltc@us.ibm.com, tj@kernel.org,
        xemul@parallels.com
Subject: Re: + mm-exec-rename-mm-exe_file-to-mm-exe_path.patch added to -mm
 tree
Message-ID: <20120307193433.GP20619@moon>
References: <20120306231325.D4B26A0395@akpm.mtv.corp.google.com>
 <20120307162630.GG20558@moon>
 <20120307174113.GA25366@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20120307174113.GA25366@redhat.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Mar 07, 2012 at 06:41:13PM +0100, Oleg Nesterov wrote:
...
> 
> Of course I can be wrong, but currently I think that either this patch
> reveals another problem (unlikley), or (most likely) I did some stupid
> mistake.
> 
> Can you send me the reproducer just in case?
> 
> > [ 1961.066410] Code: 41 5c 41 5d c9 c3 55 48 89 e5 41 54 53 48 83 ec 30
> > 66 66 66 66 90 48 63 c2 89 55 cc 48 89 fb 48 8d 04 06 48 89 45 e8 48 8b
> > 7f 08 <48> 8b 87 a8 00 00 00 48 85 c0 74 0d 48 8b 40 38 48 85 c0 74 04
> 
> No sure I understand this asm... Looks like path->dentry is NULL, strange.
> 
> I do not think I really need it, but just in case... could you send me
> (privately) the result of "make fs/dcache.s" ?
> 

yes, just sent.

> I'll try to recheck the patch and think.
> 
> But if you can _explain_ why do you think that "struct path" can't work,
> please explain ;)

OK, the best way to prove myself that I was wrong is to try to
explain why it can't work. So I prepared a call trace to point
where we can get a reference to non-existing path and... found
that it's simply impossible. So then I tried to repeat oops
after the test machine got rebooted and found that I can't
repeat it. I'll continue testing but I think it was unrelated
OOPs. Sorry for false alarm, Oleg!

	Cyrill
