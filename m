Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757156Ab2J2Rll (ORCPT <rfc822;w@1wt.eu>);
	Mon, 29 Oct 2012 13:41:41 -0400
Received: from cavan.codon.org.uk ([93.93.128.6]:33508 "EHLO
	cavan.codon.org.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750821Ab2J2Rli (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 29 Oct 2012 13:41:38 -0400
Date: Mon, 29 Oct 2012 17:41:31 +0000
From: Matthew Garrett <mjg@redhat.com>
To: Jiri Kosina <jkosina@suse.cz>
Cc: linux-kernel@vger.kernel.org, linux-security-module@vger.kernel.org,
        linux-efi@vger.kernel.org
Subject: Re: [RFC] Second attempt at kernel secure boot support
Message-ID: <20121029174131.GC7580@srcf.ucam.org>
References: <1348152065-31353-1-git-send-email-mjg@redhat.com>
 <alpine.LRH.2.00.1210290848450.10392@twin.jikos.cz>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <alpine.LRH.2.00.1210290848450.10392@twin.jikos.cz>
User-Agent: Mutt/1.5.20 (2009-06-14)
X-SA-Exim-Connect-IP: <locally generated>
X-SA-Exim-Mail-From: mjg59@cavan.codon.org.uk
X-SA-Exim-Scanned: No (on cavan.codon.org.uk); SAEximRunCond expanded to false
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Oct 29, 2012 at 08:49:41AM +0100, Jiri Kosina wrote:
> On Thu, 20 Sep 2012, Matthew Garrett wrote:
> 
> > This is pretty much identical to the first patchset, but with the capability
> > renamed (CAP_COMPROMISE_KERNEL) and the kexec patch dropped. If anyone wants
> > to deploy these then they should disable kexec until support for signed
> > kexec payloads has been merged.
> 
> Apparently your patchset currently doesn't handle device firmware loading, 
> nor do you seem to mention in in the comments.

Correct.

> I believe signed firmware loading should be put on plate as well, right?

I think that's definitely something that should be covered. I hadn't 
worried about it immediately as any attack would be limited to machines 
with a specific piece of hardware, and the attacker would need to expend 
a significant amount of reverse engineering work on the firmware - and 
we'd probably benefit from them doing that in the long run...

Having said that, yes, we should worry about this. Firmware distribution 
licenses often forbid any distribution of modified versions, so 
signatures would probably need to be detached. udev could easily glue 
together a signature and firmware when loading, but if we're moving 
towards an in-kernel firmware loader for the common case then it'll need 
to be implemented there as well.

-- 
Matthew Garrett | mjg59@srcf.ucam.org
