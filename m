Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758074Ab1KKQwm (ORCPT <rfc822;w@1wt.eu>);
	Fri, 11 Nov 2011 11:52:42 -0500
Received: from mx1.redhat.com ([209.132.183.28]:3554 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756737Ab1KKQwl (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 11 Nov 2011 11:52:41 -0500
Date: Fri, 11 Nov 2011 17:48:00 +0100
From: Oleg Nesterov <oleg@redhat.com>
To: Pavel Emelyanov <xemul@parallels.com>
Cc: Tejun Heo <tj@kernel.org>, Andrew Morton <akpm@linux-foundation.org>,
        Cyrill Gorcunov <gorcunov@openvz.org>,
        Glauber Costa <glommer@parallels.com>, Nathan Lynch <ntl@pobox.com>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        Serge Hallyn <serue@us.ibm.com>, Daniel Lezcano <dlezcano@fr.ibm.com>
Subject: Re: [PATCH 3/3] pids: Make it possible to clone tasks with given
	pids
Message-ID: <20111111164800.GA27245@redhat.com>
References: <4EBC0696.9030103@parallels.com> <4EBC06DB.3090202@parallels.com> <20111110184654.GA1006@redhat.com> <20111110185603.GA1757@redhat.com> <4EBCF4E7.4090002@parallels.com> <20111111152532.GA22640@redhat.com> <4EBD461E.1000106@parallels.com> <CAOS58YOW5KpP3OJDd5PqsMUg6PicnLW6jH_5Hb7WGPsnCYXGBw@mail.gmail.com> <4EBD4A7E.7060102@parallels.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <4EBD4A7E.7060102@parallels.com>
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 11/11, Pavel Emelyanov wrote:
>
> First of all - let's imagine that we just want to clone a set of tasks. Then
> each of them will have to fork its kids, then report first of them that he's
> OK to fork and wait for it to report back, that forking is done. Then do the
> same for the rest of them. This is not impossible, but painful.

Why we should wait/report? They can do this in parallel, only
"set_last_pid + fork" needs the synchronization or "check + retry".

> Next - let's consider we have some tasks sharing various resources, e.g. mm-s
> or fd-tables. This means, that these tasks should be cloned in the carefully
> calculated sequence with CLONE_XXX flags set. In this case the described above
> scheme with fork() serialization simply won't work and we'll have to invent
> some fancy messaging with "now X fork with Y pid" and "X done with forking,
> please go on" messages.

Can't understand...

Oleg.

