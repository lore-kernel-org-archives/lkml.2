Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754824Ab2C0Rhv (ORCPT <rfc822;w@1wt.eu>);
	Tue, 27 Mar 2012 13:37:51 -0400
Received: from li9-11.members.linode.com ([67.18.176.11]:51741 "EHLO
	test.thunk.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754466Ab2C0Rhr (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 27 Mar 2012 13:37:47 -0400
Date: Tue, 27 Mar 2012 10:37:44 -0700
From: "Ted Ts'o" <tytso@mit.edu>
To: Kees Cook <keescook@google.com>
Cc: LKML <linux-kernel@vger.kernel.org>
Subject: Re: Correct way to include siginfo.h?
Message-ID: <20120327173744.GD10142@thunk.org>
Mail-Followup-To: Ted Ts'o <tytso@mit.edu>, Kees Cook <keescook@google.com>,
	LKML <linux-kernel@vger.kernel.org>
References: <CAGXu5jK3ezCN2=hy=AARh=T9L8YzCTKAXH6dbAH7FGX3P8VkoQ@mail.gmail.com>
 <20120327172133.GB10142@thunk.org>
 <CAGXu5jJx85b2ysgx2aXWUUf4dJMc34Cukp3S1VKiC_Pc5U2+Pw@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <CAGXu5jJx85b2ysgx2aXWUUf4dJMc34Cukp3S1VKiC_Pc5U2+Pw@mail.gmail.com>
User-Agent: Mutt/1.5.20 (2009-06-14)
X-SA-Exim-Connect-IP: <locally generated>
X-SA-Exim-Mail-From: tytso@thunk.org
X-SA-Exim-Scanned: No (on test.thunk.org); SAEximRunCond expanded to false
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Mar 27, 2012 at 10:29:39AM -0700, Kees Cook wrote:
> 
> I'm trying to get at the future seccomp fields on siginfo_t, namely
> "si_syscall":

Ah, I didn't realize you were trying to do that.  siginfo_t has been
stable since forever, and so I think we've always depending on glibc
to export the structure.  As a result I don't know that much effort
has been made to make siginfo.h safe for any userspace user other than
glibc.

Silly question; we're not going to actually change the size of the
siginfo_t structure in a userspace visible way, are we?  I don't know
of are any shared libraries that fill in a siginfo_t structure passed
in by the caller (which could be located on the stack), but it's
certainly possible that such library ABI's could exist.

	  	   	     	     	   - Ted
