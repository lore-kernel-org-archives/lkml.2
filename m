Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755288Ab0KFArv (ORCPT <rfc822;w@1wt.eu>);
	Fri, 5 Nov 2010 20:47:51 -0400
Received: from isrv.corpit.ru ([86.62.121.231]:47808 "EHLO isrv.corpit.ru"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755192Ab0KFArt (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 5 Nov 2010 20:47:49 -0400
Message-ID: <4CD4A5B4.5090204@msgid.tls.msk.ru>
Date: Sat, 06 Nov 2010 03:47:48 +0300
From: Michael Tokarev <mjt@tls.msk.ru>
Organization: Telecom Service, JSC
User-Agent: Mozilla/5.0 (X11; U; Linux i686 (x86_64); en-US; rv:1.9.1.12) Gecko/20100913 Icedove/3.0.7
MIME-Version: 1.0
To: =?ISO-8859-1?Q?P=E1draig_Brady?= <P@draigBrady.com>
CC: Linux-kernel <linux-kernel@vger.kernel.org>
Subject: Re: Detecting bind-mounts
References: <4CD31B6A.7040902@msgid.tls.msk.ru> <4CD3DB5D.5040808@draigBrady.com> <4CD44D60.5050105@msgid.tls.msk.ru> <4CD46953.1010902@msgid.tls.msk.ru> <4CD4A231.1010000@draigBrady.com>
In-Reply-To: <4CD4A231.1010000@draigBrady.com>
X-Enigmail-Version: 1.0.1
OpenPGP: id=804465C5
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

06.11.2010 03:32, Pádraig Brady wrote:
[]
> As for a fast way, I don't think one exists.
> BTW I'm not sure your examples are actually valid.
> If a file/dir is bind mounted to the same file system, then
> `find -xdev` should be listing it (as it has the same dev).

Think what, say, cp or tar with --one-file-system option are
used for.  It is usually to copy a system to another place.
There, we only want single copy of everything, and with current
situation it will be two, with additional mess with hardlinks
for files wich were hardlinks already (due to optimizations
done by the utils based on link counts).

find -xdev is a bit different since it explicitly mentions
"dev", and in my examples the device is actually the same.
But usage case can be the same as for cp/tar above too, or
may be different.

> You want a separate option --same-mount or something,
> though I don't know what it would be useful for.

Stopping at the bind-mount dir definitely is useful, see
above for the "main" (and very important) usage case (this
can be solved differently on linux too - by cloning a new
namespace and removing the bind mounts before doing that
copy. but this is, again, ugly at best).

Note that this "main" usage case requires fast way to
determine mount points...

/mjt
