Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754570Ab2AaOM5 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 31 Jan 2012 09:12:57 -0500
Received: from e24smtp01.br.ibm.com ([32.104.18.85]:52272 "EHLO
	e24smtp01.br.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753526Ab2AaOMz (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 31 Jan 2012 09:12:55 -0500
Date: Tue, 31 Jan 2012 12:13:02 -0200
From: Eduardo Otubo <otubo@linux.vnet.ibm.com>
To: Will Drewry <wad@chromium.org>
Cc: linux-kernel@vger.kernel.org, keescook@chromium.org,
        john.johansen@canonical.com, serge.hallyn@canonical.com,
        coreyb@linux.vnet.ibm.com, pmoore@redhat.com, eparis@redhat.com,
        djm@mindrot.org, torvalds@linux-foundation.org, segoon@openwall.com,
        rostedt@goodmis.org, jmorris@namei.org, scarybeasts@gmail.com,
        avi@redhat.com, penberg@cs.helsinki.fi, viro@zeniv.linux.org.uk,
        luto@mit.edu, mingo@elte.hu, akpm@linux-foundation.org, khilman@ti.com,
        borislav.petkov@amd.com, amwang@redhat.com, oleg@redhat.com,
        ak@linux.intel.com, eric.dumazet@gmail.com, gregkh@suse.de,
        dhowells@redhat.com, daniel.lezcano@free.fr,
        linux-fsdevel@vger.kernel.org, linux-security-module@vger.kernel.org,
        olofj@chromium.org, mhalcrow@google.com, dlaor@redhat.com,
        corbet@lwn.net, alan@lxorguk.ukuu.org.uk, indan@nul.nu,
        mcgrathr@chromium.org
Subject: Re: [PATCH v6 2/3] seccomp_filters: system call filtering using BPF
Message-ID: <20120131141302.GA25443@bluepex.com>
References: <1327788715-24076-1-git-send-email-wad@chromium.org>
 <1327788715-24076-2-git-send-email-wad@chromium.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <1327788715-24076-2-git-send-email-wad@chromium.org>
User-Agent: Mutt/1.5.20 (2009-06-14)
x-cbid: 12013114-1524-0000-0000-0000014BCC88
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sat, Jan 28, 2012 at 04:11:54PM -0600, Will Drewry wrote:
> [This patch depends on luto@mit.edu's no_new_privs patch:
>  https://lkml.org/lkml/2012/1/12/446
> ]

Will,

I know you clearly pointed to use luto@mit.edu's first no_new_privs
patch, but I couldn't avoid to test it with the latest (and 3rd) version
of the patch [0]. Which defines PR_GET_NO_NEW_PRIVS as 37 as you can see
here [1]. The compilation then would break here:

     CC      kernel/sys.o
   kernel/sys.c: In function ‘sys_prctl’:
   kernel/sys.c:1975: error: duplicate case value
   kernel/sys.c:1904: error: previously used here
   make[1]: *** [kernel/sys.o] Error 1
   make: *** [kernel] Error 2

I just changed the value of PR_ATTACH_SECCOMP_FILTER to 38 and
everything went fine. Do you see any problems on changing this value?

Regards,

[0] - https://git.kernel.org/?p=linux/kernel/git/luto/linux.git;a=heads
[1] -
https://git.kernel.org/?p=linux/kernel/git/luto/linux.git;a=blobdiff;f=include/linux/prctl.h;h=a6b5ac9cfe560eeb277646fbe338ae2b14c46caf;hp=7ddc7f1b480fd41318d94c0a39c8e2ff80f9c5f8;hb=7102b0e278af50d27b5d61d1be5faaba1b0a091e;hpb=acb42a3b611d7ad4cb173c3b37674b549df2ffeb

-- 
Eduardo Otubo
Software Engineer
Linux Technology Center
IBM Systems & Technology Group
Mobile: +55 19 8135 0885 
eotubo@linux.vnet.ibm.com

