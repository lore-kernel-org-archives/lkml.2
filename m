Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754227Ab0C1Lsp (ORCPT <rfc822;w@1wt.eu>);
	Sun, 28 Mar 2010 07:48:45 -0400
Received: from mail-bw0-f209.google.com ([209.85.218.209]:54303 "EHLO
	mail-bw0-f209.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753444Ab0C1Lsn (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 28 Mar 2010 07:48:43 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=date:from:to:cc:subject:message-id:mail-followup-to:mime-version
         :content-type:content-disposition:user-agent;
        b=Yj8AaN090G7N0YwCQz/wdGERdPMni40nyIffRQVcE6HFNcECttcNdQYcAnN6uJCsk0
         0Q11xmcJ+/qBooPaty3YNt/dv4PloRkg59yyXm0v5hq5akWvUvVnaeTl7caONSV4x7Q2
         avKxaAmztBFVl6yXh2yaaFpxkLpLz+LX9nscY=
Date: Sun, 28 Mar 2010 14:48:34 +0300
From: Dan Carpenter <error27@gmail.com>
To: Greg Kroah-Hartman <gregkh@suse.de>
Cc: Bill Pemberton <wfp5p@virginia.edu>,
       Andrea Gelmini <andrea.gelmini@gelma.net>,
       Mithlesh Thukral <mithlesh@linsyssoft.com>, devel@driverdev.osuosl.org,
       linux-kernel@vger.kernel.org, kernel-janitors@vger.kernel.org
Subject: [patch] comedi: off by one issue
Message-ID: <20100328114834.GT5069@bicker>
Mail-Followup-To: Dan Carpenter <error27@gmail.com>,
	Greg Kroah-Hartman <gregkh@suse.de>,
	Bill Pemberton <wfp5p@virginia.edu>,
	Andrea Gelmini <andrea.gelmini@gelma.net>,
	Mithlesh Thukral <mithlesh@linsyssoft.com>,
	devel@driverdev.osuosl.org, linux-kernel@vger.kernel.org,
	kernel-janitors@vger.kernel.org
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

"dac_range_table" has 5 elements.

Signed-off-by: Dan Carpenter <error27@gmail.com>

diff --git a/drivers/staging/comedi/drivers/dt2801.c b/drivers/staging/comedi/drivers/dt2801.c
index 3f365ae..83fb6e5 100644
--- a/drivers/staging/comedi/drivers/dt2801.c
+++ b/drivers/staging/comedi/drivers/dt2801.c
@@ -472,7 +472,7 @@ static const struct comedi_lrange *dac_range_table[] = {
 
 static const struct comedi_lrange *dac_range_lkup(int opt)
 {
-	if (opt < 0 || opt > 5)
+	if (opt < 0 || opt >= 5)
 		return &range_unknown;
 	return dac_range_table[opt];
 }
