Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760486Ab0KRVhk (ORCPT <rfc822;w@1wt.eu>);
	Thu, 18 Nov 2010 16:37:40 -0500
Received: from ironport2-out.teksavvy.com ([206.248.154.183]:60459 "EHLO
	ironport2-out.pppoe.ca" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1755203Ab0KRVhi (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 18 Nov 2010 16:37:38 -0500
X-IronPort-Anti-Spam-Filtered: true
X-IronPort-Anti-Spam-Result: ApIBAKEq5UxLd/sX/2dsb2JhbAAHgz3OV5B2gSKDNnMEhFqLEA
X-IronPort-AV: E=Sophos;i="4.59,218,1288584000"; 
   d="scan'208";a="82907688"
Message-ID: <4CE59C9E.6050902@teksavvy.com>
Date: Thu, 18 Nov 2010 16:37:34 -0500
From: Mark Lord <kernel@teksavvy.com>
User-Agent: Mozilla/5.0 (X11; U; Linux i686; en-GB; rv:1.9.2.12) Gecko/20101027 Thunderbird/3.1.6
MIME-Version: 1.0
To: James Bottomley <James.Bottomley@suse.de>
CC: Christoph Hellwig <hch@infradead.org>, Matthew Wilcox <matthew@wil.cx>,
        Josef Bacik <josef@redhat.com>, Lukas Czerner <lczerner@redhat.com>,
        tytso@mit.edu, linux-ext4@vger.kernel.org,
        linux-kernel@vger.kernel.org, linux-fsdevel@vger.kernel.org,
        sandeen@redhat.com
Subject: Re: [PATCH 1/2] fs: Do not dispatch FITRIM through separate super_operation
References: <1290065809-3976-1-git-send-email-lczerner@redhat.com>	 <20101118130630.GJ6178@parisc-linux.org>	 <20101118134804.GN5618@dhcp231-156.rdu.redhat.com>	 <20101118141957.GK6178@parisc-linux.org>	 <20101118142918.GA18510@infradead.org> <1290100750.3041.72.camel@mulgrave.site>
In-Reply-To: <1290100750.3041.72.camel@mulgrave.site>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 10-11-18 12:19 PM, James Bottomley wrote:
>
> Not stepping into the debate: I'm happy to see punch go to the mapping
> data and FITRIM pick it up later.
>
> However, I think it's time to question whether we actually still want to
> allow online discard at all.  Most of the benchmarks show it to be a net
> lose to almost everything (either SSD or Thinly Provisioned arrays), so
> it's become an "enable this to degrade performance" option with no
> upside.

I also suspect that online TRIM exerts significant premature wear on the SSDs.
TRIM operations most likely trigger immediate copy/erase operations internal
to most SSDs, often regardless of the amount of data being trimmed.

Performing a 256KB erase because of a 1024-byte TRIM, over and over, is going
to harm the expected lifetime of an SSD.  Sure, some SSDs may do things differently
internally, but I don't see it working that way in much of the current crop of SSDs.

Currently, I patch my kernels to remove the automatic online TRIMs.
Is there a knob somewhere for this in the later kernels?

Cheers
