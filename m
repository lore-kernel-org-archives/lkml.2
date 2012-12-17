Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753793Ab2LQUn2 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 17 Dec 2012 15:43:28 -0500
Received: from db3ehsobe004.messaging.microsoft.com ([213.199.154.142]:37387
	"EHLO db3outboundpool.messaging.microsoft.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752678Ab2LQUn0 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 17 Dec 2012 15:43:26 -0500
X-Forefront-Antispam-Report: CIP:163.181.249.109;KIP:(null);UIP:(null);IPV:NLI;H:ausb3twp02.amd.com;RD:none;EFVD:NLI
X-SpamScore: -6
X-BigFish: VPS-6(zz98dI103dK1432I1447Izz1de0h1202h1e76h1d1ah1d2ahzzz2dh668h839h944hd25hd2bhf0ah1220h1288h12a5h12a9h12bdh137ah13b6h1441h1504h1537h153bh162dh1631h1758h1155h)
X-WSS-ID: 0MF7084-02-9WI-02
X-M-MSG: 
Date: Mon, 17 Dec 2012 14:43:17 -0600
From: Jacob Shin <jacob.shin@amd.com>
To: Borislav Petkov <bp@alien8.de>, Joe Perches <joe@perches.com>,
        Doug Thompson <dougthompson@xmission.com>,
        <linux-edac@vger.kernel.org>, <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH 1/2] MCE, AMD: Make MC2 decoding part of amd_decoder_ops
 as well
Message-ID: <20121217204317.GA32760@jshin-Toonie>
References: <1355773188-5241-1-git-send-email-jacob.shin@amd.com>
 <1355774221.13361.48.camel@joe-AO722>
 <20121217200535.GF31866@liondog.tnic>
 <1355775376.19706.1.camel@joe-AO722>
 <20121217202214.GG31866@liondog.tnic>
 <1355776475.19706.6.camel@joe-AO722>
 <20121217204011.GH31866@liondog.tnic>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Disposition: inline
In-Reply-To: <20121217204011.GH31866@liondog.tnic>
User-Agent: Mutt/1.5.21 (2010-09-15)
X-OriginatorOrg: amd.com
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Dec 17, 2012 at 09:40:11PM +0100, Borislav Petkov wrote:
> On Mon, Dec 17, 2012 at 12:34:35PM -0800, Joe Perches wrote:
> > decode_mc2_mce does
> > 
> > 	pr_emerg(HW_ERR "MC2 Error: ");
> > calls
> > 	fam_ops->mc2_mce()
> > which may not emit anything
> > and if it doesn't, does
> > 	pr_emerg(HW_ERR "Corrupted ...");
> > on another line leaving a trailing colon without
> > newline from the pr_emerg above.
> 
> Ok, this is in Jacob's patch AFAICT, I'll review those tomorrow but
> thanks for the heads-up.

Okay, I'll wait until your feedback before sending V2

> 
> > I believe the second pr_emerg should be pr_cont
> 
> Actually, it should be
> 
> pr_emerg(HW_ERR "\nCorrupted...\n");
> 
> to finish the initial pr_emerg.

Okay, all of the other decode_mc*_mce functions needs to change then.

Thanks!

> 
> Thanks.
> 
> -- 
> Regards/Gruss,
>     Boris.
> 
> Sent from a fat crate under my desk. Formatting is fine.
> --
> 

