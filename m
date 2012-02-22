Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752510Ab2BVXAO (ORCPT <rfc822;w@1wt.eu>);
	Wed, 22 Feb 2012 18:00:14 -0500
Received: from mail.linuxfoundation.org ([140.211.169.12]:36221 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750859Ab2BVXAM (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 22 Feb 2012 18:00:12 -0500
Date: Wed, 22 Feb 2012 15:00:10 -0800
From: Andrew Morton <akpm@linux-foundation.org>
To: Siddhesh Poyarekar <siddhesh.poyarekar@gmail.com>
Cc: KOSAKI Motohiro <kosaki.motohiro@gmail.com>, linux-mm@kvack.org,
        linux-kernel@vger.kernel.org, Alexander Viro <viro@zeniv.linux.org.uk>,
        linux-fsdevel@vger.kernel.org, Jamie Lokier <jamie@shareable.org>,
        Mike Frysinger <vapier@gentoo.org>
Subject: Re: [RESEND][PATCH] Mark thread stack correctly in proc/<pid>/maps
Message-Id: <20120222150010.c784b29b.akpm@linux-foundation.org>
In-Reply-To: <CAAHN_R1Ho-JNLSKXM_3uU8nTpFHr87ujUEoFJChjZyk4iBYzjA@mail.gmail.com>
References: <4F32B776.6070007@gmail.com>
	<1328972596-4142-1-git-send-email-siddhesh.poyarekar@gmail.com>
	<CAAHN_R1Ho-JNLSKXM_3uU8nTpFHr87ujUEoFJChjZyk4iBYzjA@mail.gmail.com>
X-Mailer: Sylpheed 3.0.2 (GTK+ 2.20.1; x86_64-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 21 Feb 2012 09:54:04 +0530
Siddhesh Poyarekar <siddhesh.poyarekar@gmail.com> wrote:

> Stack for a new thread is mapped by userspace code and passed via
> sys_clone. This memory is currently seen as anonymous in
> /proc/<pid>/maps, which makes it difficult to ascertain which mappings
> are being used for thread stacks. This patch uses the individual task
> stack pointers to determine which vmas are actually thread stacks.
> 
> The display for maps, smaps and numa_maps is now different at the
> thread group (/proc/PID/maps) and thread (/proc/PID/task/TID/maps)
> levels. The idea is to give the mapping as the individual tasks see it
> in /proc/PID/task/TID/maps and then give an overview of the entire mm
> as it were, in /proc/PID/maps.
> 
> At the thread group level, all vmas that are used as stacks are marked
> as such. At the thread level however, only the stack that the task in
> question uses is marked as such and all others (including the main
> stack) are marked as anonymous memory.

Please flesh this description out with specific examples of the
before-and-after contents of all the applicable procfs files.  This way
we can clearly see the proposed interface changes, which is the thing
we care most about with such a patch.

The patch itself has been utterly and hopelessly mangled by gmail. 
Please fix that up when resending (as a last resort: use a text/plain
attachment).

