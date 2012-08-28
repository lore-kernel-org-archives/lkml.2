Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753269Ab2H2AWj (ORCPT <rfc822;w@1wt.eu>);
	Tue, 28 Aug 2012 20:22:39 -0400
Received: from mail-ob0-f174.google.com ([209.85.214.174]:43388 "EHLO
	mail-ob0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750973Ab2H2AWi (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 28 Aug 2012 20:22:38 -0400
Message-ID: <503D4C71.9040501@landley.net>
Date: Tue, 28 Aug 2012 17:55:45 -0500
From: Rob Landley <rob@landley.net>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:14.0) Gecko/20120714 Thunderbird/14.0
MIME-Version: 1.0
To: "Theodore Ts'o" <tytso@mit.edu>, Kees Cook <keescook@chromium.org>,
        linux-kernel@vger.kernel.org,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Ben Hutchings <ben@decadent.org.uk>, Al Viro <viro@zeniv.linux.org.uk>,
        Ludwig Nussel <ludwig.nussel@suse.de>,
        Alessandro Rubini <rubini@gnudd.com>, linux-doc@vger.kernel.org
Subject: Re: Hardening debugfs (Was Re: [PATCH] debugfs: more tightly restrict
 default mount mode)
References: <20120827203215.GA16637@www.outflux.net> <20120828144110.GA23035@thunk.org>
In-Reply-To: <20120828144110.GA23035@thunk.org>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 08/28/2012 09:41 AM, Theodore Ts'o wrote:
> On Mon, Aug 27, 2012 at 01:32:15PM -0700, Kees Cook wrote:
>> Since the debugfs is mostly only used by root, make the default mount
>> mode 0700. Most system owners do not need a more permissive value,
>> but they can choose to weaken the restrictions via their fstab.
>>
>> Signed-off-by: Kees Cook <keescook@chromium.org>
> 
> I agree with this patch, but it would also be good if we could try to
> harden debugfs in general.  Some ideas that might be worth discussing,
> for example?
> 
> 1) Adding a per-module flag, so things in debugfs only show up if they
> are explicitly requested (you know, for debugging purposes). If most
> people are using debugfs for access to ftrace and powertap (my use
> case), there's no point making directories for other device drivers
> and file systems visible.

Are you suggesting "echo 1 > /sys/module/mymod/debug", or are you
suggesting "mount -t devfs -o mymod /tmp/mymod", or knobs in devfs?

I've always been a bit confused by the debugfs design, which seems a
giant compost heap like /proc where we find a specific styrofoam cup
useful and the temporary thing becomes permanent. (Why is there _one_
debugfs?)

Oh well, presumably too late to change it now. (Unless you mount a tmpfs
on /sys/kernel/debug and mkdir mount points in there, but in the
perpetual absence of union mounts it would probably involve
userspace-visible path changes...)

> 2) Can we find a pattern of common security #fail's with debugfs
> files, and try to sweep through and fix them?
> 
> There may be other ideas, and again, I'm not saying that this means we
> shouldn't lock down the permissions on debugfs.  But a both/and
> approach might be useful here....

Plenty of other ideas, but it says "there are no usage rules" right
there in the documentation file which makes compatible cleanup hard...

Rob
-- 
GNU/Linux isn't: Linux=GPLv2, GNU=GPLv3+, they can't share code.
Either it's "mere aggregation", or a license violation.  Pick one.
