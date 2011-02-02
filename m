Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754262Ab1BBNjL (ORCPT <rfc822;w@1wt.eu>);
	Wed, 2 Feb 2011 08:39:11 -0500
Received: from mx1.redhat.com ([209.132.183.28]:51952 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753473Ab1BBNjJ (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 2 Feb 2011 08:39:09 -0500
Date: Wed, 2 Feb 2011 15:38:58 +0200
From: Gleb Natapov <gleb@redhat.com>
To: Henrique de Moraes Holschuh <hmh@hmh.eng.br>
Cc: linux-kernel@vger.kernel.org, "H. Peter Anvin" <hpa@zytor.com>,
        Thomas Gleixner <tglx@linutronix.de>, Ingo Molnar <mingo@redhat.com>,
        x86@kernel.org
Subject: Re: [PATCH] Fix EDD3.0 data verification.
Message-ID: <20110202133858.GJ14984@redhat.com>
References: <20110202112139.GD14984@redhat.com>
 <20110202133035.GF9737@khazad-dum.debian.net>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20110202133035.GF9737@khazad-dum.debian.net>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Feb 02, 2011 at 11:30:36AM -0200, Henrique de Moraes Holschuh wrote:
> On Wed, 02 Feb 2011, Gleb Natapov wrote:
> > Check for nonzero path in edd_has_edd30() has no sense. First, it looks
> > at the wrong memory. Device path starts at offset 30 of the info->params
> > structure which is at offset 8 from the beginning of info structure, but
> > code looks at info + 4 instead. This was correct when code was introduced,
> > but around v2.6.4 three more fields were added to edd_info structure
> > (commit 66b61a5c in history.git). Second, even if it will check correct
> > memory it will always succeed since at offset 30 (params->key) there will
> > be non-zero values otherwise previous check would fail.
> 
> Hmm, would that be a reason for boot lockups on some systems ?  I've
> seen that happen on Intel D875PBZ and Debian stable (2.6.26).  We
> dropped EDD support then.
> 
Unlikely. Edd module is not loaded by default and the code that the
patch changes works on in-memory data that was read from BIOS during
boot. It is theoretically possible that BIOS, that works according to
phoenix spec, will do something bad when int13_48 is called with buffer
bigger then 66 bytes, but my patch does not fix that.

--
			Gleb.
