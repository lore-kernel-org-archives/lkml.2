Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759833Ab2CVUmu (ORCPT <rfc822;w@1wt.eu>);
	Thu, 22 Mar 2012 16:42:50 -0400
Received: from mail-wi0-f172.google.com ([209.85.212.172]:51579 "EHLO
	mail-wi0-f172.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1759748Ab2CVUms (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 22 Mar 2012 16:42:48 -0400
MIME-Version: 1.0
In-Reply-To: <20120322203658.GC6589@ZenIV.linux.org.uk>
References: <20120322183845.GA17264@phenom.dumpdata.com> <20120322200918.GZ6589@ZenIV.linux.org.uk>
 <20120322202445.GB6589@ZenIV.linux.org.uk> <20120322203658.GC6589@ZenIV.linux.org.uk>
From: Linus Torvalds <torvalds@linux-foundation.org>
Date: Thu, 22 Mar 2012 13:42:27 -0700
X-Google-Sender-Auth: mI0TNOuaV9eqoQZNwDWSk2qa3uc
Message-ID: <CA+55aFzTMTXboyJxmFWrPmv6ckt5m3-9rovwg1_8Y+3Osk9uxA@mail.gmail.com>
Subject: Re: Regression introduced by bfcfaa77bdf0f775263e906015982a608df01c76
 (vfs: use 'unsigned long' accesses for dcache name comparison and hashing)
To: Al Viro <viro@zeniv.linux.org.uk>
Cc: linux-kernel@vger.kernel.org, xen-devel@lists.xensource.com,
        Konrad Rzeszutek Wilk <konrad.wilk@oracle.com>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Mar 22, 2012 at 1:36 PM, Al Viro <viro@zeniv.linux.org.uk> wrote:
>
> Guys, could you check if this fixes it?

Yup, that's the patch I was thinking of too.

But I didn't test it. And considering that apparently I don't have
anything that ever triggers this, I guess I should write some
user-space harness thing for this.

I actually wrote some *other* user-space testing functions (checking
that the hash values we generated were good), but I never tested the
"unimportant and totally obvious" full_name_hash() function.

Btw, about test harnesses: I do have a patch to the kernel that
exposes the dentry hash chains through /proc. Interesting to anybody
else? I decided that I didn't want to try to simulate the dentry
hashing in user space, since part of the final hash function is the
'parent' dentry pointer itself (the name hash part is user-spaceable,
but I wanted to see the distribution of those parent bits too).

                          Linus
