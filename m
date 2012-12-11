Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754058Ab2LKQ7Z (ORCPT <rfc822;w@1wt.eu>);
	Tue, 11 Dec 2012 11:59:25 -0500
Received: from mail-we0-f174.google.com ([74.125.82.174]:41274 "EHLO
	mail-we0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753236Ab2LKQ7X (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 11 Dec 2012 11:59:23 -0500
MIME-Version: 1.0
In-Reply-To: <1355234914.2356.85.camel@falcor>
References: <cover.1353621075.git.dmitry.kasatkin@intel.com>
 <CALLzPKZKd38QJVPfjdNpAFO9hwmRc1asVGkHby1VGRLm89DKyg@mail.gmail.com>
 <CALLzPKZgxO9wRNfJPnSY=G6Gjib7MeEXM4D1A1YZsrVmbs1W6A@mail.gmail.com> <1355234914.2356.85.camel@falcor>
From: Linus Torvalds <torvalds@linux-foundation.org>
Date: Tue, 11 Dec 2012 08:59:01 -0800
X-Google-Sender-Auth: mY2yWdOyOw2fjgII5FQ_bZIhwpk
Message-ID: <CA+55aFwA3isRny9JyqxzjoysHbRhiKpBheeEi6VZrnWokt521A@mail.gmail.com>
Subject: Re: [PATCH 0/2] ima: policy search speedup
To: Mimi Zohar <zohar@linux.vnet.ibm.com>
Cc: "Kasatkin, Dmitry" <dmitry.kasatkin@intel.com>,
        Al Viro <viro@zeniv.linux.org.uk>,
        linux-fsdevel <linux-fsdevel@vger.kernel.org>,
        LSM List <linux-security-module@vger.kernel.org>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        James Morris <jmorris@namei.org>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Dec 11, 2012 at 6:08 AM, Mimi Zohar <zohar@linux.vnet.ibm.com> wrote:
> On Tue, 2012-12-11 at 14:51 +0200, Kasatkin, Dmitry wrote:
>> >>
>> >> Two months ago I was asking about it on mailing lists.
>> >> Suggestion was not to use s_flags, but e.g. s_feature_flags.

Quite frankly, this seems stupid.

Without really knowing the problem space, the sane thing to do would
seem to be inode->i_flags. At which point it's

 (a) faster to test (no need to dereference inode->i_sb)

 (b) matches what the integrity layer does with S_IMA (well, there the
logic is reversed: S_IMA means that it has a integrity structure
associated with it)

 (c) allows you to mark individual inodes as "no checking".

and quite frankly, (c) in particular seems to make sense to me, since
it would seem to be rather possible to do things like "I've checked
this inode, it had no policies associated with it, I never need to
check it again". Clear the flag when policies change or whatever.

What's the advantage of making it per-filesystem?

            Linus
