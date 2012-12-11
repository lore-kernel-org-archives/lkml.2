Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753838Ab2LKUFd (ORCPT <rfc822;w@1wt.eu>);
	Tue, 11 Dec 2012 15:05:33 -0500
Received: from mail-wi0-f174.google.com ([209.85.212.174]:45926 "EHLO
	mail-wi0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753083Ab2LKUFa (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 11 Dec 2012 15:05:30 -0500
MIME-Version: 1.0
In-Reply-To: <1355255320.2356.148.camel@falcor>
References: <cover.1353621075.git.dmitry.kasatkin@intel.com>
 <CALLzPKZKd38QJVPfjdNpAFO9hwmRc1asVGkHby1VGRLm89DKyg@mail.gmail.com>
 <CALLzPKZgxO9wRNfJPnSY=G6Gjib7MeEXM4D1A1YZsrVmbs1W6A@mail.gmail.com>
 <1355234914.2356.85.camel@falcor> <CA+55aFwA3isRny9JyqxzjoysHbRhiKpBheeEi6VZrnWokt521A@mail.gmail.com>
 <1355249884.2356.108.camel@falcor> <CACLa4pvLbrCbivWSNTuxROBf5qDNJZmnFVyQaQ=7qcZRtSfcfg@mail.gmail.com>
 <1355252392.2356.131.camel@falcor> <CA+55aFwG31fi9=r0Zta2hoo60vdgM61hbh4BC9Rgs8i7S82Haw@mail.gmail.com>
 <1355255320.2356.148.camel@falcor>
From: Linus Torvalds <torvalds@linux-foundation.org>
Date: Tue, 11 Dec 2012 12:05:08 -0800
X-Google-Sender-Auth: IxFITYKRmKBRWwiRuerPpcQKF6Y
Message-ID: <CA+55aFwaFqJQXR3Z8M3byube6hODmiT-dDEH3uFPSKpTDGXHaQ@mail.gmail.com>
Subject: Re: [PATCH 0/2] ima: policy search speedup
To: Mimi Zohar <zohar@linux.vnet.ibm.com>
Cc: Eric Paris <eparis@parisplace.org>,
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

On Tue, Dec 11, 2012 at 11:48 AM, Mimi Zohar <zohar@linux.vnet.ibm.com> wrote:
>
> Ok. To summarize, S_IMA indicates that there is a rule and that the iint
> was allocated.  To differentiate between 'haven't looked/don't know' and
> 'definitely not', we need another bit.  For this, you're suggesting
> using IS_PRIVATE()?  Hopefully, I misunderstood.

No, for that, I'm suggesting using a new bit in i_flags.

The "IS_PRIVATE()" thing is more a "if you know a-priori that you
aren't interested in pseudo-filesystems, you can already check that
bit, because it will be set for things like /proc and shmem mappings
and pipes etc".

Dmitry seemed to imply that the biggest use for the new bit was for
taking out whole pseudo-filesystems in one go. That would pretty much
be what S_PRIVATE is.

                  Linus
