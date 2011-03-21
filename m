Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753899Ab1CUQmg (ORCPT <rfc822;w@1wt.eu>);
	Mon, 21 Mar 2011 12:42:36 -0400
Received: from caramon.arm.linux.org.uk ([78.32.30.218]:56286 "EHLO
	caramon.arm.linux.org.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753794Ab1CUQme (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 21 Mar 2011 12:42:34 -0400
Date: Mon, 21 Mar 2011 16:41:56 +0000
From: Russell King - ARM Linux <linux@arm.linux.org.uk>
To: "Janorkar, Mayuresh" <mayur@ti.com>
Cc: Carl Vanderlip <carlv@codeaurora.org>, David Brown <davidb@codeaurora.org>,
        Daniel Walker <dwalker@fifo99.com>,
        Bryan Huntsman <bryanh@codeaurora.org>,
        "linux-fbdev@vger.kernel.org" <linux-fbdev@vger.kernel.org>,
        Brian Swetland <swetland@google.com>,
        "linux-arm-msm@vger.kernel.org" <linux-arm-msm@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        Dima Zavin <dima@android.com>, Colin Cross <ccross@android.com>,
        Rebecca Schultz Zavin <rebecca@android.com>,
        "linux-arm-kernel@lists.infradead.org" 
	<linux-arm-kernel@lists.infradead.org>
Subject: Re: [PATCH 07/20] video: msm: Allow users to request a larger x
	and y virtual fb
Message-ID: <20110321164156.GF4340@n2100.arm.linux.org.uk>
References: <1300484846-26393-1-git-send-email-carlv@codeaurora.org> <1300485381-27201-1-git-send-email-carlv@codeaurora.org> <EAF47CD23C76F840A9E7FCE10091EFAB033D22EAE7@dbde02.ent.ti.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <EAF47CD23C76F840A9E7FCE10091EFAB033D22EAE7@dbde02.ent.ti.com>
User-Agent: Mutt/1.5.19 (2009-01-05)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Mar 21, 2011 at 10:10:09AM +0530, Janorkar, Mayuresh wrote:
> > +	fix->line_length = var->xres * var->bits_per_pixel / 8;
> Why to divide by 8? Atleast use >>3, bitwise operations that would take
> less cpu cycles)
> As I stated earlier define a new macro for var also.

Modern compilers know about such things.  >> 3 vs / 8 (probably) makes no
difference to the generated code with the toolchains we use.
