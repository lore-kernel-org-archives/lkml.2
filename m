Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754032Ab1ASX6W (ORCPT <rfc822;w@1wt.eu>);
	Wed, 19 Jan 2011 18:58:22 -0500
Received: from mail-ww0-f44.google.com ([74.125.82.44]:47680 "EHLO
	mail-ww0-f44.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753317Ab1ASX6V convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 19 Jan 2011 18:58:21 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=mime-version:in-reply-to:references:date:message-id:subject:from:to
         :cc:content-type:content-transfer-encoding;
        b=Zt+U7ouvGFlWLIqNhrP7bPj2ylRB7p8SM1YoGLbIog/a0w+w4Xe/hzk758mTnzLBe9
         8ntzvoaGSEAz6RARue7EaV7yWqLgY8+EnrpnABgCNbSNc6amKmOR8l5K1irHaSaLD5IE
         qUcSwZ9a0VdrauyC/R33JegIVbJjFjkSfwKJ8=
MIME-Version: 1.0
In-Reply-To: <201101181719.05608.maciej.rutecki@gmail.com>
References: <a7a9bdaa5936630925fb7ffd1a1795b1@mail.gmail.com>
	<201101181719.05608.maciej.rutecki@gmail.com>
Date: Thu, 20 Jan 2011 10:58:19 +1100
Message-ID: <AANLkTi=o_FhhzpAiEdQymXUV-SAek-uy86Q-cB1-POG9@mail.gmail.com>
Subject: Re: [REPORT] BUG: spinlock recursion on CPU#0, init/1
From: Nick Piggin <npiggin@gmail.com>
To: maciej.rutecki@gmail.com
Cc: Santosh Shilimkar <santosh.shilimkar@ti.com>, linux-kernel@vger.kernel.org
Content-Type: text/plain; charset=ISO-8859-2
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Yeah this should be fixed as of about a week ago, sorry for
not replying earlier.

Thanks for reporting and please let us know if you have any
further problems.

On Wed, Jan 19, 2011 at 3:19 AM, Maciej Rutecki
<maciej.rutecki@gmail.com> wrote:
> I created a Bugzilla entry at
> https://bugzilla.kernel.org/show_bug.cgi?id=27022
> for your bug report, please add your address to the CC list in there, thanks!
>
> On poniedzia³ek, 10 stycznia 2011 o 16:21:59 Santosh Shilimkar wrote:
>> On latest mainline commit I seeing a regression when rootfs
>> is mounted on NFS. Not sure if it's already known regression.
>>
>> Anybody is aware of this one ?
>>
>> --------------------------------------
>> Uncompressing Linux... done, booting the kernel.
>> Linux version 2.6.37-03766-g0390214 (a0393909@a0393909-desktop) (gcc
>> version 4.4.1 (Sourcery G++ Lite 2010q1-202) ) #44 SMP Mon Jan 10 20:41:27
>> IST 2011
>>
>> [....]
>>
>> VFS: Mounted root (nfs filesystem) on device 0:13.
>> Freeing init memory: 296K
>> BUG: spinlock recursion on CPU#0, init/1
>>  lock: ef5a1e0c, .magic: dead4ead, .owner: init/1, .owner_cpu: 0
>> [<c0063290>] (unwind_backtrace+0x0/0xe4) from [<c024ce90>]
>> (do_raw_spin_lock+0x48/0x158)
>> [<c024ce90>] (do_raw_spin_lock+0x48/0x158) from [<c012f4e0>]
>> (nameidata_dentry_drop_rcu+0x84/0x17c)
>> [<c012f4e0>] (nameidata_dentry_drop_rcu+0x84/0x17c) from [<c012f608>]
