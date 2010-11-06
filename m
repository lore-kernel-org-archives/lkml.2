Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754628Ab0KFLyv (ORCPT <rfc822;w@1wt.eu>);
	Sat, 6 Nov 2010 07:54:51 -0400
Received: from mail-wy0-f174.google.com ([74.125.82.174]:36076 "EHLO
	mail-wy0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754276Ab0KFLyt (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 6 Nov 2010 07:54:49 -0400
Subject: RE: [PATCH] regulator: twl-regulator - fix twlreg_set_mode
From: Liam Girdwood <lrg@slimlogic.co.uk>
To: Lesly Arackal Manuel <leslyam@ti.com>
Cc: "'Nayak, Rajendra'" <rnayak@ti.com>, "'Axel Lin'" <axel.lin@gmail.com>,
        "'linux-kernel'" <linux-kernel@vger.kernel.org>,
        "'Juha Keski-Saari'" <ext-juha.1.keski-saari@nokia.com>,
        "'Mark Brown'" <broonie@opensource.wolfsonmicro.com>
In-Reply-To: <BD28781F6C8B49EB8AEACE6365DBFFEA@india.ti.com>
References: <1287736702.2996.4.camel@mola>
	 <20101022153006.GB16521@opensource.wolfsonmicro.com>
	 <1287841635.7486.3.camel@odin>
	 <0680EC522D0CC943BC586913CF3768C003FF2DAF9D@dbde02.ent.ti.com>
	 <BD28781F6C8B49EB8AEACE6365DBFFEA@india.ti.com>
Content-Type: text/plain; charset="UTF-8"
Date: Sat, 06 Nov 2010 11:54:45 +0000
Message-ID: <1289044485.3318.16.camel@odin>
Mime-Version: 1.0
X-Mailer: Evolution 2.30.3 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 2010-11-04 at 15:08 +0530, Lesly Arackal Manuel wrote:
> Forgot to mention-
> 
> Only omap hsmmc driver is using regulator_set_mode() which will call
> twlreg_set_mode().
> 
> > -----Original Message-----
> > From: Lesly Arackal Manuel [mailto:leslyam@ti.com]
> > Sent: Thursday, November 04, 2010 3:01 PM
> > To: 'Nayak, Rajendra'; 'Liam Girdwood'
> > Cc: 'Axel Lin'; 'linux-kernel'; 'Juha Keski-Saari'; 'Mark Brown'
> > Subject: RE: [PATCH] regulator: twl-regulator - fix twlreg_set_mode
> > 
> > 
> > I have tested it with MMC card inserted on OMAP3630SDP board (using OMAP3
> > integration tree).
> > 
> > The changes seem to be valid.
> > 
> > The i2c_transfer() returns '1' on success and the twl_i2c_write() which
> > calls i2c_transfer returns '0' if success and err value if it fails.
> > 
> > After writing the MSB if it returns with check:
> > if (status >= 0)
> > 	return status;
> > It is not writing the LSB.
> > 
> > So it should be:
> > if (status < 0)
> > 	return status;
> > 
> > Regards,
> > Lesly AM
> > 

Applied.

Thanks

Liam
-- 
Freelance Developer, SlimLogic Ltd
ASoC and Voltage Regulator Maintainer.
http://www.slimlogic.co.uk

