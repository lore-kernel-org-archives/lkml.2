Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756483Ab0LSU63 (ORCPT <rfc822;w@1wt.eu>);
	Sun, 19 Dec 2010 15:58:29 -0500
Received: from mail-ww0-f44.google.com ([74.125.82.44]:39580 "EHLO
	mail-ww0-f44.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751891Ab0LSU62 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 19 Dec 2010 15:58:28 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=date:from:to:cc:subject:message-id:mail-followup-to:mime-version
         :content-type:content-disposition:user-agent;
        b=EHB+LnLo7yicKYKQ4RTwg2o978ym2jbOKdqjw4aMWrgQkufpGTFqQnlBHOsALydGer
         R05dxfpKPMPf5G1OVvk8FwJzDEe2+gpaqtlem7Xhabgamc00JFigKanB8y4w7dU1v8lQ
         kPiKT0v+st/OO8Xs95CXFrPIX3JmRn+njy6tE=
Date: Sun, 19 Dec 2010 23:58:09 +0300
From: Dan Carpenter <error27@gmail.com>
To: Cory Maccarrone <darkstar6262@gmail.com>
Cc: linux-kernel@vger.kernel.org, Samuel Ortiz <sameo@linux.intel.com>
Subject: [bug report] mfd/htc-i2cpld.c wrong check in htcpld_chip_get()
Message-ID: <20101219205809.GM1936@bicker>
Mail-Followup-To: Dan Carpenter <error27@gmail.com>,
	Cory Maccarrone <darkstar6262@gmail.com>,
	linux-kernel@vger.kernel.org, Samuel Ortiz <sameo@linux.intel.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Cory,

Smatch complains that the check is wrong on line 280 from
drivers/mfd/htc-i2cpld.c

drivers/mfd/htc-i2cpld.c +280 htcpld_chip_get(12)
	warn: can 'chip_data' even be NULL?

   278          /* Try out first */
   279          chip_data = container_of(chip, struct htcpld_chip, chip_out);
   280          if (!chip_data) {
   281                  /* Try in */
   282                  is_input = 1;
   283                  chip_data = container_of(chip, struct htcpld_chip, chip_in);
   284                  if (!chip_data)
   285                          return -EINVAL;
   286          }

container_of() takes the chip pointer and subtracts a small number (it
subtracts the offset of the chip_out element from the start of the
htcpld_chip struct).  So basically it's never NULL.  I'm not sure what
the correct check should be here, can you take a look?

regards,
dan carpenter
