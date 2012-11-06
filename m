Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752853Ab2KFUBZ (ORCPT <rfc822;w@1wt.eu>);
	Tue, 6 Nov 2012 15:01:25 -0500
Received: from na01-by2-obe.ptr.protection.outlook.com ([207.46.100.28]:22655
	"EHLO na01-by2-obe.mail.protection.outlook.com"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1752744Ab2KFUBV (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 6 Nov 2012 15:01:21 -0500
X-Forefront-Antispam-Report-Untrusted: CIP:157.56.234.5;KIP:(null);UIP:(null);(null);H:SN2PRD0310HT003.namprd03.prod.outlook.com;R:internal;EFV:INT
X-SpamScore: -7
X-BigFish: PS-7(zz9371I542M1432Izz1de0h1202h1d1ah1d2ahzz8275bhz31h2a8h668h839h93fhd25hf0ah1288h12a5h12a9h12bdh137ah13b6h1441h1504h1537h153bh1155h)
From: KY Srinivasan <kys@microsoft.com>
To: Tomas Hozza <thozza@redhat.com>
CC: Olaf Hering <olaf@aepfle.de>,
        "gregkh@linuxfoundation.org" <gregkh@linuxfoundation.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "devel@linuxdriverproject.org" <devel@linuxdriverproject.org>,
        "apw@canonical.com" <apw@canonical.com>,
        "jasowang@redhat.com" <jasowang@redhat.com>
Subject: RE: [PATCH] tools/hv/hv_kvp_daemon.c: Netlink source address
 validation allows DoS
Thread-Topic: [PATCH] tools/hv/hv_kvp_daemon.c: Netlink source address
 validation allows DoS
Thread-Index: AQHNvDJ2n/qQZEYb3k68at4bTNkDfZfc7oFQgABKPYCAAAB/0A==
Date: Tue, 6 Nov 2012 19:58:40 +0000
Message-ID: <426367E2313C2449837CD2DE46E7EAF930DFBCEC@SN2PRD0310MB382.namprd03.prod.outlook.com>
References: <426367E2313C2449837CD2DE46E7EAF930DFBAFA@SN2PRD0310MB382.namprd03.prod.outlook.com>
 <1002964725.7541965.1352231685241.JavaMail.root@redhat.com>
In-Reply-To: <1002964725.7541965.1352231685241.JavaMail.root@redhat.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
x-originating-ip: [98.110.61.144]
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
X-OrganizationHeadersPreserved: SN2PRD0310HT003.namprd03.prod.outlook.com
X-FOPE-CONNECTOR: Id%0$Dn%*$RO%0$TLS%0$FQDN%$TlsDn%
X-FOPE-CONNECTOR: Id%59$Dn%REDHAT.COM$RO%2$TLS%6$FQDN%131.107.125.5$TlsDn%
X-FOPE-CONNECTOR: Id%59$Dn%AEPFLE.DE$RO%2$TLS%6$FQDN%131.107.125.5$TlsDn%
X-FOPE-CONNECTOR: Id%59$Dn%LINUXFOUNDATION.ORG$RO%2$TLS%6$FQDN%131.107.125.5$TlsDn%
X-FOPE-CONNECTOR: Id%59$Dn%VGER.KERNEL.ORG$RO%2$TLS%6$FQDN%131.107.125.5$TlsDn%
X-FOPE-CONNECTOR: Id%59$Dn%LINUXDRIVERPROJECT.ORG$RO%2$TLS%6$FQDN%131.107.125.5$TlsDn%
X-FOPE-CONNECTOR: Id%59$Dn%CANONICAL.COM$RO%2$TLS%6$FQDN%131.107.125.5$TlsDn%
X-CrossPremisesHeadersPromoted: TK5EX14HUBC104.redmond.corp.microsoft.com
X-CrossPremisesHeadersFiltered: TK5EX14HUBC104.redmond.corp.microsoft.com
X-Forefront-Antispam-Report: CIP:131.107.125.37;CTRY:US;IPV:CAL;IPV:NLI;EFV:NLI;SFV:NSPM;SFS:(377454001)(13464001)(51704002)(16676001)(46102001)(33656001)(76482001)(4396001)(23676001)(6806001)(5343635001)(54356001)(31966008)(47776002)(49866001)(47446002)(50986001)(54316001)(74502001)(47736001)(44976002)(74662001)(47976001)(50466001)(51856001)(53806001);DIR:OUT;SFP:;LANG:en;
X-OriginatorOrg: microsoft.onmicrosoft.com
X-Forefront-PRVS: 0657D528EC
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org
Content-Transfer-Encoding: 8bit
X-MIME-Autoconverted: from base64 to 8bit by mail.home.local id qA6K1UgE016750



> -----Original Message-----
> From: Tomas Hozza [mailto:thozza@redhat.com]
> Sent: Tuesday, November 06, 2012 2:55 PM
> To: KY Srinivasan
> Cc: Olaf Hering; gregkh@linuxfoundation.org; linux-kernel@vger.kernel.org;
> devel@linuxdriverproject.org; apw@canonical.com; jasowang@redhat.com
> Subject: Re: [PATCH] tools/hv/hv_kvp_daemon.c: Netlink source address
> validation allows DoS
> 
> From 6199072f8131056efce208f04e6985d1f9968d8e Mon Sep 17 00:00:00 2001
> From: Tomas Hozza <thozza@redhat.com>
> Date: Mon, 5 Nov 2012 10:08:16 +0100
> Subject: [PATCH] Netlink source address validation allows DoS
> 
> The source code without this patch caused hypervkvpd to exit when it processed
> a spoofed Netlink packet which has been sent from an untrusted local user.
> Netlink messages with a non-zero nl_pid source address should just be ignored.

Thomas,

You need a Signed-off-by line. Please refer to the documentation on how to submit a patch.

Regards,

K. Y
> ---
>  tools/hv/hv_kvp_daemon.c | 8 +++++++-
>  1 file changed, 7 insertions(+), 1 deletion(-)
> 
> diff --git a/tools/hv/hv_kvp_daemon.c b/tools/hv/hv_kvp_daemon.c
> index 3ea3af2..7d74497 100755
> --- a/tools/hv/hv_kvp_daemon.c
> +++ b/tools/hv/hv_kvp_daemon.c
> @@ -1478,13 +1478,19 @@ int main(void)
>  		len = recvfrom(fd, kvp_recv_buffer, sizeof(kvp_recv_buffer), 0,
>  				addr_p, &addr_l);
> 
> -		if (len < 0 || addr.nl_pid) {
> +		if (len < 0) {
>  			syslog(LOG_ERR, "recvfrom failed; pid:%u error:%d %s",
>  					addr.nl_pid, errno, strerror(errno));
>  			close(fd);
>  			return -1;
>  		}
> 
> +		if (addr.nl_pid) {
> +			syslog(LOG_WARNING, "Received packet from untrusted
> pid:%u",
> +					addr.nl_pid);
> +			continue;
> +		}
> +
>  		incoming_msg = (struct nlmsghdr *)kvp_recv_buffer;
>  		incoming_cn_msg = (struct cn_msg
> *)NLMSG_DATA(incoming_msg);
>  		hv_msg = (struct hv_kvp_msg *)incoming_cn_msg->data;
> --
> 1.7.11.7
> 
> ----- Original Message -----
> >
> >
> > > -----Original Message-----
> > > From: Tomas Hozza [mailto:thozza@redhat.com]
> > > Sent: Tuesday, November 06, 2012 10:21 AM
> > > To: gregkh@linuxfoundation.org; linux-kernel@vger.kernel.org;
> > > devel@linuxdriverproject.org; apw@canonical.com;
> > > jasowang@redhat.com
> > > Cc: Olaf Hering; KY Srinivasan
> > > Subject: [PATCH] tools/hv/hv_kvp_daemon.c: Netlink source address
> > > validation
> > > allows DoS
> > >
> > > Hi.
> > >
> > > After discussion with KY Srinivasan and Olaf Hering I'm sending you
> > > a patch for the HyperV KVP daemon distributed in linux kernel
> > > "tools/hv/hv_kvp_daemon.c".
> > >
> > > There is an issue in the current daemon source causing hyperv kvp
> > > daemon
> > > to exit when it processes a spoofed Netlink packet which has been
> > > sent
> > > from an untrusted local user.
> > >
> > > This patch is fixing this, so now the Netlink messages with a
> > > non-zero
> > > nl_pid source address are just ignored.
> >
> > You don't want to send the patch as an attachment.  Please send the
> > patch
> > as part of the mail.
> >
> > Regards,
> >
> > K. Y
> > >
> > >
> > > Regards,
> > >
> > > Tomas Hozza
> > > Associate Software Engineer
> > > BaseOS - Brno, CZ
> >
> 

ˇÙË∫{.n«+â∑üÆâ≠Ü+%äÀˇ±È›∂•äwˇ∫{.n«+â∑•ä{±˛G´ùÈˇä{ay∫ á⁄ôÎ,j≠¢f£¢∑höèÔÅÍˇëÍÁz_ËÆ(≠Èöéä›¢j"ù˙∂mßˇˇæ´˛G´ùÈˇ¢∏?ô®Ë≠⁄&£¯ß~è·∂iOïÊ¨z∑övÿ^∂mßˇˇ√ˇ∂Ïˇ¢∏?ñI•
