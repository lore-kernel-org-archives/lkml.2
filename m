Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752738Ab1BVNo1 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 22 Feb 2011 08:44:27 -0500
Received: from hrndva-omtalb.mail.rr.com ([71.74.56.122]:54778 "EHLO
	hrndva-omtalb.mail.rr.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752342Ab1BVNoZ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 22 Feb 2011 08:44:25 -0500
X-Authority-Analysis: v=1.1 cv=dquaJDitHqzHCdqWSoZ6IgapSuTzW/4TaRYx9N9k4W8= c=1 sm=0 a=b8VkJ_G4jssA:10 a=Q9fys5e9bTEA:10 a=OPBmh+XkhLl+Enan7BmTLg==:17 a=EJKYFmySKGpQ5nXSE4wA:9 a=eosnBhdNzV7LnYnO5Uh4zVrmSGAA:4 a=PUjeQqilurYA:10 a=OPBmh+XkhLl+Enan7BmTLg==:117
X-Cloudmark-Score: 0
X-Originating-IP: 67.242.120.143
Subject: Re: [PATCH] rt2x00: Use ops name instead of device name
From: Steven Rostedt <rostedt@goodmis.org>
To: Ben Hutchings <bhutchings@solarflare.com>
Cc: LKML <linux-kernel@vger.kernel.org>, netdev <netdev@vger.kernel.org>,
        Felix Fietkau <nbd@openwrt.org>, Ivo van Doorn <IvDoorn@gmail.com>,
        "John W. Linville" <linville@tuxdriver.com>, abogani@texware.it
In-Reply-To: <1298381695.2211.486.camel@localhost>
References: <1298380368.6140.1193.camel@gandalf.stny.rr.com>
	 <1298381695.2211.486.camel@localhost>
Content-Type: text/plain; charset="ISO-8859-15"
Date: Tue, 22 Feb 2011 08:44:23 -0500
Message-ID: <1298382263.6140.1196.camel@gandalf.stny.rr.com>
Mime-Version: 1.0
X-Mailer: Evolution 2.30.3 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 2011-02-22 at 13:34 +0000, Ben Hutchings wrote:

> > 19:   73474106          0   IO-APIC-fasteoi   ata_piix, uhci_hcd:usb6, 0000:05:01.0

> >  	rt2x00dev->irq = pci_dev->irq;
> > -	rt2x00dev->name = pci_name(pci_dev);
> > +	rt2x00dev->name = ops->name;


> But then how can users distinguish the IRQs for multiple devices handled
> by the same driver?  (Probably unusual for WLAN devices, but still
> possible.)
> 
> I assume you can't use a net device name as there may be multiple net
> devices per bus device?

Honestly, I do not know this code well enough, but this patch seemed to
solve the problem at hand. Hence I sent it out to the experts hoping
they either take this patch or come up with a proper solution ;)

In any case, just posting the pci address is not a pretty answer.

-- Steve


