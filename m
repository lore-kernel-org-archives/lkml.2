Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S964925Ab1JFOeJ (ORCPT <rfc822;w@1wt.eu>);
	Thu, 6 Oct 2011 10:34:09 -0400
Received: from rcsinet15.oracle.com ([148.87.113.117]:35783 "EHLO
	rcsinet15.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755944Ab1JFOeH (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 6 Oct 2011 10:34:07 -0400
Date: Thu, 6 Oct 2011 17:30:38 +0300
From: Dan Carpenter <dan.carpenter@oracle.com>
To: Achim Leubner <Achim_Leubner@pmc-sierra.com>
Cc: Rolf Eike Beer <eike-kernel@sf-tec.de>,
        Adaptec OEM Raid Solutions <aacraid@adaptec.com>,
        "James E.J. Bottomley" <jbottomley@parallels.com>,
        linux-scsi@vger.kernel.org, linux-kernel@vger.kernel.org,
        kernel-janitors@vger.kernel.org
Subject: Re: [patch] [SCSI] aacraid: use lower snprintf() limit
Message-ID: <20111006143038.GC18470@longonot.mountain>
References: <20111005055046.GD32077@elgon.mountain>
 <d97a34694e741dc6a2a71fbcd49bab49.squirrel@webmail.sf-mail.de>
 <FD2BDBE06AC58549AE9E16C08B45675D05D8ED9E@BBY1EXM10.pmc_nt.nt.pmc-sierra.bc.ca>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <FD2BDBE06AC58549AE9E16C08B45675D05D8ED9E@BBY1EXM10.pmc_nt.nt.pmc-sierra.bc.ca>
User-Agent: Mutt/1.5.21 (2010-09-15)
X-Source-IP: ucsinet23.oracle.com [156.151.31.71]
X-CT-RefId: str=0001.0A090206.4E8DBC35.01BB,ss=1,re=0.000,fgs=0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Oct 05, 2011 at 05:19:12AM -0700, Achim Leubner wrote:
> Looks good so far. But do we really need the last two lines?
> > +	if (len > 16)
> > +		len = 16;
> 

snprintf() returns the number of characters that it _would_ have
copied if it had space.  We want to return the number of bytes
actually copied.

Again, the snprintf() values do fit so this change doesn't actually
make any difference.

regards,
dan carpenter
