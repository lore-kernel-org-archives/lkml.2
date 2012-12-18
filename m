Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754743Ab2LRW4S (ORCPT <rfc822;w@1wt.eu>);
	Tue, 18 Dec 2012 17:56:18 -0500
Received: from mail.skyhub.de ([78.46.96.112]:52897 "EHLO mail.skyhub.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751465Ab2LRW4N (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 18 Dec 2012 17:56:13 -0500
Date: Tue, 18 Dec 2012 23:56:10 +0100
From: Borislav Petkov <bp@alien8.de>
To: Joe Perches <joe@perches.com>
Cc: Jacob Shin <jacob.shin@amd.com>, Doug Thompson <dougthompson@xmission.com>,
        linux-edac@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH 2/2] MCE, AMD: MCE decoding support for AMD Family 16h
Message-ID: <20121218225610.GL31255@liondog.tnic>
Mail-Followup-To: Borislav Petkov <bp@alien8.de>,
	Joe Perches <joe@perches.com>, Jacob Shin <jacob.shin@amd.com>,
	Doug Thompson <dougthompson@xmission.com>,
	linux-edac@vger.kernel.org, linux-kernel@vger.kernel.org
References: <1355864771-13839-1-git-send-email-jacob.shin@amd.com>
 <1355864771-13839-3-git-send-email-jacob.shin@amd.com>
 <1355868659.3982.3.camel@joe-AO722>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
In-Reply-To: <1355868659.3982.3.camel@joe-AO722>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Dec 18, 2012 at 02:10:59PM -0800, Joe Perches wrote:
> On Tue, 2012-12-18 at 15:06 -0600, Jacob Shin wrote:
> > Add MCE decoding logic for AMD Family 16h processors.
> 
> More trivia:
> 
> > diff --git a/drivers/edac/mce_amd.c b/drivers/edac/mce_amd.c
> []
> > @@ -64,6 +64,10 @@ EXPORT_SYMBOL_GPL(to_msgs);
> >  const char * const ii_msgs[] = { "MEM", "RESV", "IO", "GEN" };
> >  EXPORT_SYMBOL_GPL(ii_msgs);
> >  
> > +/* internal error type */
> > +const char * const uu_msgs[] = { "RESV", "RESV", "HWA", "RESV" };
> > +EXPORT_SYMBOL_GPL(uu_msgs);
> 
> Do these really need to be exported?
> These don't seem to be used outside of mce_amd.
> 
> If these really need export, are these very good names?
> Perhaps these should be prefixed with something?

Hmm, some of those were used in amd64_edac at some point but then the
whole decoding code got concentrated into mce_amd.c but the exports
remained.

PP() and thus pp_msgs is still used there, for example.

So, if you'd like, you could wait until I apply Jacob's patches and push
that git branch to kernel.org and then write a patch ontop removing all
the exports except pp_msgs (you could add them to the "amd_" namespace
by calling it amd_pp_msgs or something) test that patch and send it to
me.

Thanks.

-- 
Regards/Gruss,
    Boris.

Sent from a fat crate under my desk. Formatting is fine.
--
