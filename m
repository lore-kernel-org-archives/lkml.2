Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754711Ab2LKUQB (ORCPT <rfc822;w@1wt.eu>);
	Tue, 11 Dec 2012 15:16:01 -0500
Received: from mail-ea0-f174.google.com ([209.85.215.174]:35163 "EHLO
	mail-ea0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753034Ab2LKUP6 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 11 Dec 2012 15:15:58 -0500
MIME-Version: 1.0
In-Reply-To: <CA+55aFwaFqJQXR3Z8M3byube6hODmiT-dDEH3uFPSKpTDGXHaQ@mail.gmail.com>
References: <cover.1353621075.git.dmitry.kasatkin@intel.com>
	<CALLzPKZKd38QJVPfjdNpAFO9hwmRc1asVGkHby1VGRLm89DKyg@mail.gmail.com>
	<CALLzPKZgxO9wRNfJPnSY=G6Gjib7MeEXM4D1A1YZsrVmbs1W6A@mail.gmail.com>
	<1355234914.2356.85.camel@falcor>
	<CA+55aFwA3isRny9JyqxzjoysHbRhiKpBheeEi6VZrnWokt521A@mail.gmail.com>
	<1355249884.2356.108.camel@falcor>
	<CACLa4pvLbrCbivWSNTuxROBf5qDNJZmnFVyQaQ=7qcZRtSfcfg@mail.gmail.com>
	<1355252392.2356.131.camel@falcor>
	<CA+55aFwG31fi9=r0Zta2hoo60vdgM61hbh4BC9Rgs8i7S82Haw@mail.gmail.com>
	<1355255320.2356.148.camel@falcor>
	<CA+55aFwaFqJQXR3Z8M3byube6hODmiT-dDEH3uFPSKpTDGXHaQ@mail.gmail.com>
Date: Tue, 11 Dec 2012 15:15:57 -0500
Message-ID: <CACLa4puuwbvSibSk2Q4t732jAyf=ncTMvYe_57opNTEz-2NLWw@mail.gmail.com>
Subject: Re: [PATCH 0/2] ima: policy search speedup
From: Eric Paris <eparis@parisplace.org>
To: Linus Torvalds <torvalds@linux-foundation.org>
Cc: Mimi Zohar <zohar@linux.vnet.ibm.com>,
        "Kasatkin, Dmitry" <dmitry.kasatkin@intel.com>,
        Al Viro <viro@zeniv.linux.org.uk>,
        linux-fsdevel <linux-fsdevel@vger.kernel.org>,
        LSM List <linux-security-module@vger.kernel.org>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        James Morris <jmorris@namei.org>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Dec 11, 2012 at 3:05 PM, Linus Torvalds
<torvalds@linux-foundation.org> wrote:

> The "IS_PRIVATE()" thing is more a "if you know a-priori that you
> aren't interested in pseudo-filesystems, you can already check that
> bit, because it will be set for things like /proc and shmem mappings
> and pipes etc".

I know it isn't relevant to the final solution, but this is simply
wrong.  IS_PRIVATE() means 'this inode is filesystem internal.'  It is
not used by anything except rieser and the anon_inode.  If it is used
by psuedo filesystems in general, like /proc, shmem mappings, and
pipes that is a huge bug and is absolutely wrong.

You are correct IS_PRIVATE is sufficient to know you don't need to do
any IMA stuff with that inode, but it is used in damn few places and
better remain that way....

-Eric
