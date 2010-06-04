Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756280Ab0FDRIR (ORCPT <rfc822;w@1wt.eu>);
	Fri, 4 Jun 2010 13:08:17 -0400
Received: from ppsw-33.csi.cam.ac.uk ([131.111.8.133]:38468 "EHLO
	ppsw-33.csi.cam.ac.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752069Ab0FDRIP (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 4 Jun 2010 13:08:15 -0400
X-Cam-AntiVirus: no malware found
X-Cam-SpamDetails: not scanned
X-Cam-ScannerInfo: http://www.cam.ac.uk/cs/email/scanner/
Message-ID: <4C093317.1090606@cam.ac.uk>
Date: Fri, 04 Jun 2010 18:08:39 +0100
From: Jonathan Cameron <jic23@cam.ac.uk>
User-Agent: Mozilla/5.0 (X11; U; Linux x86_64; en-US; rv:1.9.1.9) Gecko/20100426 Thunderbird/3.0.4
MIME-Version: 1.0
To: Henrik Rydberg <rydberg@bitmath.org>
CC: Dmitry Torokhov <dmitry.torokhov@gmail.com>, linux-input@vger.kernel.org,
       linux-kernel@vger.kernel.org, Jiri Kosina <jkosina@suse.cz>,
       Mika Kuoppala <mika.kuoppala@nokia.com>,
       Benjamin Tissoires <tissoire@cena.fr>, Rafi Rubin <rafi@seas.upenn.edu>,
       Oleg Nesterov <oleg@redhat.com>
Subject: Re: [PATCH 1/4] input: Introduce buflock, a one-to-many circular
 buffer mechanism
References: <1275552062-8153-1-git-send-email-rydberg@euromail.se> <1275552062-8153-2-git-send-email-rydberg@euromail.se> <20100604065658.GE21239@core.coreip.homeip.net> <4C08BCB5.7020201@bitmath.org>
In-Reply-To: <4C08BCB5.7020201@bitmath.org>
X-Enigmail-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 06/04/10 09:43, Henrik Rydberg wrote:
> Hi Dmitry,
>>> +struct buflock_writer {
>>> +	unsigned int head;
>>> +	unsigned int next_head;
>>> +};
>>
>> Since there can be only one writer thread should we just create "struct
>> buflock" and pull head and next head into it along with the buffer
>> itself and element size?
> 
> It is possible, but there are some arguments against it:
> 
> 1. What type to give the buffer?
> 2. Static or dynamic buffering?
> 3. Can size be both a compile-time constant and a variable?
> 
> In short, I think that by _not_ including the actual buffer, the method
> ultimately becomes more useful.
> 
>> Also, maybe we could extend kfifo with the notion of multiple readers?
> 
> If merging the data and algorithm as you suggest, that would be a logical step,
> yes. To me, the most ideal would be to modify split the kfifo into data, writers
> and readers. But that would require api changes.
> 
>>
>> In any case, it shoudl not live in include/linux/input/ as it may be
>> useful ouside of input subsystem.
> 
> Agreed.
I've just opened a debate on linux-iio about whether we want our event infrastructure to
support multiple readers. If enough people care, then this looks like some infrastructure
we will be wanting to use as well so I would definitely support putting this outside 
of input.

Jonathan
