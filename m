Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754978Ab0IXCxX (ORCPT <rfc822;w@1wt.eu>);
	Thu, 23 Sep 2010 22:53:23 -0400
Received: from ironport2-out.teksavvy.com ([206.248.154.181]:53637 "EHLO
	ironport2-out.pppoe.ca" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1751844Ab0IXCxV (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 23 Sep 2010 22:53:21 -0400
X-IronPort-Anti-Spam-Filtered: true
X-IronPort-Anti-Spam-Result: ArsBAKevm0xLd/sX/2dsb2JhbAAHgxSRJocyvQKSLYEigy1zBA
X-IronPort-AV: E=Sophos;i="4.57,226,1283745600"; 
   d="scan'208";a="76601642"
Message-ID: <4C9C129E.5050504@teksavvy.com>
Date: Thu, 23 Sep 2010 22:53:18 -0400
From: Mark Lord <kernel@teksavvy.com>
User-Agent: Mozilla/5.0 (X11; U; Linux i686; en-US; rv:1.9.2.9) Gecko/20100915 Thunderbird/3.1.4
MIME-Version: 1.0
To: dgilbert@interlog.com
CC: Linux Kernel <linux-kernel@vger.kernel.org>,
        IDE/ATA development list <linux-ide@vger.kernel.org>,
        linux-scsi <linux-scsi@vger.kernel.org>
Subject: Re: "blocked for more than 120 secs" --> a valid situation, how to
 prevent?
References: <4C9BE5A8.1090002@teksavvy.com> <4C9BEB49.2060208@interlog.com>
In-Reply-To: <4C9BEB49.2060208@interlog.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 10-09-23 08:05 PM, Douglas Gilbert wrote:
> Mark,
> If you issued the SG_IO ioctl with a timeout of at
> least 66 minutes (expressed in milliseconds) then
> it looks like ata_scsi_queuecmd() has a problem.
..

Mmm.. more like  blk_execute_rq() perhaps.
That's where the wait_for_completion(&wait) call is at.

Perhaps I should change it to wait in smaller increments,
so that the lockup detection doesn't trigger on it..

Doing that seems rather wasteful, though.

Note that this is the ATA "SECURITY ERASE" command,
which doesn't have an "immed" bit to toggle.
So one must wait for it to complete.

cheers
