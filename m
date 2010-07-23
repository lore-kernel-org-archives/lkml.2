Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752692Ab0GWHnn (ORCPT <rfc822;w@1wt.eu>);
	Fri, 23 Jul 2010 03:43:43 -0400
Received: from mail-ey0-f174.google.com ([209.85.215.174]:46737 "EHLO
	mail-ey0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751064Ab0GWHnk convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 23 Jul 2010 03:43:40 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=sender:from:to:cc:subject:references:date:in-reply-to:message-id
         :user-agent:mime-version:content-type:content-transfer-encoding;
        b=JEAQRZkPK3LoOXSkCNzCx+AD0M+Qhn3oityZIa3hDKY3vir0nN6u58/1x1TvMVmPpw
         pAN+9ISKV+i0HEzDakChKRAjznps2ZbgygDFd5n2+hdxZnlNfwZedLh7BbLXmf5IzSRV
         gI9hDoedWRYNidZmKwsROADJkjtyqyOwiSpx0=
From: Dmitry Monakhov <dmonakhov@openvz.org>
To: Drunkard Zhang <gongfan193@gmail.com>
Cc: "Ted Ts'o" <tytso@mit.edu>, linux-kernel@vger.kernel.org, devel@openvz.org,
        Andreas Dilger <adilger@sun.com>, linux-ext4@vger.kernel.org
Subject: Re: openvz: Oops in ext4 when VPS starts
References: <AANLkTilaycSLL2dDnXDVs1gCiD0B8K78i2rBdWJGZrRD@mail.gmail.com>
	<20100722150145.GE14882@thunk.org>
	<AANLkTinISdrdpYfgVzTAhgQmdJculdOJ5qNPdvNCBPjE@mail.gmail.com>
Date: Fri, 23 Jul 2010 11:43:32 +0400
In-Reply-To: <AANLkTinISdrdpYfgVzTAhgQmdJculdOJ5qNPdvNCBPjE@mail.gmail.com>
	(Drunkard Zhang's message of "Fri, 23 Jul 2010 10:22:08 +0800")
Message-ID: <87tynqfxsr.fsf@dmon-lap.sw.ru>
User-Agent: Gnus/5.13 (Gnus v5.13) Emacs/23.1 (gnu/linux)
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Drunkard Zhang <gongfan193@gmail.com> writes:

> 2010/7/22 Ted Ts'o <tytso@mit.edu>:
>> On Thu, Jul 22, 2010 at 05:39:16PM +0800, Drunkard Zhang wrote:
>>> I run into a oops when mirgate /vz directory to ext4 lvm under gentoo + openvz.
>>
>> What were you doing precisely at the time of the oops?  The oops logs
>> indicates it was a cp, but a cp of what?  And is this somethign you
>> can easily reproduce?
>>
Wow. Sorry almost missed that thread.
2.6.32-openvz-budarin.1 does not contains any specific patches for ext4.
So it is probably memory corruption caused by ovz stuff (2.6.32  is still
experimental), or you caught unknown bug, the later it very unlikely because
"cp" is very popular cmd :)
I'll try to reproduce your issue.

> I did: "/etc/init.d/vz start" with vpsid 101 and 109, which from:
> http://bb.xnull.de/projects/gentoo/amd64/stage4-amd64-current.tar.bz2
> following the guide from:
> http://www.gentoo.org/proj/en/vps/openvz-howto.xml
>
> Didn't change the content of stage4-amd64-current.tar.bz2 yet.
> It looks like when "/etc/init.d/vz start", it will cp all files from
> /vz/private/101/ to /vz/root/root/101/
That's not true, root/$veid is just stacked filesystem on top
of private/$veid.
>
> The oops allways reproduced yesterday between reboot and kernel
> remake, but this morning when I trying to finger out the oops point
> using strace, I can't get the oops anymore. Sorry for interrupt,:-(
>
> Maybe distcc caused problem? I used to make kernel... Sorry again.

> --
> To unsubscribe from this list: send the line "unsubscribe linux-ext4" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html

