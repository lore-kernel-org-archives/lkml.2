Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755386Ab1KWNIT (ORCPT <rfc822;w@1wt.eu>);
	Wed, 23 Nov 2011 08:08:19 -0500
Received: from mail-bw0-f46.google.com ([209.85.214.46]:41053 "EHLO
	mail-bw0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755112Ab1KWNIS (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 23 Nov 2011 08:08:18 -0500
Subject: Re: [PATCH v3 2/3] hvc_init(): Enforce one-time initialization.
From: Sasha Levin <levinsasha928@gmail.com>
To: Amit Shah <amit.shah@redhat.com>
Cc: Miche Baker-Harvey <miche@google.com>,
        Rusty Russell <rusty@rustcorp.com.au>,
        Greg Kroah-Hartman <gregkh@suse.de>,
        Stephen Rothwell <sfr@canb.auug.org.au>, xen-devel@lists.xensource.com,
        Konrad Rzeszutek Wilk <konrad.wilk@oracle.com>,
        Benjamin Herrenschmidt <benh@kernel.crashing.org>,
        linux-kernel@vger.kernel.org,
        virtualization@lists.linux-foundation.org,
        Anton Blanchard <anton@samba.org>, Mike Waychison <mikew@google.com>,
        ppc-dev <linuxppc-dev@lists.ozlabs.org>,
        Eric Northrup <digitaleric@google.com>
In-Reply-To: <20111123125657.GH16665@amit-x200.redhat.com>
References: <20111108214452.28884.14840.stgit@miche.sea.corp.google.com>
	 <20111108214504.28884.61814.stgit@miche.sea.corp.google.com>
	 <874nybqo0o.fsf@rustcorp.com.au>
	 <CAB8RdapbaueyWLJuJDE_ZdvLkRNM4sQHTxgmgO=jrnXZ6YPSmA@mail.gmail.com>
	 <20111123103852.GG16665@amit-x200.redhat.com>
	 <20111123125657.GH16665@amit-x200.redhat.com>
Content-Type: text/plain; charset="us-ascii"
Date: Wed, 23 Nov 2011 15:06:04 +0200
Message-ID: <1322053564.3581.19.camel@lappy>
Mime-Version: 1.0
X-Mailer: Evolution 2.32.3 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 2011-11-23 at 18:26 +0530, Amit Shah wrote:
> On (Wed) 23 Nov 2011 [16:08:52], Amit Shah wrote:
> > With this setup, with and without patches, I can spawn two consoles
> > via:
> > 
> > /sbin/agetty /dev/hvc0 9600 vt100
> > /sbin/agetty /dev/hvc1 9600 vt100
> > 
> > (Strange thing is, the second one gives a 'password incorrect' error
> > on login attempts, while the first one logs in fine.  I do remember
> > testing multiple consoles just fine a year and a half back, so no idea
> > why this isn't behaving as expected -- but it mostly looks like a
> > userspace issue rather than kernel one.)
> 
> Right -- when I test this on the Fedora 11 VM I used back then, the
> two consoles work just fine without these patches.  When I use
> something newer (F14), I get the weird password rejection, with and
> without your patches.

It's not a weird password rejection, it's probably not set as a secure
terminal :)

Try adding hvc1 to /etc/securetty on the guest.

-- 

Sasha.

