Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754347Ab0IQN0t (ORCPT <rfc822;w@1wt.eu>);
	Fri, 17 Sep 2010 09:26:49 -0400
Received: from one.firstfloor.org ([213.235.205.2]:38383 "EHLO
	one.firstfloor.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752547Ab0IQN0s (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 17 Sep 2010 09:26:48 -0400
Date: Fri, 17 Sep 2010 15:26:39 +0200
From: Andi Kleen <andi@firstfloor.org>
To: Will Drewry <wad@chromium.org>
Cc: linux-kernel@vger.kernel.org, Alexander Viro <viro@zeniv.linux.org.uk>,
        Andrew Morton <akpm@linux-foundation.org>,
        Oleg Nesterov <oleg@redhat.com>,
        KOSAKI Motohiro <kosaki.motohiro@jp.fujitsu.com>,
        Roland McGrath <roland@redhat.com>,
        Neil Horman <nhorman@tuxdriver.com>,
        "Eric W. Biederman" <ebiederm@xmission.com>,
        containers@lists.linux-foundation.org, linux-fsdevel@vger.kernel.org
Subject: Re: [PATCH][RFC] fs/exec.c: provide the correct process pid to the
 pipe helper
Message-ID: <20100917152639.0e88341a@basil.nowhere.org>
In-Reply-To: <1284663599-3549-1-git-send-email-wad@chromium.org>
References: <1284663599-3549-1-git-send-email-wad@chromium.org>
X-Mailer: Claws Mail 3.7.5 (GTK+ 2.20.1; x86_64-unknown-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 16 Sep 2010 13:59:59 -0500
Will Drewry <wad@chromium.org> wrote:

> format_corename uses task_tgid_vnr to provide the numeric pid of a
> core-dumping process.  For file-based coredumps, this is perfectly
> satisfactory.  However, when the core_pattern contains a pipe, the
> substituted PID is invalid in the namespace of the core_pattern pipe
> helper, the init namespace.

Nasty problem. I wonder how many more similar problems name spaces
have introduced.

But wouldn't it be better to place the helper into the name space(s)
of the executed process? I guess it would risk breaking some existing
set ups, but it seem like the cleanest solution to me. If you want
to move the core dump out of the name space you could still
use a named pipe or something like that with someone outside listening.

That would also fix the net namespace problem you mentioned

-Andi


