Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754387Ab2GNXRo (ORCPT <rfc822;w@1wt.eu>);
	Sat, 14 Jul 2012 19:17:44 -0400
Received: from co1ehsobe003.messaging.microsoft.com ([216.32.180.186]:18652
	"EHLO co1outboundpool.messaging.microsoft.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751421Ab2GNXRj convert rfc822-to-8bit
	(ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sat, 14 Jul 2012 19:17:39 -0400
X-Forefront-Antispam-Report: CIP:131.107.125.8;KIP:(null);UIP:(null);IPV:NLI;H:TK5EX14HUBC102.redmond.corp.microsoft.com;RD:none;EFVD:NLI
X-SpamScore: -8
X-BigFish: VS-8(zz98dI9371I542M1432Izz1202hzz8275bhz2fh2a8h683h839h944hd25hf0ah107ah)
X-Forefront-Antispam-Report-Untrusted: CIP:157.56.234.5;KIP:(null);UIP:(null);(null);H:SN2PRD0310HT005.namprd03.prod.outlook.com;R:internal;EFV:INT
From: KY Srinivasan <kys@microsoft.com>
To: richard -rw- weinberger <richard.weinberger@gmail.com>
CC: "gregkh@linuxfoundation.org" <gregkh@linuxfoundation.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "devel@linuxdriverproject.org" <devel@linuxdriverproject.org>,
        "virtualization@lists.osdl.org" <virtualization@lists.osdl.org>,
        "olaf@aepfle.de" <olaf@aepfle.de>,
        "apw@canonical.com" <apw@canonical.com>
Subject: RE: [PATCH 12/15] Tools: hv: Gather DHCP information
Thread-Topic: [PATCH 12/15] Tools: hv: Gather DHCP information
Thread-Index: AQHNYgGF7jiaahmUC0aSkRp0zhyJApcpTXIAgAAWAFA=
Date: Sat, 14 Jul 2012 23:02:24 +0000
Message-ID: <426367E2313C2449837CD2DE46E7EAF9223B7004@SN2PRD0310MB382.namprd03.prod.outlook.com>
References: <1342297930-12607-1-git-send-email-kys@microsoft.com>
	<1342298060-12662-1-git-send-email-kys@microsoft.com>
	<1342298060-12662-12-git-send-email-kys@microsoft.com>
 <CAFLxGvxkidfN+o8yFsmGm8-YhT4Q5dgzQOAJJXnM=nXoXVpqTA@mail.gmail.com>
In-Reply-To: <CAFLxGvxkidfN+o8yFsmGm8-YhT4Q5dgzQOAJJXnM=nXoXVpqTA@mail.gmail.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
x-originating-ip: [173.61.179.128]
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 8BIT
MIME-Version: 1.0
X-OrganizationHeadersPreserved: SN2PRD0310HT005.namprd03.prod.outlook.com
X-FOPE-CONNECTOR: Id%0$Dn%*$RO%0$TLS%0$FQDN%$TlsDn%
X-FOPE-CONNECTOR: Id%59$Dn%GMAIL.COM$RO%2$TLS%6$FQDN%131.107.125.5$TlsDn%
X-FOPE-CONNECTOR: Id%59$Dn%LINUXFOUNDATION.ORG$RO%2$TLS%6$FQDN%131.107.125.5$TlsDn%
X-FOPE-CONNECTOR: Id%59$Dn%VGER.KERNEL.ORG$RO%2$TLS%6$FQDN%131.107.125.5$TlsDn%
X-FOPE-CONNECTOR: Id%59$Dn%LINUXDRIVERPROJECT.ORG$RO%2$TLS%6$FQDN%131.107.125.5$TlsDn%
X-FOPE-CONNECTOR: Id%59$Dn%LISTS.OSDL.ORG$RO%2$TLS%6$FQDN%131.107.125.5$TlsDn%
X-FOPE-CONNECTOR: Id%59$Dn%AEPFLE.DE$RO%2$TLS%6$FQDN%131.107.125.5$TlsDn%
X-FOPE-CONNECTOR: Id%59$Dn%CANONICAL.COM$RO%2$TLS%6$FQDN%131.107.125.5$TlsDn%
X-CrossPremisesHeadersPromoted: TK5EX14HUBC102.redmond.corp.microsoft.com
X-CrossPremisesHeadersFiltered: TK5EX14HUBC102.redmond.corp.microsoft.com
X-OriginatorOrg: microsoft.com
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org



> -----Original Message-----
> From: richard -rw- weinberger [mailto:richard.weinberger@gmail.com]
> Sent: Saturday, July 14, 2012 5:37 PM
> To: KY Srinivasan
> Cc: gregkh@linuxfoundation.org; linux-kernel@vger.kernel.org;
> devel@linuxdriverproject.org; virtualization@lists.osdl.org; olaf@aepfle.de;
> apw@canonical.com
> Subject: Re: [PATCH 12/15] Tools: hv: Gather DHCP information
> 
> On Sat, Jul 14, 2012 at 10:34 PM, K. Y. Srinivasan <kys@microsoft.com> wrote:
> > Collect information on dhcp setting for the specified interface.
> > We invoke an exyernal script to get this information.
> >
> > Signed-off-by: K. Y. Srinivasan <kys@microsoft.com>
> > Reviewed-by: Haiyang Zhang <haiyangz@microsoft.com>
> > ---
> >  tools/hv/hv_kvp_daemon.c |   33 +++++++++++++++++++++++++++++++++
> >  1 files changed, 33 insertions(+), 0 deletions(-)
> >
> > diff --git a/tools/hv/hv_kvp_daemon.c b/tools/hv/hv_kvp_daemon.c
> > index a81ce67..c510283 100644
> > --- a/tools/hv/hv_kvp_daemon.c
> > +++ b/tools/hv/hv_kvp_daemon.c
> > @@ -524,6 +524,9 @@ static void kvp_get_ipconfig_info(char *if_name,
> >                                  struct hv_kvp_ipaddr_value *buffer)
> >  {
> >         char cmd[512];
> > +       char dhcp_info[128];
> > +       char *p;
> > +       FILE *file;
> >
> >         /*
> >          * Get the address of default gateway (ipv4).
> > @@ -580,6 +583,36 @@ static void kvp_get_ipconfig_info(char *if_name,
> >          */
> >         kvp_process_ipconfig_file(cmd, (char *)buffer->dns_addr,
> >                                 (MAX_IP_ADDR_SIZE * 2), INET_ADDRSTRLEN, 0);
> > +
> > +       /*
> > +        * Gather the DHCP state.
> > +        * We will gather this state by invoking an external script.
> > +        * The parameter to the script is the interface name.
> > +        * Here is the expected output:
> > +        *
> > +        * Enabled: DHCP enabled.
> > +        */
> > +
> > +       memset(cmd, 0, 512);
> 
> Why not sizeof(cmd)?

I have a bunch of other cleanups lined up for this user level daemon. If it is
ok with you, I could address this as part of that patch set. However, if 
there are more substantive changes needed in this patch-set, I will
also address this. 

Thank you,

K. Y



