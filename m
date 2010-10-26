Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760195Ab0JZUkI (ORCPT <rfc822;w@1wt.eu>);
	Tue, 26 Oct 2010 16:40:08 -0400
Received: from devils.ext.ti.com ([198.47.26.153]:35378 "EHLO
	devils.ext.ti.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754539Ab0JZUkG convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 26 Oct 2010 16:40:06 -0400
From: "Guzman Lugo, Fernando" <fernando.lugo@ti.com>
To: Felipe Contreras <felipe.contreras@nokia.com>,
        "felipe.contreras@gmail.com" <felipe.contreras@gmail.com>
CC: "gregkh@suse.de" <gregkh@suse.de>,
        "hiroshi.doyu@nokia.com" <hiroshi.doyu@nokia.com>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "andy.shevchenko@gmail.com" <andy.shevchenko@gmail.com>,
        "linux-omap@vger.kernel.org" <linux-omap@vger.kernel.org>,
        "linux-arm-kernel@lists.infradead.org" 
	<linux-arm-kernel@lists.infradead.org>
Date: Tue, 26 Oct 2010 15:39:50 -0500
Subject: RE: [PATCH 1/8] staging: tidspbridge - remove req_addr from proc_map
Thread-Topic: [PATCH 1/8] staging: tidspbridge - remove req_addr from
 proc_map
Thread-Index: Act1RVG6S4zJWVmSRVOpUQO0c4xX1AABEwHw
Message-ID: <496565EC904933469F292DDA3F1663E602F49E29F7@dlee06.ent.ti.com>
References: <1288054306-4361-1-git-send-email-x0095840@ti.com>
 <1288054306-4361-2-git-send-email-x0095840@ti.com>
 <AANLkTimCDM_nruvh_gqxxy0CVnw2sH5UYNT9VgyeBfZN@mail.gmail.com>
 <496565EC904933469F292DDA3F1663E602F49E280A@dlee06.ent.ti.com>
 <1288112616-notmuch-felipe.contreras@nokia.com>
 <496565EC904933469F292DDA3F1663E602F49E28BD@dlee06.ent.ti.com>
 <1288121251-notmuch-felipe.contreras@nokia.com>
In-Reply-To: <1288121251-notmuch-felipe.contreras@nokia.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
acceptlanguage: en-US
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 8BIT
MIME-Version: 1.0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

 

> -----Original Message-----
> From: Felipe Contreras [mailto:felipe.contreras@nokia.com] 
> Sent: Tuesday, October 26, 2010 2:38 PM
> To: Guzman Lugo, Fernando; felipe.contreras@gmail.com
> Cc: gregkh@suse.de; hiroshi.doyu@nokia.com; 
> linux-kernel@vger.kernel.org; andy.shevchenko@gmail.com; 
> linux-omap@vger.kernel.org; linux-arm-kernel@lists.infradead.org
> Subject: RE: [PATCH 1/8] staging: tidspbridge - remove 
> req_addr from proc_map
> 
> fernando.lugo@ti.com wrote:
> > > fernando.lugo@ti.com wrote:
> > > > > On Tue, Oct 26, 2010 at 3:51 AM, Fernando Guzman Lugo 
> > > > > <x0095840@ti.com> wrote:
> > > > > > The device address is assigned by tidspbridge no need for
> > > > > that parameter anymore.
> > > > > >
> > > > > > Signed-off-by: Fernando Guzman Lugo <x0095840@ti.com>
> > > > > 
> > > > > This would break the API with user-space, right?
> > > > 
> > > > Yes, user-space needs to be changed accordingly.
> > > 
> > > Wouldn't it make sense to avoid stuffing so many changes at once 
> > > including ABI breakage?
> > > 
> > > Does user-space really _needs_ to be changed? Can't you 
> just ignore 
> > > that argument?
> > 
> > Actually, I had a previous version of that patch where I 
> only Ignored 
> > that paramteter. But after thinking again and seeing How 
> the long time 
> > ago depreacted function are still there I Removed the parameter in 
> > order to force apps to make the change.
> 
> Again, can we concentrate on first getting this thing to work?

If to make it work for 37 the iommu migration patch will be revert
These set of patches will have to wait until the patches are merged
Again. So the dspbridge would be "fix" first a then the patches would
Be merged.

> 
> We can think on breaking things again later.
> 
> > You can ignore that argument at API level, so all users of 
> the API not 
> > need to have change (in that momment). That should be Only few line 
> > change.
> 
> Yes, that's what I'm proposing.

I meant userspace api or library level:
Example:

Dsp_proc_map(proc, mpu_addr, req_addr, *dsp_addr, attr) {
...
	struct proc_map args = {
		.map_addr = mpu_addr;
		/* ignore req_addr */
		.dsp_addr = dsp_addr;
		.attr = attr;
	}

	ret = ioctl(handle, PROCMAP_CMD, args)
...
}


> 
> > > > > I think this change should be delayed, preferably 
> after we have 
> > > > > a working tidspbridge.
> > > > 
> > > > The issue you were seeing must be fixed with patch 2/8, and
> > > Having all
> > > > the dependencies tidspbridge has to be working Properly.
> > > 
> > > Yes, which might not happen at .37. If we revert the 
> iommu stuff, we 
> > > might have a chance at having a working bridge on .37.
> > 
> > But havi that merged in tidspbridge make more pressure to 
> merged The 
> > dependencies, if not maybe that wont have event for .38.
> 
> Those patches have been there for a while and there's no sign 
> of when they'll be merged. Also, remember that the fact that 
> the patches have been sent doesn't guarantee they would be on 
> this, or even the next cycle.
> 
> Besides, the rule followed here is: it's ready when it's 
> ready. In the meantime the driver should work, and we can do 
> that rather easily.

I don't have much experience in this kind of situacion if it is
believed it is the best solution then ok for me.

> 
> > But That is just my opinion if you all are agree revert is the best 
> > Option I am ok, but I looks like more work reverting and rebaseing 
> > specially because it is a big change.
> 
> git makes this easy.

Till we need to fix all the conflics, make sure everything work
Properly and then send it again to review. That can take a while,
But it seems someone else is agree to revert the changes, so maybe
That is the best to do in this situacion.

Thanks and regards,
Fernando.

> 
> The hard part is for the people out there that are trying to 
> use this driver and have to hunt mailing lists and multiple 
> repos just to get this to work. Moving to staging was 
> supposed to make this easier, not harder.
> 
> --
> Felipe Contreras
> 