Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753467Ab2A1Vc2 (ORCPT <rfc822;w@1wt.eu>);
	Sat, 28 Jan 2012 16:32:28 -0500
Received: from mail-iy0-f174.google.com ([209.85.210.174]:58397 "EHLO
	mail-iy0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752722Ab2A1Vc0 convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 28 Jan 2012 16:32:26 -0500
MIME-Version: 1.0
In-Reply-To: <m139azpn2n.fsf@fess.ebiederm.org>
References: <20120124000517.GA28878@sergelap> <CA+55aFz9ofF+Ey8VCDS8UEf2XSw36kj2RhkHfFScuzLXMeNrkA@mail.gmail.com>
 <20120124002555.GA29534@sergelap> <CA+55aFzwOU137V6wtyBjessx05NJo2G4KV0rvTKWvC79A+o9iQ@mail.gmail.com>
 <20120124010758.GJ23916@ZenIV.linux.org.uk> <m1k44gj1cu.fsf@fess.ebiederm.org>
 <20120124220247.GA26353@hallyn.com> <CAPXgP13_gczQmG_USAp0p2AuTfxkzAvzHvjbZY_rbbLH-4rDyg@mail.gmail.com>
 <20120124231601.GA4470@sergelap> <CAPXgP12REAwmDORzdGJhsxZKU8nhiauCxoVdKa8Eifw4MWWtgA@mail.gmail.com>
 <20120128195103.GA11299@sergelap> <m139azpn2n.fsf@fess.ebiederm.org>
From: Kay Sievers <kay.sievers@vrfy.org>
Date: Sat, 28 Jan 2012 22:32:06 +0100
Message-ID: <CAPXgP12hk4iQNYGVrcKG1xBEJ2TmCH8jDx-E+1a8Mw8wiWCeDA@mail.gmail.com>
Subject: Re: [RFC] fix devpts mount behavior
To: "Eric W. Biederman" <ebiederm@xmission.com>
Cc: Serge Hallyn <serge.hallyn@canonical.com>,
        "Serge E. Hallyn" <serge@hallyn.com>,
        containers@lists.linux-foundation.org,
        Dave Hansen <haveblue@us.ibm.com>, linux-kernel@vger.kernel.org,
        Andy Whitcroft <apw@canonical.com>, sukadev@linux.vnet.ibm.com,
        Linus Torvalds <torvalds@linux-foundation.org>,
        Al Viro <viro@zeniv.linux.org.uk>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sat, Jan 28, 2012 at 21:52, Eric W. Biederman <ebiederm@xmission.com> wrote:
> Serge Hallyn <serge.hallyn@canonical.com> writes:
>
>> Quoting Kay Sievers (kay.sievers@vrfy.org):
>>> We might also thing about changing /sys/class/tty/ptmx/, and have the
>>> kernel create the symlink? The loops through userspace to setup
>>> default kernel stuff are kind of crazy ...

>> sorry, there is something I'm missing here.  Without a target kobj
>> to link to, how would we go about telling the kernel that /dev/ptmx
>> should be a symlink to /dev/pts/ptmx?  Is there a way to do that?

There is no support for symlinks in the core at the moment. But I
guess we could just add support for it to the driver core and devtmpfs
to create a symlink in /dev instead of a device node.

The ptmx device would need to pass that information along to the
driver core call when creating the ptmx device.

> There is precedent in the /dev/fd symlinks, so I expect you want
> to look and see where the configuration for that comes from.

That's a static list of stuff created at startup. But it's easier to
do in usersace, because /proc is not configurable or optional for
usual use cases, so we can just do it unconditionally in userspace.
They also can not conflict with device nodes.

Kay
