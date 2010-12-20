Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754792Ab0LTJQI (ORCPT <rfc822;w@1wt.eu>);
	Mon, 20 Dec 2010 04:16:08 -0500
Received: from mail-ww0-f44.google.com ([74.125.82.44]:48898 "EHLO
	mail-ww0-f44.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754435Ab0LTJQG (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 20 Dec 2010 04:16:06 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=date:from:to:cc:subject:message-id:mail-followup-to:mime-version
         :content-type:content-disposition:user-agent;
        b=PBv5Iwm/pwiYUMRA1m81qgv+AnmLndHAzIgewa5fGF/k/3L8wkpEa2ojihXYXuxH2x
         0t+w+ATGf6P/7xPcjzBC1HEYipRBJkVyW4HoLx6/Jwm32X0ti9G+kNBDLINa+RXgGOEA
         rjXD280VVqOUpe6MgSpsbmQnCRrlHc7SpxqJA=
Date: Mon, 20 Dec 2010 12:15:55 +0300
From: Dan Carpenter <error27@gmail.com>
To: Russ Gorby <richardx.r.gorby@intel.com>
Cc: Alan Cox <alan@linux.intel.com>, linux-kernel@vger.kernel.org
Subject: smatch stuff: serial: ifx6x60: oops on load
Message-ID: <20101220091555.GR1936@bicker>
Mail-Followup-To: Dan Carpenter <error27@gmail.com>,
	Russ Gorby <richardx.r.gorby@intel.com>,
	Alan Cox <alan@linux.intel.com>, linux-kernel@vger.kernel.org
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Smatch complains that the ifx6x60 driver in linux-next has a NULL
dereference.

drivers/serial/ifx6x60.c +986 ifx_spi_spi_probe(27)
	error: potential null derefence 'pl_data'.

   984          ifx_dev->spi_timer.function = ifx_spi_timeout;
   985          ifx_dev->spi_timer.data = (unsigned long)ifx_dev;
   986          ifx_dev->is_6160 = pl_data->is_6160;
                                   ^^^^^^^
"pl_data" is always NULL at this point.  Presumably this crashes on load
every time.

regards,
dan carpenter

