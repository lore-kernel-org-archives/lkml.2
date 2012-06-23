Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756363Ab2FWWek (ORCPT <rfc822;w@1wt.eu>);
	Sat, 23 Jun 2012 18:34:40 -0400
Received: from mail-ob0-f174.google.com ([209.85.214.174]:50924 "EHLO
	mail-ob0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756166Ab2FWWei (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 23 Jun 2012 18:34:38 -0400
Message-ID: <4FE6446D.20101@landley.net>
Date: Sat, 23 Jun 2012 17:34:21 -0500
From: Rob Landley <rob@landley.net>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:12.0) Gecko/20120430 Thunderbird/12.0.1
MIME-Version: 1.0
To: Kees Cook <keescook@chromium.org>
CC: linux-kernel@vger.kernel.org, Alan Cox <alan@linux.intel.com>,
        "Eric W. Biederman" <ebiederm@xmission.com>,
        Alexander Viro <viro@zeniv.linux.org.uk>,
        Ingo Molnar <mingo@redhat.com>, Peter Zijlstra <peterz@infradead.org>,
        Doug Ledford <dledford@redhat.com>,
        Andrew Morton <akpm@linux-foundation.org>,
        Marcel Holtmann <marcel@holtmann.org>,
        Serge Hallyn <serge.hallyn@canonical.com>,
        Joe Korty <joe.korty@ccur.com>, David Howells <dhowells@redhat.com>,
        James Morris <james.l.morris@oracle.com>, linux-doc@vger.kernel.org,
        linux-fsdevel@vger.kernel.org
Subject: Re: [PATCH v3] fs: introduce pipe-only dump mode suid_dumpable=3
References: <20120622192413.GA5774@www.outflux.net>
In-Reply-To: <20120622192413.GA5774@www.outflux.net>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 06/22/2012 02:24 PM, Kees Cook wrote:
> When the suid_dumpable sysctl is set to "2", and there is no core
> dump pipe defined in the core_pattern sysctl, a local user can cause
> core files to be written to root-writable directories, potentially with
> user-controlled content. This means an admin can unknowningly reintroduce
> a variation of CVE-2006-2451.
...
> --- a/Documentation/sysctl/fs.txt
> +++ b/Documentation/sysctl/fs.txt
> @@ -167,12 +167,12 @@ or otherwise protected/tainted binaries. The modes are
>  1 - (debug) - all processes dump core when possible. The core dump is
>  	owned by the current user and no security is applied. This is
>  	intended for system debugging situations only. Ptrace is unchecked.
> -2 - (suidsafe) - any binary which normally would not be dumped is dumped
> -	readable by root only. This allows the end user to remove
> -	such a dump but not access it directly. For security reasons
> -	core dumps in this mode will not overwrite one another or
> -	other files. This mode is appropriate when administrators are
> -	attempting to debug problems in a normal environment.
> +2 - (suidsafe) - no longer allowed (returns -EINVAL).

Random comment: a reference to the CVE might be good here.

Rob
-- 
GNU/Linux isn't: Linux=GPLv2, GNU=GPLv3+, they can't share code.
Either it's "mere aggregation", or a license violation.  Pick one.
