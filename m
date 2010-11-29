Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751868Ab0K2QWv (ORCPT <rfc822;w@1wt.eu>);
	Mon, 29 Nov 2010 11:22:51 -0500
Received: from cantor2.suse.de ([195.135.220.15]:53649 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751013Ab0K2QWv (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 29 Nov 2010 11:22:51 -0500
Date: Mon, 29 Nov 2010 17:22:45 +0100 (CET)
From: Jiri Kosina <jkosina@suse.cz>
To: Michael Doube <michael@doube.net>
Cc: Debora Velarde <debora@linux.vnet.ibm.com>,
        Rajiv Andrade <srajiv@linux.vnet.ibm.com>,
        Marcel Selhorst <m.selhorst@sirrix.com>,
        "Rafael J. Wysocki" <rjw@suse.com>, tpmdd-devel@lists.sourceforge.net,
        linux-kernel@vger.kernel.org
Subject: Re: [tpmdd-devel] [REGRESSION] Suspend fails because of TPM
 modules
In-Reply-To: <4CF3D182.8090907@doube.net>
Message-ID: <alpine.LNX.2.00.1011291720580.981@pobox.suse.cz>
References: <alpine.LNX.2.00.1011291554570.981@pobox.suse.cz> <alpine.LNX.2.00.1011291614060.981@pobox.suse.cz> <4CF3D182.8090907@doube.net>
User-Agent: Alpine 2.00 (LNX 1167 2008-08-23)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 29 Nov 2010, Michael Doube wrote:

> > I just found out, that if I modprobe tpm_tis module with
> > 
> > 	itpm=1
> > 
> > parameter, the problem doesn't happen any more and suspend works fine.
> 
> Not here unfortunately. Suspend still fails with itpm=1, and I get this
> in my logs
> 
> Nov 29 15:52:32 doris kernel: [  649.110923] tpm_tis 00:09: 1.2 TPM (device-id 0xB, rev-id 16)
> Nov 29 15:52:32 doris kernel: [  649.110929] tpm_tis 00:09: Intel iTPM workaround enabled
> Nov 29 15:54:34 doris kernel: [  771.360067] tpm_tis 00:09: tpm_transmit: tpm_send: error -62

That looks like a completely separate issue -- in your case, 
wait_for_stat() times out while waiting for _READY.

Is this regressions from older kernels as well?

> Looks for a string that is absent from my Vaio SZ650, so the workaround
> is not applied (and if it was, it probably wouldn't work, right?).

Yeah, it's workaround for symptoms different from than what you are 
seeing.

-- 
Jiri Kosina
SUSE Labs, Novell Inc.
