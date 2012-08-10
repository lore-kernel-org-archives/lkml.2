Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759368Ab2HJPCJ (ORCPT <rfc822;w@1wt.eu>);
	Fri, 10 Aug 2012 11:02:09 -0400
Received: from relay4-d.mail.gandi.net ([217.70.183.196]:41474 "EHLO
	relay4-d.mail.gandi.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1758269Ab2HJPCG (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 10 Aug 2012 11:02:06 -0400
X-Originating-IP: 217.70.178.142
X-Originating-IP: 50.43.46.74
Date: Fri, 10 Aug 2012 08:01:57 -0700
From: Josh Triplett <josh@joshtriplett.org>
To: Serge Hallyn <serge.hallyn@canonical.com>
Cc: Alex Kelly <alex.page.kelly@gmail.com>,
        Alexander Viro <viro@zeniv.linux.org.uk>,
        Heiko Carstens <heiko.carstens@de.ibm.com>,
        "Eric W. Biederman" <ebiederm@xmission.com>,
        "Paul E. McKenney" <paulmck@linux.vnet.ibm.com>,
        Andrew Morton <akpm@linux-foundation.org>,
        Ingo Molnar <mingo@kernel.org>, Kees Cook <keescook@chromium.org>,
        linux-fsdevel@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCHv4 2/3] fs: Make core dump functionality optional
Message-ID: <20120810150157.GA23457@leaf>
References: <1344587169-18682-1-git-send-email-alex.page.kelly@gmail.com>
 <1344587169-18682-2-git-send-email-alex.page.kelly@gmail.com>
 <20120810132323.GA21048@sergelap>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20120810132323.GA21048@sergelap>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Aug 10, 2012 at 08:23:23AM -0500, Serge Hallyn wrote:
> Quoting Alex Kelly (alex.page.kelly@gmail.com):
> > Adds an expert Kconfig option, CONFIG_COREDUMP, which allows disabling of core dump.
> > This saves approximately 2.6k in the compiled kernel, and complements CONFIG_ELF_CORE,
> > which now depends on it.
> 
> Is there another reason than the 2.6k to do this?  My kernels range
> between 4.8 and 5M, so that's .05% size savings?

A kitchen-sink kernel might take up that much space, but you can build a
minimal embedded kernel that only takes up ~200k, at which point 2.6k
represents a >1% decrease.  Add a few more changes like this, and those
decreases start to add up.  At this point, no one thing you can chop out
of the kernel will give you a 100k decrease by itself; you need a pile
of changes like this one to do that.

- Josh Triplett
