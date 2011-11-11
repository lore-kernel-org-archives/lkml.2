Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758099Ab1KKRCu (ORCPT <rfc822;w@1wt.eu>);
	Fri, 11 Nov 2011 12:02:50 -0500
Received: from mail-pz0-f42.google.com ([209.85.210.42]:44710 "EHLO
	mail-pz0-f42.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757979Ab1KKRCt (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 11 Nov 2011 12:02:49 -0500
Date: Fri, 11 Nov 2011 09:02:44 -0800
From: Tejun Heo <tj@kernel.org>
To: Pavel Emelyanov <xemul@parallels.com>
Cc: Oleg Nesterov <oleg@redhat.com>, Andrew Morton <akpm@linux-foundation.org>,
        Cyrill Gorcunov <gorcunov@openvz.org>,
        Glauber Costa <glommer@parallels.com>, Nathan Lynch <ntl@pobox.com>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        Serge Hallyn <serue@us.ibm.com>, Daniel Lezcano <dlezcano@fr.ibm.com>
Subject: Re: [PATCH 3/3] pids: Make it possible to clone tasks with given
 pids
Message-ID: <20111111170244.GB24737@google.com>
References: <20111110184654.GA1006@redhat.com>
 <20111110185603.GA1757@redhat.com>
 <4EBCF4E7.4090002@parallels.com>
 <20111111152532.GA22640@redhat.com>
 <4EBD461E.1000106@parallels.com>
 <CAOS58YOW5KpP3OJDd5PqsMUg6PicnLW6jH_5Hb7WGPsnCYXGBw@mail.gmail.com>
 <CAOS58YOS77+WZt19qu_72DPgEPdwTdkD88J6RNR4a3x0h-2Qkw@mail.gmail.com>
 <4EBD4ACB.2070001@parallels.com>
 <20111111162200.GA24737@google.com>
 <4EBD522E.2000203@parallels.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <4EBD522E.2000203@parallels.com>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hello,

On Fri, Nov 11, 2011 at 08:49:50PM +0400, Pavel Emelyanov wrote:
> 1 cpu 500k forks                                         - 37s

That's ~14k forks per sec.  Do you still think you need parallel
forking?

> 2 cpus on different cores 500k forks on each in parallel - 39s
> 4 cpus on different cores 500k forks on each in parallel - 41s
> 
> 8 cpus 500k forks on each in parallel                    - 1m5s
> 
> So the fork() scaling seems quite good to me.

Yeah, looks pretty good actually.  Hmmm, this is on a single socket w/
shared cache where cacheline bouncing is quite cheap, right?  Also,
how are those forking processes related?  On multiple sockets, it's
gonna scale worse.  Dunno how much tho.

At any rate, if you do the rest in paralllel, whether forking is
parallel or not is immaterial.  Let's just do something least
intrusive.

Thanks.

-- 
tejun
