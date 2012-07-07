Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755929Ab2GGATV (ORCPT <rfc822;w@1wt.eu>);
	Fri, 6 Jul 2012 20:19:21 -0400
Received: from webmail.solarflare.com ([12.187.104.25]:15999 "EHLO
	ocex02.SolarFlarecom.com" rhost-flags-OK-OK-OK-FAIL)
	by vger.kernel.org with ESMTP id S1752853Ab2GGATT (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 6 Jul 2012 20:19:19 -0400
Message-ID: <1341620355.2923.46.camel@bwh-desktop.uk.solarflarecom.com>
Subject: Re: [PATCH net,1/1] hyperv: Add support for setting MAC from within
 guests
From: Ben Hutchings <bhutchings@solarflare.com>
To: Haiyang Zhang <haiyangz@microsoft.com>
CC: <davem@davemloft.net>, <netdev@vger.kernel.org>, <kys@microsoft.com>,
        <olaf@aepfle.de>, <linux-kernel@vger.kernel.org>,
        <devel@linuxdriverproject.org>
Date: Sat, 7 Jul 2012 01:19:15 +0100
In-Reply-To: <1341609932-18971-1-git-send-email-haiyangz@microsoft.com>
References: <1341609932-18971-1-git-send-email-haiyangz@microsoft.com>
Organization: Solarflare Communications
Content-Type: text/plain; charset="UTF-8"
X-Mailer: Evolution 3.2.3 (3.2.3-1.fc16) 
Content-Transfer-Encoding: 7bit
MIME-Version: 1.0
X-Originating-IP: [10.17.20.137]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, 2012-07-06 at 14:25 -0700, Haiyang Zhang wrote:
> This adds support for setting synthetic NIC MAC address from within Linux
> guests. Before using this feature, the option "spoofing of MAC address"
> should be enabled at the Hyper-V manager / Settings of the synthetic
> NIC.
[...]
> +int rndis_filter_set_device_mac(struct hv_device *hdev, char *mac)
> +{
[...]
> +	t = wait_for_completion_timeout(&request->wait_event, 5*HZ);
> +	if (t == 0) {
> +		netdev_err(ndev, "timeout before we got a set response...\n");
> +		/*
> +		 * can't put_rndis_request, since we may still receive a
> +		 * send-completion.
> +		 */
> +		return -EBUSY;
> +	} else {
> +		set_complete = &request->response_msg.msg.set_complete;
> +		if (set_complete->status != RNDIS_STATUS_SUCCESS)
> +			ret = -EINVAL;
[...]

Is there a specific error code that indicates the hypervisor is
configured not to allow MAC address changes?  If so, shouldn't that be
translated to return EPERM rather than EINVAL?

Ben.

-- 
Ben Hutchings, Staff Engineer, Solarflare
Not speaking for my employer; that's the marketing department's job.
They asked us to note that Solarflare product names are trademarked.

