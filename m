Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754082Ab2ALPnl (ORCPT <rfc822;w@1wt.eu>);
	Thu, 12 Jan 2012 10:43:41 -0500
Received: from hrndva-omtalb.mail.rr.com ([71.74.56.125]:45369 "EHLO
	hrndva-omtalb.mail.rr.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753706Ab2ALPnk (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 12 Jan 2012 10:43:40 -0500
X-Authority-Analysis: v=2.0 cv=SqgSGYy0 c=1 sm=0 a=ZycB6UtQUfgMyuk2+PxD7w==:17 a=CN4PQ-MNGcoA:10 a=5SG0PmZfjMsA:10 a=Q9fys5e9bTEA:10 a=6-N4bbpydDtNlQQiLSgA:9 a=PUjeQqilurYA:10 a=ZycB6UtQUfgMyuk2+PxD7w==:117
X-Cloudmark-Score: 0
X-Originating-IP: 74.67.80.29
Message-ID: <1326383015.7642.77.camel@gandalf.stny.rr.com>
Subject: Re: [RFC,PATCH 1/2] seccomp_filters: system call filtering using BPF
From: Steven Rostedt <rostedt@goodmis.org>
To: Will Drewry <wad@chromium.org>
Cc: linux-kernel@vger.kernel.org, keescook@chromium.org,
        john.johansen@canonical.com, serge.hallyn@canonical.com,
        coreyb@linux.vnet.ibm.com, pmoore@redhat.com, eparis@redhat.com,
        djm@mindrot.org, torvalds@linux-foundation.org, segoon@openwall.com,
        jmorris@namei.org, scarybeasts@gmail.com, avi@redhat.com,
        penberg@cs.helsinki.fi, viro@zeniv.linux.org.uk, luto@mit.edu,
        mingo@elte.hu, akpm@linux-foundation.org, khilman@ti.com,
        borislav.petkov@amd.com, amwang@redhat.com, oleg@redhat.com,
        ak@linux.intel.com, eric.dumazet@gmail.com, gregkh@suse.de,
        dhowells@redhat.com, daniel.lezcano@free.fr,
        linux-fsdevel@vger.kernel.org, linux-security-module@vger.kernel.org,
        olofj@chromium.org, mhalcrow@google.com, dlaor@redhat.com
Date: Thu, 12 Jan 2012 10:43:35 -0500
In-Reply-To: <1326302710-9427-2-git-send-email-wad@chromium.org>
References: <1326302710-9427-1-git-send-email-wad@chromium.org>
	 <1326302710-9427-2-git-send-email-wad@chromium.org>
Content-Type: text/plain; charset="ISO-8859-15"
X-Mailer: Evolution 3.2.2-1 
Content-Transfer-Encoding: 7bit
Mime-Version: 1.0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 2012-01-11 at 11:25 -0600, Will Drewry wrote:

> Filter programs may _only_ cross the execve(2) barrier if last filter
> program was attached by a task with CAP_SYS_ADMIN capabilities in its
> user namespace.  Once a task-local filter program is attached from a
> process without privileges, execve will fail.  This ensures that only
> privileged parent task can affect its privileged children (e.g., setuid
> binary).

This means that a non privileged user can not run another program with
limited features? How would a process exec another program and filter
it? I would assume that the filter would need to be attached first and
then the execv() would be performed. But after the filter is attached,
the execv is prevented?

Maybe I don't understand this correctly.

-- Steve
 

