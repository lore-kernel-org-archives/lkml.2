Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758029Ab1KKQGR (ORCPT <rfc822;w@1wt.eu>);
	Fri, 11 Nov 2011 11:06:17 -0500
Received: from mail-fx0-f46.google.com ([209.85.161.46]:48543 "EHLO
	mail-fx0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1758004Ab1KKQGK (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 11 Nov 2011 11:06:10 -0500
MIME-Version: 1.0
In-Reply-To: <4EBD461E.1000106@parallels.com>
References: <4EBC0696.9030103@parallels.com>
	<4EBC06DB.3090202@parallels.com>
	<20111110184654.GA1006@redhat.com>
	<20111110185603.GA1757@redhat.com>
	<4EBCF4E7.4090002@parallels.com>
	<20111111152532.GA22640@redhat.com>
	<4EBD461E.1000106@parallels.com>
Date: Fri, 11 Nov 2011 08:06:09 -0800
X-Google-Sender-Auth: R-32rziIzYihIQEcNcXNpyp4jNY
Message-ID: <CAOS58YOW5KpP3OJDd5PqsMUg6PicnLW6jH_5Hb7WGPsnCYXGBw@mail.gmail.com>
Subject: Re: [PATCH 3/3] pids: Make it possible to clone tasks with given pids
From: Tejun Heo <tj@kernel.org>
To: Pavel Emelyanov <xemul@parallels.com>
Cc: Oleg Nesterov <oleg@redhat.com>, Andrew Morton <akpm@linux-foundation.org>,
        Cyrill Gorcunov <gorcunov@openvz.org>,
        Glauber Costa <glommer@parallels.com>, Nathan Lynch <ntl@pobox.com>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        Serge Hallyn <serue@us.ibm.com>, Daniel Lezcano <dlezcano@fr.ibm.com>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hello,

On Fri, Nov 11, 2011 at 7:58 AM, Pavel Emelyanov <xemul@parallels.com> wrote:
>> Hmm. It seems, we can make a simpler patch to achieve the (roughly)
>> same effect. Without touching copy_process/alloc_pid paths. What if
>> we simply add PR_SET_LAST_PID? (or something else).
>>
>> In this case the new init (created normally) read the pids from image
>> file and does prcrl(PR_SET_LAST_PID, pid-1) before the next fork.
>>
>> What do you think?
>
> This will make it impossible to fork() children on restore in parallel. And
> I don't want to lose this ability :(

It's highly unlikely that the ability to fork in parallel would
contribute to any meaningful speedup. That is not the critical path by
*far* and I don't think it's worth optimizing for. Forking in serial
and restoring the rest of states in parallel should be enough.

Thanks.

-- 
tejun
