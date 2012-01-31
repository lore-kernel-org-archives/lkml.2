Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753393Ab2AaDLF (ORCPT <rfc822;w@1wt.eu>);
	Mon, 30 Jan 2012 22:11:05 -0500
Received: from ozlabs.org ([203.10.76.45]:60311 "EHLO ozlabs.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752527Ab2AaDLE (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 30 Jan 2012 22:11:04 -0500
From: Rusty Russell <rusty@rustcorp.com.au>
To: Dave Young <dyoung@redhat.com>
Cc: linux-kernel@vger.kernel.org
Subject: Re: [PATCH] add kernel parameter to disable module load
In-Reply-To: <4F2755A2.5040108@redhat.com>
References: <20120128033450.GA2138@darkstar> <87vcnvbab1.fsf@rustcorp.com.au> <4F2755A2.5040108@redhat.com>
User-Agent: Notmuch/0.6.1-1 (http://notmuchmail.org) Emacs/23.3.1 (i686-pc-linux-gnu)
Date: Tue, 31 Jan 2012 13:29:56 +1030
Message-ID: <871uqglgpf.fsf@rustcorp.com.au>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 31 Jan 2012 10:44:50 +0800, Dave Young <dyoung@redhat.com> wrote:
> On 01/29/2012 08:51 AM, Rusty Russell wrote:
> 
> > On Sat, 28 Jan 2012 11:34:50 +0800, Dave Young <dyoung@redhat.com> wrote:
> >> Sometimes we need to test a kernel of same version with code or config
> >> option changes.
> >>
> >> We already have sysctl to disable module load, but add a kernel
> >> parameter will be more convenient.
> > 
> > 
> >> +static int __init module_load_disable(char *str)
> >> +{
> >> +	modules_disabled = 1;
> >> +	return 1;
> >> +}
> >> +__setup("nomodule", module_load_disable);
> > 
> > You misspelled core_param here :)
> > 
> 
> 
> Hello Rusty, If use core_param I'd better to change modules_disabled
> from int to bool or we must pass nomodule=1 instead of simply pass
> nomodule. But I think I can firstly post the core_param patch with
> current int type, then work on the transition patch for the variable
> type changes, what do you think?

You could code your set function, but "bint" is what you want.  Cleaning
it up to be a bool is a good idea too.

> Another do you think we need to expose this to sysfs via core_param?
> According to the sysctl code looks like we should not add sysfs
> interface to allow transition from "1" to "0"

If you want it writable, you definitely want to code your own set
function so it's one way.  But perm 0 or 0444 make sense, too.

Cheers,
Rusty.
