Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753893Ab2B0Q12 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 27 Feb 2012 11:27:28 -0500
Received: from smtp.eu.citrix.com ([62.200.22.115]:53018 "EHLO
	SMTP.EU.CITRIX.COM" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752995Ab2B0Q10 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 27 Feb 2012 11:27:26 -0500
X-IronPort-AV: E=Sophos;i="4.73,491,1325462400"; 
   d="scan'208";a="10961077"
Message-ID: <1330360043.8557.302.camel@zakaz.uk.xensource.com>
Subject: Re: [PATCH-WIP 01/13] xen/arm: use r12 to pass the hypercall number
 to the hypervisor
From: Ian Campbell <Ian.Campbell@citrix.com>
To: Stefano Stabellini <stefano.stabellini@eu.citrix.com>
CC: "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "xen-devel@lists.xensource.com" <xen-devel@lists.xensource.com>,
        "arnd@arndb.de" <arnd@arndb.de>,
        "linux-arm-kernel@lists.infradead.org" 
	<linux-arm-kernel@lists.infradead.org>,
        "catalin.marinas@arm.com" <catalin.marinas@arm.com>,
        "linaro-dev@lists.linaro.org" <linaro-dev@lists.linaro.org>,
        David Vrabel <david.vrabel@citrix.com>,
        "kvm@vger.kernel.org" <kvm@vger.kernel.org>
Date: Mon, 27 Feb 2012 16:27:23 +0000
In-Reply-To: <1330019314-20865-1-git-send-email-stefano.stabellini@eu.citrix.com>
References: <alpine.DEB.2.00.1202231714590.23091@kaball-desktop>
	 <1330019314-20865-1-git-send-email-stefano.stabellini@eu.citrix.com>
Organization: Citrix Systems, Inc.
Content-Type: text/plain; charset="UTF-8"
X-Mailer: Evolution 3.2.2-1 
Content-Transfer-Encoding: 7bit
MIME-Version: 1.0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 2012-02-23 at 17:48 +0000, Stefano Stabellini wrote:
> We need a register to pass the hypercall number because we might not
> know it at compile time and HVC only takes an immediate argument.
> 
> Among the available registers r12 seems to be the best choice because it
> is defined as "intra-procedure call scratch register".

R12 is not accessible from the 16 bit "T1" Thumb encoding of mov
immediate (which can only target r0..r7).

Since we support only ARMv7+ there are "T2" and "T3" encodings available
which do allow direct mov of an immediate into R12, but are 32 bit Thumb
instructions.

Should we use r7 instead to maximise instruction density for Thumb code?

Ian.

