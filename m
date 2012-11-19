Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751807Ab2KSKk5 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 19 Nov 2012 05:40:57 -0500
Received: from smtp.eu.citrix.com ([46.33.159.39]:53785 "EHLO
	SMTP.EU.CITRIX.COM" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751429Ab2KSKk4 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 19 Nov 2012 05:40:56 -0500
X-Greylist: delayed 578 seconds by postgrey-1.27 at vger.kernel.org; Mon, 19 Nov 2012 05:40:56 EST
X-IronPort-AV: E=Sophos;i="4.83,278,1352073600"; 
   d="scan'208";a="15874730"
Message-ID: <1353321075.18229.29.camel@zakaz.uk.xensource.com>
Subject: Re: [Xen-devel] [PATCH 09/14] xen: events: Remove redundant check
 on unsigned variable
From: Ian Campbell <Ian.Campbell@citrix.com>
To: Tushar Behera <tushar.behera@linaro.org>
CC: Jeremy Fitzhardinge <jeremy@goop.org>,
        "xen-devel@lists.xensource.com" <xen-devel@lists.xensource.com>,
        "patches@linaro.org" <patches@linaro.org>,
        "virtualization@lists.linux-foundation.org" 
	<virtualization@lists.linux-foundation.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        Konrad Rzeszutek Wilk <konrad.wilk@oracle.com>
Date: Mon, 19 Nov 2012 10:31:15 +0000
In-Reply-To: <50A9AD05.5080201@linaro.org>
References: <1353048646-10935-1-git-send-email-tushar.behera@linaro.org>
	 <1353048646-10935-10-git-send-email-tushar.behera@linaro.org>
	 <20121116160923.GP22320@phenom.dumpdata.com>
	 <b0cd27cf-919f-46b0-afa1-4566f6ea0f61@email.android.com>
	 <50A9AD05.5080201@linaro.org>
Organization: Citrix Systems, Inc.
Content-Type: text/plain; charset="UTF-8"
X-Mailer: Evolution 3.4.3-1 
MIME-Version: 1.0
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 2012-11-19 at 03:52 +0000, Tushar Behera wrote:
> On 11/16/2012 10:23 PM, Jeremy Fitzhardinge wrote:
> > To be honest I'd nack this kind of patch. The test is only redundant in the most trivial sense that the compiler can easily optimise away. The point of the test is to make sure that the range is OK even if the type subsequently becomes signed (to hold a -ve error, for example).
> > 
> > J
> > 
> 
> The check is on the function argument which is unsigned, so checking '<
> 0' doesn't make sense. We should force signed check only if the argument
> is of signed type. In any case, even if irq has been assigned some error
> value, that would be caught by the check irq >= nr_irqs.

Jeremy is (I think) arguing that this check is not redundant because
someone might change the type of the argument to be signed and until
then the compiler can trivially optimise the check away, so what's the
harm in it?

I'm somewhat inclined to agree with him.

Ian.

