Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755583Ab2FGMkZ (ORCPT <rfc822;w@1wt.eu>);
	Thu, 7 Jun 2012 08:40:25 -0400
Received: from [213.199.154.207] ([213.199.154.207]:20180 "EHLO
	am1outboundpool.messaging.microsoft.com" rhost-flags-FAIL-FAIL-OK-OK)
	by vger.kernel.org with ESMTP id S1754682Ab2FGMkX convert rfc822-to-8bit
	(ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 7 Jun 2012 08:40:23 -0400
X-Forefront-Antispam-Report: CIP:131.107.125.8;KIP:(null);UIP:(null);IPV:NLI;H:TK5EX14MLTC104.redmond.corp.microsoft.com;RD:none;EFVD:NLI
X-SpamScore: -12
X-BigFish: VS-12(zz9371I542M1432Nzz1202hzz8275dhz2fh2a8h683h839h944hd25hf0ah)
X-Forefront-Antispam-Report-Untrusted: CIP:157.56.234.5;KIP:(null);UIP:(null);(null);H:SN2PRD0310HT002.namprd03.prod.outlook.com;R:internal;EFV:INT
From: KY Srinivasan <kys@microsoft.com>
To: Marcus Meissner <meissner@suse.de>,
        "gregkh@linuxfoundation.org" <gregkh@linuxfoundation.org>,
        "dan.carpenter@oracle.com" <dan.carpenter@oracle.com>,
        Haiyang Zhang <haiyangz@microsoft.com>,
        "jkosina@suse.cz" <jkosina@suse.cz>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "stable@kernel.org" <stable@kernel.org>
CC: Sebastian Krahmer <krahmer@suse.de>, Olaf Hering <ohering@suse.de>
Subject: RE: [PATCH] tools/hv: Check the source of netlink messages to be
 the kernel
Thread-Topic: [PATCH] tools/hv: Check the source of netlink messages to be
 the kernel
Thread-Index: AQHNRI0TkdJ4CpOrYUiatoQ4Ts2S7Zbuy3pg
Date: Thu, 7 Jun 2012 12:38:33 +0000
Message-ID: <426367E2313C2449837CD2DE46E7EAF90710DEB1@SN2PRD0310MB382.namprd03.prod.outlook.com>
References: <1339060068-19951-1-git-send-email-meissner@suse.de>
In-Reply-To: <1339060068-19951-1-git-send-email-meissner@suse.de>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
x-originating-ip: [173.61.53.133]
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 8BIT
MIME-Version: 1.0
X-OrganizationHeadersPreserved: SN2PRD0310HT002.namprd03.prod.outlook.com
X-FOPE-CONNECTOR: Id%0$Dn%*$RO%0$TLS%0$FQDN%$TlsDn%
X-FOPE-CONNECTOR: Id%59$Dn%LINUXFOUNDATION.ORG$RO%2$TLS%6$FQDN%131.107.125.5$TlsDn%
X-FOPE-CONNECTOR: Id%59$Dn%SUSE.CZ$RO%2$TLS%6$FQDN%131.107.125.5$TlsDn%
X-FOPE-CONNECTOR: Id%59$Dn%ORACLE.COM$RO%2$TLS%6$FQDN%131.107.125.5$TlsDn%
X-FOPE-CONNECTOR: Id%59$Dn%SUSE.DE$RO%2$TLS%6$FQDN%131.107.125.5$TlsDn%
X-FOPE-CONNECTOR: Id%59$Dn%VGER.KERNEL.ORG$RO%2$TLS%6$FQDN%131.107.125.5$TlsDn%
X-FOPE-CONNECTOR: Id%59$Dn%KERNEL.ORG$RO%2$TLS%6$FQDN%131.107.125.5$TlsDn%
X-CrossPremisesHeadersPromoted: TK5EX14MLTC104.redmond.corp.microsoft.com
X-CrossPremisesHeadersFiltered: TK5EX14MLTC104.redmond.corp.microsoft.com
X-OriginatorOrg: microsoft.com
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org



> -----Original Message-----
> From: Marcus Meissner [mailto:meissner@suse.de]
> Sent: Thursday, June 07, 2012 5:08 AM
> To: gregkh@linuxfoundation.org; KY Srinivasan; dan.carpenter@oracle.com;
> Haiyang Zhang; jkosina@suse.cz; linux-kernel@vger.kernel.org;
> stable@kernel.org
> Cc: Marcus Meissner; Sebastian Krahmer; Olaf Hering
> Subject: [PATCH] tools/hv: Check the source of netlink messages to be the kernel
> 
> Hi,
> 
> The hyper-v userspace helper daemon receives and handles netlink
> messages. It assumes them to be from the kernel, but does not check
> that.
> 
> This patch adds this checking (nl_pid == 0).
> 
> CVE-2012-2669
> 
> Ciao, Marcus
> 
> Signed-off-by: Marcus Meissner <meissner@suse.de>
> Signed-off-by: Sebastian Krahmer <krahmer@suse.de>
> Signed-off-by: Olaf Hering <ohering@suse.de>

Olaf already posted this patch and I signed off on it.

Regards,

K. Y
> ---
>  tools/hv/hv_kvp_daemon.c |    8 +++++---
>  1 file changed, 5 insertions(+), 3 deletions(-)
> 
> diff --git a/tools/hv/hv_kvp_daemon.c b/tools/hv/hv_kvp_daemon.c
> index 146fd61..f0566c8 100644
> --- a/tools/hv/hv_kvp_daemon.c
> +++ b/tools/hv/hv_kvp_daemon.c
> @@ -701,14 +701,16 @@ int main(void)
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
> addr_p, &addr_l);
> 
> -		if (len < 0) {
> -			syslog(LOG_ERR, "recv failed; error:%d", len);
> +		if (len < 0 || addr.nl_pid) {
> +			syslog(LOG_ERR, "recvfrom failed; pid:%u error:%d %s",
> addr.nl_pid, errno, strerror(errno));
>  			close(fd);
>  			return -1;
>  		}
> --
> 1.7.9.2
> 
> 
> 



