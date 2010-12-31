Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753996Ab0LaRlT (ORCPT <rfc822;w@1wt.eu>);
	Fri, 31 Dec 2010 12:41:19 -0500
Received: from mail-ww0-f44.google.com ([74.125.82.44]:48302 "EHLO
	mail-ww0-f44.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753871Ab0LaRlQ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 31 Dec 2010 12:41:16 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=date:from:to:cc:subject:message-id:mail-followup-to:references
         :mime-version:content-type:content-disposition:in-reply-to
         :user-agent;
        b=UW7fglT+3gVLOKjzgZ3eerKU6lNC9ZzUbq53HqtLbW33lH3Hd67w+DTilHTgzg5db+
         9D0jWf73g2rqXfx7DkgxN4KBPd4ZPMUoSSjfu/E8ApzfZ5RVxySlmDDLxKkqbQCWTIKX
         MNF1EqfWSK7mYHpaMdTNjOoWqw2Qn0KJnOvsM=
Date: Fri, 31 Dec 2010 20:41:00 +0300
From: Dan Carpenter <error27@gmail.com>
To: "Justin P. Mattock" <justinmattock@gmail.com>
Cc: Grant Likely <grant.likely@secretlab.ca>, trivial@kernel.org,
        devel@driverdev.osuosl.org, linux-scsi@vger.kernel.org,
        netdev@vger.kernel.org, linux-usb@vger.kernel.org,
        linux-wireless@vger.kernel.org, linux-kernel@vger.kernel.org,
        ivtv-devel@ivtvdriver.org, linux-m68k@vger.kernel.org,
        spi-devel-general@lists.sourceforge.net, linux-media@vger.kernel.org
Subject: Re: [PATCH 02/15]drivers:spi:dw_spi.c Typo change diable to
 disable.
Message-ID: <20101231174100.GF1886@bicker>
Mail-Followup-To: Dan Carpenter <error27@gmail.com>,
	"Justin P. Mattock" <justinmattock@gmail.com>,
	Grant Likely <grant.likely@secretlab.ca>, trivial@kernel.org,
	devel@driverdev.osuosl.org, linux-scsi@vger.kernel.org,
	netdev@vger.kernel.org, linux-usb@vger.kernel.org,
	linux-wireless@vger.kernel.org, linux-kernel@vger.kernel.org,
	ivtv-devel@ivtvdriver.org, linux-m68k@lists.linux-m68k.org,
	spi-devel-general@lists.sourceforge.net,
	linux-media@vger.kernel.org
References: <1293750484-1161-1-git-send-email-justinmattock@gmail.com>
 <1293750484-1161-2-git-send-email-justinmattock@gmail.com>
 <20101231064515.GC3733@angua.secretlab.ca>
 <4D1D7DAE.7060504@gmail.com>
 <20101231091136.GC1886@bicker>
 <4D1DE616.7010105@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <4D1DE616.7010105@gmail.com>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Dec 31, 2010 at 06:17:58AM -0800, Justin P. Mattock wrote:
> >Wrong:  [PATCH 02/15]drivers:spi:dw_spi.c Typo change diable to disable.
> >
> >Right:  [PATCH 02/15] spi/dw_spi: Typo change diable to disable
> >
> >regards,
> >dan carpenter
> >
> 
> alright.. so having the backlash is alright for the subject

Well really my point is not so much about backslashes vs colons, it's
about getting the *one* correct prefix.  This stuff is probably
scriptable most of the time, but you may still be required to think a
little on the corner cases.

Here is a script to get you started.

git log --format="%s" drivers/spi/dw_spi.c | \
	head -n 20 |                         \
	perl -ne 's/(.*):.*/$1/; print' |    \
	sort | uniq -c | sort -rn |          \
	perl -ne 's/^\W+\d+ //; print' |     \
	head -n 1

regards,
dan carpenter
