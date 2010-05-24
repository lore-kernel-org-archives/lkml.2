Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751416Ab0EXEeB (ORCPT <rfc822;w@1wt.eu>);
	Mon, 24 May 2010 00:34:01 -0400
Received: from mail-gw0-f46.google.com ([74.125.83.46]:42728 "EHLO
	mail-gw0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750733Ab0EXEeA (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 24 May 2010 00:34:00 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=mime-version:in-reply-to:references:from:date:message-id:subject:to
         :cc:content-type;
        b=sX3GwpEkT4SG3SBRCYm2d4HVsBNjaGy3UoQsTUonubZwogQDn8m81bvv0E+NzuWwaA
         VeyC3pNFAiFOZ9KeNh8b4pSnzgH+D2GnMLYkPosj1hnHZ/N6zhqLRLJoOYJje1lrQDuA
         bAJvmpZ7DzI9ohvUKnFdfpbcp5DuwN5CI0Adg=
MIME-Version: 1.0
In-Reply-To: <20100522165401.GB19573@redhat.com>
References: <1266280229-18469-1-git-send-email-vapier@gentoo.org> 
	<1274431345-22366-1-git-send-email-vapier@gentoo.org> <20100521162659.GA16193@redhat.com> 
	<20100521183512.4477F40476@magilla.sf.frob.com> <20100522165320.GA19573@redhat.com> 
	<20100522165401.GB19573@redhat.com>
From: Mike Frysinger <vapier.adi@gmail.com>
Date: Mon, 24 May 2010 00:33:38 -0400
Message-ID: <AANLkTinCtKiXjz08FI6EDUKWgLRDd64UVgDawhonZr__@mail.gmail.com>
Subject: Re: [Uclinux-dist-devel] [PATCH -mm 1/1] ptrace: PTRACE_GETFDPIC: fix 
	the unsafe usage of child->mm
To: Oleg Nesterov <oleg@redhat.com>
Cc: Roland McGrath <roland@redhat.com>,
       Andrew Morton <akpm@linux-foundation.org>,
       Mike Frysinger <vapier@gentoo.org>, linux-sh@vger.kernel.org,
       linux-kernel@vger.kernel.org, David Howells <dhowells@redhat.com>,
       Paul Mundt <lethal@linux-sh.org>,
       uclinux-dist-devel@blackfin.uclinux.org
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sat, May 22, 2010 at 12:54, Oleg Nesterov wrote:
> Now that Mike Frysinger unified the FDPIC ptrace code, we can fix
> the unsafe usage of child->mm in ptrace_request(PTRACE_GETFDPIC).
>
> We have the reference to task_struct, and ptrace_check_attach()
> verified the tracee is stopped. But nothing can protect from
> SIGKILL after that, we must not assume child->mm != NULL.

gdb still works with FDPIC apps after this, so presumably it works
fine :).  ive added it to the Blackfin tree to get more testing on our
side (not that i'll be pushing it out or anything).

thanks!
-mike
