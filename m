Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933849Ab1CXTTB (ORCPT <rfc822;w@1wt.eu>);
	Thu, 24 Mar 2011 15:19:01 -0400
Received: from srv04.jarevo.de ([88.198.54.146]:64172 "EHLO srv04.jarevo.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S933676Ab1CXTS7 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 24 Mar 2011 15:18:59 -0400
Message-ID: <4D8B991E.5070604@nachtgeist.net>
Date: Thu, 24 Mar 2011 20:18:54 +0100
From: Daniel Reichelt <debian@nachtgeist.net>
User-Agent: Mozilla/5.0 (X11; U; Linux x86_64; en-US; rv:1.9.1.16) Gecko/20110307 Icedove/3.0.11
MIME-Version: 1.0
To: linux-kernel@vger.kernel.org
Subject: Re: procfs: boot- and runtime configurable access mode for /proc/<pid>
 dirs
References: <4D8AC408.9000503@nachtgeist.net> <20110324073225.GA3806@p183.telecom.by> <4D8B03D6.2090204@nachtgeist.net> <20110324182230.GB5187@p183.telecom.by>
In-Reply-To: <20110324182230.GB5187@p183.telecom.by>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

> More to the point, permissions in /proc/<pid>/* don't do us much good.
> As the matter of fact, we ought to make them all flat - i.e. same for
> user/group/other, since we have to recheck access rights on every damn
> IO operations.  Checks done at open() are useless here - have the
> task exec suid-root binary and they are obsolete.

Well, my patch is about modes of the pid-dirs themselves, not their
contents. And it changes procfs' behaviour about modes both on initial
creation and during revalidation on access. However flattening all the
piddir's entries DOES pose a security risk. Have a look at the
"traditional behaviour": piddir world-readable, however e.g.
<pid>/environ isn't. Often it's a workaround for broken software to
specify a password within an environment variable instead of by cmdline.
Since up until now all processes including their full cmdlines are
visible to everyone, environ must be considered more sensitive than a
cmdline.

The security implications are taken care of by my patch. The more
restrictive the modes for the piddir, the less access to its contents.
So from a security point of view, my patch takes care of that and IMHO
there's no need to put hands on the procfs' management of modes for
piddir-contents.
