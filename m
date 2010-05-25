Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932195Ab0EYB35 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 24 May 2010 21:29:57 -0400
Received: from mail-gx0-f227.google.com ([209.85.217.227]:62997 "EHLO
	mail-gx0-f227.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1758090Ab0EYB3z (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 24 May 2010 21:29:55 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=mime-version:in-reply-to:references:from:date:message-id:subject:to
         :cc:content-type;
        b=vWsXROhpNwKA2nlGLbT8ERy43HXJREBbAp4Dnlr8/1ddeC07whZOmYjEKjvYuqMrqx
         NYDdhSJpUub69pnNkArm6yrVsJZQ58KbWLrvC5y4mM+BsmD+rDDU6EbTOIXKWaNTQqV6
         w248lfv0/Y0g5cNefsNBjpOVBpVMg40oYut1Y=
MIME-Version: 1.0
In-Reply-To: <20100524234250.F158849A56@magilla.sf.frob.com>
References: <20100522165401.GB19573@redhat.com> <1266280229-18469-1-git-send-email-vapier@gentoo.org> 
	<1274431345-22366-1-git-send-email-vapier@gentoo.org> <20100521162659.GA16193@redhat.com> 
	<20100521183512.4477F40476@magilla.sf.frob.com> <20100522165320.GA19573@redhat.com> 
	<25539.1274711817@redhat.com> <20100524151445.GA6393@redhat.com> 
	<20100524234250.F158849A56@magilla.sf.frob.com>
From: Mike Frysinger <vapier.adi@gmail.com>
Date: Mon, 24 May 2010 21:29:34 -0400
Message-ID: <AANLkTinpMp1yZ2c5B5O7aT2NR57zBHlggvUXZ58bLGv2@mail.gmail.com>
Subject: Re: [Uclinux-dist-devel] [PATCH -mm 1/1] ptrace: PTRACE_GETFDPIC: fix 
	the unsafe usage of child->mm
To: Roland McGrath <roland@redhat.com>
Cc: Oleg Nesterov <oleg@redhat.com>, linux-sh@vger.kernel.org,
       linux-kernel@vger.kernel.org, David Howells <dhowells@redhat.com>,
       Paul Mundt <lethal@linux-sh.org>,
       uclinux-dist-devel@blackfin.uclinux.org,
       Andrew Morton <akpm@linux-foundation.org>
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, May 24, 2010 at 19:42, Roland McGrath wrote:
>> You mean, pass it to arch_ptrace() ?
>>
>> grep, grep, grep. I guess I understand you. We have more unsafe code
>> like this in arch/*/kernel/ptrace.c. Of course, it can be fixed without
>> doing get_task_mm() in sys_ptrace(), but perhaps it would be more clean
>> to do what you suggest.
>>
>> Roland, what do you think?
>
> The mm pointer is only used by these uncommon ptrace operations that exist
> only in certain unusual arch's (and they're all ill-advised old arch ptrace
> ABI additions, at that).

are you suggesting the FDPIC additions are ill-advised as well ?
curious how you would have implemented this if that's the case ...
-mike
