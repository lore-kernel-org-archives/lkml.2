Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754581Ab0KSOx5 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 19 Nov 2010 09:53:57 -0500
Received: from ironport2-out.teksavvy.com ([206.248.154.183]:54611 "EHLO
	ironport2-out.pppoe.ca" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1753548Ab0KSOxz (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 19 Nov 2010 09:53:55 -0500
X-IronPort-Anti-Spam-Filtered: true
X-IronPort-Anti-Spam-Result: ApIBAJIe5kxLd/sX/2dsb2JhbAAHgz3MM5EQgSKDNnMEhFqLEw
X-IronPort-AV: E=Sophos;i="4.59,223,1288584000"; 
   d="scan'208";a="82982504"
Message-ID: <4CE68F80.7000607@teksavvy.com>
Date: Fri, 19 Nov 2010 09:53:52 -0500
From: Mark Lord <kernel@teksavvy.com>
User-Agent: Mozilla/5.0 (X11; U; Linux i686; en-GB; rv:1.9.2.12) Gecko/20101027 Thunderbird/3.1.6
MIME-Version: 1.0
To: Chris Mason <chris.mason@oracle.com>
CC: James Bottomley <james.bottomley@suse.de>,
        Christoph Hellwig <hch@infradead.org>, Matthew Wilcox <matthew@wil.cx>,
        Josef Bacik <josef@redhat.com>, Lukas Czerner <lczerner@redhat.com>,
        tytso <tytso@mit.edu>, linux-ext4 <linux-ext4@vger.kernel.org>,
        linux-kernel <linux-kernel@vger.kernel.org>,
        linux-fsdevel <linux-fsdevel@vger.kernel.org>,
        sandeen <sandeen@redhat.com>
Subject: Re: [PATCH 1/2] fs: Do not dispatch FITRIM through separate super_operation
References: <1290065809-3976-1-git-send-email-lczerner@redhat.com> <20101118130630.GJ6178@parisc-linux.org> <20101118134804.GN5618@dhcp231-156.rdu.redhat.com> <20101118141957.GK6178@parisc-linux.org> <20101118142918.GA18510@infradead.org> <1290100750.3041.72.camel@mulgrave.site> <4CE59C9E.6050902@teksavvy.com> <1290177488-sup-6540@think>
In-Reply-To: <1290177488-sup-6540@think>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 10-11-19 09:40 AM, Chris Mason wrote:
>
> We've been told that online and constant trimming is the default in
> windows7.   The ssds are most likely to just start ignoring the trims
> they can't service efficiently.

Win7 collects multiple TRIM ranges over time and batches them as single TRIMs
(as reported to me by an SSD vendor who traced it with a SATA analyzer,
  and who also apparently has "inside info").

That's what we also need Linux to do.

Cheers
