Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756564Ab0IUOzO (ORCPT <rfc822;w@1wt.eu>);
	Tue, 21 Sep 2010 10:55:14 -0400
Received: from cantor2.suse.de ([195.135.220.15]:60001 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751413Ab0IUOzM (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 21 Sep 2010 10:55:12 -0400
Date: Tue, 21 Sep 2010 16:55:11 +0200 (CEST)
From: Jiri Kosina <jkosina@suse.cz>
To: Heinz Diehl <htd@fancy-poultry.org>
Cc: Alan Ott <alan@signal11.us>, Markus Trippelsdorf <markus@trippelsdorf.de>,
        linux-kernel@vger.kernel.org, linux-usb@vger.kernel.org,
        linux-input@vger.kernel.org, Arnd Bergmann <arnd@arndb.de>
Subject: Re: [BUG] object: is not initialized, yet kobject_put() is being
 called
In-Reply-To: <20100920181100.GA12295@fancy-poultry.org>
Message-ID: <alpine.LNX.2.00.1009211653510.26813@pobox.suse.cz>
References: <20100812091659.GA1591@arch.tripp.de> <alpine.LNX.2.00.1008121148100.2702@pobox.suse.cz> <20100812113624.GB1591@arch.tripp.de> <20100812114513.GA1584@arch.tripp.de> <20100812115657.GA1611@arch.tripp.de> <alpine.LNX.2.00.1008121401580.2702@pobox.suse.cz>
 <alpine.LNX.2.00.1008121457060.2702@pobox.suse.cz> <20100812130411.GA1626@arch.tripp.de> <4C63F285.8070801@signal11.us> <20100812164035.GB6761@fritha.org> <20100920181100.GA12295@fancy-poultry.org>
User-Agent: Alpine 2.00 (LNX 1167 2008-08-23)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 20 Sep 2010, Heinz Diehl wrote:

> > > >>Could please those of you, who are able to reproduce the problem, verify
> > > >>whether the patch below (completely untested) makes everything behave
> > > >>again? Thanks.
>  
> > > >Yes, everything behaves again. Thanks Jiri.
>   
> > > Seconded. Works good. Thanks for your support Jiri.
>  
> > Thirded! This fixes the warning here.
> 
> Unfortunately, I have to take up this problem a second time. 
> I considered the issue fixed, and in fact it was using Jiris patch.
> 
> However, the same problem came back while testing 2.6.36-rc4 and the
> following -git's. /var/log/warn shows the same warning as mentioned in
> the first mail in this thread:
> 
>  Sep 20 08:18:42 liesel apcupsd[5436]: apcupsd FATAL ERROR in linux-usb.c at line 609 
>  Cannot find UPS device -- For a link to detailed USB trouble
>  shooting information, please see <http://www.apcupsd.com/support.html>.
>  Sep 20 08:18:42 liesel apcupsd[5436]: apcupsd error shutdown completed
> 
> No additional oops this time, only the warning, and my UPS is no longer
> working.
> 
> Jiris patch obviously didn't made it into 2.6.36-rc4, and it doesn't
> apply nay longer either.

This seems like a completely different problem -- apcupsd is not finding 
the UPS, yes, but kernel doesn't WARN/BUG here, so it seems like similar 
symptoms, but very likely a different cause.

Could you perhaps strace apcupsd to see what it is doing before it fails?

-- 
Jiri Kosina
SUSE Labs, Novell Inc.
