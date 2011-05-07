Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754426Ab1EGBap (ORCPT <rfc822;w@1wt.eu>);
	Fri, 6 May 2011 21:30:45 -0400
Received: from mx2.fusionio.com ([66.114.96.31]:41088 "EHLO mx2.fusionio.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753330Ab1EGBan (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 6 May 2011 21:30:43 -0400
X-ASG-Debug-ID: 1304731832-01de28096b1b740001-xx1T2L
X-Barracuda-Envelope-From: JAxboe@fusionio.com
Message-ID: <4DC4A0B8.7060801@fusionio.com>
Date: Fri, 6 May 2011 19:30:32 -0600
From: Jens Axboe <jaxboe@fusionio.com>
MIME-Version: 1.0
To: Lukas Czerner <lczerner@redhat.com>
CC: "linux-fsdevel@vger.kernel.org" <linux-fsdevel@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        Jeff Moyer <jmoyer@redhat.com>
Subject: Re: [PATCH] blkdev: Do not return -EOPNOTSUPP if discard is supported
References: <1304345841-20063-1-git-send-email-lczerner@redhat.com> <1304608365-17199-1-git-send-email-lczerner@redhat.com>
X-ASG-Orig-Subj: Re: [PATCH] blkdev: Do not return -EOPNOTSUPP if discard is supported
In-Reply-To: <1304608365-17199-1-git-send-email-lczerner@redhat.com>
Content-Type: text/plain; charset="ISO-8859-1"
Content-Transfer-Encoding: 7bit
X-Barracuda-Connect: mail1.int.fusionio.com[10.101.1.21]
X-Barracuda-Start-Time: 1304731832
X-Barracuda-URL: http://10.101.1.181:8000/cgi-mod/mark.cgi
X-Barracuda-Spam-Score: 0.00
X-Barracuda-Spam-Status: No, SCORE=0.00 using global scores of TAG_LEVEL=1000.0 QUARANTINE_LEVEL=1000.0 KILL_LEVEL=9.0 tests=
X-Barracuda-Spam-Report: Code version 3.2, rules version 3.2.2.62992
	Rule breakdown below
	 pts rule name              description
	---- ---------------------- --------------------------------------------------
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 2011-05-05 09:12, Lukas Czerner wrote:
> Currently we return -EOPNOTSUPP in blkdev_issue_discard() if any of the
> bio fails due to underlying device not supporting discard request.
> However, if the device is for example dm device composed of devices
> which some of them support discard and some of them does not, it is ok
> for some bios to fail with EOPNOTSUPP, but it does not mean that discard
> is not supported at all.
> 
> This commit removes the check for bios failed with EOPNOTSUPP and change
> blkdev_issue_discard() to return operation not supported if and only if
> the device does not actually supports it, not just part of the device as
> some bios might indicate.
> 
> This change also fixes problem with BLKDISCARD ioctl() which now works
> correctly on such dm devices.

Applied, thanks.

-- 
Jens Axboe

