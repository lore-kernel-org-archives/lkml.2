Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756036Ab0JOBY4 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 14 Oct 2010 21:24:56 -0400
Received: from mail-bw0-f46.google.com ([209.85.214.46]:48088 "EHLO
	mail-bw0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753276Ab0JOBYz (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 14 Oct 2010 21:24:55 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=subject:from:to:cc:in-reply-to:references:content-type:date
         :message-id:mime-version:x-mailer:content-transfer-encoding;
        b=WDintIJP0HHEP9aUcQYkOUqi7/aaF1IIdA/KcUYKhiYx8Qj89cpksQjxHaMNLYpcLY
         XzcOcvRRwlc9gBsAEbU3yFZHbgetfHMMrSEyj48eoN7gyKkuNko6Y8V3pu5uyf6eeBlO
         u7Fhf0YvDMfZqZwW4usN4BygV7kC3ZjpuUN8E=
Subject: Re: [PATCH 2/2] ieee1394: remove the old IEEE 1394 driver stack
From: Maxim Levitsky <maximlevitsky@gmail.com>
To: Stefan Richter <stefanr@s5r6.in-berlin.de>
Cc: linux1394-devel@lists.sourceforge.net, linux-kernel@vger.kernel.org
In-Reply-To: <4CB6B570.6030509@s5r6.in-berlin.de>
References: <tkrat.a80c49c9cfb3380e@s5r6.in-berlin.de>
	 <tkrat.3d7c94e2ecb3a995@s5r6.in-berlin.de>
	 <1287014362.23588.1.camel@maxim-laptop>
	 <4CB6B570.6030509@s5r6.in-berlin.de>
Content-Type: text/plain; charset="UTF-8"
Date: Fri, 15 Oct 2010 01:29:20 +0200
Message-ID: <1287098960.4301.26.camel@maxim-laptop>
Mime-Version: 1.0
X-Mailer: Evolution 2.30.3 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 2010-10-14 at 09:46 +0200, Stefan Richter wrote:
> Maxim Levitsky wrote:
> > On Sun, 2010-10-10 at 00:12 +0200, Stefan Richter wrote:
> >> The drivers
> >>   - ohci1394 (controller driver)
> >>   - ieee1394 (core)
> >>   - dv1394, raw1394, video1394 (userspace ABI)
> >>   - eth1394, sbp2 (protocol drivers)
> >> are replaced by
> >>   - firewire-ohci (controller driver)
> >>   - firewire-core (core and userspace ABI)
> >>   - firewire-net, firewire-sbp2 (protocol drivers)
> >> which are more featureful, better performing, and more secure than the older
> >> drivers; all with a smaller and more modern code base.
> > But new stack doesn't have working networking support...
> 
> firewire-net did work for me to /some/ degree when I tested it last:  Transfer
> s via FTP or SCP command line clients was OK, even with huge files, but an
> attempt to use FTP via desktop file manager ended in kernel crash.
> 
> In contrast, eth1394 worked to /some/ other degree for me when I tested it
> last:  It never crashed, but it had irregular performance (due to DMA context
> program overflow, besides ieee1394's tlabel recycling in a wrong context) when
> paired with {Linux,Windows,OS X}/x86, whereas transfers from and to an OS
> X/PPC peer always failed due to data corruption.
Here transfers new stack <-> new stack fail at around 250 KB due to
corrupted packets. (tested via SFTP and GUI).

But anyway, I can't agree more with what you said.
So go ahead and remove the old stack.
But maybe you need to move the firewire-net driver to staging? It really
doesn't work at all, this way or around.
EXPEREMENTAL today doesn't mean much.


Best regards,
	Maxim Levitsky

