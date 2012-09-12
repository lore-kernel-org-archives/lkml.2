Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760727Ab2ILR00 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 12 Sep 2012 13:26:26 -0400
Received: from rcsinet15.oracle.com ([148.87.113.117]:17983 "EHLO
	rcsinet15.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752032Ab2ILR0X (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 12 Sep 2012 13:26:23 -0400
Date: Wed, 12 Sep 2012 20:25:54 +0300
From: Dan Carpenter <dan.carpenter@oracle.com>
To: Peter Senna Tschudin <peter.senna@gmail.com>
Cc: Marcos Souza <marcos.souza.org@gmail.com>,
        Mauro Carvalho Chehab <mchehab@infradead.org>,
        kernel-janitors@vger.kernel.org, linux-media@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH v2 7/8] drivers/media/platform/davinci/vpbe.c: Removes
 useless kfree()
Message-ID: <20120912172554.GH19396@mwanda>
References: <1347454564-5178-2-git-send-email-peter.senna@gmail.com>
 <CAH0vN5+ZoexHtmgyZ+s9tiW3LYx+6PMT8aLyYt-T5mnaGXvYbQ@mail.gmail.com>
 <CA+MoWDquDi6+kY9z3rj79dJK6j5tSWO9oWHCkvt6J-XBB=HNvA@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <CA+MoWDquDi6+kY9z3rj79dJK6j5tSWO9oWHCkvt6J-XBB=HNvA@mail.gmail.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
X-Source-IP: ucsinet22.oracle.com [156.151.31.94]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Sep 12, 2012 at 05:50:54PM +0200, Peter Senna Tschudin wrote:
> Marcos,
> 
> > Now that you removed this kfree, you could remove this label too. Very
> > nice your cleanup :)
> Thanks!
> 
> >
> >>  vpbe_fail_sd_register:
> >>         kfree(vpbe_dev->encoders);
> >>  vpbe_fail_v4l2_device:
> 
> The problem removing the label is that it will require some more work
> naming the labels. See:
> if (!vpbe_dev->amp) {
> ...
> 	goto vpbe_fail_amp_register;
> 
> If I just remove the label vpbe_fail_amp_register, the label names
> will not make sense any more as the next label is
> vpbe_fail_sd_register. So I will need to change the name to something
> different or rename all labels to out1, out2, out3 or err1, err2,
> err3, or ....
> 
> Any suggestions?

Labal names should not be numbers because this is not GW-BASIC.  The
label should reflect what happens on the next line.  Labeling the
place after the goto location where you started from is always
nonsense.

regards,
dan carpenter

