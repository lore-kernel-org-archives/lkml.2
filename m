Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933311Ab2GYOwE (ORCPT <rfc822;w@1wt.eu>);
	Wed, 25 Jul 2012 10:52:04 -0400
Received: from va3ehsobe004.messaging.microsoft.com ([216.32.180.14]:24633
	"EHLO va3outboundpool.messaging.microsoft.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S932943Ab2GYOwB convert rfc822-to-8bit
	(ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 25 Jul 2012 10:52:01 -0400
X-Forefront-Antispam-Report: CIP:131.107.125.8;KIP:(null);UIP:(null);IPV:NLI;H:TK5EX14HUBC105.redmond.corp.microsoft.com;RD:none;EFVD:NLI
X-SpamScore: -9
X-BigFish: VS-9(zz98dI9371I936eI542M1432Izz1202hzz8275bh8275dhz2fh2a8h683h839h944hd25hf0ah107ah)
X-Forefront-Antispam-Report-Untrusted: CIP:157.56.234.5;KIP:(null);UIP:(null);(null);H:SN2PRD0310HT002.namprd03.prod.outlook.com;R:internal;EFV:INT
From: KY Srinivasan <kys@microsoft.com>
To: Ben Hutchings <ben@decadent.org.uk>
CC: "gregkh@linuxfoundation.org" <gregkh@linuxfoundation.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "devel@linuxdriverproject.org" <devel@linuxdriverproject.org>,
        "virtualization@lists.osdl.org" <virtualization@lists.osdl.org>,
        "olaf@aepfle.de" <olaf@aepfle.de>,
        "apw@canonical.com" <apw@canonical.com>,
        "netdev@vger.kernel.org" <netdev@vger.kernel.org>
Subject: RE: [PATCH 03/17] Drivers: hv: kvp: Cleanup error handling in KVP
Thread-Topic: [PATCH 03/17] Drivers: hv: kvp: Cleanup error handling in KVP
Thread-Index: AQHNabOMVUyc1R5/kU2T3KG86DWCqpc5MToAgADZT6CAAArfgIAAAG4w
Date: Wed, 25 Jul 2012 14:51:43 +0000
Message-ID: <426367E2313C2449837CD2DE46E7EAF9236A8BEA@SN2PRD0310MB382.namprd03.prod.outlook.com>
References: <1343145672-3641-1-git-send-email-kys@microsoft.com>
 <1343145701-3691-1-git-send-email-kys@microsoft.com>
 <1343145701-3691-3-git-send-email-kys@microsoft.com>
 <1343178644.5132.103.camel@deadeye.wl.decadent.org.uk>
 <426367E2313C2449837CD2DE46E7EAF9236A8B61@SN2PRD0310MB382.namprd03.prod.outlook.com>
 <20120725144724.GD1894@decadent.org.uk>
In-Reply-To: <20120725144724.GD1894@decadent.org.uk>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
x-originating-ip: [108.24.39.100]
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 8BIT
MIME-Version: 1.0
X-OrganizationHeadersPreserved: SN2PRD0310HT002.namprd03.prod.outlook.com
X-FOPE-CONNECTOR: Id%0$Dn%*$RO%0$TLS%0$FQDN%$TlsDn%
X-FOPE-CONNECTOR: Id%59$Dn%DECADENT.ORG.UK$RO%2$TLS%6$FQDN%131.107.125.5$TlsDn%
X-FOPE-CONNECTOR: Id%59$Dn%LINUXFOUNDATION.ORG$RO%2$TLS%6$FQDN%131.107.125.5$TlsDn%
X-FOPE-CONNECTOR: Id%59$Dn%VGER.KERNEL.ORG$RO%2$TLS%6$FQDN%131.107.125.5$TlsDn%
X-FOPE-CONNECTOR: Id%59$Dn%LINUXDRIVERPROJECT.ORG$RO%2$TLS%6$FQDN%131.107.125.5$TlsDn%
X-FOPE-CONNECTOR: Id%59$Dn%LISTS.OSDL.ORG$RO%2$TLS%6$FQDN%131.107.125.5$TlsDn%
X-FOPE-CONNECTOR: Id%59$Dn%AEPFLE.DE$RO%2$TLS%6$FQDN%131.107.125.5$TlsDn%
X-FOPE-CONNECTOR: Id%59$Dn%CANONICAL.COM$RO%2$TLS%6$FQDN%131.107.125.5$TlsDn%
X-CrossPremisesHeadersPromoted: TK5EX14HUBC105.redmond.corp.microsoft.com
X-CrossPremisesHeadersFiltered: TK5EX14HUBC105.redmond.corp.microsoft.com
X-OriginatorOrg: microsoft.com
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org



> -----Original Message-----
> From: Ben Hutchings [mailto:ben@decadent.org.uk]
> Sent: Wednesday, July 25, 2012 10:47 AM
> To: KY Srinivasan
> Cc: gregkh@linuxfoundation.org; linux-kernel@vger.kernel.org;
> devel@linuxdriverproject.org; virtualization@lists.osdl.org; olaf@aepfle.de;
> apw@canonical.com; netdev@vger.kernel.org
> Subject: Re: [PATCH 03/17] Drivers: hv: kvp: Cleanup error handling in KVP
> 
> On Wed, Jul 25, 2012 at 02:10:05PM +0000, KY Srinivasan wrote:
> >
> >
> > > -----Original Message-----
> > > From: Ben Hutchings [mailto:ben@decadent.org.uk]
> > > Sent: Tuesday, July 24, 2012 9:11 PM
> > > To: KY Srinivasan
> > > Cc: gregkh@linuxfoundation.org; linux-kernel@vger.kernel.org;
> > > devel@linuxdriverproject.org; virtualization@lists.osdl.org; olaf@aepfle.de;
> > > apw@canonical.com; netdev@vger.kernel.org
> > > Subject: Re: [PATCH 03/17] Drivers: hv: kvp: Cleanup error handling in KVP
> > >
> > > On Tue, 2012-07-24 at 09:01 -0700, K. Y. Srinivasan wrote:
> > > > In preparation to implementing IP injection, cleanup the way we propagate
> > > > and handle errors both in the driver as well as in the user level daemon.
> > > >
> > > > Signed-off-by: K. Y. Srinivasan <kys@microsoft.com>
> > > > Reviewed-by: Haiyang Zhang <haiyangz@microsoft.com>
> > > > ---
> > > >  drivers/hv/hv_kvp.c      |  112
> +++++++++++++++++++++++++++++++++++++-
> > > --------
> > > >  include/linux/hyperv.h   |   17 +++++---
> > > >  tools/hv/hv_kvp_daemon.c |   70 +++++++++++++++-------------
> > > >  3 files changed, 138 insertions(+), 61 deletions(-)
> > > >
> > > > diff --git a/drivers/hv/hv_kvp.c b/drivers/hv/hv_kvp.c
> > > > index 0012eed..9b7fc4a 100644
> > > > --- a/drivers/hv/hv_kvp.c
> > > > +++ b/drivers/hv/hv_kvp.c
> > > [...]
> > > > @@ -109,27 +154,52 @@ kvp_cn_callback(struct cn_msg *msg, struct
> > > netlink_skb_parms *nsp)
> > > >  {
> > > >  	struct hv_kvp_msg *message;
> > > >  	struct hv_kvp_msg_enumerate *data;
> > > > +	int	error = 0;
> > > >
> > > >  	message = (struct hv_kvp_msg *)msg->data;
> > > > -	switch (message->kvp_hdr.operation) {
> > > > +
> > > > +	/*
> > > > +	 * If we are negotiating the version information
> > > > +	 * with the daemon; handle that first.
> > > > +	 */
> > > > +
> > > > +	if (in_hand_shake) {
> > > > +		if (kvp_handle_handshake(message))
> > > > +			in_hand_shake = false;
> > > > +		return;
> > > > +	}
> > > > +
> > > > +	/*
> > > > +	 * Based on the version of the daemon, we propagate errors from the
> > > > +	 * daemon differently.
> > > > +	 */
> > > > +
> > > > +	data = &message->body.kvp_enum_data;
> > > > +
> > > > +	switch (dm_reg_value) {
> > > >  	case KVP_OP_REGISTER:
> > > > -		pr_info("KVP: user-mode registering done.\n");
> > > > -		kvp_register();
> > > > -		kvp_transaction.active = false;
> > > > -		hv_kvp_onchannelcallback(kvp_transaction.kvp_context);
> > > > +		/*
> > > > +		 * Null string is used to pass back error condition.
> > > > +		 */
> > > > +		if (!strlen(data->data.key))
> > >
> > > Do we know that the key is null-terminated here?  Shouldn't we just
> > > check whether data->data.key[0] == 0?
> >
> > Yes, currently we do return null string to indicate error.
> [...]
> 
> So the kernel should assume userland input is always valid?

Good point! This is the existing code and this patch-set cleans up all
the error handling and would not have this problem.

K. Y



