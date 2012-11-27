Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754537Ab2K0Nj7 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 27 Nov 2012 08:39:59 -0500
Received: from viridian.itc.Virginia.EDU ([128.143.12.139]:48265 "EHLO
	viridian.itc.virginia.edu" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751228Ab2K0Nj6 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 27 Nov 2012 08:39:58 -0500
Subject: Re: new warnings from partial __devexit removal
To: gregkh@linuxfoundation.org
Date: Tue, 27 Nov 2012 08:39:57 -0500
Cc: arnd@arndb.de (Arnd Bergmann),
        linux-kernel@vger.kernel.org (linux-kernel@vger.kernel.org)
In-Reply-To: <20121126225056.GB28995@kroah.com>
X-Mailer: ELM [version 2.5.8.59.gd925]
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Message-Id: <20121127133957.63D2D8013C@viridian.itc.virginia.edu>
From: wfp5p@viridian.itc.virginia.edu (Bill Pemberton)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

gregkh@linuxfoundation.org writes:
> 
> On Mon, Nov 26, 2012 at 08:38:32PM +0000, Arnd Bergmann wrote:
> > This is probably known and fixed already, but in case it's not, let me just
> > mention that I saw two new warnings with ARM allyesconfig about a
> > __devexit being removed but the __devexit_p() still being there:
> > 
> > drivers/tty/serial/xilinx_uartps.c:1000:12: error: 'xuartps_remove' defined but not used [-Werror=unused-function]
> > drivers/usb/gadget/mv_udc_core.c:2131:12: error: 'mv_udc_remove' defined but not used [-Werror=unused-function]
> 
> What platform has -Werror=unused-function set?
> 
> Bill, care to send follow-on patches to resolve these warnings?
> 

I don't understand how my changes would causing the warning.  Both
functions are put in the platform_driver struct using __exit_p, not
__devexit_p.  It seems like you should get the warning with or without
my changes as long as MODULE is not defined.

-- 
Bill


