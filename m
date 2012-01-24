Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756315Ab2AXUPt (ORCPT <rfc822;w@1wt.eu>);
	Tue, 24 Jan 2012 15:15:49 -0500
Received: from e36.co.us.ibm.com ([32.97.110.154]:54772 "EHLO
	e36.co.us.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755778Ab2AXUPs (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 24 Jan 2012 15:15:48 -0500
Date: Tue, 24 Jan 2012 12:16:00 -0800
From: Sukadev Bhattiprolu <sukadev@linux.vnet.ibm.com>
To: "Serge E. Hallyn" <serge@hallyn.com>
Cc: Al Viro <viro@ZenIV.linux.org.uk>, containers@lists.linux-foundation.org,
        Dave Hansen <haveblue@us.ibm.com>, linux-kernel@vger.kernel.org,
        Andy Whitcroft <apw@canonical.com>,
        Linus Torvalds <torvalds@linux-foundation.org>
Subject: Re: [RFC] fix devpts mount behavior
Message-ID: <20120124201600.GB20039@us.ibm.com>
References: <20120124000517.GA28878@sergelap>
 <CA+55aFz9ofF+Ey8VCDS8UEf2XSw36kj2RhkHfFScuzLXMeNrkA@mail.gmail.com>
 <20120124002555.GA29534@sergelap>
 <CA+55aFzwOU137V6wtyBjessx05NJo2G4KV0rvTKWvC79A+o9iQ@mail.gmail.com>
 <20120124010758.GJ23916@ZenIV.linux.org.uk>
 <20120124182116.GA11715@hallyn.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20120124182116.GA11715@hallyn.com>
X-Operating-System: Linux 2.0.32 on an i486
User-Agent: Mutt/1.5.20 (2009-06-14)
X-Content-Scanned: Fidelis XPS MAILER
x-cbid: 12012420-3352-0000-0000-000002266C15
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Serge Hallyn [serge@hallyn.com] wrote:
| Quoting Al Viro (viro@ZenIV.linux.org.uk):
| > On Mon, Jan 23, 2012 at 04:41:25PM -0800, Linus Torvalds wrote:
| > 
| > > Right. I think the opportunity for problems should be pretty small.
| > > 
| > > And it's not like the pty itself wouldn't continue to work - it's just
| > > that programs like /usr/bin/tty wouldn't be able to *find* it.
| > > 
| > > Although who knows - maybe there is some other subtle interaction.
| > 
| > FWIW, the subtle and nasty part in all that is  that you can mknod /dev/ptmx
| > and it *will* work, refering to the "initial" instance.  That's what
| > concerns me about the chroot scenarios -
| > 	mknod /jail/dev/ptmx c 5 2
| > 	mkdir /jail/dev/pts
| > 	mount -t devpts /jail/dev/pts
| > 	chroot /jail
| > works fine right now, but with that change behaviour will be all wrong -
| > opening /dev/ptmx inside of jail will grab you a pts, all right, but
| > it will *not* show up in (jail) /dev/pts/* as it does with the current
| > kernel.
| > 
| > Note that if you replace that mknod with symlink pts/ptmx /jail/dev/ptmx
| > the things will keep working.  However, that will _only_ work for kernels
| > with DEVPTS_MULTIPLE_INSTANCES - without it you won't get ptmx inside
| > devpts (which is arguably wrong, BTW)
| 
| Should /dev/pts/ptmx be created for DEVPTS_MULTIPLE_INSTANCES=n?

With DEVPTS_MULTIPLE_INSTANCES=n, there is only _one_ (global) instance
right ? Why would we need a 'pts/ptmx' node ? To keep the symlink (i.e
user space scripts) valid for both single and multiple instance cases ?

Sukadev

