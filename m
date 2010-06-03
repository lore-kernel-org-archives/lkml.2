Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758099Ab0FCIOe (ORCPT <rfc822;w@1wt.eu>);
	Thu, 3 Jun 2010 04:14:34 -0400
Received: from crca.org.au ([74.207.252.120]:41883 "EHLO crca.org.au"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1757936Ab0FCIOa (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 3 Jun 2010 04:14:30 -0400
X-Bogosity: Ham, spamicity=0.000000
Message-ID: <4C07645D.1060409@crca.org.au>
Date: Thu, 03 Jun 2010 18:14:21 +1000
From: Nigel Cunningham <ncunningham@crca.org.au>
User-Agent: Mozilla/5.0 (X11; U; Linux i686; en-US; rv:1.9.1.9) Gecko/20100423 Thunderbird/3.0.4
MIME-Version: 1.0
To: Pavel Machek <pavel@ucw.cz>
CC: pm list <linux-pm@lists.linux-foundation.org>,
       LKML <linux-kernel@vger.kernel.org>,
       TuxOnIce-devel <tuxonice-devel@tuxonice.net>
Subject: Re: [linux-pm] Proposal for a new algorithm for reading & writing
 a hibernation image.
References: <4BE7475A.8030901@crca.org.au> <20100530052546.GA25287@ucw.cz>
In-Reply-To: <20100530052546.GA25287@ucw.cz>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi.

On 30/05/10 15:25, Pavel Machek wrote:
> Hi!
>
>> 2. Prior to writing any of the image, also set up new 4k page tables
>> such that an attempt to make a change to any of the pages we're about to
>> write to disk will result in a page fault, giving us an opportunity to
>> flag the page as needing an atomic copy later. Once this is done, write
>> protection for the page can be disabled and the write that caused the
>> fault allowed to proceed.
>
> Tricky.
>
> page faulting code touches memory, too...

Yeah. I realise we'd need to make the pages that are used to record the 
faults be unprotected themselves. I'm imagining a bitmap for that.

Do you see any reason that it could be inherently impossible? That's 
what I really want to know before (potentially) wasting time trying it.

Regards,

Nigel
