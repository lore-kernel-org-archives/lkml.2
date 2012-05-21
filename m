Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754462Ab2EUTPH (ORCPT <rfc822;w@1wt.eu>);
	Mon, 21 May 2012 15:15:07 -0400
Received: from terminus.zytor.com ([198.137.202.10]:45178 "EHLO mail.zytor.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752634Ab2EUTPE (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 21 May 2012 15:15:04 -0400
Message-ID: <4FBA93C1.1070308@zytor.com>
Date: Mon, 21 May 2012 12:13:05 -0700
From: "H. Peter Anvin" <hpa@zytor.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:11.0) Gecko/20120329 Thunderbird/11.0.1
MIME-Version: 1.0
To: richard -rw- weinberger <richard.weinberger@gmail.com>
CC: Eric Paris <netdev@parisplace.org>, Will Drewry <wad@chromium.org>,
        linux-kernel@vger.kernel.org, linux-security-module@vger.kernel.org,
        kernel-hardening@lists.openwall.com, mingo@redhat.com, oleg@redhat.com,
        peterz@infradead.org, rdunlap@xenotime.net, mcgrathr@chromium.org,
        tglx@linutronix.de, luto@mit.edu, eparis@redhat.com,
        serge.hallyn@canonical.com, indan@nul.nu, pmoore@redhat.com,
        akpm@linux-foundation.org, corbet@lwn.net, eric.dumazet@gmail.com,
        markus@chromium.org, coreyb@linux.vnet.ibm.com, keescook@chromium.org
Subject: Re: seccomp and ptrace. what is the correct order?
References: <CACLa4puRJLUd6hAHO6zFYiqa5dFVum8eLmNMk_ef+=r8OGhjRg@mail.gmail.com> <CAFLxGvxtK7Dqw_PDqkMjNYzWyYdqx5CRYLB4+o=S5zHy2CgiTQ@mail.gmail.com>
In-Reply-To: <CAFLxGvxtK7Dqw_PDqkMjNYzWyYdqx5CRYLB4+o=S5zHy2CgiTQ@mail.gmail.com>
X-Enigmail-Version: 1.4.1
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 05/21/2012 11:47 AM, richard -rw- weinberger wrote:
> On Mon, May 21, 2012 at 8:21 PM, Eric Paris <netdev@parisplace.org> wrote:
>> Is that what we want?  Do we want to do the permission check based on
>> what a process ask at syscall enter or do we want to do the permission
>> check based on what the kernel is actually going to do on behalf of
>> the process?
> 
> I think we want the latter.
> A system call emulator like UserModeLinux would benefit from that.
> 

Are you sure?  This would mean that a seccomp program used by the
process to intercept its own system calls via SIGSYS would give
completely different results under UML than under native...

	-hpa

