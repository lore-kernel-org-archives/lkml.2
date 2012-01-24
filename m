Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752662Ab2AXWzE (ORCPT <rfc822;w@1wt.eu>);
	Tue, 24 Jan 2012 17:55:04 -0500
Received: from mail-iy0-f174.google.com ([209.85.210.174]:64537 "EHLO
	mail-iy0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751292Ab2AXWzB convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 24 Jan 2012 17:55:01 -0500
MIME-Version: 1.0
In-Reply-To: <20120124220247.GA26353@hallyn.com>
References: <20120124000517.GA28878@sergelap> <CA+55aFz9ofF+Ey8VCDS8UEf2XSw36kj2RhkHfFScuzLXMeNrkA@mail.gmail.com>
 <20120124002555.GA29534@sergelap> <CA+55aFzwOU137V6wtyBjessx05NJo2G4KV0rvTKWvC79A+o9iQ@mail.gmail.com>
 <20120124010758.GJ23916@ZenIV.linux.org.uk> <m1k44gj1cu.fsf@fess.ebiederm.org>
 <20120124220247.GA26353@hallyn.com>
From: Kay Sievers <kay.sievers@vrfy.org>
Date: Tue, 24 Jan 2012 23:54:38 +0100
Message-ID: <CAPXgP13_gczQmG_USAp0p2AuTfxkzAvzHvjbZY_rbbLH-4rDyg@mail.gmail.com>
Subject: Re: [RFC] fix devpts mount behavior
To: "Serge E. Hallyn" <serge@hallyn.com>
Cc: "Eric W. Biederman" <ebiederm@xmission.com>,
        Al Viro <viro@zeniv.linux.org.uk>,
        containers@lists.linux-foundation.org,
        Dave Hansen <haveblue@us.ibm.com>, linux-kernel@vger.kernel.org,
        Andy Whitcroft <apw@canonical.com>, sukadev@linux.vnet.ibm.com,
        Linus Torvalds <torvalds@linux-foundation.org>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Jan 24, 2012 at 23:02, Serge E. Hallyn <serge@hallyn.com> wrote:
> Quoting Eric W. Biederman (ebiederm@xmission.com):

>> It looks like relatively recent udev still creates /dev/ptmx and does
>
> Boy, it does, and it's stubborn about it.  Removing the /lib/udev/rules.d
> entry doesn't stop it.  (this is after I've had an init job replace the
> devtmpfs-created ptmx entry with a symlink)

Udev has nothing to do with that. The kernel creates that device node.
Udev does not carry any rules you could remove, to name device nodes,
it only set permissions and creates symlinks to device nodes.

It will never replace a kernel-created device node with a symlink,
there is no way to express that. If you don't want a device node
there, you need to change the kernel, to not export
/sys/class/tty/ptmx/ the way it is today.

> So current distros (well, Ubuntu and Fedora at least) would need to at least
> (a) fix udev,

To do what?

> (b) change the default devpts mount (done from initramfs) to
> add ptmxmode=666,

> (c) (if not done in udev) create the /dev/ptmx symlink.

Udev can only create symlinks to devices the driver-core creates, not
to devices inside a custom filesystem.

> For safety I'd recommend creating /dev/pts/ptmx with
> DEVPTS_MULTIPLE_INSTANCES=n (or dropping that support), and by default
> setting ptmxmode to 666 as that's what udev does.

The mode for ptmx is set by the kernel itself, and does not even need
udev to do that:
  $ cat /sys/class/tty/ptmx/uevent
  MAJOR=5
  MINOR=2
  DEVNAME=ptmx
  DEVMODE=0666

Kay
