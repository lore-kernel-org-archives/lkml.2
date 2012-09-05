Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758228Ab2IEJDj (ORCPT <rfc822;w@1wt.eu>);
	Wed, 5 Sep 2012 05:03:39 -0400
Received: from mail.mev.co.uk ([62.49.15.74]:49878 "EHLO mail.mev.co.uk"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750826Ab2IEJDh (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 5 Sep 2012 05:03:37 -0400
Message-ID: <50471558.4030505@mev.co.uk>
Date: Wed, 5 Sep 2012 10:03:20 +0100
From: Ian Abbott <abbotti@mev.co.uk>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:15.0) Gecko/20120903 Thunderbird/15.0
MIME-Version: 1.0
To: Jan Kara <jack@suse.cz>
CC: Ian Abbott <ian.abbott@mev.co.uk>, lkml <linux-kernel@vger.kernel.org>,
        "linux-fsdevel@vger.kernel.org" <linux-fsdevel@vger.kernel.org>
Subject: Re: [PATCH v3] UDF: Add support for O_DIRECT
References: <1343731212-4381-1-git-send-email-abbotti@mev.co.uk> <1346752179-28052-1-git-send-email-abbotti@mev.co.uk> <20120904143947.GC8656@quack.suse.cz> <50461A24.8070003@mev.co.uk>
In-Reply-To: <50461A24.8070003@mev.co.uk>
Content-Type: text/plain; charset="us-ascii"; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 2012-09-04 16:11, Ian Abbott wrote:
> On 2012-09-04 15:39, Jan Kara wrote:
>> On Tue 04-09-12 10:49:39, Ian Abbott wrote:
>>> Add support for the O_DIRECT flag.  There are two cases to deal with:
>>    Out of curiosity, do you have a use for this feature or is it mostly
>> academic interest?
>
> I'm planning to use it for an embedded project that needs to stream
> large files off a CompactFlash card, but the data doesn't need to be in
> the buffer cache as its only read once, and the system has very limited
> memory bandwidth so I can't afford the the extra copy.  The old version
> of this project only supported FAT, but that limited the file size to
> about 4GiB.  The filesystem needs to be something reasonably
> Windows-friendly, at least for adding the files to the CompactFlash card
> in the first place.

Actually, remembering back (the old project was about 3 years ago), the 
main reason for using O_DIRECT was it was causing too much memory 
fragmentation on my MMU-less embedded system.  That and the extra 
overhead of managing the buffer cache for data that was only read once.

-- 
-=( Ian Abbott @ MEV Ltd.    E-mail: <abbotti@mev.co.uk>        )=-
-=( Tel: +44 (0)161 477 1898   FAX: +44 (0)161 718 3587         )=-
