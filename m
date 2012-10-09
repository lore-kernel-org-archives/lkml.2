Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752449Ab2JIXrV (ORCPT <rfc822;w@1wt.eu>);
	Tue, 9 Oct 2012 19:47:21 -0400
Received: from mail-vc0-f174.google.com ([209.85.220.174]:35895 "EHLO
	mail-vc0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751666Ab2JIXrS (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 9 Oct 2012 19:47:18 -0400
MIME-Version: 1.0
In-Reply-To: <20121009233927.GX2616@ZenIV.linux.org.uk>
References: <20110917001215.GA961@zombie.hq.fstein.net>
	<CAOH1cHkn_Yndw55y8QU-ipygRMfDyCG+An-qqBERtu4P-tt3MA@mail.gmail.com>
	<20121009233927.GX2616@ZenIV.linux.org.uk>
Date: Tue, 9 Oct 2012 16:47:17 -0700
Message-ID: <CAOH1cHmueHV9AiPkNSHXpEKm94nf2XZM9STv=qd7fJ+-n1VK-Q@mail.gmail.com>
Subject: Re: linux-audit: reconstruct path names from syscall events?
From: Mark Moseley <moseleymark@gmail.com>
To: Al Viro <viro@zeniv.linux.org.uk>
Cc: john@feurix.com, linux-kernel@vger.kernel.org, linux-audit@redhat.com
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Oct 9, 2012 at 4:39 PM, Al Viro <viro@zeniv.linux.org.uk> wrote:
> On Tue, Oct 09, 2012 at 04:09:18PM -0700, Mark Moseley wrote:
>
>> If you see my recent linux-audit posting, another related thing (at
>> least as far as missing relevant information in the logs) is that the
>> audit logs are logging pathnames relative to the chroot, instead of
>> the pathnames relative to the root of the OS itself. You'd expect a
>> process chroot'd to /chroot, accessing (from the perspective of the
>> OS) /chroot/etc/password would get logged as /chroot/etc/password but
>> is rather logged as /etc/password.
>>
>> I don't have a working LXC install handy, but I'd imagine the audit
>> subsystem would log relative to the container's / instead of the
>> host's / too.
>
> BTW, what makes you think that container's root is even reachable from
> "the host's /"?  There is no such thing as "root of the OS itself"; different
> processes can (and in case of containers definitely do) run in different
> namespaces.  With entirely different filesystems mounted in those, and
> no promise whatsoever that any specific namespace happens to have all
> filesystems mounted somewhere in it...

Nothing beyond guesswork, since it's been a while since I've played
with LXC. In any case, I was struggling a bit for the correct
terminology.

Am I similarly off-base with regards to the chroot'd scenario?
