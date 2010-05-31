Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752703Ab0EaKrZ (ORCPT <rfc822;w@1wt.eu>);
	Mon, 31 May 2010 06:47:25 -0400
Received: from thunk.org ([69.25.196.29]:43816 "EHLO thunker.thunk.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751541Ab0EaKrV (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 31 May 2010 06:47:21 -0400
Date: Mon, 31 May 2010 06:47:08 -0400
From: tytso@mit.edu
To: Kees Cook <kees.cook@canonical.com>
Cc: linux-kernel@vger.kernel.org, linux-security-module@vger.kernel.org,
       linux-fsdevel@vger.kernel.org, linux-doc@vger.kernel.org,
       Randy Dunlap <rdunlap@xenotime.net>,
       Andrew Morton <akpm@linux-foundation.org>,
       Jiri Kosina <jkosina@suse.cz>, Dave Young <hidave.darkstar@gmail.com>,
       Martin Schwidefsky <schwidefsky@de.ibm.com>,
       James Morris <jmorris@namei.org>, Eric Paris <eparis@redhat.com>,
       David Howells <dhowells@redhat.com>, Ingo Molnar <mingo@elte.hu>,
       Peter Zijlstra <a.p.zijlstra@chello.nl>,
       "Eric W. Biederman" <ebiederm@xmission.com>,
       Tim Gardner <tim.gardner@canonical.com>,
       "Serge E. Hallyn" <serue@us.ibm.com>
Subject: Re: [PATCH v2] fs: block cross-uid sticky symlinks
Message-ID: <20100531104708.GR26177@thunk.org>
Mail-Followup-To: tytso@mit.edu, Kees Cook <kees.cook@canonical.com>,
	linux-kernel@vger.kernel.org, linux-security-module@vger.kernel.org,
	linux-fsdevel@vger.kernel.org, linux-doc@vger.kernel.org,
	Randy Dunlap <rdunlap@xenotime.net>,
	Andrew Morton <akpm@linux-foundation.org>,
	Jiri Kosina <jkosina@suse.cz>,
	Dave Young <hidave.darkstar@gmail.com>,
	Martin Schwidefsky <schwidefsky@de.ibm.com>,
	James Morris <jmorris@namei.org>, Eric Paris <eparis@redhat.com>,
	David Howells <dhowells@redhat.com>, Ingo Molnar <mingo@elte.hu>,
	Peter Zijlstra <a.p.zijlstra@chello.nl>,
	"Eric W. Biederman" <ebiederm@xmission.com>,
	Tim Gardner <tim.gardner@canonical.com>,
	"Serge E. Hallyn" <serue@us.ibm.com>
References: <20100531030402.GQ6056@outflux.net>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20100531030402.GQ6056@outflux.net>
User-Agent: Mutt/1.5.20 (2009-06-14)
X-SA-Exim-Connect-IP: <locally generated>
X-SA-Exim-Mail-From: tytso@thunk.org
X-SA-Exim-Scanned: No (on thunker.thunk.org); SAEximRunCond expanded to false
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sun, May 30, 2010 at 08:04:02PM -0700, Kees Cook wrote:
>  - Violates POSIX.
>    - POSIX didn't consider this situation and it's not useful to follow
>      a broken specification at the cost of security.

POSIX allows implementations to fail requested operations with a
permission denied for reasons beyond that which is specified by the
POSIX implementation.  Indeed, POSIX doesn't specify the sticky bit at
all, so implementations that implemented the sticky bit were able to
pass POSIX precisely because it's OK to provide stricter semantics
than that which is specified by POSIX.  (The sticky bit is specified
in the XSI exstension to the Single Unix Specification, but the same
principle applies; it's OK for us have additional situations where we
return EACCESS beyond that which was contemplated by POSIX/SUS; this
alone wouldn't cause us to 'violate POSIX'.)

So for people who to argue against this (which I believe to be a
useful restriction, and not one that necessarily has to be done in a
LSM), it's not sufficient to say that it is a POSIX violation, because
it isn't.  The sticky bit itself wasn't originally considered by
POSIX, and many systems which implemented the sticky bit had no
problems becoming ceritifed as POSIX compliant.

						- Ted
