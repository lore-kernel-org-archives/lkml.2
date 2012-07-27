Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751820Ab2G0JA7 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 27 Jul 2012 05:00:59 -0400
Received: from smtp.eu.citrix.com ([62.200.22.115]:32091 "EHLO
	SMTP.EU.CITRIX.COM" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751113Ab2G0JA5 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 27 Jul 2012 05:00:57 -0400
X-IronPort-AV: E=Sophos;i="4.77,666,1336348800"; 
   d="scan'208";a="13729848"
Message-ID: <1343379653.6812.92.camel@zakaz.uk.xensource.com>
Subject: Re: [Xen-devel] [PATCH 02/24] xen/arm: hypercalls
From: Ian Campbell <Ian.Campbell@citrix.com>
To: David Vrabel <dvrabel@cantab.net>
CC: Stefano Stabellini <Stefano.Stabellini@eu.citrix.com>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "xen-devel@lists.xensource.com" <xen-devel@lists.xensource.com>,
        "linaro-dev@lists.linaro.org" <linaro-dev@lists.linaro.org>,
        "arnd@arndb.de" <arnd@arndb.de>,
        "konrad.wilk@oracle.com" <konrad.wilk@oracle.com>,
        "catalin.marinas@arm.com" <catalin.marinas@arm.com>,
        "Tim (Xen.org)" <tim@xen.org>,
        "linux-arm-kernel@lists.infradead.org" 
	<linux-arm-kernel@lists.infradead.org>
Date: Fri, 27 Jul 2012 10:00:53 +0100
In-Reply-To: <501176AF.3000607@cantab.net>
References: <alpine.DEB.2.02.1207251741470.26163@kaball.uk.xensource.com>
	 <1343316846-25860-2-git-send-email-stefano.stabellini@eu.citrix.com>
	 <501176AF.3000607@cantab.net>
Organization: Citrix Systems, Inc.
Content-Type: text/plain; charset="UTF-8"
X-Mailer: Evolution 3.4.3-1 
MIME-Version: 1.0
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 2012-07-26 at 17:56 +0100, David Vrabel wrote:
> On 26/07/12 16:33, Stefano Stabellini wrote:
> > 
> > + * The hvc ISS is required to be 0xEA1, that is the Xen specific ARM
> > + * hypercall tag.
> 
> Is this number, 0xea1, assigned to Xen by some external body?

The value and semantics of the hvc instructions immediate operand is
entirely up to the hypervisor authors. We could have chosen 0 or some
random number, we went for the latter because it increases the chances,
by some tiny amount, that we won't clash with some other hypervisors ABI
which makes supporting "foreign" guests that bit easier should it even
come to it.

IOW it's arbitrary in the same way that a Linux system calls used to use
int 0x80.

Ian.

