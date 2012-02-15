Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755991Ab2BOWYT (ORCPT <rfc822;w@1wt.eu>);
	Wed, 15 Feb 2012 17:24:19 -0500
Received: from moutng.kundenserver.de ([212.227.126.186]:56820 "EHLO
	moutng.kundenserver.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751388Ab2BOWYR (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 15 Feb 2012 17:24:17 -0500
From: Arnd Bergmann <arnd@arndb.de>
To: qemu-devel@nongnu.org
Subject: Re: [Qemu-devel] [RFC] Next gen kvm api
Date: Wed, 15 Feb 2012 22:21:35 +0000
User-Agent: KMail/1.12.2 (Linux/3.3.0-rc1; KDE/4.3.2; x86_64; ; )
Cc: Alexander Graf <agraf@suse.de>, michael@ellerman.id.au,
        KVM list <kvm@vger.kernel.org>,
        "linux-kernel" <linux-kernel@vger.kernel.org>,
        Eric Northup <digitaleric@google.com>,
        Scott Wood <scottwood@freescale.com>, Avi Kivity <avi@redhat.com>
References: <4F2AB552.2070909@redhat.com> <1328597934.6802.6.camel@concordia> <F1B17875-23E2-4965-BE05-6A3858995D21@suse.de>
In-Reply-To: <F1B17875-23E2-4965-BE05-6A3858995D21@suse.de>
MIME-Version: 1.0
Content-Type: Text/Plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Message-Id: <201202152221.36154.arnd@arndb.de>
X-Provags-ID: V02:K0:4FI4kEZ7pXvrEDec1Z/VAzYC5thy2yjrFqXZQz3tHIU
 ivmMdsnf3evi6hDl8ZKQRVY6ZnvNiVWuF7+rULUU1clICfX+ja
 y7kUsH62fQcfArAZULjCsRGYlsUbsqJ9786918mNOtOS9v5j61
 OYb42xcz77sKuk66u0x7zqONTF2IViRjqJwLCciEutt2jnjTiJ
 t5o2schd0/cbr5wGsul01X3XlsB96c4JB5tn4y4lDD8Az5J+yw
 GhL8Pd7ddfgThL7jTsZKDCDX1pvM1fMXDOHXRatOrJNtmcDzJ+
 MCipY9fiGjDN0VrLBzQl8S8rdE8tj/YeW5nVAPobsf7qs8t2fO
 fudL5FB8BiwI7m7dJxkQ=
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tuesday 07 February 2012, Alexander Graf wrote:
> On 07.02.2012, at 07:58, Michael Ellerman wrote:
> 
> > On Mon, 2012-02-06 at 13:46 -0600, Scott Wood wrote:
> >> You're exposing a large, complex kernel subsystem that does very
> >> low-level things with the hardware.  It's a potential source of exploits
> >> (from bugs in KVM or in hardware).  I can see people wanting to be
> >> selective with access because of that.
> > 
> > Exactly.
> > 
> > In a perfect world I'd agree with Anthony, but in reality I think
> > sysadmins are quite happy that they can prevent some users from using
> > KVM.
> > 
> > You could presumably achieve something similar with capabilities or
> > whatever, but a node in /dev is much simpler.
> 
> Well, you could still keep the /dev/kvm node and then have syscalls operate on the fd.
> 
> But again, I don't see the problem with the ioctl interface. It's nice, extensible and works great for us.
> 

ioctl is good for hardware devices and stuff that you want to enumerate
and/or control permissions on. For something like KVM that is really a
core kernel service, a syscall makes much more sense.

I would certainly never mix the two concepts: If you use a chardev to get
a file descriptor, use ioctl to do operations on it, and if you use a 
syscall to get the file descriptor then use other syscalls to do operations
on it.

I don't really have a good recommendation whether or not to change from an
ioctl based interface to syscall for KVM now. On the one hand I believe it
would be significantly cleaner, on the other hand we cannot remove the
chardev interface any more since there are many existing users.

	Arnd
