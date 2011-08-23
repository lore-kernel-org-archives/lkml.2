Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755111Ab1HWJMW (ORCPT <rfc822;w@1wt.eu>);
	Tue, 23 Aug 2011 05:12:22 -0400
Received: from cernmx30.cern.ch ([137.138.144.177]:7792 "EHLO CERNMX30.cern.ch"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754958Ab1HWJMU (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 23 Aug 2011 05:12:20 -0400
Date: Tue, 23 Aug 2011 11:09:02 +0200
From: Manohar Vanga <manohar.vanga@cern.ch>
To: Martyn Welch <martyn.welch@ge.com>
CC: "Emilio G. Cota" <cota@braap.org>, <gregkh@suse.de>,
        <devel@driverdev.osuosl.org>, <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH 3/5] staging: vme: add functions for bridge module
 refcounting
Message-ID: <20110823090902.GA8421@becoht-mvanga>
Mail-Followup-To: Martyn Welch <martyn.welch@ge.com>,
	"Emilio G. Cota" <cota@braap.org>, gregkh@suse.de,
	devel@driverdev.osuosl.org, linux-kernel@vger.kernel.org
References: <1313145051-13397-1-git-send-email-manohar.vanga@cern.ch>
 <1313145051-13397-4-git-send-email-manohar.vanga@cern.ch>
 <20110813074714.GA32149@flamenco.cs.columbia.edu>
 <4E524A9B.7090700@ge.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Disposition: inline
In-Reply-To: <4E524A9B.7090700@ge.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
X-Originating-IP: [137.138.192.18]
Keywords: CERN SpamKiller Note: -50
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hey Martyn,

Thanks for testing this out. Sorry for the inactivity last week, I have been
busy with some unrelated work. I will resend the patches by the end of this
week with the correct fixes.

Thanks again!

On Mon, Aug 22, 2011 at 01:24:59PM +0100, Martyn Welch wrote:
> On 13/08/11 08:47, Emilio G. Cota wrote:
> > On Fri, Aug 12, 2011 at 12:30:49 +0200, Manohar Vanga wrote:
> >> +	struct vme_bridge *bridge;
> >> +
> >> +	mutex_lock(&vme_buses_lock);
> >> +	list_for_each_entry(bridge, &vme_bus_list, bus_list) {
> >> +		if (bridge->num == bus_id) {
> >> +			if (!bridge->owner)
> >> +				dev_warn(bridge->parent,
> >> +					"bridge->owner not set\n");
> > 
> > Don't do this; it will throw a false warning if the kernel is
> > built without module support. Note that in that case
> > 
> > 	THIS_MODULE == (struct module *)0.
> > 
> > try_module_get() and module_put() do the right thing for all
> > possible configs. Trust them.
> > 
> 
> I can confirm that this does break when the bridge is compiled into the kernel.
> 
> Martyn
> 
> -- 
> Martyn Welch (Principal Software Engineer) | Registered in England and
> GE Intelligent Platforms                   | Wales (3828642) at 100
> T +44(0)1327322748                         | Barbirolli Square, Manchester,
> E martyn.welch@ge.com                      | M2 3AB  VAT:GB 927559189

-- 
/manohar
