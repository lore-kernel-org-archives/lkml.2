Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752315Ab2EPONk (ORCPT <rfc822;w@1wt.eu>);
	Wed, 16 May 2012 10:13:40 -0400
Received: from mail-qc0-f174.google.com ([209.85.216.174]:48628 "EHLO
	mail-qc0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751522Ab2EPONi (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 16 May 2012 10:13:38 -0400
MIME-Version: 1.0
In-Reply-To: <CA+55aFzOtY7tBw4YNH+QX+6L4opMsJ=sN4DfJURMv_yBTWqL1w@mail.gmail.com>
References: <1336963631-3541-1-git-send-email-zohar@us.ibm.com>
	<CA+55aFzrJNd5J7i3Rp7-ctc=bDn5GTWu=H1xyCgGZ-rzu74Gbw@mail.gmail.com>
	<CA+55aFyPPZ0wayqPMCZtfP1w9nN-GnKJxYc9i_XM_Qk8d-zJzg@mail.gmail.com>
	<CACLa4pujEBAS349Pr-EcBmzQgTHWthhCMV0Yqq0BG-F_gDjz4Q@mail.gmail.com>
	<1337112446.20904.50.camel@falcor>
	<CA+55aFxRRuWGD-4LYzO-T8eg22goKpej5AV36ALL8GaLP56oRA@mail.gmail.com>
	<CA+55aFzOtY7tBw4YNH+QX+6L4opMsJ=sN4DfJURMv_yBTWqL1w@mail.gmail.com>
Date: Wed, 16 May 2012 10:13:37 -0400
Message-ID: <CACLa4pspOFx638fn6aDHpESVZrKmWCnrO999qoO+Mna4ccF_7g@mail.gmail.com>
Subject: Re: [PATCH] vfs: fix IMA lockdep circular locking dependency
From: Eric Paris <eparis@parisplace.org>
To: Linus Torvalds <torvalds@linux-foundation.org>
Cc: Mimi Zohar <zohar@linux.vnet.ibm.com>, Mimi Zohar <zohar@us.ibm.com>,
        linux-security-module@vger.kernel.org, linux-kernel@vger.kernel.org,
        Al Viro <viro@zeniv.linux.org.uk>, Stephen Smalley <sds@tycho.nsa.gov>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, May 15, 2012 at 8:37 PM, Linus Torvalds
<torvalds@linux-foundation.org> wrote:

> It does change some things, like say that "->mmap_file()" is only ever
> called for actual files, not for anonymous mappings. It doesn't seem
> to be sensible to have a security model for anonymous mappings -
> there's nothing there to really target. Whatever.

So we would have no checks for anonymous mappings?  We actually do
have some controls around them today

http://www.akkadia.org/drepper/selinux-mem.html

It's mostly around W+X memory.  (or was W now X memory)

Admittedly with the growing prevalence of JiT stuff we are using those
protections less and less and less....

Not certain how happy some will be to see them completely disappear....
