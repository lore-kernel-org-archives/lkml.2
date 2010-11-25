Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753342Ab0KYOx7 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 25 Nov 2010 09:53:59 -0500
Received: from ironport2-out.teksavvy.com ([206.248.154.183]:37463 "EHLO
	ironport2-out.pppoe.ca" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1752628Ab0KYOx5 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 25 Nov 2010 09:53:57 -0500
X-IronPort-Anti-Spam-Filtered: true
X-IronPort-Anti-Spam-Result: ApIBAJIH7kxLd/sX/2dsb2JhbAAHg0jPA5BpgSGDM3MEhFyLGQ
X-IronPort-AV: E=Sophos;i="4.59,255,1288584000"; 
   d="scan'208";a="83661082"
Message-ID: <4CEE7884.5010007@teksavvy.com>
Date: Thu, 25 Nov 2010 09:53:56 -0500
From: Mark Lord <kernel@teksavvy.com>
User-Agent: Mozilla/5.0 (X11; U; Linux i686; en-GB; rv:1.9.2.12) Gecko/20101027 Thunderbird/3.1.6
MIME-Version: 1.0
To: Greg Freemyer <greg.freemyer@gmail.com>
CC: "Ted Ts'o" <tytso@mit.edu>, Lukas Czerner <lczerner@redhat.com>,
        Steven Whitehouse <swhiteho@redhat.com>,
        James Bottomley <James.Bottomley@suse.de>,
        Christoph Hellwig <hch@infradead.org>, Matthew Wilcox <matthew@wil.cx>,
        Josef Bacik <josef@redhat.com>, linux-ext4@vger.kernel.org,
        linux-kernel@vger.kernel.org, linux-fsdevel@vger.kernel.org,
        sandeen@redhat.com
Subject: Re: [PATCH 1/2] fs: Do not dispatch FITRIM through separate super_operation
References: <20101118134804.GN5618@dhcp231-156.rdu.redhat.com> <20101118141957.GK6178@parisc-linux.org> <20101118142918.GA18510@infradead.org> <1290100750.3041.72.camel@mulgrave.site> <alpine.LFD.2.00.1011181826550.15886@dhcp-lab-213.englab.brq.redhat.com> <1290168976.2570.45.camel@dolmen> <4CE68155.50705@teksavvy.com> <20101119140203.GC10039@thunk.org> <4CE69940.6040908@teksavvy.com> <alpine.LFD.2.00.1011191640320.3238@dhcp-lab-213.englab.brq.redhat.com> <20101119163013.GJ10039@thunk.org> <4CEDCE60.9050109@teksavvy.com> <AANLkTimkGr=mpf6xbjvSFc9hZtf6f+UQ2F-N9aZxBsgb@mail.gmail.com>
In-Reply-To: <AANLkTimkGr=mpf6xbjvSFc9hZtf6f+UQ2F-N9aZxBsgb@mail.gmail.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 10-11-24 11:41 PM, Greg Freemyer wrote:
>
> If you see a significant speed difference between mke2fs and running
> wiper.sh on that same filesystem immediately after formatting, then
> their is likely a bug worth chasing.


You're right.  They're both equally slow on a blank Sandforce drive,
taking about 83-90 seconds to TRIM 100GB.

The difference being that mke2fs just sits there with zero indication
or information as to what the huge delay is.

It's a pity the TRIM commands are so sluggish on the Sandforce.
It's a generation newer than the original Vertex, and TRIM is way faster
on the older Vertex.  Not that either of them do it quickly enough that
I'd ever want the kernel doing it automatically "on my behalf".

The strange thing, is that when we TRIM the entire raw device,
using ATA SECURITY ERASE, it takes less than 2 seconds.

Cheers
