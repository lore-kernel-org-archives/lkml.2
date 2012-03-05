Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757383Ab2CESZ2 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 5 Mar 2012 13:25:28 -0500
Received: from mail-bk0-f46.google.com ([209.85.214.46]:32879 "EHLO
	mail-bk0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757288Ab2CESZ1 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 5 Mar 2012 13:25:27 -0500
Authentication-Results: mr.google.com; spf=pass (google.com: domain of gorcunov@gmail.com designates 10.204.13.72 as permitted sender) smtp.mail=gorcunov@gmail.com; dkim=pass header.i=gorcunov@gmail.com
Date: Mon, 5 Mar 2012 22:25:22 +0400
From: Cyrill Gorcunov <gorcunov@openvz.org>
To: Oleg Nesterov <oleg@redhat.com>
Cc: Andrew Morton <akpm@linux-foundation.org>,
        Matt Helsley <matthltc@us.ibm.com>,
        Alexey Dobriyan <adobriyan@gmail.com>,
        "Eric W. Biederman" <ebiederm@xmission.com>,
        Kees Cook <keescook@chromium.org>,
        KOSAKI Motohiro <kosaki.motohiro@jp.fujitsu.com>,
        Pavel Emelyanov <xemul@parallels.com>, Tejun Heo <tj@kernel.org>,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH 0/1] turn mm->exe_file into mm->exe_path
Message-ID: <20120305182522.GD12341@moon>
References: <20120305152826.GA12419@redhat.com>
 <20120305170556.GC12341@moon>
 <20120305173314.GA17895@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20120305173314.GA17895@redhat.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Mar 05, 2012 at 06:33:14PM +0100, Oleg Nesterov wrote:
> 
> > Not sure where we may use PR_SET_MM_EXE_PATH with NULL to kill
> > num_exe_file_vmas from user space though
> 
> Please see above:
> 
> 	Why do we need mm->num_exe_file_vmas? Afaics it is only needed to
> 	"free" mm->exe_file if the application unmaps all these vmas. Say,
> 	to allow to unmount fs.
> 
> If we remove this counter, the application can't do the final put.
> But if we add PR_SET_MM_EXE_PATH which accepts NULL we solve this
> problem and this works for c/r too.
> 
> Of course, this is orthogonal to the patch I sent.
> 

I see. Thanks, Oleg!

	Cyrill
