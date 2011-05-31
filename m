Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753228Ab1EaAeZ (ORCPT <rfc822;w@1wt.eu>);
	Mon, 30 May 2011 20:34:25 -0400
Received: from db3ehsobe004.messaging.microsoft.com ([213.199.154.142]:44850
	"EHLO DB3EHSOBE004.bigfish.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751876Ab1EaAeX convert rfc822-to-8bit
	(ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 30 May 2011 20:34:23 -0400
X-SpamScore: -15
X-BigFish: VPS-15(zz9371M4015L542M1432Nzz1202hzz8275bh8275dha509lz32i668h839h61h)
X-Spam-TCS-SCL: 0:0
X-Forefront-Antispam-Report: CIP:163.181.249.109;KIP:(null);UIP:(null);IPVD:NLI;H:ausb3twp02.amd.com;RD:none;EFVD:NLI
X-WSS-ID: 0LM1AX1-02-6LT-02
X-M-MSG: 
X-MimeOLE: Produced By Microsoft Exchange V6.5
Content-Class: urn:content-classes:message
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 8BIT
Subject: RE: [PATCH] [RFC] usb: Broaden range of vendor codes for xhci
Date: Tue, 31 May 2011 08:34:12 +0800
Message-ID: <2DEEA3AB13739D45A22ADDB5086AEA0B016C1261@sshaexmb1.amd.com>
In-Reply-To: <1306749406-21124-1-git-send-email-m.b.lankhorst@gmail.com>
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
Thread-Topic: [PATCH] [RFC] usb: Broaden range of vendor codes for xhci
thread-index: Acwer/ZY7QiS8JarSeiR8CzK6ostiAAeXIaw
References: <1306749406-21124-1-git-send-email-m.b.lankhorst@gmail.com>
From: "Xu, Andiry" <Andiry.Xu@amd.com>
To: Maarten Lankhorst <m.b.lankhorst@gmail.com>, <linux-usb@vger.kernel.org>
CC: Sarah Sharp <sarah.a.sharp@linux.intel.com>,
        <linux-kernel@vger.kernel.org>
X-OriginalArrivalTime: 31 May 2011 00:34:16.0132 (UTC) FILETIME=[78B81840:01CC1F2A]
X-OriginatorOrg: amd.com
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

> -----Original Message-----
> From: linux-usb-owner@vger.kernel.org [mailto:linux-usb-
> owner@vger.kernel.org] On Behalf Of Maarten Lankhorst
> Sent: Monday, May 30, 2011 5:57 PM
> To: linux-usb@vger.kernel.org
> Cc: Sarah Sharp; linux-kernel@vger.kernel.org; Maarten Lankhorst
> Subject: [PATCH] [RFC] usb: Broaden range of vendor codes for xhci
> 
> My asrock P67 chipset sends code 192 on device reset. Allowing >= 192
> to be treated as success fixes it, and allows me to use my USB3 port.
> 

TRB completion code 192-223 is defined as Vendor defined error. Your
host
controller returns a error - don't know what causes the error since it's
vendor defined.

> Signed-off-by: Maarten Lankhorst <m.b.lankhorst@gmail.com>
> 
> ---
> There still appears to be a possible regression though. I can't
> currently use my usb headset, but since my xhci port never worked, I
> can't tell for sure if it ever worked.
> 
> Resending, forgot to add relevant maintainers.
> ---
>  drivers/usb/host/xhci-ring.c |    2 +-
>  1 files changed, 1 insertions(+), 1 deletions(-)
> 
> diff --git a/drivers/usb/host/xhci-ring.c b/drivers/usb/host/xhci-
> ring.c
> index 7437386..f8b9f79 100644
> --- a/drivers/usb/host/xhci-ring.c
> +++ b/drivers/usb/host/xhci-ring.c
> @@ -1464,7 +1464,7 @@ static int
> xhci_requires_manual_halt_cleanup(struct xhci_hcd *xhci,
> 
>  int xhci_is_vendor_info_code(struct xhci_hcd *xhci, unsigned int
> trb_comp_code)
>  {
> -	if (trb_comp_code >= 224 && trb_comp_code <= 255) {
> +	if (trb_comp_code >= 192 && trb_comp_code <= 255) {
>  		/* Vendor defined "informational" completion code,
>  		 * treat as not-an-error.
>  		 */
> --

You may need to create another function, maybe
xhci_is_vendor_error_code(),
because trb_comp_code between 192-223(Vendor Defined Error) and 224-255
(Vendor defined Info) has different meanings.

Thanks,
Andiry

> 1.7.4.1
> 
> --
> To unsubscribe from this list: send the line "unsubscribe linux-usb"
in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html


