Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756473Ab2GJRED (ORCPT <rfc822;w@1wt.eu>);
	Tue, 10 Jul 2012 13:04:03 -0400
Received: from ch1ehsobe006.messaging.microsoft.com ([216.32.181.186]:39073
	"EHLO ch1outboundpool.messaging.microsoft.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1756293Ab2GJREA (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 10 Jul 2012 13:04:00 -0400
X-Forefront-Antispam-Report: CIP:131.107.125.8;KIP:(null);UIP:(null);IPV:NLI;H:TK5EX14MLTC102.redmond.corp.microsoft.com;RD:none;EFVD:NLI
X-SpamScore: -10
X-BigFish: VS-10(zz98dI9371I936eI542M1432I4015Izz1202hzz8275dhz2fh2a8h668h839h93fhd25hf0ah107ah)
From: Haiyang Zhang <haiyangz@microsoft.com>
To: Ben Hutchings <bhutchings@solarflare.com>
CC: "davem@davemloft.net" <davem@davemloft.net>,
        "netdev@vger.kernel.org" <netdev@vger.kernel.org>,
        KY Srinivasan <kys@microsoft.com>, "olaf@aepfle.de" <olaf@aepfle.de>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "devel@linuxdriverproject.org" <devel@linuxdriverproject.org>
Subject: RE: [PATCH net,1/1] hyperv: Add support for setting MAC from within
 guests
Thread-Topic: [PATCH net,1/1] hyperv: Add support for setting MAC from
 within guests
Thread-Index: AQHNW7v2NmSg3uaojEi/HXuJHHO9xZcc9NCAgAXN8rA=
Date: Tue, 10 Jul 2012 17:03:53 +0000
Message-ID: <A1F3067C9B68744AA19F6802BAB8FFDC0DDC8C5E@TK5EX14MBXC222.redmond.corp.microsoft.com>
References: <1341609932-18971-1-git-send-email-haiyangz@microsoft.com>
 <1341620355.2923.46.camel@bwh-desktop.uk.solarflarecom.com>
In-Reply-To: <1341620355.2923.46.camel@bwh-desktop.uk.solarflarecom.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
x-originating-ip: [157.54.51.72]
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
X-OriginatorOrg: microsoft.com
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org
Content-Transfer-Encoding: 8bit
X-MIME-Autoconverted: from base64 to 8bit by nfs id q6AH4KCt024895



> -----Original Message-----
> From: Ben Hutchings [mailto:bhutchings@solarflare.com]
> Sent: Friday, July 06, 2012 8:19 PM
> To: Haiyang Zhang
> Cc: davem@davemloft.net; netdev@vger.kernel.org; KY Srinivasan;
> olaf@aepfle.de; linux-kernel@vger.kernel.org;
> devel@linuxdriverproject.org
> Subject: Re: [PATCH net,1/1] hyperv: Add support for setting MAC from
> within guests
> 
> On Fri, 2012-07-06 at 14:25 -0700, Haiyang Zhang wrote:
> > This adds support for setting synthetic NIC MAC address from within
> Linux
> > guests. Before using this feature, the option "spoofing of MAC
> address"
> > should be enabled at the Hyper-V manager / Settings of the synthetic
> > NIC.
> [...]
> > +int rndis_filter_set_device_mac(struct hv_device *hdev, char *mac)
> > +{
> [...]
> > +	t = wait_for_completion_timeout(&request->wait_event, 5*HZ);
> > +	if (t == 0) {
> > +		netdev_err(ndev, "timeout before we got a set
> response...\n");
> > +		/*
> > +		 * can't put_rndis_request, since we may still receive a
> > +		 * send-completion.
> > +		 */
> > +		return -EBUSY;
> > +	} else {
> > +		set_complete = &request->response_msg.msg.set_complete;
> > +		if (set_complete->status != RNDIS_STATUS_SUCCESS)
> > +			ret = -EINVAL;
> [...]
> 
> Is there a specific error code that indicates the hypervisor is
> configured not to allow MAC address changes?  If so, shouldn't that be
> translated to return EPERM rather than EINVAL?

I have check the return code, 0xc000000d, which is returned both when MAC
spoofing is not enabled or the parameter contains other errors. So we can't
tell if it permission error or not. I will re-submit this patch still
using EINVAL.

Thanks,
- Haiyang

ÿôèº{.nÇ+‰·Ÿ®‰­†+%ŠËÿ±éİ¶¥Šwÿº{.nÇ+‰·¥Š{±şG«éÿŠ{ayºÊ‡Ú™ë,j­¢f£¢·hšïêÿ‘êçz_è®(­éšŠİ¢j"ú¶m§ÿÿ¾«şG«éÿ¢¸?™¨è­Ú&£ø§~á¶iO•æ¬z·švØ^¶m§ÿÿÃÿ¶ìÿ¢¸?–I¥
