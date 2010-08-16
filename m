Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754558Ab0HPOrv (ORCPT <rfc822;w@1wt.eu>);
	Mon, 16 Aug 2010 10:47:51 -0400
Received: from mxout1.idt.com ([157.165.5.25]:47987 "EHLO mxout1.idt.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754539Ab0HPOru convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 16 Aug 2010 10:47:50 -0400
X-MimeOLE: Produced By Microsoft Exchange V6.5
Content-class: urn:content-classes:message
MIME-Version: 1.0
Content-Type: text/plain;
	charset="us-ascii"
Content-Transfer-Encoding: 8BIT
Subject: RE: [PATCH 5/9] RapidIO: Add default handler for error_stopped state
Date: Mon, 16 Aug 2010 07:47:18 -0700
Message-ID: <0CE8B6BE3C4AD74AB97D9D29BD24E552011D5F71@CORPEXCH1.na.ads.idt.com>
In-Reply-To: <4C692D4D.1030401@neli.hopto.org>
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
thread-topic: [PATCH 5/9] RapidIO: Add default handler for error_stopped state
thread-index: Acs9PTDlN7R3QHFvSWK4xhBF5h3sdgAFEDWA
References: <1281712686-31308-1-git-send-email-alexandre.bounine@idt.com> <1281712686-31308-6-git-send-email-alexandre.bounine@idt.com> <4C692D4D.1030401@neli.hopto.org>
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
> Alexandre Bounine wrote:
> > +
> > +	if (err_status & RIO_PORT_N_ERR_STS_PW_OUT_ES) {
> > +		pr_debug("RIO_EM: servicing Output Error-Stopped
state\n");
> > +		/*
> > +		 * Send a Link-Request/Input-Status control symbol
> > +		 */
> > +
> > +		/* Read from link maintenance response register
> > +		 * to clear valid bit */
> > +		rio_mport_read_config_32(mport, destid, hopcount,
> > +			rdev->phys_efptr + RIO_PORT_N_MNT_RSP_CSR(pnum),
> > +			&regval);
> > +		udelay(50);
> 
> Perhaps this whole part of operating the MNT_RSP registers (sending
> link-request symbol is the only useful action IIRC?) can be put in a
> separate function for readability.
> 
I was on the fence with this one. Now I have an extra vote in favor of a
separate function ;)
Will do.
 
