Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754062Ab2FXGqz (ORCPT <rfc822;w@1wt.eu>);
	Sun, 24 Jun 2012 02:46:55 -0400
Received: from mail-bk0-f46.google.com ([209.85.214.46]:36112 "EHLO
	mail-bk0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751722Ab2FXGqw (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 24 Jun 2012 02:46:52 -0400
MIME-Version: 1.0
In-Reply-To: <87mx3twr6g.fsf@xmission.com>
References: <20120623001206.GA22639@www.outflux.net>
	<87mx3twr6g.fsf@xmission.com>
Date: Sat, 23 Jun 2012 23:46:50 -0700
X-Google-Sender-Auth: VFMnMrnJw2AG379kD2bBrIsYa1Y
Message-ID: <CAGXu5jKpoiMJWMJ-KwSFExNHCe4iusfJAPkwg5MCo6H7qmnSrg@mail.gmail.com>
Subject: Re: [PATCH v4] fs: make dumpable=2 only write to a pipe
From: Kees Cook <keescook@chromium.org>
To: "Eric W. Biederman" <ebiederm@xmission.com>
Cc: linux-kernel@vger.kernel.org, Andrew Morton <akpm@linux-foundation.org>,
        Alan Cox <alan@linux.intel.com>, Rob Landley <rob@landley.net>,
        Alexander Viro <viro@zeniv.linux.org.uk>,
        Doug Ledford <dledford@redhat.com>,
        Serge Hallyn <serge.hallyn@canonical.com>,
        Joe Korty <joe.korty@ccur.com>, linux-doc@vger.kernel.org,
        linux-fsdevel@vger.kernel.org,
        James Morris <james.l.morris@oracle.com>
Content-Type: text/plain; charset=ISO-8859-1
X-System-Of-Record: true
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sat, Jun 23, 2012 at 4:21 PM, Eric W. Biederman
<ebiederm@xmission.com> wrote:
> Kees Cook <keescook@chromium.org> writes:
>
>> When the suid_dumpable sysctl is set to "2", and there is no core
>> dump pipe defined in the core_pattern sysctl, a local user can cause
>> core files to be written to root-writable directories, potentially
>> with user-controlled content. This means an admin can unknowningly
>> reintroduce a variation of CVE-2006-2451, allowing local users to gain
>> root privileges.
>
> Is there a security exploit possible if a path is defined in the
> core_pattern?
>
> From the description of the problem so far I don't think there is.
> Requiring a program when a simple path will do seems excessive.

Having a fully qualified path would be sufficient, yes. Looking at how
%e and %E are handled, I'm satisfied (for example, no additional "/"
characters can be injected via argv0). In this case, then, I'll adjust
this to require either a pipe or a fully qualified core_pattern (i.e.
core_pattern must start with "!" or "/" for mode 2). How does that
sound?

-Kees

-- 
Kees Cook
Chrome OS Security
