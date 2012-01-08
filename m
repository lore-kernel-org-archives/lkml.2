Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753396Ab2AHLoL (ORCPT <rfc822;w@1wt.eu>);
	Sun, 8 Jan 2012 06:44:11 -0500
Received: from palinux.external.hp.com ([192.25.206.14]:60635 "EHLO
	mail.parisc-linux.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750967Ab2AHLoK (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 8 Jan 2012 06:44:10 -0500
Date: Sun, 8 Jan 2012 04:44:07 -0700
From: Matthew Wilcox <matthew@wil.cx>
To: Kees Cook <keescook@chromium.org>
Cc: Andrew Morton <akpm@linux-foundation.org>, linux-kernel@vger.kernel.org,
        Alexander Viro <viro@zeniv.linux.org.uk>,
        Rik van Riel <riel@redhat.com>,
        Federica Teodori <federica.teodori@googlemail.com>,
        Lucian Adrian Grijincu <lucian.grijincu@gmail.com>,
        Ingo Molnar <mingo@elte.hu>, Peter Zijlstra <a.p.zijlstra@chello.nl>,
        Eric Paris <eparis@redhat.com>, Randy Dunlap <rdunlap@xenotime.net>,
        Dan Rosenberg <drosenberg@vsecurity.com>, linux-doc@vger.kernel.org,
        linux-fsdevel@vger.kernel.org, kernel-hardening@lists.openwall.com
Subject: Re: [PATCH v2012.2] fs: symlink restrictions on sticky directories
Message-ID: <20120108114407.GA22056@parisc-linux.org>
References: <20120107185548.GA30748@outflux.net>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20120107185548.GA30748@outflux.net>
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sat, Jan 07, 2012 at 10:55:48AM -0800, Kees Cook wrote:
> v2012.2:
>  - Change sysctl mode to 0600, suggested by Ingo Molnar.
>  - Rework CONFIG logic to split code from default behavior.
>  - Renamed sysctl to have a "sysctl_" prefix, suggested by Andrew Morton.

All the sysctl / CONFIG logic seems very complex.  Why not make it
a module parameter instead?  It can be easily changed at boot time
(specify kernel.insecure_symlinks=1 on the kernel command line) and,
with a mode of 0600, can be modified at runtime too.

-- 
Matthew Wilcox				Intel Open Source Technology Centre
"Bill, look, we understand that you're interested in selling us this
operating system, but compare it to ours.  We can't possibly take such
a retrograde step."
