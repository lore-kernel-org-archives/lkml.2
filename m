Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760665Ab0KRVmT (ORCPT <rfc822;w@1wt.eu>);
	Thu, 18 Nov 2010 16:42:19 -0500
Received: from ironport2-out.teksavvy.com ([206.248.154.183]:48963 "EHLO
	ironport2-out.pppoe.ca" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1757165Ab0KRVmQ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 18 Nov 2010 16:42:16 -0500
X-IronPort-Anti-Spam-Filtered: true
X-IronPort-Anti-Spam-Result: ApIBAMIr5UxLd/sX/2dsb2JhbAAHgz3OV5B2gSKDNnMEhFqLEA
X-IronPort-AV: E=Sophos;i="4.59,218,1288584000"; 
   d="scan'208";a="82908159"
Message-ID: <4CE59DB6.9090304@teksavvy.com>
Date: Thu, 18 Nov 2010 16:42:14 -0500
From: Mark Lord <kernel@teksavvy.com>
User-Agent: Mozilla/5.0 (X11; U; Linux i686; en-GB; rv:1.9.2.12) Gecko/20101027 Thunderbird/3.1.6
MIME-Version: 1.0
To: Greg Freemyer <greg.freemyer@gmail.com>
CC: James Bottomley <James.Bottomley@suse.de>, Jeff Moyer <jmoyer@redhat.com>,
        Christoph Hellwig <hch@infradead.org>, Matthew Wilcox <matthew@wil.cx>,
        Josef Bacik <josef@redhat.com>, Lukas Czerner <lczerner@redhat.com>,
        tytso@mit.edu, linux-ext4@vger.kernel.org,
        linux-kernel@vger.kernel.org, linux-fsdevel@vger.kernel.org,
        sandeen@redhat.com
Subject: Re: [PATCH 1/2] fs: Do not dispatch FITRIM through separate super_operation
References: <1290065809-3976-1-git-send-email-lczerner@redhat.com> <20101118130630.GJ6178@parisc-linux.org> <20101118134804.GN5618@dhcp231-156.rdu.redhat.com> <20101118141957.GK6178@parisc-linux.org> <20101118142918.GA18510@infradead.org> <1290100750.3041.72.camel@mulgrave.site> <x494obe4kd5.fsf@segfault.boston.devel.redhat.com> <1290102098.3041.77.camel@mulgrave.site> <AANLkTim=SkqBehcCvEME7YVHk3S0dLdmBS8ooRF+-BuW@mail.gmail.com>
In-Reply-To: <AANLkTim=SkqBehcCvEME7YVHk3S0dLdmBS8ooRF+-BuW@mail.gmail.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 10-11-18 03:04 PM, Greg Freemyer wrote:
>
> I'm a fan of wiper.sh, but afaik it still cannot address a
> multi-spindle LVM setup, Nor a MDraid setup.  etc.
>
> That's because it bypasses the block stack and talks directly to the
> devices.  Thus it doesn't get the benefit of all the logical to
> physical sector remapping handled via the block stack.
>
> Mark, please correct me if I'm wrong.

I'm a big fan of FITRIM, especially as it should work on MD devices
as well, which are problematic for wiper.sh today.   I originally proposed
FITRIM (without the name, though) back when first implementing wiper.sh,
and I really believe we should extend FITRIM to btrfs and xfs.

hdparm is picking up support for FITRIM in the next release,
and wiper.sh will use it when it can in place of raw TRIMs.

This remains my own preferred method for TRIM:  offline, that is.  :)

Cheers
