Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756690Ab2BXSXt (ORCPT <rfc822;w@1wt.eu>);
	Fri, 24 Feb 2012 13:23:49 -0500
Received: from mail-qy0-f174.google.com ([209.85.216.174]:55999 "EHLO
	mail-qy0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753695Ab2BXSXr convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 24 Feb 2012 13:23:47 -0500
MIME-Version: 1.0
In-Reply-To: <201202241112.46337.vapier@gentoo.org>
References: <20120222150010.c784b29b.akpm@linux-foundation.org>
	<201202231847.55733.vapier@gentoo.org>
	<CAAHN_R0ihoA6K8w53ToRD1xew9NWk-bJAZ=U0+hgRV3=0FpVDg@mail.gmail.com>
	<201202241112.46337.vapier@gentoo.org>
Date: Fri, 24 Feb 2012 23:53:38 +0530
Message-ID: <CAAHN_R1Viv5GpJfbvc71OyNG7CdFWei7-3XPTap47MM2e8uEsg@mail.gmail.com>
Subject: Re: [PATCH] Mark thread stack correctly in proc/<pid>/maps
From: Siddhesh Poyarekar <siddhesh.poyarekar@gmail.com>
To: Mike Frysinger <vapier@gentoo.org>
Cc: Andrew Morton <akpm@linux-foundation.org>,
        KOSAKI Motohiro <kosaki.motohiro@gmail.com>, linux-mm@kvack.org,
        linux-kernel@vger.kernel.org, Alexander Viro <viro@zeniv.linux.org.uk>,
        linux-fsdevel@vger.kernel.org, Jamie Lokier <jamie@shareable.org>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Feb 24, 2012 at 9:42 PM, Mike Frysinger <vapier@gentoo.org> wrote:
>> I like the idea of marking all stack vmas with their task ids but it
>> will most likely break procps.
>
> how ?

I don't know yet, since I haven't looked at the procps code. I intend
to do that once the patch is stable. But I imagine it would look for
"[stack]" or something similar in the output. It ought to be easy
enough to change I guess.

>> Besides, I think it could be done within procps with this change rather than
>> having the kernel do it.
>
> how exactly is procps supposed to figure this out ?  /proc/<pid>/maps shows the
> pid's main stack, as does /proc/<pid>/tid/*/maps.

Since the maps are essentially the same, it would require pmap for
example, to read through the PID/maps as well as TID/maps and
associate them. I understand now that this may be a little racy.

I'll include thread ids and see how procps copes with it.


-- 
Siddhesh Poyarekar
http://siddhesh.in
