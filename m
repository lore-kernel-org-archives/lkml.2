Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751715Ab0LUMFO (ORCPT <rfc822;w@1wt.eu>);
	Tue, 21 Dec 2010 07:05:14 -0500
Received: from mail-fx0-f43.google.com ([209.85.161.43]:33654 "EHLO
	mail-fx0-f43.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751376Ab0LUMFN convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 21 Dec 2010 07:05:13 -0500
MIME-Version: 1.0
X-Originating-IP: [87.194.19.206]
In-Reply-To: <20101221095625.GA4438@tango.0pointer.de>
References: <AANLkTik052sWOtqNyVdg6g6+cvo-NE-TBdSGdmmp_7en@mail.gmail.com>
	<20101221095625.GA4438@tango.0pointer.de>
Date: Tue, 21 Dec 2010 12:05:11 +0000
Message-ID: <AANLkTi=GGGP4vK1hOBn-+oCAM1gFXg_XUfLeTFM2CqA_@mail.gmail.com>
Subject: Re: [PATCH] exit: PR_SET_ANCHOR for marking processes as reapers for
 child processes
From: Scott James Remnant <scott@netsplit.com>
To: Lennart Poettering <mzxreary@0pointer.de>
Cc: linux-kernel@vger.kernel.org
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Dec 21, 2010 at 9:56 AM, Lennart Poettering
<mzxreary@0pointer.de> wrote:
> On Mon, 20.12.10 14:26, Scott James Remnant (scott@netsplit.com) wrote:
>
>> > This patch adds a simple flag for each process that marks it as an
>> > "anchor" process for all its children and grandchildren. If a child of
>> > such an anchor dies all its children will not be reparented to init, but
>> > instead to this anchor, escaping this anchor process is not possible. A
>> > task with this flag set hence acts is little "sub-init".
>> >
>> Why can't you simply begin a new pid namespace with the session
>> manager or other process supervisor?  That way the session
>> manager/process supervisor is for all intents and purposes an init
>> daemon, so shouldn't be surprised about getting SIGCHLD.
>
> PID namespaces primarily provide an independent PID numbering scheme for
> a subset of processes, i.e. so that identical may PIDs refer to different
> processes depending on the namespace they are running in. As a side
> effect this also provides init-like behaviour for processes that aren't
> the original PID 1 of the operating system. For systemd we are only
> interested in this side effect, but are not interested at all in the
> renumbering of processes, and in fact would even really dislike if it
> happened. That's why PR_SET_ANCHOR is useful: it gives us init-like
> behaviour without renaming all processes.
>
Right, but I don't get why you need this behavior to supervise either
system or user processes.  You already get all the functionality you
need to track processes via either cgroups or the proc connector (or a
combination of both).

So is this really just about making ps look pretty, as Kay says?

Scott
