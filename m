Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933270Ab0JZNkF (ORCPT <rfc822;w@1wt.eu>);
	Tue, 26 Oct 2010 09:40:05 -0400
Received: from mxout1.idt.com ([157.165.5.25]:60872 "EHLO mxout1.idt.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S933243Ab0JZNkB convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 26 Oct 2010 09:40:01 -0400
X-MimeOLE: Produced By Microsoft Exchange V6.5
Content-class: urn:content-classes:message
MIME-Version: 1.0
Content-Type: text/plain;
	charset="us-ascii"
Content-Transfer-Encoding: 8BIT
Subject: RE: [PATCH -mm 0/2] RapidIO: Changes to handling of RIO switches
Date: Tue, 26 Oct 2010 06:39:29 -0700
Message-ID: <0CE8B6BE3C4AD74AB97D9D29BD24E5520147D879@CORPEXCH1.na.ads.idt.com>
In-Reply-To: <4CC5E354.80009@neli.hopto.org>
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
Thread-Topic: [PATCH -mm 0/2] RapidIO: Changes to handling of RIO switches
Thread-Index: Act0gD3/+Nm/2BT+R2SDOERtjMDD5gAIpXFg
References: <1287688250-14226-1-git-send-email-alexandre.bounine@idt.com> <4CC0AD74.8070800@neli.hopto.org> <0CE8B6BE3C4AD74AB97D9D29BD24E55201445906@CORPEXCH1.na.ads.idt.com> <4CC1D7DE.7060405@neli.hopto.org> <0CE8B6BE3C4AD74AB97D9D29BD24E55201445A6B@CORPEXCH1.na.ads.idt.com> <4CC20923.8050400@neli.hopto.org> <0CE8B6BE3C4AD74AB97D9D29BD24E55201445BA4@CORPEXCH1.na.ads.idt.com> <4CC5ACAB.7070309@neli.hopto.org> <0CE8B6BE3C4AD74AB97D9D29BD24E5520147D5C2@CORPEXCH1.na.ads.idt.com> <4CC5E354.80009@neli.hopto.org>
From: "Bounine, Alexandre" <Alexandre.Bounine@idt.com>
To: "Micha Nelissen" <micha@neli.hopto.org>
Cc: <akpm@linux-foundation.org>, <linux-kernel@vger.kernel.org>,
        <linuxppc-dev@lists.ozlabs.org>,
        "Matt Porter" <mporter@kernel.crashing.org>,
        "Li Yang" <leoli@freescale.com>,
        "Kumar Gala" <galak@kernel.crashing.org>,
        "Thomas Moll" <thomas.moll@sysgo.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Micha Nelissen <micha@neli.hopto.org> wrote:
> 
> I look at it this way: it prevents the need for another layer of
> indirection: translating component tag to a destid.

The destid alone is not enough. You will need an entire rio_dev object
for that device anyway.

> 
> Why no relation? My experience is that during debugging it's useful to
> have the destid directly at hand, it's just very practical. (Otherwise
> any drawing of a random network would need two "identification"
numbers
> per drawn node: the component tag (true identification), and destid
> since that's what everyone uses to identify a device, what needs to
> programmed into the LUTs of a switch, identification in sysfs, etc.).

I think we are mixing two things together here. I understand your idea
but do not see how it prevents me from having one common set of access
coordinates for RIO devices (the starting point of our discussion). 

Regardless of an implementation, having a way that ensures unified
identification of switches by all processor boards is better than the
current mainline implementation. Methods of forming a component tag may
differ but still serve the same purpose. Personally I prefer to avoid
any link of device identification to the destid because it may not be as
intuitive as it seems for large systems with hot-plug. I will discuss
this with some of RIO TWG guys to get their opinion on the best
approach.

I will make a patch that defines fields of component tag, probably just
one for now - identification field. This will ensure that any method
used to assign component tag (id part of it) will be compatible with RIO
spec part 8 error management.

As for switch identification, at this moment I still prefer replacing
rswitch->switchid with ID portion of the component tag because it is
very simple and does not require changes to enumeration algorithm.   

Alex.

           
