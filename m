Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758053Ab0HQRsX (ORCPT <rfc822;w@1wt.eu>);
	Tue, 17 Aug 2010 13:48:23 -0400
Received: from mxout1.idt.com ([157.165.5.25]:51435 "EHLO mxout1.idt.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754819Ab0HQRsT convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 17 Aug 2010 13:48:19 -0400
X-MimeOLE: Produced By Microsoft Exchange V6.5
Content-class: urn:content-classes:message
MIME-Version: 1.0
Content-Type: text/plain;
	charset="us-ascii"
Content-Transfer-Encoding: 8BIT
Subject: RE: [PATCH 4/9] RapidIO: Add relation links between RIO device structures
Date: Tue, 17 Aug 2010 10:47:59 -0700
Message-ID: <0CE8B6BE3C4AD74AB97D9D29BD24E552011D6317@CORPEXCH1.na.ads.idt.com>
In-Reply-To: <4C6A3573.3070403@neli.hopto.org>
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
thread-topic: [PATCH 4/9] RapidIO: Add relation links between RIO device structures
thread-index: Acs92rSS3Qbbj9fcR7CSVOVTCQFcpgAVr3pA
References: <1281712686-31308-1-git-send-email-alexandre.bounine@idt.com> <1281712686-31308-5-git-send-email-alexandre.bounine@idt.com> <4C692C9D.6040100@neli.hopto.org> <0CE8B6BE3C4AD74AB97D9D29BD24E552011D5F1F@CORPEXCH1.na.ads.idt.com> <4C6A3573.3070403@neli.hopto.org>
From: "Bounine, Alexandre" <Alexandre.Bounine@idt.com>
To: "Micha Nelissen" <micha@neli.hopto.org>
Cc: <akpm@linux-foundation.org>, <linux-kernel@vger.kernel.org>,
        <linuxppc-dev@ozlabs.org>,
        "Bounine, Alexandre" <Alexandre.Bounine@idt.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Micha Nelissen wrote:
> 
> I agree it's desirable to have this information. Notes:
> 1) is rio_dev->prev used anywhere? (maybe I missed it)

It is used to scan route back when servicing an orphaned PW message.
I also see its future use when invalidating route(s) in case of device
removal.
  
> 2) is the nextdev[port] list complete? I mean are all connected
switches
> in the list? My guess is that multiply connected switches are
enumerated
> only once therefore only appear in the nextdev if only one switch,
> instead of all
> 3) it would be nice to have all switch connections information.

Good catch. I will address this.

> In case ever the network is rerouted, this information will become
> useful; instead of having a tree representation of the network only.

I consider proposed implementation as transitional until enumeration
logic is reworked.
It already is an attempt to move towards a tree representation. Making
switch support 
available was given higher priority compared to other things needed for
RIO subsystem.  

Alex.


