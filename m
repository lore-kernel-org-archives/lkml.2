Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933323Ab2HPUBs (ORCPT <rfc822;w@1wt.eu>);
	Thu, 16 Aug 2012 16:01:48 -0400
Received: from smtprelay-b21.telenor.se ([195.54.99.212]:38713 "EHLO
	smtprelay-b21.telenor.se" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S933217Ab2HPUBq (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 16 Aug 2012 16:01:46 -0400
X-SENDER-IP: [85.230.170.20]
X-LISTENER: [smtp.bredband.net]
X-IronPort-Anti-Spam-Filtered: true
X-IronPort-Anti-Spam-Result: AgFOAK1QLVBV5qoUPGdsb2JhbABFhRiFI690GQEBAQEeGQ0ngiABAQQBOhwjBQsIA0YUJQoaiBoKuw4UkG1gA5VOhWyNCA
X-IronPort-AV: E=Sophos;i="4.77,781,1336341600"; 
   d="scan'208";a="98471683"
From: "Henrik Rydberg" <rydberg@euromail.se>
Date: Thu, 16 Aug 2012 22:05:53 +0200
To: Ping Cheng <pinglinux@gmail.com>
Cc: Dmitry Torokhov <dmitry.torokhov@gmail.com>, Jiri Kosina <jkosina@suse.cz>,
        linux-input@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH 09/19] Input: MT - Handle frame synchronization in core
Message-ID: <20120816200553.GA751@polaris.bitmath.org>
References: <1344807757-2217-1-git-send-email-rydberg@euromail.se>
 <1344807757-2217-10-git-send-email-rydberg@euromail.se>
 <CAF8JNhLBO72-Rpm7dFWfYLPvbhDZZsm2yOy_7sREnNhTWqZ04w@mail.gmail.com>
 <20120816180732.GA451@polaris.bitmath.org>
 <CAF8JNhJ1R68pU3aOCnYC8KvmfDDU7oKhMsvQV5hfRX2qE=X5WA@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <CAF8JNhJ1R68pU3aOCnYC8KvmfDDU7oKhMsvQV5hfRX2qE=X5WA@mail.gmail.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

> For example, the new input_mt_init_slots() takes care of the
> __set_bit() functions in one place. That is great. But, it requires
> wacom_wac.c to be updated since it has an interface change. I guess
> there are other drivers calling input_mt_init_slots as well.

The default behavior in the "new" input_mt_init_slots(), i.e. with the
zero flags argument added to all the drivers, is exactly the same as
before. No further changes are necessary.

Yes, some drivers could definitely start using some of the flags to
good advantage, but there is no rush to make that happen. Such changes
would of course involve the driver maintainers.

> I was wondering if you plan to update all drivers after this patchset
> is accepted or if you need us to chime in.

Thank you, the best is definitely if you want to do it yourself. Let's
just see where the latency-related work takes us first, since it might
affect how to send data from drivers.

> From what I see, frame/mt is only initialized when driver starts.
> Frame will be increased by MT events while the driver running. If this
> is true, won't it be possible the value gets too large?

Yes, but as is apparent from the code, the semantics of that variable
is not to count the number of frames since the dawn of times, but to
keep track of changes per frame.

Thanks,
Henrik
