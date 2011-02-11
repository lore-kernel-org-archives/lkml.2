Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756985Ab1BKOjF (ORCPT <rfc822;w@1wt.eu>);
	Fri, 11 Feb 2011 09:39:05 -0500
Received: from mga02.intel.com ([134.134.136.20]:6684 "EHLO mga02.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756927Ab1BKOi5 convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 11 Feb 2011 09:38:57 -0500
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.60,455,1291622400"; 
   d="scan'208";a="706648226"
From: "Paoloni, Gabriele" <gabriele.paoloni@intel.com>
To: Pavel Machek <pavel@ucw.cz>, Jesper Juhl <jj@chaosbits.net>
CC: "Struk, Tadeusz" <tadeusz.struk@intel.com>,
        "herbert@gondor.hengli.com.au" <herbert@gondor.hengli.com.au>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "linux-crypto@vger.kernel.org" <linux-crypto@vger.kernel.org>,
        "O Mahony, Aidan" <aidan.o.mahony@intel.com>,
        "Hoban, Adrian" <adrian.hoban@intel.com>
Date: Fri, 11 Feb 2011 14:38:49 +0000
Subject: RE: [PATCH] rfc4106, Intel, AES-NI: Don't leak memory in
 rfc4106_set_hash_subkey().
Thread-Topic: [PATCH] rfc4106, Intel, AES-NI: Don't leak memory in
 rfc4106_set_hash_subkey().
Thread-Index: AcvJ98jZkLVTlg8GRGWnUCBwfiRgFwAAS45Q
Message-ID: <DF7BB929B28FCF479E888E3D9F8D9E88F3E2E668@irsmsx502.ger.corp.intel.com>
References: <4d502ccb.p+rKcuFjWCnBlXY9%tadeusz.struk@intel.com>
 <alpine.LNX.2.00.1102071922220.27796@swampdragon.chaosbits.net>
 <20110211142647.GA3920@ucw.cz>
In-Reply-To: <20110211142647.GA3920@ucw.cz>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
acceptlanguage: en-US
Content-Type: text/plain; charset="us-ascii"
MIME-Version: 1.0
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Well anyway I think that the return value of "ablkcipher_request_alloc(ctr_tfm, GFP_KERNEL)" has to be changed from -EINVAL to -ENOMEM in case of failure. That is why would stay on the patch that Tadeusz proposed. Otherwise Juhl should send another one....

> -----Original Message-----
> From: Pavel Machek [mailto:pavel@ucw.cz]
> Sent: Friday, February 11, 2011 2:27 PM
> To: Jesper Juhl
> Cc: Struk, Tadeusz; herbert@gondor.hengli.com.au; linux-
> kernel@vger.kernel.org; linux-crypto@vger.kernel.org; O Mahony, Aidan;
> Paoloni, Gabriele; Hoban, Adrian
> Subject: Re: [PATCH] rfc4106, Intel, AES-NI: Don't leak memory in
> rfc4106_set_hash_subkey().
> 
> On Mon 2011-02-07 19:24:43, Jesper Juhl wrote:
> > On Mon, 7 Feb 2011, tadeusz.struk@intel.com wrote:
> >
> > > From:
> > > Date: Sun, 16 Jan 2011 16:41:11 +0000
> > > Subject: RE: [PATCH] rfc4106, Intel, AES-NI: Don't leak memory in
> rfc4106_set_hash_subkey().
> > >
> > > Hi Jesper,
> > > Thanks, but I think there is still a problem here. You don't want
> to kfree req_data
> > > when the kmalloc failed. I think it should look as follows.
> > > Are you ok with this?
> > >
> > Fine by me.
> >
> > I was aware of the kfree(NULL) thing, but desided to leave it as is
> for
> > two reasons - 1) kfree(NULL) is harmless and this is an error path,
> so the
> > extra function call doesn't matter much. 2) I wanted to preserve
> > deallocations in the reverse order of the allocations. But sure,
> moving
> > that kfree is a tiny optimization of the error path, so I'm fine with
> it.
> 
> I don't think such optimalization is worth doing... original code is
> as good but shorter and less complex...
> 
> --
> (english) http://www.livejournal.com/~pavelmachek
> (cesky, pictures)
> http://atrey.karlin.mff.cuni.cz/~pavel/picture/horses/blog.html
--------------------------------------------------------------
Intel Shannon Limited
Registered in Ireland
Registered Office: Collinstown Industrial Park, Leixlip, County Kildare
Registered Number: 308263
Business address: Dromore House, East Park, Shannon, Co. Clare

This e-mail and any attachments may contain confidential material for the sole use of the intended recipient(s). Any review or distribution by others is strictly prohibited. If you are not the intended recipient, please contact the sender and delete all copies.


