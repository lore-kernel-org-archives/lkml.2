Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754754Ab1KRTtH (ORCPT <rfc822;w@1wt.eu>);
	Fri, 18 Nov 2011 14:49:07 -0500
Received: from out2.smtp.messagingengine.com ([66.111.4.26]:51557 "EHLO
	out2.smtp.messagingengine.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752113Ab1KRTtE (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 18 Nov 2011 14:49:04 -0500
X-Sasl-enc: VrwJGe7TK+GRSjAkO339rDDOVc1cGSuWUkZGML1twYmV 1321645744
Date: Fri, 18 Nov 2011 11:48:43 -0800
From: Greg KH <greg@kroah.com>
To: Alessandro Rubini <rubini@gnudd.com>
Cc: gregkh@suse.de, linux-kernel@vger.kernel.org, giancarlo.asnaghi@st.com,
        balbi@ti.com, broonie@opensource.wolfsonmicro.com
Subject: Re: [PATCH V2 2/2] usb: dwc3: use debugfs_print_regs32()
Message-ID: <20111118194843.GA17915@kroah.com>
References: <20111118002049.GA24806@mail.gnudd.com>
 <20111118135143.GA1101@mail.gnudd.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <20111118135143.GA1101@mail.gnudd.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Nov 18, 2011 at 02:51:43PM +0100, Alessandro Rubini wrote:
> This a use example of the regs32 utilities in debugfs, although
> this fuse use ":" as separator between name and value, and debugs
> uses "=" (as it looked to me a more common practice).
> 
> Signed-off-by: Alessandro Rubini <rubini@gnudd.com>
> Acked-by: Felipe Balbi <balbi@ti.com>

I've applied this, but it causes the following complier warnings to be
spit out:

drivers/usb/dwc3/debugfs.c: In function ‘dwc3_regdump_show’:
drivers/usb/dwc3/debugfs.c:384:9: warning: passing argument 2 of ‘debugfs_print_regs32’ discards ‘const’ qualifier from pointer target type [enabled by default]
include/linux/debugfs.h:93:5: note: expected ‘struct debugfs_reg32 *’ but argument is of type ‘const struct debugfs_reg32 *’
drivers/usb/dwc3/debugfs.c:380:8: warning: unused variable ‘i’ [-Wunused-variable]

Alessandro, care to send me a follow-on patch to fix this up?

thanks,

greg k-h
