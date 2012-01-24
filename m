Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757323Ab2AXSTh (ORCPT <rfc822;w@1wt.eu>);
	Tue, 24 Jan 2012 13:19:37 -0500
Received: from 50-56-35-84.static.cloud-ips.com ([50.56.35.84]:36216 "EHLO
	mail.hallyn.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752828Ab2AXSTg (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 24 Jan 2012 13:19:36 -0500
Date: Tue, 24 Jan 2012 18:21:16 +0000
From: "Serge E. Hallyn" <serge@hallyn.com>
To: Al Viro <viro@ZenIV.linux.org.uk>
Cc: Linus Torvalds <torvalds@linux-foundation.org>,
        containers@lists.linux-foundation.org,
        Dave Hansen <haveblue@us.ibm.com>, linux-kernel@vger.kernel.org,
        Andy Whitcroft <apw@canonical.com>, sukadev@linux.vnet.ibm.com
Subject: Re: [RFC] fix devpts mount behavior
Message-ID: <20120124182116.GA11715@hallyn.com>
References: <20120124000517.GA28878@sergelap>
 <CA+55aFz9ofF+Ey8VCDS8UEf2XSw36kj2RhkHfFScuzLXMeNrkA@mail.gmail.com>
 <20120124002555.GA29534@sergelap>
 <CA+55aFzwOU137V6wtyBjessx05NJo2G4KV0rvTKWvC79A+o9iQ@mail.gmail.com>
 <20120124010758.GJ23916@ZenIV.linux.org.uk>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20120124010758.GJ23916@ZenIV.linux.org.uk>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Quoting Al Viro (viro@ZenIV.linux.org.uk):
> On Mon, Jan 23, 2012 at 04:41:25PM -0800, Linus Torvalds wrote:
> 
> > Right. I think the opportunity for problems should be pretty small.
> > 
> > And it's not like the pty itself wouldn't continue to work - it's just
> > that programs like /usr/bin/tty wouldn't be able to *find* it.
> > 
> > Although who knows - maybe there is some other subtle interaction.
> 
> FWIW, the subtle and nasty part in all that is  that you can mknod /dev/ptmx
> and it *will* work, refering to the "initial" instance.  That's what
> concerns me about the chroot scenarios -
> 	mknod /jail/dev/ptmx c 5 2
> 	mkdir /jail/dev/pts
> 	mount -t devpts /jail/dev/pts
> 	chroot /jail
> works fine right now, but with that change behaviour will be all wrong -
> opening /dev/ptmx inside of jail will grab you a pts, all right, but
> it will *not* show up in (jail) /dev/pts/* as it does with the current
> kernel.
> 
> Note that if you replace that mknod with symlink pts/ptmx /jail/dev/ptmx
> the things will keep working.  However, that will _only_ work for kernels
> with DEVPTS_MULTIPLE_INSTANCES - without it you won't get ptmx inside
> devpts (which is arguably wrong, BTW)

Should /dev/pts/ptmx be created for DEVPTS_MULTIPLE_INSTANCES=n?

-serge
