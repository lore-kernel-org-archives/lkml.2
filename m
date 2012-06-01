Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758246Ab2FAT2A (ORCPT <rfc822;w@1wt.eu>);
	Fri, 1 Jun 2012 15:28:00 -0400
Received: from va3ehsobe005.messaging.microsoft.com ([216.32.180.31]:42073
	"EHLO va3outboundpool.messaging.microsoft.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1755085Ab2FAT16 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 1 Jun 2012 15:27:58 -0400
X-Forefront-Antispam-Report: CIP:131.107.125.8;KIP:(null);UIP:(null);IPV:NLI;H:TK5EX14HUBC105.redmond.corp.microsoft.com;RD:none;EFVD:NLI
X-SpamScore: -12
X-BigFish: VS-12(zz9371I542M1432Nzz1202hzz8275bh8275dhz2fh2a8h683h839h93fhd25hf0ah)
X-Forefront-Antispam-Report-Untrusted: CIP:157.56.234.5;KIP:(null);UIP:(null);(null);H:SN2PRD0310HT004.namprd03.prod.outlook.com;R:internal;EFV:INT
From: KY Srinivasan <kys@microsoft.com>
To: Olaf Hering <olaf@aepfle.de>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>
CC: "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Subject: RE: [PATCH] Tools: hv: verify origin of netlink connector message
Thread-Topic: [PATCH] Tools: hv: verify origin of netlink connector message
Thread-Index: AQHNPztaRH65TdyUHkiuG8hBEnFgg5bl2c1Q
Date: Fri, 1 Jun 2012 19:26:44 +0000
Message-ID: <426367E2313C2449837CD2DE46E7EAF90710C2A7@SN2PRD0310MB382.namprd03.prod.outlook.com>
References: <20120531144006.GA24592@aepfle.de>
In-Reply-To: <20120531144006.GA24592@aepfle.de>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
x-originating-ip: [131.107.174.42]
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
X-OrganizationHeadersPreserved: SN2PRD0310HT004.namprd03.prod.outlook.com
X-FOPE-CONNECTOR: Id%0$Dn%*$RO%0$TLS%0$FQDN%$TlsDn%
X-FOPE-CONNECTOR: Id%59$Dn%AEPFLE.DE$RO%2$TLS%6$FQDN%131.107.125.5$TlsDn%
X-FOPE-CONNECTOR: Id%59$Dn%LINUXFOUNDATION.ORG$RO%2$TLS%6$FQDN%131.107.125.5$TlsDn%
X-FOPE-CONNECTOR: Id%59$Dn%VGER.KERNEL.ORG$RO%2$TLS%6$FQDN%131.107.125.5$TlsDn%
X-CrossPremisesHeadersPromoted: TK5EX14HUBC105.redmond.corp.microsoft.com
X-CrossPremisesHeadersFiltered: TK5EX14HUBC105.redmond.corp.microsoft.com
X-OriginatorOrg: microsoft.com
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org
Content-Transfer-Encoding: 8bit
X-MIME-Autoconverted: from base64 to 8bit by nfs id q51JS5P7015549



> -----Original Message-----
> From: Olaf Hering [mailto:olaf@aepfle.de]
> Sent: Thursday, May 31, 2012 10:40 AM
> To: KY Srinivasan; Greg Kroah-Hartman
> Cc: linux-kernel@vger.kernel.org
> Subject: [PATCH] Tools: hv: verify origin of netlink connector message
> 
> The SuSE security team suggested to use recvfrom instead of recv to be
> certain that the connector message is originated from kernel.

Thanks Olaf.

> 
> Signed-off-by: Olaf Hering <olaf@aepfle.de>

Signed-off-by:  K. Y. Srinivasan <kys@microsoft.com>

> 
> ---
>  tools/hv/hv_kvp_daemon.c |   10 +++++++---
>  1 file changed, 7 insertions(+), 3 deletions(-)
> 
> Index: linux-3.4/tools/hv/hv_kvp_daemon.c
> ==============================================================
> =====
> --- linux-3.4.orig/tools/hv/hv_kvp_daemon.c
> +++ linux-3.4/tools/hv/hv_kvp_daemon.c
> @@ -701,14 +701,18 @@ int main(void)
>  	pfd.fd = fd;
> 
>  	while (1) {
> +		struct sockaddr *addr_p = (struct sockaddr *) &addr;
> +		socklen_t addr_l = sizeof(addr);
>  		pfd.events = POLLIN;
>  		pfd.revents = 0;
>  		poll(&pfd, 1, -1);
> 
> -		len = recv(fd, kvp_recv_buffer, sizeof(kvp_recv_buffer), 0);
> +		len = recvfrom(fd, kvp_recv_buffer, sizeof(kvp_recv_buffer), 0,
> +				addr_p, &addr_l);
> 
> -		if (len < 0) {
> -			syslog(LOG_ERR, "recv failed; error:%d", len);
> +		if (len < 0 || addr.nl_pid) {
> +			syslog(LOG_ERR, "recvfrom failed; pid:%u error:%d %s",
> +					addr.nl_pid, errno, strerror(errno));
>  			close(fd);
>  			return -1;
>  		}
> 
> 

ÿôèº{.nÇ+‰·Ÿ®‰­†+%ŠËÿ±éİ¶¥Šwÿº{.nÇ+‰·¥Š{±şG«éÿŠ{ayºÊ‡Ú™ë,j­¢f£¢·hšïêÿ‘êçz_è®(­éšŠİ¢j"ú¶m§ÿÿ¾«şG«éÿ¢¸?™¨è­Ú&£ø§~á¶iO•æ¬z·švØ^¶m§ÿÿÃÿ¶ìÿ¢¸?–I¥
