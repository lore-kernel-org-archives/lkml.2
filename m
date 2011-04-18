Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753177Ab1DRMaH (ORCPT <rfc822;w@1wt.eu>);
	Mon, 18 Apr 2011 08:30:07 -0400
Received: from smtp.nokia.com ([147.243.128.24]:37776 "EHLO mgw-da01.nokia.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751780Ab1DRMaA (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 18 Apr 2011 08:30:00 -0400
Subject: Re: [PATCH 1/1] Add check for dirty_writeback_interval in
 bdi_wakeup_thread_delayed
From: Artem Bityutskiy <Artem.Bityutskiy@nokia.com>
Reply-To: Artem.Bityutskiy@nokia.com
To: Raghavendra D Prabhu <rprabhu@wnohang.net>
Cc: linux-mm@kvack.org, Jens Axboe <jaxboe@fusionio.com>,
        Christoph Hellwig <hch@lst.de>,
        Andrew Morton <akpm@linux-foundation.org>,
        linux-kernel@vger.kernel.org
In-Reply-To: <20110418091609.GC5143@Xye>
References: <20110417162308.GA1208@Xye> <1303111152.2815.29.camel@localhost>
	 <20110418091609.GC5143@Xye>
Content-Type: text/plain; charset="UTF-8"
Organization: Nokia
Date: Mon, 18 Apr 2011 15:26:29 +0300
Message-ID: <1303129589.8589.5.camel@localhost>
Mime-Version: 1.0
X-Mailer: Evolution 2.32.2 (2.32.2-1.fc14) 
Content-Transfer-Encoding: 8bit
X-Nokia-AV: Clean
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 2011-04-18 at 14:46 +0530, Raghavendra D Prabhu wrote:
> I have set it to 500 centisecs as that is the default value of
> dirty_writeback_interval. I used this logic for following reason: the
> purpose for which dirty_writeback_interval is set to 0 is to disable
> periodic writeback
> (http://tomoyo.sourceforge.jp/cgi-bin/lxr/source/fs/fs-writeback.c#L818)
> , whereas here (in bdi_wakeup_thread_delayed) it is being used for a
> different purpose -- to delay the bdi wakeup in order to reduce context
> switches for  dirty inode writeback.

But why it wakes up the bdi thread? Exactly to make sure the periodic
write-back happen.

-- 
Best Regards,
Artem Bityutskiy (Артём Битюцкий)

