Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756868Ab2EPQKW (ORCPT <rfc822;w@1wt.eu>);
	Wed, 16 May 2012 12:10:22 -0400
Received: from mail-we0-f174.google.com ([74.125.82.174]:62495 "EHLO
	mail-we0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756257Ab2EPQKU (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 16 May 2012 12:10:20 -0400
MIME-Version: 1.0
In-Reply-To: <1337183225.3522.14.camel@falcor>
References: <1336963631-3541-1-git-send-email-zohar@us.ibm.com>
 <CA+55aFzrJNd5J7i3Rp7-ctc=bDn5GTWu=H1xyCgGZ-rzu74Gbw@mail.gmail.com>
 <CA+55aFyPPZ0wayqPMCZtfP1w9nN-GnKJxYc9i_XM_Qk8d-zJzg@mail.gmail.com>
 <CACLa4pujEBAS349Pr-EcBmzQgTHWthhCMV0Yqq0BG-F_gDjz4Q@mail.gmail.com>
 <1337112446.20904.50.camel@falcor> <CA+55aFxRRuWGD-4LYzO-T8eg22goKpej5AV36ALL8GaLP56oRA@mail.gmail.com>
 <CA+55aFzOtY7tBw4YNH+QX+6L4opMsJ=sN4DfJURMv_yBTWqL1w@mail.gmail.com>
 <20120516004251.GO22082@ZenIV.linux.org.uk> <CA+55aFy0wJdq+-OAkUBsrkQogF5-N0P4DBQ+6-LXjBGscRQFNw@mail.gmail.com>
 <CA+55aFy1qQkGXAr=0Zqk=qJeGTpfMOVC2=rdRWzQ1qsUZ5P0_g@mail.gmail.com>
 <alpine.LRH.2.02.1205162135320.10697@tundra.namei.org> <1337175731.2492.4.camel@localhost>
 <1337176336.3522.5.camel@falcor> <CACLa4psYWecSy9sRuV2Nf9BPU0xspjJF-ZD63biqv6erUYKyGQ@mail.gmail.com>
 <1337183225.3522.14.camel@falcor>
From: Linus Torvalds <torvalds@linux-foundation.org>
Date: Wed, 16 May 2012 09:09:58 -0700
X-Google-Sender-Auth: MZTVFeCoN7UEk5DZu4nFp5PkCf8
Message-ID: <CA+55aFxcK87o3Yp26R0R+-XKNdZ92hjKBkjNbNAHFDX0FBmtSA@mail.gmail.com>
Subject: Re: [PATCH] vfs: fix IMA lockdep circular locking dependency
To: Mimi Zohar <zohar@linux.vnet.ibm.com>
Cc: Eric Paris <eparis@parisplace.org>, James Morris <jmorris@namei.org>,
        Al Viro <viro@zeniv.linux.org.uk>, Mimi Zohar <zohar@us.ibm.com>,
        linux-security-module@vger.kernel.org, linux-kernel@vger.kernel.org
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, May 16, 2012 at 8:47 AM, Mimi Zohar <zohar@linux.vnet.ibm.com> wrote:
>
> The default
> today, without LSM enabled, is to call the cap functions directly from
> the security stub functions,

.. I wouldn't call that the default actually: the default today is
pretty much whatever "makes sense".

A *lot* of them just do "return 0" (or, for the ones without a return
value, nothing at all).

In fact, I think it's most of them by far.

Some of them return errors (-EOPNOTSUPP).

So really only for a small subset of the simple cases do the security
wrapper inlines call the cap functions directly. Those simple cases
tend to happen to be at the top of the list, though, so it may seem
more common at first glance than it actually is.

                    Linus
