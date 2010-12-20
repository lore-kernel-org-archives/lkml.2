Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757920Ab0LTO0o (ORCPT <rfc822;w@1wt.eu>);
	Mon, 20 Dec 2010 09:26:44 -0500
Received: from mail-fx0-f43.google.com ([209.85.161.43]:33418 "EHLO
	mail-fx0-f43.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757892Ab0LTO0f (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 20 Dec 2010 09:26:35 -0500
MIME-Version: 1.0
X-Originating-IP: [87.194.19.206]
In-Reply-To: <20100202120457.GA19605@omega>
References: <20100202120457.GA19605@omega>
Date: Mon, 20 Dec 2010 14:26:33 +0000
Message-ID: <AANLkTik052sWOtqNyVdg6g6+cvo-NE-TBdSGdmmp_7en@mail.gmail.com>
Subject: Re: [PATCH] exit: PR_SET_ANCHOR for marking processes as reapers for
 child processes
From: Scott James Remnant <scott@netsplit.com>
To: Lennart Poettering <lennart@poettering.net>
Cc: linux-kernel@vger.kernel.org
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Feb 2, 2010 at 12:04 PM, Lennart Poettering
<lennart@poettering.net> wrote:

> Right now, if a process dies all its children are reparented to init.
> This logic has good uses, i.e. for double forking when daemonizing.
> However it also allows child processes to "escape" their parents, which
> is a problem for software like session managers (such as gnome-session)
> or other process supervisors.
>
> This patch adds a simple flag for each process that marks it as an
> "anchor" process for all its children and grandchildren. If a child of
> such an anchor dies all its children will not be reparented to init, but
> instead to this anchor, escaping this anchor process is not possible. A
> task with this flag set hence acts is little "sub-init".
>
Why can't you simply begin a new pid namespace with the session
manager or other process supervisor?  That way the session
manager/process supervisor is for all intents and purposes an init
daemon, so shouldn't be surprised about getting SIGCHLD.

More to the point, it means that as far as the processes themselves
are concerned, they're being reparented to pid 1 just as they were
before, so you wouldn't be breaking any assumptions there either.

You could use the existing init daemon to create these pid namespaces
when it spawns the session manager.

Scott
