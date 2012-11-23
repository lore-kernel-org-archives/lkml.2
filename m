Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755114Ab2KWRml (ORCPT <rfc822;w@1wt.eu>);
	Fri, 23 Nov 2012 12:42:41 -0500
Received: from mx1.redhat.com ([209.132.183.28]:45126 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753474Ab2KWRmk (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 23 Nov 2012 12:42:40 -0500
Date: Fri, 23 Nov 2012 18:42:56 +0100
From: Oleg Nesterov <oleg@redhat.com>
To: Pavel Emelyanov <xemul@parallels.com>
Cc: Amnon Shiloh <u3557@miso.sublimeip.com>,
        Cyrill Gorcunov <gorcunov@openvz.org>,
        Steven Rostedt <rostedt@goodmis.org>,
        Frederic Weisbecker <fweisbec@gmail.com>,
        Ingo Molnar <mingo@redhat.com>,
        Peter Zijlstra <a.p.zijlstra@chello.nl>, linux-kernel@vger.kernel.org
Subject: Re: vdso && cr (Was: arch_check_bp_in_kernelspace: fix the range
	check)
Message-ID: <20121123174256.GA3361@redhat.com>
References: <20121121141627.GB21030@redhat.com> <20121121173043.F0319592076@miso.sublimeip.com> <20121122161238.GA27078@redhat.com> <50AE91AD.1090709@parallels.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <50AE91AD.1090709@parallels.com>
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 11/23, Pavel Emelyanov wrote:
>
> On 11/22/2012 08:12 PM, Oleg Nesterov wrote:
>
> > Sure. You shouldn't try to save/restore this page(s) directly. But
> > I do not really understand why do you need. IOW, I don't really
> > understand the problem, it depends on what c/r actually does.
>
> Think about it like this -- you stop a process, then change the kern^w VDSO
> page. Everything should work as it used to be :)

I understand. But again, this depends on how you restore. For example,
if you do not "transfer" libc/ld code, then probably vdso is not a
problem. Just you need to ensure the task was not stopped "inside" vdso.
Yes, yes, I understand that this is too limited, you probably want to
transfer "everything".

Oleg.

