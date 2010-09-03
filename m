Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756550Ab0ICJRI (ORCPT <rfc822;w@1wt.eu>);
	Fri, 3 Sep 2010 05:17:08 -0400
Received: from mail-wy0-f174.google.com ([74.125.82.174]:39794 "EHLO
	mail-wy0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756087Ab0ICJRH (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 3 Sep 2010 05:17:07 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=date:from:to:cc:subject:message-id:mail-followup-to:mime-version
         :content-type:content-disposition:user-agent;
        b=OHfqpiQkg8UM0swO4P+PUM+pCk3MFbH2wZYtrAtO7ywOPSEkd27/OBpJ24w6ZP0Fe/
         IdzGimJVjk1jo7BVHQO5EKsV9fEqACeB86YtccJi/NpGgBl+3C5bNhzIyEZ83nVN3wT6
         5gq+SeMOth9d88KBi4enkGAy4HjMLPpE5RMWo=
Date: Fri, 3 Sep 2010 11:16:32 +0200
From: Dan Carpenter <error27@gmail.com>
To: Adrian Hunter <adrian.hunter@nokia.com>
Cc: linux-kernel@vger.kernel.org, Jens Axboe <axboe@kernel.dk>
Subject: does "block: add secure discard" cause an overflow?
Message-ID: <20100903091631.GI5437@bicker>
Mail-Followup-To: Dan Carpenter <error27@gmail.com>,
	Adrian Hunter <adrian.hunter@nokia.com>,
	linux-kernel@vger.kernel.org, Jens Axboe <axboe@kernel.dk>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This is the commit 8d57a98ccd0b44 "block: add secure discard".

The patch adds a letter 'E' to the string in blk_fill_rwbs().
        if (rw & REQ_SECURE)
                rwbs[i++] = 'E';

The problem is that "rwbs" is a 6 character buffer and if all the flags
are set the we'd get "WABSME" which would put us off the end (when you
add the NUL terminator).

regards,
dan carpenter
