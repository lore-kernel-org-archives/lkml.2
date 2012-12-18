Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753853Ab2LRSJy (ORCPT <rfc822;w@1wt.eu>);
	Tue, 18 Dec 2012 13:09:54 -0500
Received: from ch1ehsobe003.messaging.microsoft.com ([216.32.181.183]:18813
	"EHLO ch1outboundpool.messaging.microsoft.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1750703Ab2LRSJw (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 18 Dec 2012 13:09:52 -0500
X-Forefront-Antispam-Report: CIP:163.181.249.108;KIP:(null);UIP:(null);IPV:NLI;H:ausb3twp01.amd.com;RD:none;EFVD:NLI
X-SpamScore: -2
X-BigFish: VPS-2(zz98dI1432Izz1de0h1202h1e76h1d1ah1d2ahzzz2dh668h839h944hd25hd2bhf0ah1220h1288h12a5h12a9h12bdh137ah13b6h1441h1504h1537h153bh162dh1631h1758h1155h)
X-WSS-ID: 0MF8NSB-01-6Q2-02
X-M-MSG: 
Date: Tue, 18 Dec 2012 12:09:45 -0600
From: Jacob Shin <jacob.shin@amd.com>
To: Borislav Petkov <bp@alien8.de>, Doug Thompson <dougthompson@xmission.com>,
        <linux-edac@vger.kernel.org>, <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH 2/2] MCE, AMD: MCE decoding support for AMD Family 16h
Message-ID: <20121218180945.GA21573@jshin-Toonie>
References: <1355773188-5241-1-git-send-email-jacob.shin@amd.com>
 <1355773188-5241-2-git-send-email-jacob.shin@amd.com>
 <20121218171915.GE31255@liondog.tnic>
 <20121218173024.GA18732@jshin-Toonie>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Disposition: inline
In-Reply-To: <20121218173024.GA18732@jshin-Toonie>
User-Agent: Mutt/1.5.21 (2010-09-15)
X-OriginatorOrg: amd.com
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Dec 18, 2012 at 11:30:24AM -0600, Jacob Shin wrote:
> On Tue, Dec 18, 2012 at 06:19:15PM +0100, Borislav Petkov wrote:
> > On Mon, Dec 17, 2012 at 01:39:48PM -0600, Jacob Shin wrote:

> > > +/* internal error type */
> > > +const char * const uu_msgs[] = { "RESV", "RESV", "HWA", "RESV" };
> > > +EXPORT_SYMBOL_GPL(uu_msgs);
> > 
> > Seems like those aren't used anywhere?

> > > @@ -634,6 +727,10 @@ static void decode_mc6_mce(struct mce *m)
> > >  
> > >  static inline void amd_decode_err_code(u16 ec)
> > >  {
> > > +	if (INT_ERROR(ec)) {
> > > +		pr_emerg(HW_ERR "internal: %s\n", LL_MSG(ec));
> > > +		return;
> > > +	}
> > 
> > Is this correct? I'm just confirming because I don't have the internal
> > info anymore.
> > 
> > Uuh, hold on, maybe those otherwise unused uu_msgs above were meant to
> > be used here instead of the LL_MSG? IOW,
> 
> > 
> > 		pr_emerg(HW_ERR "internal: %s\n", UU_MSG(ec));
> > 
> > Right?
> 
> Ah, yes thats right, sorry about the typo. It looks like:
> 
> Error Code           Error Code Type        Description
> 0000 01UU 0000 0000  Internal Unclassified  UU = Internal Error Type
> 
> And the UU encoding is as is in the mce_amd.h file

I think I meant to say as in uu_msgs[] above. HWA stands for
"Hardware Assertion" ..

