Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1161064Ab2JXTqK (ORCPT <rfc822;w@1wt.eu>);
	Wed, 24 Oct 2012 15:46:10 -0400
Received: from mail.linuxfoundation.org ([140.211.169.12]:41337 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1161038Ab2JXTqJ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 24 Oct 2012 15:46:09 -0400
Date: Wed, 24 Oct 2012 12:46:07 -0700
From: Andrew Morton <akpm@linux-foundation.org>
To: Andrey Wagin <avagin@gmail.com>
Cc: linux-kernel@vger.kernel.org, Oleg Nesterov <oleg@redhat.com>,
        Cyrill Gorcunov <gorcunov@openvz.org>,
        "Eric W. Biederman" <ebiederm@xmission.com>,
        Pavel Emelyanov <xemul@parallels.com>
Subject: Re: [PATCH] pidns: limit the nesting depth of pid namespaces
Message-Id: <20121024124607.43f599e8.akpm@linux-foundation.org>
In-Reply-To: <CANaxB-xVVmQaCze=4+SaLbwkbJYxBwjbzF0hWX+Js94veWxj3w@mail.gmail.com>
References: <1350045042-1369134-1-git-send-email-avagin@openvz.org>
	<20121023165651.88af399d.akpm@linux-foundation.org>
	<CANaxB-xVVmQaCze=4+SaLbwkbJYxBwjbzF0hWX+Js94veWxj3w@mail.gmail.com>
X-Mailer: Sylpheed 3.0.2 (GTK+ 2.20.1; x86_64-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 24 Oct 2012 09:38:57 +0400
Andrey Wagin <avagin@gmail.com> wrote:

> >
> > I think that returning -ENOMEM in response to an excessive nesting
> > attempt is misleading - the system *didn't* run out of memory.  EINVAL
> > is better?
> 
> I chose ENOMEM by analogy with max_pid.  When a new PID can not be
> allocated, ENOMEM is returned too.

I don't know what this means - please be carefully specific when
identifying kernel code.

If you're referring to kernel/pid.c:alloc_pid() then -ENOMEM is
appropriate there, because a failure *is* caused by memory allocation
failure.

But ENOMEM isn't appropriate for nesting-depth-exceeded - we shouldn't
tell the user "you ran out of memory" when he didn't!  -EINVAL isn't
really appropriate either ("Invalid argument") but it has become a
general you-screwed-up catchall and seems to me to be the most
appropriate errno we have available.

