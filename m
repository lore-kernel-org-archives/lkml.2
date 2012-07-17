Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755992Ab2GQRka (ORCPT <rfc822;w@1wt.eu>);
	Tue, 17 Jul 2012 13:40:30 -0400
Received: from tx2ehsobe004.messaging.microsoft.com ([65.55.88.14]:23229 "EHLO
	tx2outboundpool.messaging.microsoft.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751109Ab2GQRk1 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 17 Jul 2012 13:40:27 -0400
X-Forefront-Antispam-Report: CIP:131.107.125.8;KIP:(null);UIP:(null);IPV:NLI;H:TK5EX14MLTC103.redmond.corp.microsoft.com;RD:none;EFVD:NLI
X-SpamScore: -8
X-BigFish: VS-8(zz98dI9371I542M1432Izz1202hzz8275bhz2fh2a8h683h839h93fhd25hf0ah107ah)
X-Forefront-Antispam-Report-Untrusted: CIP:157.56.234.5;KIP:(null);UIP:(null);(null);H:SN2PRD0310HT004.namprd03.prod.outlook.com;R:internal;EFV:INT
From: KY Srinivasan <kys@microsoft.com>
To: Olaf Hering <olaf@aepfle.de>
CC: "gregkh@linuxfoundation.org" <gregkh@linuxfoundation.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "devel@linuxdriverproject.org" <devel@linuxdriverproject.org>,
        "apw@canonical.com" <apw@canonical.com>
Subject: RE: [PATCH 02/15] Drivers: hv: Add KVP definitions for IP address
 injection
Thread-Topic: [PATCH 02/15] Drivers: hv: Add KVP definitions for IP address
 injection
Thread-Index: AQHNYf4QnjbEKHKtJUqIqRriKjZpOZcs39yAgAChiDA=
Date: Tue, 17 Jul 2012 17:39:44 +0000
Message-ID: <426367E2313C2449837CD2DE46E7EAF9224EA2D3@SN2PRD0310MB382.namprd03.prod.outlook.com>
References: <1342297930-12607-1-git-send-email-kys@microsoft.com>
 <1342298060-12662-1-git-send-email-kys@microsoft.com>
 <1342298060-12662-2-git-send-email-kys@microsoft.com>
 <20120717040912.GA6369@aepfle.de>
In-Reply-To: <20120717040912.GA6369@aepfle.de>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
x-originating-ip: [108.24.39.100]
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
X-OrganizationHeadersPreserved: SN2PRD0310HT004.namprd03.prod.outlook.com
X-FOPE-CONNECTOR: Id%0$Dn%*$RO%0$TLS%0$FQDN%$TlsDn%
X-FOPE-CONNECTOR: Id%59$Dn%AEPFLE.DE$RO%2$TLS%6$FQDN%131.107.125.5$TlsDn%
X-FOPE-CONNECTOR: Id%59$Dn%LINUXFOUNDATION.ORG$RO%2$TLS%6$FQDN%131.107.125.5$TlsDn%
X-FOPE-CONNECTOR: Id%59$Dn%VGER.KERNEL.ORG$RO%2$TLS%6$FQDN%131.107.125.5$TlsDn%
X-FOPE-CONNECTOR: Id%59$Dn%LINUXDRIVERPROJECT.ORG$RO%2$TLS%6$FQDN%131.107.125.5$TlsDn%
X-FOPE-CONNECTOR: Id%59$Dn%CANONICAL.COM$RO%2$TLS%6$FQDN%131.107.125.5$TlsDn%
X-CrossPremisesHeadersPromoted: TK5EX14MLTC103.redmond.corp.microsoft.com
X-CrossPremisesHeadersFiltered: TK5EX14MLTC103.redmond.corp.microsoft.com
X-OriginatorOrg: microsoft.com
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org
Content-Transfer-Encoding: 8bit
X-MIME-Autoconverted: from base64 to 8bit by nfs id q6HHeaMA003618



> -----Original Message-----
> From: Olaf Hering [mailto:olaf@aepfle.de]
> Sent: Tuesday, July 17, 2012 12:09 AM
> To: KY Srinivasan
> Cc: gregkh@linuxfoundation.org; linux-kernel@vger.kernel.org;
> devel@linuxdriverproject.org; apw@canonical.com
> Subject: Re: [PATCH 02/15] Drivers: hv: Add KVP definitions for IP address
> injection
> 
> On Sat, Jul 14, K. Y. Srinivasan wrote:
> 
> > diff --git a/include/linux/hyperv.h b/include/linux/hyperv.h
> > index 68ed7f7..38b561a 100644
> > --- a/include/linux/hyperv.h
> > +++ b/include/linux/hyperv.h
> > @@ -127,6 +127,8 @@ enum hv_kvp_exchg_op {
> >  	KVP_OP_SET,
> >  	KVP_OP_DELETE,
> >  	KVP_OP_ENUMERATE,
> > +	KVP_OP_GET_IP_INFO,
> > +	KVP_OP_SET_IP_INFO,
> >  	KVP_OP_REGISTER,
> >  	KVP_OP_COUNT /* Number of operations, must be last. */
> >  };
> 
> I think this will break the kernel/daemon API for existing binaries.
> Perhaps a forward/backwards compatible API where an older binary
> continues to work with a newer kernel should be added.

You are right. If I were to keep the existing op codes unchanged, I think we can 
maintain backward compatibility - older daemon binaries will be able to function
correctly on newer KVP driver. However, newer daemon binary will require a 
matching KVP driver. Let me first validate what I think is the case. Greg, please drop
the patch-set; I will resubmit the set.

Regards,

K. Y
ÿôèº{.nÇ+‰·Ÿ®‰­†+%ŠËÿ±éİ¶¥Šwÿº{.nÇ+‰·¥Š{±şG«éÿŠ{ayºÊ‡Ú™ë,j­¢f£¢·hšïêÿ‘êçz_è®(­éšŠİ¢j"ú¶m§ÿÿ¾«şG«éÿ¢¸?™¨è­Ú&£ø§~á¶iO•æ¬z·švØ^¶m§ÿÿÃÿ¶ìÿ¢¸?–I¥
