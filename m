Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760746Ab0KRWHH (ORCPT <rfc822;w@1wt.eu>);
	Thu, 18 Nov 2010 17:07:07 -0500
Received: from ironport2-out.teksavvy.com ([206.248.154.181]:38304 "EHLO
	ironport2-out.pppoe.ca" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1754952Ab0KRWHE (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 18 Nov 2010 17:07:04 -0500
X-IronPort-Anti-Spam-Filtered: true
X-IronPort-Anti-Spam-Result: ApIBAJ4x5UxLd/sX/2dsb2JhbAAHgz3ONpBygSKDNnMEhFqLEA
X-IronPort-AV: E=Sophos;i="4.59,219,1288584000"; 
   d="scan'208";a="82910916"
Message-ID: <4CE5A386.7000105@teksavvy.com>
Date: Thu, 18 Nov 2010 17:07:02 -0500
From: Mark Lord <kernel@teksavvy.com>
User-Agent: Mozilla/5.0 (X11; U; Linux i686; en-GB; rv:1.9.2.12) Gecko/20101027 Thunderbird/3.1.6
MIME-Version: 1.0
To: James Bottomley <James.Bottomley@suse.de>
CC: Greg Freemyer <greg.freemyer@gmail.com>, Jeff Moyer <jmoyer@redhat.com>,
        Christoph Hellwig <hch@infradead.org>, Matthew Wilcox <matthew@wil.cx>,
        Josef Bacik <josef@redhat.com>, Lukas Czerner <lczerner@redhat.com>,
        tytso@mit.edu, linux-ext4@vger.kernel.org,
        linux-kernel@vger.kernel.org, linux-fsdevel@vger.kernel.org,
        sandeen@redhat.com
Subject: Re: [PATCH 1/2] fs: Do not dispatch FITRIM through separate super_operation
References: <1290065809-3976-1-git-send-email-lczerner@redhat.com>	 <20101118130630.GJ6178@parisc-linux.org>	 <20101118134804.GN5618@dhcp231-156.rdu.redhat.com>	 <20101118141957.GK6178@parisc-linux.org>	 <20101118142918.GA18510@infradead.org>	 <1290100750.3041.72.camel@mulgrave.site>	 <x494obe4kd5.fsf@segfault.boston.devel.redhat.com>	 <1290102098.3041.77.camel@mulgrave.site>	 <AANLkTim=SkqBehcCvEME7YVHk3S0dLdmBS8ooRF+-BuW@mail.gmail.com>	 <4CE59E57.2090009@teksavvy.com> <1290117009.11007.42.camel@mulgrave.site>
In-Reply-To: <1290117009.11007.42.camel@mulgrave.site>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 10-11-18 04:50 PM, James Bottomley wrote:
>
> Before we go gung ho on this, there's no evidence that N discontiguous
> ranges in one command are any better than the ranges sent N times ...
> the same amount of erase overhead gets sent on SSDs.

No, we do have evidence:  execution time of the TRIM commands on the SSD.

The one-range-at-a-time is incredibly slow compared to multiple ranges at a time.
That slowness comes from somewhere, with about 99.9% certainty that it is due
to the drive performing slow flash erase cycles.

I think perhaps we should do the batching as much as possible,
and then split them into single ranges for LLDs that cannot handle multi-ranges.

Way more efficient that way.

Cheers
