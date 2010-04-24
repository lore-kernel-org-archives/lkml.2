Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753876Ab0DXQZN (ORCPT <rfc822;w@1wt.eu>);
	Sat, 24 Apr 2010 12:25:13 -0400
Received: from mail-wy0-f174.google.com ([74.125.82.174]:40004 "EHLO
	mail-wy0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752678Ab0DXQZK convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 24 Apr 2010 12:25:10 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=mime-version:in-reply-to:references:date:message-id:subject:from:to
         :cc:content-type:content-transfer-encoding;
        b=pc4gKlioraKFfgifFcU+a78mz2mY1JseHzG2UyUFW/Q1+wUIiGMA6dj1efXPXVYkpC
         nykT7WU4yOpCgoYwaVWfVMXyBgWkNawmamRccZfiBNx7o999zeaIX9MzknbwJ9gdIO8L
         wK9RnctTEyqd6is5Bo8r8EeNT67QDQ+LLXAw0=
MIME-Version: 1.0
In-Reply-To: <20100424033614.GA4180@us.ibm.com>
References: <20100421012749.GA21338@us.ibm.com>
	 <20100421012908.GB24251@us.ibm.com> <20100421030406.GB10258@kroah.com>
	 <20100421034532.GA9254@us.ibm.com> <m1zl0xo1m9.fsf@fess.ebiederm.org>
	 <20100424033614.GA4180@us.ibm.com>
Date: Sat, 24 Apr 2010 09:25:08 -0700
Message-ID: <n2s13426df11004240925id540ed94mc2ebafada0099ec4@mail.gmail.com>
Subject: Re: [PATCH 3/3] p9auth: add p9auth driver
From: ron minnich <rminnich@gmail.com>
To: "Serge E. Hallyn" <serue@us.ibm.com>
Cc: "Eric W. Biederman" <ebiederm@xmission.com>, Greg KH <greg@kroah.com>,
       lkml <linux-kernel@vger.kernel.org>,
       David Howells <dhowells@redhat.com>,
       Ashwin Ganti <ashwin.ganti@gmail.com>, rsc@swtch.com, ericvh@gmail.com,
       linux-security-module@vger.kernel.org, jt.beard@gmail.com,
       Andrew Morton <akpm@linux-foundation.org>,
       Andrew Morgan <morgan@kernel.org>, oleg@us.ibm.com,
       Eric Paris <eparis@redhat.com>, linux-api@vger.kernel.org,
       Randy Dunlap <rdunlap@xenotime.net>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Apr 23, 2010 at 8:36 PM, Serge E. Hallyn <serue@us.ibm.com> wrote:

> An fs actually seems overkill for two write-only files for
> process-related information.  Would these actually be candidates
> for new /proc files?
>
>        /proc/grantcred - replaces /dev/caphash, for privileged
>                tasks to tell the kernel about new setuid
>                capabilities
>        /proc/self/usecred - replaces /dev/capuse for unprivileged
>                tasks to make use of a setuid capability

An fs is fine.

To relate this to Plan 9, where it all began, might be useful. There's
no equivalent in Plan 9 to Linux/Unix devices of the major/minor
number etc. variety. In-kernel drivers and out-of-kernel servers both
end up providing the services (i.e. file name spaces) that we see in a
Linux file system. So the Plan 9 driver for the capability device
really does match closely in function and interface to a Linux
kernel-based file system.

Hence, making devcap a file system is entirely appropriate, because it
best fits the way it works in Plan 9: a kernel driver that provides
two files.

It's pretty easy to write a Linux VFS anyway, so it makes sense from
that point of view.

Eric, that was a great suggestion.

ron
