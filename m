Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753558Ab2BXFrv (ORCPT <rfc822;w@1wt.eu>);
	Fri, 24 Feb 2012 00:47:51 -0500
Received: from mail-qy0-f174.google.com ([209.85.216.174]:58318 "EHLO
	mail-qy0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751117Ab2BXFrs convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 24 Feb 2012 00:47:48 -0500
MIME-Version: 1.0
In-Reply-To: <201202231847.55733.vapier@gentoo.org>
References: <20120222150010.c784b29b.akpm@linux-foundation.org>
	<1329969811-3997-1-git-send-email-siddhesh.poyarekar@gmail.com>
	<201202231847.55733.vapier@gentoo.org>
Date: Fri, 24 Feb 2012 11:17:48 +0530
Message-ID: <CAAHN_R0ihoA6K8w53ToRD1xew9NWk-bJAZ=U0+hgRV3=0FpVDg@mail.gmail.com>
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

On Fri, Feb 24, 2012 at 5:17 AM, Mike Frysinger <vapier@gentoo.org> wrote:
> i don't suppose we could have it say "[tid stack]" rather than "[stack]" ?  or
> perhaps even "[stack tid:%u]" with replacing %u with the tid ?

Why do we need to differentiate a thread stack from a process stack?
If someone really wants to know, the main stack is the last one since
it doesn't look like mmap allocates anything above the stack right
now.

I like the idea of marking all stack vmas with their task ids but it
will most likely break procps. Besides, I think it could be done
within procps with this change rather than having the kernel do it.

-- 
Siddhesh Poyarekar
http://siddhesh.in
