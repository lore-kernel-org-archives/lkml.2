Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753074Ab0IDGln (ORCPT <rfc822;w@1wt.eu>);
	Sat, 4 Sep 2010 02:41:43 -0400
Received: from smtp.nokia.com ([192.100.122.233]:23519 "EHLO
	mgw-mx06.nokia.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751179Ab0IDGll (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 4 Sep 2010 02:41:41 -0400
Message-ID: <4C81EA1A.1010100@nokia.com>
Date: Sat, 04 Sep 2010 09:41:30 +0300
From: Adrian Hunter <adrian.hunter@nokia.com>
User-Agent: Thunderbird 2.0.0.24 (X11/20100411)
MIME-Version: 1.0
To: Dan Carpenter <error27@gmail.com>
CC: Adrian Hunter <adrian.hunter@nokia.com>, linux-kernel@vger.kernel.org,
        Jens Axboe <axboe@kernel.dk>
Subject: Re: does "block: add secure discard" cause an overflow?
References: <20100903091631.GI5437@bicker>
In-Reply-To: <20100903091631.GI5437@bicker>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
X-OriginalArrivalTime: 04 Sep 2010 06:41:32.0482 (UTC) FILETIME=[36498220:01CB4BFC]
X-Nokia-AV: Clean
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Dan Carpenter wrote:
> This is the commit 8d57a98ccd0b44 "block: add secure discard".
> 
> The patch adds a letter 'E' to the string in blk_fill_rwbs().
>         if (rw & REQ_SECURE)
>                 rwbs[i++] = 'E';
> 
> The problem is that "rwbs" is a 6 character buffer and if all the flags
> are set the we'd get "WABSME" which would put us off the end (when you
> add the NUL terminator).

E goes with D which will not have either A or M, so there will not be
a rwbs with E that has more than 5 characters.

> 
> regards,
> dan carpenter
> 

