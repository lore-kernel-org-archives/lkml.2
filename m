Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755349Ab0KFK5w (ORCPT <rfc822;w@1wt.eu>);
	Sat, 6 Nov 2010 06:57:52 -0400
Received: from mail1.slb.deg.dub.stisp.net ([84.203.253.98]:1770 "HELO
	mail1.slb.deg.dub.stisp.net" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with SMTP id S1754588Ab0KFK5v (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 6 Nov 2010 06:57:51 -0400
Message-ID: <4CD53499.90308@draigBrady.com>
Date: Sat, 06 Nov 2010 10:57:29 +0000
From: =?ISO-8859-1?Q?P=E1draig_Brady?= <P@draigBrady.com>
User-Agent: Mozilla/5.0 (X11; U; Linux i686; en-US; rv:1.9.1.8) Gecko/20100227 Thunderbird/3.0.3
MIME-Version: 1.0
To: Michael Tokarev <mjt@tls.msk.ru>
CC: Linux-kernel <linux-kernel@vger.kernel.org>
Subject: Re: Detecting bind-mounts
References: <4CD31B6A.7040902@msgid.tls.msk.ru> <4CD3DB5D.5040808@draigBrady.com> <4CD44D60.5050105@msgid.tls.msk.ru> <4CD46953.1010902@msgid.tls.msk.ru> <4CD4A231.1010000@draigBrady.com> <4CD4A5B4.5090204@msgid.tls.msk.ru>
In-Reply-To: <4CD4A5B4.5090204@msgid.tls.msk.ru>
X-Enigmail-Version: 1.0.1
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 06/11/10 00:47, Michael Tokarev wrote:
> 06.11.2010 03:32, Pádraig Brady wrote:
> []
>> As for a fast way, I don't think one exists.
>> BTW I'm not sure your examples are actually valid.
>> If a file/dir is bind mounted to the same file system, then
>> `find -xdev` should be listing it (as it has the same dev).
> 
> Think what, say, cp or tar with --one-file-system option are
> used for.  It is usually to copy a system to another place.
> There, we only want single copy of everything, and with current
> situation it will be two, with additional mess with hardlinks
> for files wich were hardlinks already (due to optimizations
> done by the utils based on link counts).

Fair enough, but that starts to overlap with how hardlinks
are handled.  If you're following symlinks then you can't
use the hardlink count. Note the du utility has recently
handled this by using a "di-set" to efficiently exclude
duplicate dev,inode pairs.

> 
> find -xdev is a bit different since it explicitly mentions
> "dev", and in my examples the device is actually the same.
> But usage case can be the same as for cp/tar above too, or
> may be different.
> 
>> You want a separate option --same-mount or something,
>> though I don't know what it would be useful for.
> 
> Stopping at the bind-mount dir definitely is useful, see
> above for the "main" (and very important) usage case (this
> can be solved differently on linux too - by cloning a new
> namespace and removing the bind mounts before doing that
> copy. but this is, again, ugly at best).
> 
> Note that this "main" usage case requires fast way to
> determine mount points...

I can see how it would be useful, yes.

cheers,
Pádraig.
