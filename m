Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757275Ab2KHXUf (ORCPT <rfc822;w@1wt.eu>);
	Thu, 8 Nov 2012 18:20:35 -0500
Received: from mx1.redhat.com ([209.132.183.28]:63547 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751425Ab2KHXUd (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 8 Nov 2012 18:20:33 -0500
Organization: Red Hat UK Ltd. Registered Address: Red Hat UK Ltd, Amberley
	Place, 107-111 Peascod Street, Windsor, Berkshire, SI4 1TE, United
	Kingdom.
	Registered in England and Wales under Company Registration No. 3798903
From: David Howells <dhowells@redhat.com>
In-Reply-To: <C2D7FE5348E1B147BCA15975FBA230750D9832@in01wembx1.internal.synopsys.com>
References: <C2D7FE5348E1B147BCA15975FBA230750D9832@in01wembx1.internal.synopsys.com> <509251CA.8050008@synopsys.com> <18137.1349203013@warthog.procyon.org.uk> <CAAG0J9_gYLn5+4j9WUnPmxWyJfQK_b8e5xjxZdRPG21euXoCFg@mail.gmail.com> <CAAG0J9_LZ5Q1fNdcbSOyieesabkqcTMT0ueEDLXmemV2C_+F=g@mail.gmail.com>,<8419.1352387261@warthog.procyon.org.uk>
To: Vineet Gupta <Vineet.Gupta1@synopsys.com>
Cc: dhowells@redhat.com, James Hogan <james@albanarts.com>,
        "torvalds@osdl.org" <torvalds@osdl.org>,
        "arnd@arndb.de" <arnd@arndb.de>, "hpa@zytor.com" <hpa@zytor.com>,
        "alan@lxorguk.ukuu.org.uk" <alan@lxorguk.ukuu.org.uk>,
        "fengguang.wu@intel.com" <fengguang.wu@intel.com>,
        "linux-arch@vger.kernel.org" <linux-arch@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "arc-linux-dev@synopsys.com" <arc-linux-dev@synopsys.com>
Subject: Re: UAPI for new arches (was Re: [GIT PULL] User API Disintegrate: Preparatory patches)
Date: Thu, 08 Nov 2012 23:19:48 +0000
Message-ID: <14356.1352416788@warthog.procyon.org.uk>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Vineet Gupta <Vineet.Gupta1@synopsys.com> wrote:

> While I'd done some of the prep work in my code such as splitting __KERNEL__
> && __ASSEMBLY__ into two separate lines, majority of orig headers didn't
> have #ifdef __KERNEL__ guard despite the code not being meant for user-space
> ABI. Is that fundamental to UAPI split scripting

Yes.  My scripts work purely along __KERNEL__ lines.  If there are no
__KERNEL__ markers and the header is marked for export, it is simply moved.

> because it seems to be causing setup.h to be in uapi despite seemingly being
> kernel internal only.

Check also include/uapi/asm-generic/Kbuild.asm.  That exports setup.h, whether
you think it should be exported or not.

Vineet Gupta <Vineet.Gupta1@synopsys.com> wrote:

> Per you email from last week, When I ran the disintergrate-one.pl script
> myself I saw a whole bunch of empty UAPI files being generated with
> references in orig header.  I'm not sure what I'm doing wrong.

Can you give an example of such a header?

> For any ABI changes to headers per review of the new port on list
> (e.g. don't export pt_regs) would mean moving the code manually from uapi to
> orig header - right. And if the file becomes empty just nuke it completely.

You can't necessarily remove a UAPI header completely.  Userspace may depend
on its existence, even if it gets no content from there.

> How do you reckon we go about fixing these. I don't want to bother you
> multiple times hence it would be best if I could reproduce this at my end.

The best advice I can give you without more specific examples is to compare
what's in your arch's headers to those of, say, hexagon or arm64.  Those are
recent additions and should be pretty clean as to what they contain.

David
