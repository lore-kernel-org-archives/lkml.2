Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755454Ab1BHAon (ORCPT <rfc822;w@1wt.eu>);
	Mon, 7 Feb 2011 19:44:43 -0500
Received: from tundra.namei.org ([65.99.196.166]:41469 "EHLO tundra.namei.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754212Ab1BHAom (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 7 Feb 2011 19:44:42 -0500
Date: Tue, 8 Feb 2011 11:44:40 +1100 (EST)
From: James Morris <jmorris@namei.org>
To: Kees Cook <kees.cook@canonical.com>
cc: linux-kernel@vger.kernel.org
Subject: Re: [SECURITY] /proc/$pid/ leaks contents across setuid exec
In-Reply-To: <20110207231416.GD1457@outflux.net>
Message-ID: <alpine.LRH.2.00.1102081127330.3342@tundra.namei.org>
References: <20110207231416.GD1457@outflux.net>
User-Agent: Alpine 2.00 (LRH 1167 2008-08-23)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 7 Feb 2011, Kees Cook wrote:

> $ ./procleak.py auxv,syscall /usr/bin/passwd
> running
> AT_BASE:   0x7f2828bde000
> AT_RANDOM: 0x7fff80bde7c9
> Changing password for kees.
> (current) UNIX password: 0 0x0 0x7fff80bdda90 0x1ff 0x7fff80bdd580 0x7f2828dc57c0 0x7f28287cec1d 0x7fff80bdd088 0x7f28282fe6c0
> 
> There needs to be some way to break the connection to these files across
> the setuid exec, or perform some sort of revalidation of permissions. (Maybe
> check dumpable?)

The way to do this is to set O_CLOEXEC.

See: 

http://udrepper.livejournal.com/20407.html
https://www.securecoding.cert.org/confluence/display/seccode/FIO42-C.+Ensure+files+are+properly+closed+when+they+are+no+longer+needed

Changing the behavior in the core kernel will break userspace.



- James
-- 
James Morris
<jmorris@namei.org>
