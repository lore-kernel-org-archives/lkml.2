Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754686Ab0KEUaQ (ORCPT <rfc822;w@1wt.eu>);
	Fri, 5 Nov 2010 16:30:16 -0400
Received: from isrv.corpit.ru ([86.62.121.231]:43776 "EHLO isrv.corpit.ru"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752454Ab0KEUaO (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 5 Nov 2010 16:30:14 -0400
Message-ID: <4CD46953.1010902@msgid.tls.msk.ru>
Date: Fri, 05 Nov 2010 23:30:11 +0300
From: Michael Tokarev <mjt@tls.msk.ru>
Organization: Telecom Service, JSC
User-Agent: Mozilla/5.0 (X11; U; Linux i686 (x86_64); en-US; rv:1.9.1.12) Gecko/20100913 Icedove/3.0.7
MIME-Version: 1.0
To: =?ISO-8859-1?Q?P=E1draig_Brady?= <P@draigBrady.com>
CC: Linux-kernel <linux-kernel@vger.kernel.org>
Subject: Re: Detecting bind-mounts
References: <4CD31B6A.7040902@msgid.tls.msk.ru> <4CD3DB5D.5040808@draigBrady.com> <4CD44D60.5050105@msgid.tls.msk.ru>
In-Reply-To: <4CD44D60.5050105@msgid.tls.msk.ru>
X-Enigmail-Version: 1.0.1
OpenPGP: id=804465C5
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

05.11.2010 21:30, Michael Tokarev wrote:
> 05.11.2010 13:24, Pádraig Brady wrote:
>> On 04/11/10 20:45, Michael Tokarev wrote:
> []
>>> There are 2 (mostly) different kinds of applications.  One
>>> is cp/tar/find with --same-filesystem option (or equivalent),
>>> that should not cross mountpoints.  And one more, apps like
>>> mountpoint(1) from sysvinit - a utility to determine if a
>>> given path is a mountpoint.
>>>
>>> Neither of the two work when two directores on the same
>>> filesystem are bind-mounted.
> []
>> The `stat` command recently got support for
>> printing the mount point for a file:
>> http://git.savannah.gnu.org/gitweb/?p=coreutils.git;a=commit;h=ddf6fb86
>>
>> `stat` will output the alias for a bind mounted file
>> while `df` will output the initial mount point of its backing device
>> So you could do something like:
>>
>> file=.
>> df_mnt=$(df -P "$file" | sed -n '2s/.* \([^ ]*$\)/\1/p')
>> stat_mnt=$(stat -c%m "$file")
>> test "$df_mnt" = "$stat_mnt" || echo "bind mount"
> 
> This is incorrect in two ways.
> 
> First of all, stat(1), even after that commit you quote,
> still compares st_dev fields, which are the same for this
> and parent directory in case of bind mount.  So this version
> of stat(1) does _not_ detect a bind mount, unfortunately.

And this statement, in turn, is untrue.  I apologize for the
misinformation, it wasn't intentional.  The mentioned commit
adds the ability to detect bind mounts indeed.  but...

> Second, I asked for a low-level way to detect such a mount.
> I know how to do it not as efficient as stat(2) and not as
> reliable but much simpler than you propose above, in shell
> or in C, and I already provided that way in my original
> email: we just parse /proc/mounts file, this is faster and
> more reliable than the above shell fragment which calls a
> few external commands.

.. the way used by stat(1) is to enumerate /proc/mounts --
which is what I were able to come with initially.  It is slow
and unreliable.  Hence I asked if a faster way exist.

/mjt
