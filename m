Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S934405Ab2J3VYO (ORCPT <rfc822;w@1wt.eu>);
	Tue, 30 Oct 2012 17:24:14 -0400
Received: from mail-la0-f46.google.com ([209.85.215.46]:55350 "EHLO
	mail-la0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751989Ab2J3VYM (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 30 Oct 2012 17:24:12 -0400
Date: Wed, 31 Oct 2012 01:23:56 +0400
From: Cyrill Gorcunov <gorcunov@openvz.org>
To: Arvid Brodin <Arvid.Brodin@xdin.com>
Cc: "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        Andrew Morton <akpm@linux-foundation.org>,
        Al Viro <viro@zeniv.linux.org.uk>,
        David Rientjes <rientjes@google.com>,
        "Eric W. Biederman" <ebiederm@xmission.com>
Subject: Re: fs/proc/base.c: text md5sums; tgid vs tid; and INF vs ONE?
Message-ID: <20121030212356.GP15657@moon>
References: <50904066.4060404@xdin.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <50904066.4060404@xdin.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Oct 30, 2012 at 09:02:33PM +0000, Arvid Brodin wrote:
> Hi,
> 
> Below is a patch that adds a file /proc/PID/text_md5sum which when read returns the md5
> checksum of a process' text segment. (This would be used e.g. to make sure a process'
> code hasn't been tampered with.)
> 
> However, I have a few questions:
> 
> * What's the difference between the tgid_base_stuff and tid_base_stuff arrays? (One for
> processes and one for the process' threads? I haven't been able to find any info about
> this so I'm guessing.)
> 
> * When should I use the INF ("read") vs the ONE ("show") macro?
> 
> * Any other comments about the code?
> 
> Thanks!

I don't think this increments security by any means. start/end-code are rather
informative fields which are set when program being started, so one can ptrace
it, alloc new exec area, put evil code there, tuneup cs:ip and restore original
program contents, you won't even notice that.
