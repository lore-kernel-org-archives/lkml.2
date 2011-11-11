Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758051Ab1KKQWI (ORCPT <rfc822;w@1wt.eu>);
	Fri, 11 Nov 2011 11:22:08 -0500
Received: from mail-pz0-f42.google.com ([209.85.210.42]:63537 "EHLO
	mail-pz0-f42.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752116Ab1KKQWG (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 11 Nov 2011 11:22:06 -0500
Date: Fri, 11 Nov 2011 08:22:00 -0800
From: Tejun Heo <tj@kernel.org>
To: Pavel Emelyanov <xemul@parallels.com>
Cc: Oleg Nesterov <oleg@redhat.com>, Andrew Morton <akpm@linux-foundation.org>,
        Cyrill Gorcunov <gorcunov@openvz.org>,
        Glauber Costa <glommer@parallels.com>, Nathan Lynch <ntl@pobox.com>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        Serge Hallyn <serue@us.ibm.com>, Daniel Lezcano <dlezcano@fr.ibm.com>
Subject: Re: [PATCH 3/3] pids: Make it possible to clone tasks with given
 pids
Message-ID: <20111111162200.GA24737@google.com>
References: <4EBC0696.9030103@parallels.com>
 <4EBC06DB.3090202@parallels.com>
 <20111110184654.GA1006@redhat.com>
 <20111110185603.GA1757@redhat.com>
 <4EBCF4E7.4090002@parallels.com>
 <20111111152532.GA22640@redhat.com>
 <4EBD461E.1000106@parallels.com>
 <CAOS58YOW5KpP3OJDd5PqsMUg6PicnLW6jH_5Hb7WGPsnCYXGBw@mail.gmail.com>
 <CAOS58YOS77+WZt19qu_72DPgEPdwTdkD88J6RNR4a3x0h-2Qkw@mail.gmail.com>
 <4EBD4ACB.2070001@parallels.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <4EBD4ACB.2070001@parallels.com>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Nov 11, 2011 at 08:18:19PM +0400, Pavel Emelyanov wrote:
> > To add a bit, it's also one of the more *serialized* path. Doing it in
> > parallel might actually hurt, 
> 
> Can you elaborate on this, please?

It goes through a lot of locks - tasklist_lock, mmlist_lock, other
subsys locks depending on CLONE_* options.  If you try to do that on
multiple CPUs in parallel, depending on the level of concurrency,
contention and extra cacheline bounces may dominate the overhead.

Thanks.

-- 
tejun
