Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932216Ab0GVJ53 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 22 Jul 2010 05:57:29 -0400
Received: from smtp.nokia.com ([192.100.122.233]:53151 "EHLO
	mgw-mx06.nokia.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932134Ab0GVJ51 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 22 Jul 2010 05:57:27 -0400
Subject: Re: [PATCHv2 11/11] writeback: prevent unnecessary bdi threads
 wakeups
From: Artem Bityutskiy <dedekind1@gmail.com>
Reply-To: dedekind1@gmail.com
To: Nick Piggin <npiggin@suse.de>
Cc: Kristo Tero Tapani <tero.kristo@nokia.com>, Jens Axboe <axboe@kernel.dk>,
        linux-fsdevel@vger.kernel.org, linux-kernel@vger.kernel.org
In-Reply-To: <20100722080511.GA9377@amd>
References: <1279704706-1267-1-git-send-email-dedekind1@gmail.com>
	 <1279704706-1267-12-git-send-email-dedekind1@gmail.com>
	 <20100722031922.GA3446@amd> <1279781304.3044.12.camel@localhost>
	 <20100722080511.GA9377@amd>
Content-Type: text/plain; charset="UTF-8"
Date: Thu, 22 Jul 2010 12:50:25 +0300
Message-ID: <1279792225.3044.37.camel@localhost>
Mime-Version: 1.0
X-Mailer: Evolution 2.30.2 (2.30.2-1.fc13) 
Content-Transfer-Encoding: 8bit
X-OriginalArrivalTime: 22 Jul 2010 09:57:17.0701 (UTC) FILETIME=[44CEB350:01CB2984]
X-Nokia-AV: Clean
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 2010-07-22 at 18:05 +1000, Nick Piggin wrote:
> This is producing 2 unrequired context switches, so I really would
> like to see it done properly. Setting up a timer is really pretty
> simple (or if you would care to implement a delayed process wakeup
> API, I think that would be useful -- I'm surprised there isn't one
> already).

OK, a generic 'wake_up_process_timeout()' would need a timer, and it
cannot set it up on stack because it has to return immediately, this is
why we do not have such a generic helper, I think.

-- 
Best Regards,
Artem Bityutskiy (Артём Битюцкий)

