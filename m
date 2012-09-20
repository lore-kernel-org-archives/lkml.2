Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752198Ab2ITKRJ (ORCPT <rfc822;w@1wt.eu>);
	Thu, 20 Sep 2012 06:17:09 -0400
Received: from smtp.ctxuk.citrix.com ([62.200.22.115]:7849 "EHLO
	SMTP.EU.CITRIX.COM" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751199Ab2ITKRH (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 20 Sep 2012 06:17:07 -0400
X-IronPort-AV: E=Sophos;i="4.80,453,1344211200"; 
   d="scan'208";a="14651511"
Message-ID: <1348136222.26501.19.camel@zakaz.uk.xensource.com>
Subject: Re: [PATCH] arm: introduce a DTS for Xen unprivileged virtual
 machines
From: Ian Campbell <Ian.Campbell@citrix.com>
To: Stefano Stabellini <stefano.stabellini@eu.citrix.com>
CC: "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "xen-devel@lists.xensource.com" <xen-devel@lists.xensource.com>,
        "konrad.wilk@oracle.com" <konrad.wilk@oracle.com>,
        Pawel Moll <pawel.moll@arm.com>,
        "linux-arm-kernel@lists.infradead.org" 
	<linux-arm-kernel@lists.infradead.org>
Date: Thu, 20 Sep 2012 11:17:02 +0100
In-Reply-To: <1348076658-4511-1-git-send-email-stefano.stabellini@eu.citrix.com>
References: <1348076658-4511-1-git-send-email-stefano.stabellini@eu.citrix.com>
Organization: Citrix Systems, Inc.
Content-Type: text/plain; charset="UTF-8"
X-Mailer: Evolution 3.4.3-1 
MIME-Version: 1.0
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 2012-09-19 at 18:44 +0100, Stefano Stabellini wrote:
> +/include/ "skeleton.dtsi"
> +
> +/ {
> +	model = "XENVM-4.2";

Why the shouty caps?

Did you mean 4.3 here and throughout?

> +	compatible = "xen,xenvm-4.2", "arm,vexpress";

Is this second compatible thing actually true? We don't actually emulate
much (anything?) of what would be on a real vexpress motherboard.

"arm,vexpress" is used only in v2m.c and I don't think we want the
majority of that -- we don't provide any of the peripherals which it
registers.

I think the only things we might want out of that lot are the arch timer
and perhaps the uart0 (as a debug port).

I suspect we should have our own xen machine .c.

[...]
> +	gic: interrupt-controller@2c001000 {
> +		compatible = "arm,cortex-a9-gic";

Don't we mean "arm,cortex-a15-gic" here? That's what we actually
provide. I'm not sure how the a9 and a15 differ.

> +		#interrupt-cells = <3>;
> +		#address-cells = <0>;
> +		interrupt-controller;
> +		reg = <0x2c001000 0x1000>,
> +		      <0x2c002000 0x100>;
> +	};
> +

Ian.

