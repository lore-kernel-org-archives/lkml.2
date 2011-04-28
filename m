Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757250Ab1D1DnI (ORCPT <rfc822;w@1wt.eu>);
	Wed, 27 Apr 2011 23:43:08 -0400
Received: from mail-fx0-f46.google.com ([209.85.161.46]:34479 "EHLO
	mail-fx0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754869Ab1D1DnG convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 27 Apr 2011 23:43:06 -0400
MIME-Version: 1.0
In-Reply-To: <20110428034003.GG9487@ZenIV.linux.org.uk>
References: <1303960136-14298-1-git-send-email-wad@chromium.org>
	<1303960136-14298-3-git-send-email-wad@chromium.org>
	<20110428122334.D197.A69D9226@jp.fujitsu.com>
	<BANLkTinfXZ3j0vG51=cQjM0FZQ5VR5ze8A@mail.gmail.com>
	<20110428034003.GG9487@ZenIV.linux.org.uk>
Date: Wed, 27 Apr 2011 22:43:04 -0500
Message-ID: <BANLkTikfM+WAjgWEcaift+3=fd0z3FkprQ@mail.gmail.com>
Subject: Re: [PATCH 4/7] seccomp_filter: add process state reporting
From: Will Drewry <wad@chromium.org>
To: Al Viro <viro@zeniv.linux.org.uk>
Cc: KOSAKI Motohiro <kosaki.motohiro@jp.fujitsu.com>,
        linux-kernel@vger.kernel.org, kees.cook@canonical.com,
        eparis@redhat.com, agl@chromium.org, mingo@elte.hu, jmorris@namei.org,
        rostedt@goodmis.org, Andrew Morton <akpm@linux-foundation.org>,
        Alexey Dobriyan <adobriyan@gmail.com>,
        David Howells <dhowells@redhat.com>,
        David Rientjes <rientjes@google.com>,
        Stephen Wilson <wilsons@start.ca>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Apr 27, 2011 at 10:40 PM, Al Viro <viro@zeniv.linux.org.uk> wrote:
> On Wed, Apr 27, 2011 at 10:24:20PM -0500, Will Drewry wrote:
>
>> Definitely.  Would it make sense to have /proc/<pid>/seccomp and
>> /proc/<pid>/seccomp_filter?
>
> Just one question: WTF bother with S_IRUSR?  Note that it's absolutely
> _useless_ in procfs; any kind of permission checks must be done in
> read(2) time since doing it in open(2) is worthless.  Consider execve()
> on suid binary; oops, there goes your uid and there goes the effect
> of checks done by open(2).  And if you *do* checks in read(2), why bother
> duplicating them in open(2)?

In earlier versions I was allowing filter/bitmask updating via the
proc file (which I nixed :).  Is S_IRUGO preferred? I don't see any
crazy information leakage by sharing the filters/ruleset.  I'll fold
it into the next version of this patch.

thanks!
will
