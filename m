Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1422911Ab2JaOuj (ORCPT <rfc822;w@1wt.eu>);
	Wed, 31 Oct 2012 10:50:39 -0400
Received: from cantor2.suse.de ([195.135.220.15]:53695 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1422964Ab2JaOuD (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 31 Oct 2012 10:50:03 -0400
Date: Wed, 31 Oct 2012 15:50:00 +0100 (CET)
From: Jiri Kosina <jkosina@suse.cz>
To: Matthew Garrett <mjg@redhat.com>
Cc: linux-kernel@vger.kernel.org, linux-security-module@vger.kernel.org,
        linux-efi@vger.kernel.org
Subject: Re: [RFC] Second attempt at kernel secure boot support
In-Reply-To: <20121029174131.GC7580@srcf.ucam.org>
Message-ID: <alpine.LNX.2.00.1210311444080.12781@pobox.suse.cz>
References: <1348152065-31353-1-git-send-email-mjg@redhat.com> <alpine.LRH.2.00.1210290848450.10392@twin.jikos.cz> <20121029174131.GC7580@srcf.ucam.org>
User-Agent: Alpine 2.00 (LNX 1167 2008-08-23)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 29 Oct 2012, Matthew Garrett wrote:

> > > This is pretty much identical to the first patchset, but with the capability
> > > renamed (CAP_COMPROMISE_KERNEL) and the kexec patch dropped. If anyone wants
> > > to deploy these then they should disable kexec until support for signed
> > > kexec payloads has been merged.
> > 
> > Apparently your patchset currently doesn't handle device firmware loading, 
> > nor do you seem to mention in in the comments.
> 
> Correct.
> 
> > I believe signed firmware loading should be put on plate as well, right?
> 
> I think that's definitely something that should be covered. I hadn't 
> worried about it immediately as any attack would be limited to machines 
> with a specific piece of hardware, and the attacker would need to expend 
> a significant amount of reverse engineering work on the firmware - and 
> we'd probably benefit from them doing that in the long run...

Now -- how about resuming from S4?

Reading stored memory image (potentially tampered before reboot) from disk 
is basically DMA-ing arbitrary data over the whole RAM. I am currently not 
able to imagine a scenario how this could be made "secure" (without 
storing private keys to sign the hibernation image on the machine itself 
which, well, doesn't sound secure either).

-- 
Jiri Kosina
SUSE Labs
