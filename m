Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756409Ab0EaJPh (ORCPT <rfc822;w@1wt.eu>);
	Mon, 31 May 2010 05:15:37 -0400
Received: from smtp.nokia.com ([192.100.122.233]:31090 "EHLO
	mgw-mx06.nokia.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755889Ab0EaJPf (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 31 May 2010 05:15:35 -0400
Message-ID: <4C037E0D.6030708@nokia.com>
Date: Mon, 31 May 2010 12:14:53 +0300
From: Adrian Hunter <adrian.hunter@nokia.com>
User-Agent: Thunderbird 2.0.0.24 (X11/20100411)
MIME-Version: 1.0
To: Christoph Hellwig <hch@infradead.org>
CC: Andrew Morton <akpm@linux-foundation.org>,
       "linux-mmc@vger.kernel.org" <linux-mmc@vger.kernel.org>,
       LKML <linux-kernel@vger.kernel.org>
Subject: Re: [RFC][PATCH] mmc: add an ioctl for erasing
References: <4BF68EFC.70101@nokia.com> <20100521140714.GB15070@infradead.org> <4C037731.5030301@nokia.com> <20100531084709.GA7784@infradead.org>
In-Reply-To: <20100531084709.GA7784@infradead.org>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
X-OriginalArrivalTime: 31 May 2010 09:14:39.0268 (UTC) FILETIME=[B261CE40:01CB00A1]
X-Nokia-AV: Clean
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Christoph Hellwig wrote:
> On Mon, May 31, 2010 at 11:45:37AM +0300, Adrian Hunter wrote:
>> Sorry for the slow reply, I have been away.
>>
>> Connecting erase to discard was rejected for performance reasons in 2008.
>> Refer:
>>
>> 	http://thread.gmane.org/gmane.linux.file-systems/25378/focus=25606
> 
> The discard implementation changed a lot since those days.  Discard
> requests now have their own request size limitation which is separate
> form that for normal requests, and we also store the alignment
> requirement for them separately.
> 


I tested extensively at that time with all changes necessary to allow
discards to produce MMC erases that work with maximum efficacy.  There was
no performance benefit and operations like file deletion were much slower.

If connecting discard to MMC erase does not always improve performance, then
many people will have to change their mount options to include nodiscard.
Alternatively, if the connection is an optional configuration, then the
ioctl won't work all the time.

The erase ioctl needs to be separate from discard, which means it can be
made to support secure erase also.
