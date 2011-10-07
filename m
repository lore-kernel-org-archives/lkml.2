Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S965355Ab1JGK3J (ORCPT <rfc822;w@1wt.eu>);
	Fri, 7 Oct 2011 06:29:09 -0400
Received: from mail-vw0-f46.google.com ([209.85.212.46]:36804 "EHLO
	mail-vw0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1759778Ab1JGK3H convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 7 Oct 2011 06:29:07 -0400
MIME-Version: 1.0
In-Reply-To: <20111007111231.6e11d18e@lxorguk.ukuu.org.uk>
References: <1317943022.1095.25.camel@mop> <20111007111231.6e11d18e@lxorguk.ukuu.org.uk>
From: Kay Sievers <kay.sievers@vrfy.org>
Date: Fri, 7 Oct 2011 12:28:46 +0200
Message-ID: <CAPXgP12nDB2NX6hZabmkUZA9n0PZadi6Yv70LNms8fz9+MnVoA@mail.gmail.com>
Subject: =?UTF-8?Q?Re=3A_A_Plumber=E2=80=99s_Wish_List_for_Linux?=
To: Alan Cox <alan@lxorguk.ukuu.org.uk>
Cc: linux-kernel@vger.kernel.org, lennart@poettering.net, harald@redhat.com,
        david@fubar.dk, greg@kroah.com
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Oct 7, 2011 at 12:12, Alan Cox <alan@lxorguk.ukuu.org.uk> wrote:
>> * (ioctl based?) interface to query and modify the label of a mounted
>> FAT volume:
>
> Seems sensible - or it could go in sysfs ?

That would mean to export superblocks in /sys, which isn't namespaced,
and which might create issues by making information globally available
which probably shouldn't?

>> A FAT labels is implemented as a hidden directory entry in the file
>> system which need to be renamed when changing the file system label,
>
> That would be ugly - it works for FAT as you can create an imaginary name
> which is not possible on the fs, but that isn't true for say ext4. Sysfs
> sounds the logic way, it means adding chunks of code to various file
> systems.

What do you mean would be ugly?

>> * expose CAP_LAST_CAP somehow in the running kernel at runtime:
>> Userspace needs to know the highest valid capability of the running
>> kernel, which right now cannot reliably be retrieved from header files
>> only. The fact that this value cannot be detected properly right now
>> creates various problems for libraries compiled on newer header files
>> which are run on older kernels. They assume capabilities are available
>> which actually aren’t. Specifically, libcap-ng claims that all running
>> processes retain the higher capabilities in this case due to the
>> “inverted” semantics of CapBnd in /proc/$PID/status.
>
> You can probably deduce this by poking around but to me it seems like a
> very sensible idea.
>
>> * allow changing argv[] of a process without mucking with environ[]:
>> Something like setproctitle() or a prctl() would be ideal. Of course it
>> is questionable if services like sendmail make use of this, but otoh for
>> services which fork but do not immediately exec() another binary being
>> able to rename this child processes in ps is of importance.
>
> Yes, its a real valuable tool for r00tkits, worms and general purpose
> deception.

They can do that already today.  The code to do that just looks really
ugly. So the r00tkits could have nicer looking code. :)

Thanks,
Kay
