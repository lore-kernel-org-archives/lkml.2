Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752196Ab2KFPbP (ORCPT <rfc822;w@1wt.eu>);
	Tue, 6 Nov 2012 10:31:15 -0500
Received: from na01-by2-obe.ptr.protection.outlook.com ([207.46.100.23]:32732
	"EHLO na01-by2-obe.mail.protection.outlook.com"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1751326Ab2KFPbO (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 6 Nov 2012 10:31:14 -0500
X-Forefront-Antispam-Report-Untrusted: CIP:157.56.234.5;KIP:(null);UIP:(null);(null);H:SN2PRD0310HT002.namprd03.prod.outlook.com;R:internal;EFV:INT
X-SpamScore: -7
X-BigFish: PS-7(zz9371I542M1432Izz1de0h1202h1d1ah1d2ahzz8275bhz31h2a8h668h839h93fhd25hf0ah1288h12a5h12a9h12bdh137ah13b6h1441h1504h1537h153bh1155h)
From: KY Srinivasan <kys@microsoft.com>
To: Tomas Hozza <thozza@redhat.com>,
        "gregkh@linuxfoundation.org" <gregkh@linuxfoundation.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "devel@linuxdriverproject.org" <devel@linuxdriverproject.org>,
        "apw@canonical.com" <apw@canonical.com>,
        "jasowang@redhat.com" <jasowang@redhat.com>
CC: Olaf Hering <olaf@aepfle.de>
Subject: RE: [PATCH] tools/hv/hv_kvp_daemon.c: Netlink source address
 validation allows DoS
Thread-Topic: [PATCH] tools/hv/hv_kvp_daemon.c: Netlink source address
 validation allows DoS
Thread-Index: AQHNvDJ2n/qQZEYb3k68at4bTNkDfZfc7oFQ
Date: Tue, 6 Nov 2012 15:30:34 +0000
Message-ID: <426367E2313C2449837CD2DE46E7EAF930DFBAFA@SN2PRD0310MB382.namprd03.prod.outlook.com>
References: <456703059.7446523.1352215033661.JavaMail.root@redhat.com>
 <165383498.7447465.1352215261695.JavaMail.root@redhat.com>
In-Reply-To: <165383498.7447465.1352215261695.JavaMail.root@redhat.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
x-originating-ip: [98.110.61.144]
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
X-OrganizationHeadersPreserved: SN2PRD0310HT002.namprd03.prod.outlook.com
X-FOPE-CONNECTOR: Id%0$Dn%*$RO%0$TLS%0$FQDN%$TlsDn%
X-FOPE-CONNECTOR: Id%59$Dn%REDHAT.COM$RO%2$TLS%6$FQDN%131.107.125.5$TlsDn%
X-FOPE-CONNECTOR: Id%59$Dn%LINUXFOUNDATION.ORG$RO%2$TLS%6$FQDN%131.107.125.5$TlsDn%
X-FOPE-CONNECTOR: Id%59$Dn%VGER.KERNEL.ORG$RO%2$TLS%6$FQDN%131.107.125.5$TlsDn%
X-FOPE-CONNECTOR: Id%59$Dn%LINUXDRIVERPROJECT.ORG$RO%2$TLS%6$FQDN%131.107.125.5$TlsDn%
X-FOPE-CONNECTOR: Id%59$Dn%CANONICAL.COM$RO%2$TLS%6$FQDN%131.107.125.5$TlsDn%
X-FOPE-CONNECTOR: Id%59$Dn%AEPFLE.DE$RO%2$TLS%6$FQDN%131.107.125.5$TlsDn%
X-CrossPremisesHeadersPromoted: TK5EX14MLTC101.redmond.corp.microsoft.com
X-CrossPremisesHeadersFiltered: TK5EX14MLTC101.redmond.corp.microsoft.com
X-Forefront-Antispam-Report: CIP:131.107.125.37;CTRY:US;IPV:CAL;IPV:NLI;EFV:NLI;SFV:NSPM;SFS:(51704002)(13464001)(377454001)(23676001)(50986001)(47776002)(44976002)(50466001)(47976001)(5343635001)(4396001)(53806001)(31966008)(51856001)(74662001)(16676001)(6806001)(47736001)(54316001)(54356001)(46102001)(74502001)(76482001)(33656001)(49866001)(47446002);DIR:OUT;SFP:;LANG:en;
X-OriginatorOrg: microsoft.onmicrosoft.com
X-Forefront-PRVS: 0657D528EC
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org
Content-Transfer-Encoding: 8bit
X-MIME-Autoconverted: from base64 to 8bit by mail.home.local id qA6FVJMd015733



> -----Original Message-----
> From: Tomas Hozza [mailto:thozza@redhat.com]
> Sent: Tuesday, November 06, 2012 10:21 AM
> To: gregkh@linuxfoundation.org; linux-kernel@vger.kernel.org;
> devel@linuxdriverproject.org; apw@canonical.com; jasowang@redhat.com
> Cc: Olaf Hering; KY Srinivasan
> Subject: [PATCH] tools/hv/hv_kvp_daemon.c: Netlink source address validation
> allows DoS
> 
> Hi.
> 
> After discussion with KY Srinivasan and Olaf Hering I'm sending you
> a patch for the HyperV KVP daemon distributed in linux kernel
> "tools/hv/hv_kvp_daemon.c".
> 
> There is an issue in the current daemon source causing hyperv kvp daemon
> to exit when it processes a spoofed Netlink packet which has been sent
> from an untrusted local user.
> 
> This patch is fixing this, so now the Netlink messages with a non-zero
> nl_pid source address are just ignored.

You don't want to send the patch as an attachment.  Please send the patch
as part of the mail.

Regards,

K. Y
> 
> 
> Regards,
> 
> Tomas Hozza
> Associate Software Engineer
> BaseOS - Brno, CZ
ˇÙË∫{.n«+â∑üÆâ≠Ü+%äÀˇ±È›∂•äwˇ∫{.n«+â∑•ä{±˛G´ùÈˇä{ay∫ á⁄ôÎ,j≠¢f£¢∑höèÔÅÍˇëÍÁz_ËÆ(≠Èöéä›¢j"ù˙∂mßˇˇæ´˛G´ùÈˇ¢∏?ô®Ë≠⁄&£¯ß~è·∂iOïÊ¨z∑övÿ^∂mßˇˇ√ˇ∂Ïˇ¢∏?ñI•
