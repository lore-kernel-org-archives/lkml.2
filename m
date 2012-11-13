Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754809Ab2KMKhv (ORCPT <rfc822;w@1wt.eu>);
	Tue, 13 Nov 2012 05:37:51 -0500
Received: from moutng.kundenserver.de ([212.227.17.8]:60465 "EHLO
	moutng.kundenserver.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753421Ab2KMKht (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 13 Nov 2012 05:37:49 -0500
From: Arnd Bergmann <arnd@arndb.de>
To: "Gilad Ben-Yossef" <gilad@benyossef.com>
Subject: Re: [RFC PATCH v1 14/31] ARC: syscall support
Date: Tue, 13 Nov 2012 10:37:43 +0000
User-Agent: KMail/1.12.2 (Linux/3.5.0; KDE/4.3.2; x86_64; ; )
Cc: Vineet Gupta <Vineet.Gupta1@synopsys.com>, linux-arch@vger.kernel.org,
        linux-kernel@vger.kernel.org, tglx@linutronix.de
References: <1352281674-2186-1-git-send-email-vgupta@synopsys.com> <201211071421.39523.arnd@arndb.de> <CAOtvUMcc-7mBxYWEe7oypri7wxf58R8cph7EpdLYR_fLHO6eTg@mail.gmail.com>
In-Reply-To: <CAOtvUMcc-7mBxYWEe7oypri7wxf58R8cph7EpdLYR_fLHO6eTg@mail.gmail.com>
MIME-Version: 1.0
Content-Type: Text/Plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Message-Id: <201211131037.43526.arnd@arndb.de>
X-Provags-ID: V02:K0:PPHLNH9vl3o8haSc/3zh7OvtkXP2Wuqpv8rneqSVN2c
 Zx108aYXH0LLB3DkNNlLWoeGo1veCjAsElNYflSfTYkxFRNKOL
 HIum3MjMduOeZRAh3eLI3SVT/iidueOqGaZm5gZdN4ZOWW68NG
 aqr7oa2qjpdSEdlGTvdTNtH/XXm6IbNPG73cdmrR4HGvlQOUdE
 4VAFswH5ti1Iji9iIB/mrHHh8qEGDvv/EIECmVTAS7T40w5kqM
 +PclT4hlZxRdFgIBnKFiwF9W0c8faipOH1nFVaVu3ENYyLLj5M
 3OEyNzt0aCXvMfyYuw8i66CXpeDUZ2qBlczUJktMh0z/D99fDa
 Gz+9AyQLyGCUnQat3DRI=
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tuesday 13 November 2012, Gilad Ben-Yossef wrote:
> So, I completely agree about not adding more deprecated system call or
> ABIs (thinking about the ptrace regset issues in another patch in the
> same patchset), but on the other hand I have to wonder if having a
> port in the tree that doesn't have a working C library or a debugger
> makes sense.
> 
> I mean, it is not quite the same thing as saying: "well, users of the
> old versions of the user tools will need to maintain out of tree
> patches". That makes sense - it puts the burden of maintenance on
> people clinging to new versions when newer one exists, but this is not
> what is happening with Arc. Right now, there are no working version of
> the tools for Arc, so everyone will need to use the out of tree
> patches.
> 
> I wonder what is worse - having an in tree port that no one (can) use
> or adding some deprecated crap (sorry...), clearly marked for deletion
> the minute a version of the relevant user tools exists that can be
> used with the new mechanisms?

The point is that all existing users already need to rebuild all their
user space since the upstream version is using the generic system call
numbers. What I want to avoid is breaking everything twice, and the most
logical point to do that is when moving from an out-of-tree kernel fork
to the mainline version.

If mainline doesn't work for you yet, the most logical choice is to
stay on whatever kernel you have working right now, and only change
over to the upstream version once it works with an ABI that we want
to maintain in the long term. Obviously I can't stop from using a
mix of the two while you are waiting for (or working on) getting
gdb and uclibc supported with the new interface, but my recommendation
is not to ship that in products to end-users that would suffer
from another ABI change later on. 

What I'm trying to enforce here is that the upstream version follows
the exact same rules that we apply to all other ports, which is
that we don't break existing user space that was running with an
older upstream kernel.

	Arnd
