Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755197Ab0KFAdK (ORCPT <rfc822;w@1wt.eu>);
	Fri, 5 Nov 2010 20:33:10 -0400
Received: from mail1.slb.deg.dub.stisp.net ([84.203.253.98]:9091 "HELO
	mail1.slb.deg.dub.stisp.net" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with SMTP id S1753529Ab0KFAdI (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 5 Nov 2010 20:33:08 -0400
Message-ID: <4CD4A231.1010000@draigBrady.com>
Date: Sat, 06 Nov 2010 00:32:49 +0000
From: =?ISO-8859-1?Q?P=E1draig_Brady?= <P@draigBrady.com>
User-Agent: Mozilla/5.0 (X11; U; Linux i686; en-US; rv:1.9.1.8) Gecko/20100227 Thunderbird/3.0.3
MIME-Version: 1.0
To: Michael Tokarev <mjt@tls.msk.ru>
CC: Linux-kernel <linux-kernel@vger.kernel.org>
Subject: Re: Detecting bind-mounts
References: <4CD31B6A.7040902@msgid.tls.msk.ru> <4CD3DB5D.5040808@draigBrady.com> <4CD44D60.5050105@msgid.tls.msk.ru> <4CD46953.1010902@msgid.tls.msk.ru>
In-Reply-To: <4CD46953.1010902@msgid.tls.msk.ru>
X-Enigmail-Version: 1.0.1
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 05/11/10 20:30, Michael Tokarev wrote:
> 05.11.2010 21:30, Michael Tokarev wrote:
>> 05.11.2010 13:24, Pádraig Brady wrote:
>>> On 04/11/10 20:45, Michael Tokarev wrote:
>> []
>>>> There are 2 (mostly) different kinds of applications.  One
>>>> is cp/tar/find with --same-filesystem option (or equivalent),
>>>> that should not cross mountpoints.  And one more, apps like
>>>> mountpoint(1) from sysvinit - a utility to determine if a
>>>> given path is a mountpoint.
>>>>
>>>> Neither of the two work when two directores on the same
>>>> filesystem are bind-mounted.
>> []
>>> The `stat` command recently got support for
>>> printing the mount point for a file:
>>> http://git.savannah.gnu.org/gitweb/?p=coreutils.git;a=commit;h=ddf6fb86
>>>
>>> `stat` will output the alias for a bind mounted file
>>> while `df` will output the initial mount point of its backing device
>>> So you could do something like:
>>>
>>> file=.
>>> df_mnt=$(df -P "$file" | sed -n '2s/.* \([^ ]*$\)/\1/p')
>>> stat_mnt=$(stat -c%m "$file")
>>> test "$df_mnt" = "$stat_mnt" || echo "bind mount"
>>
>> This is incorrect in two ways.
>>
>> First of all, stat(1), even after that commit you quote,
>> still compares st_dev fields, which are the same for this
>> and parent directory in case of bind mount.  So this version
>> of stat(1) does _not_ detect a bind mount, unfortunately.
> 
> And this statement, in turn, is untrue.  I apologize for the
> misinformation, it wasn't intentional.  The mentioned commit
> adds the ability to detect bind mounts indeed.  but...
> 
>> Second, I asked for a low-level way to detect such a mount.
>> I know how to do it not as efficient as stat(2) and not as
>> reliable but much simpler than you propose above, in shell
>> or in C, and I already provided that way in my original
>> email: we just parse /proc/mounts file, this is faster and
>> more reliable than the above shell fragment which calls a
>> few external commands.
> 
> .. the way used by stat(1) is to enumerate /proc/mounts --
> which is what I were able to come with initially.  It is slow
> and unreliable.  Hence I asked if a faster way exist.

Sorry I was unclear.

I was just providing reference info about the changes in
the new `stat -c %m` that both showed tools do now exist
to determine if a file/dir is a mount point, and to
validate your "slow way" of detecting (bind) mounts.

As for a fast way, I don't think one exists.
BTW I'm not sure your examples are actually valid.
If a file/dir is bind mounted to the same file system, then
`find -xdev` should be listing it (as it has the same dev).

You want a separate option --same-mount or something,
though I don't know what it would be useful for.

cheers,
Pádraig.
