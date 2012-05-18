Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S966589Ab2ERDhT (ORCPT <rfc822;w@1wt.eu>);
	Thu, 17 May 2012 23:37:19 -0400
Received: from mail-ob0-f174.google.com ([209.85.214.174]:51380 "EHLO
	mail-ob0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751795Ab2ERDhQ convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 17 May 2012 23:37:16 -0400
MIME-Version: 1.0
In-Reply-To: <CAFeW=pZcqnybTeMQPEMUguAwwgqpM1Hap2Dh3K-5majfYqMTaA@mail.gmail.com>
References: <CAFeW=pZcqnybTeMQPEMUguAwwgqpM1Hap2Dh3K-5majfYqMTaA@mail.gmail.com>
Date: Fri, 18 May 2012 11:37:15 +0800
Message-ID: <CAFeW=pZ-HZKyBALRZVo=PeWUoaEk39QUSoMsV-1K5CBgcVUMeA@mail.gmail.com>
Subject: Re: cgroup: denying device doesn't work with 'rw' mode string
From: Amos Kong <kongjianjun@gmail.com>
To: serue@us.ibm.com, viro@zeniv.linux.org.uk
Cc: linux-kernel@vger.kernel.org, lizf@cn.fujitsu.com, tj@kernel.org,
        jmorris@namei.org
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

CC: Li Zefan <lizf@cn.fujitsu.com>, Tejun Heo <tj@kernel.org>, jmorris@namei.org

On Sat, Oct 15, 2011 at 8:39 AM, Amos Kong <kongjianjun@gmail.com> wrote:
> # mount -t cgroup -o devices none /cgroup
> # mkdir /cgroups/devices
> # ls -l /dev/vg/lv
> lrwxrwxrwx. 1 root root 7 Oct 14 19:03 /dev/vg/lv -> ../dm-3
> # ls -l /dev/dm-3
> brw-rw----. 1 root disk 253, 3 Oct 14 19:03 /dev/dm-3
>
>
> ------- test1
> deny read-write permission of dm-3, but it doesn't effect.
>
> # echo a > devices/devices.allow
> # echo 'b 253:2 rw' > devices.deny
>                ^^
> # echo $$ > task
> # dd if=/dev/zero of=/dev/dm-3 bs=1M count=1
> can write to /dev/dm-3 successfully  (problem exists)
>
> ------- test2
> # echo a > devices/devices.allow
> # echo 'b 253:3 rwm' > devices/devices.deny
>                ^^^
> # echo $$ > task
> # dd if=/dev/zero of=/dev/dm-3 bs=1M count=1
> couldn't write to /dev/dm-3 successfully
>
> -----------
>
> related upstream commit:
> commit 08ce5f16ee466ffc5bf243800deeecd77d9eaf50
> Author: Serge E. Hallyn <serue@us.ibm.com>
> Date:   Tue Apr 29 01:00:10 2008 -0700
>
>    cgroups: implement device whitelist
>
>
> cgroup tracks and enforces open and mknod restrictions on device files,
> so 'm' are always needed in the mode string? 'rw' is ineffective?
