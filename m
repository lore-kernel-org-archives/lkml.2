Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757114Ab2JIV6K (ORCPT <rfc822;w@1wt.eu>);
	Tue, 9 Oct 2012 17:58:10 -0400
Received: from mga11.intel.com ([192.55.52.93]:47315 "EHLO mga11.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754650Ab2JIV6I (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 9 Oct 2012 17:58:08 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.80,562,1344236400"; 
   d="scan'208";a="231917737"
Message-ID: <50749DE8.7010703@zytor.com>
Date: Wed, 10 Oct 2012 05:58:00 +0800
From: "H. Peter Anvin" <hpa@zytor.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:13.0) Gecko/20120605 Thunderbird/13.0
MIME-Version: 1.0
To: Michael Kerrisk <mtk.manpages@gmail.com>
CC: Kees Cook <keescook@chromium.org>, linux-kernel@vger.kernel.org,
        Andrew Morton <akpm@linux-foundation.org>,
        Rusty Russell <rusty@rustcorp.com.au>,
        Mimi Zohar <zohar@linux.vnet.ibm.com>,
        Serge Hallyn <serge.hallyn@canonical.com>,
        Arnd Bergmann <arnd@arndb.de>,
        James Morris <james.l.morris@oracle.com>,
        Al Viro <viro@zeniv.linux.org.uk>, Eric Paris <eparis@redhat.com>,
        Jiri Kosina <jkosina@suse.cz>, linux-security-module@vger.kernel.org
Subject: Re: [PATCH 1/4] module: add syscall to load module from fd
References: <1348179300-11653-1-git-send-email-keescook@chromium.org> <CAHO5Pa2fysDRS3sFSy785XBKApxydN0ONW5kAfVJNkrB+wOaBw@mail.gmail.com>
In-Reply-To: <CAHO5Pa2fysDRS3sFSy785XBKApxydN0ONW5kAfVJNkrB+wOaBw@mail.gmail.com>
X-Enigmail-Version: 1.4.3
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 10/10/2012 05:54 AM, Michael Kerrisk wrote:
> Kees,
> 
>> +SYSCALL_DEFINE2(finit_module, int, fd, const char __user *, uargs)
> 
> Given the repeated experience of the last few years--new system calls
> that are in essence revisions of older system calls with a 'flags'
> argument bolted on to allow more flexible behavior (e.g., accept4(),
> dup3(), utimensat(), epoll_create1(), pipe2(), inotify_init(1), and so
> on.)--maybe it is worth considering adding a 'flags' bit mask
> argument[1] to the finti_module() system call now, to allow for
> possible future extensions to the behavior of the interface. What do
> you think?
> 
> Thanks,
> 
> Michael
> 
> [1] Yes, I know that init_module() doesn't have a flags argument, but
> that interface was added when we'd seen fewer of the kinds of cases
> listed above.
> 

Then maybe go whole hog and make it an init_module_at() system call
(allowing NULL for the pathname half to implement finit_module())...?

	-hpa


