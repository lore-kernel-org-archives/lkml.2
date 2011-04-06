Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755510Ab1DFKOM (ORCPT <rfc822;w@1wt.eu>);
	Wed, 6 Apr 2011 06:14:12 -0400
Received: from dspnet.fr ([188.165.44.67]:32145 "EHLO dspnet.fr"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755101Ab1DFKOL (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 6 Apr 2011 06:14:11 -0400
Date: Wed, 6 Apr 2011 12:14:05 +0200
From: Olivier Galibert <galibert@pobox.com>
To: Ingo Molnar <mingo@elte.hu>
Cc: Avi Kivity <avi@redhat.com>, Anthony Liguori <anthony@codemonkey.ws>,
        Pekka Enberg <penberg@kernel.org>, linux-kernel@vger.kernel.org,
        aarcange@redhat.com, mtosatti@redhat.com, kvm@vger.kernel.org,
        joro@8bytes.org, penberg@cs.helsinki.fi, asias.hejun@gmail.com,
        gorcunov@gmail.com
Subject: Re: [ANNOUNCE] Native Linux KVM tool
Message-ID: <20110406101405.GA65838@dspnet.fr>
References: <1301592656.586.15.camel@jaguar>
 <4D982E89.8070502@redhat.com>
 <BANLkTinbCAUqaKfmKaj-7GXTh9F2if0x+Q@mail.gmail.com>
 <4D9847BC.9060906@redhat.com>
 <4D98716D.9040307@codemonkey.ws>
 <4D9873CD.3080207@redhat.com>
 <20110406093333.GB6465@elte.hu>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20110406093333.GB6465@elte.hu>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Apr 06, 2011 at 11:33:33AM +0200, Ingo Molnar wrote:
> Examples: X11 and GCC - both were struggling for years to break through magic 
> invisible barriers of growth and IMHO a lot of it had to do with the lack of 
> code (and development model) cleanliness.

A large part of what's killing X11 and qemu is the decomposition in
multiple trees and the requirement that every version must work with
every other version.

For X11 you have:
- the server
- the protocol headers
- the individual 2D drivers
- libdrm
- the kernel
- mesa
- the video decoding driver/libs

For qemu you have:
- qemu
- qemu-kvm
- the kernel
- libvirt
- seabios

Any reaching change ends up hitting most of the trees, with all to
coordination that means.  And in any case you're supposed to handle
any version of the other components.

Virtualbox works in part because they provide everything, from the
dhcp server to the kernel modules.  The NVidia closed-source drivers
works in part because they provide everything, from the glx interface
to the kernel modules.  And both of them refuse to start if everything
is not in lockstep.  Meanwhile the open source idealists are a way
smaller number and expect to support every combination of everything
with everything as long as it appeared one day in a release, no matter
how buggy or badly designed it was.

So less people, additional hurdles that experience has shown not to be
a necessity (people cope with lockstep updates, vbox and nvidia prove
it), and one wonders why the "open" solutions end up way inferior?

  OG.

