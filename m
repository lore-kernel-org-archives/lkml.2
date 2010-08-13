Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S934333Ab0HMNYH (ORCPT <rfc822;w@1wt.eu>);
	Fri, 13 Aug 2010 09:24:07 -0400
Received: from hera.kernel.org ([140.211.167.34]:37833 "EHLO hera.kernel.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S934280Ab0HMNYF (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 13 Aug 2010 09:24:05 -0400
Message-ID: <4C6546E0.7070208@kernel.org>
Date: Fri, 13 Aug 2010 15:21:36 +0200
From: Tejun Heo <tj@kernel.org>
User-Agent: Mozilla/5.0 (X11; U; Linux i686 (x86_64); en-US; rv:1.9.2.8) Gecko/20100802 Thunderbird/3.1.2
MIME-Version: 1.0
To: Vladislav Bolkhovitin <vst@vlnb.net>
CC: jaxboe@fusionio.com, linux-fsdevel@vger.kernel.org,
        linux-scsi@vger.kernel.org, linux-ide@vger.kernel.org,
        linux-kernel@vger.kernel.org, linux-raid@vger.kernel.org, hch@lst.de,
        James.Bottomley@suse.de, tytso@mit.edu, chris.mason@oracle.com,
        swhiteho@redhat.com, konishi.ryusuke@lab.ntt.co.jp,
        dm-devel@redhat.com, jack@suse.cz, rwheeler@redhat.com, hare@suse.de
Subject: Re: [PATCHSET block#for-2.6.36-post] block: replace barrier with
 sequenced flush
References: <1281616891-5691-1-git-send-email-tj@kernel.org> <4C6540C5.8070108@vlnb.net>
In-Reply-To: <4C6540C5.8070108@vlnb.net>
X-Enigmail-Version: 1.1.1
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-4.2.3 (hera.kernel.org [127.0.0.1]); Fri, 13 Aug 2010 13:23:41 +0000 (UTC)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hello,

On 08/13/2010 02:55 PM, Vladislav Bolkhovitin wrote:
> If requested, I can develop the interface further.

I still think the benefit of ordering by tag would be marginal at
best, and what have you guys measured there?  Under the current
framework, there's no easy way to measure full ordered-by-tag
implementation.  The mechanism for filesystems to communicate the
ordering information (which would be a partially ordered graph) just
isn't there and there is no way the current usage of ordering-by-tag
only for barrier sequence can achieve anything close to that level of
difference.

Ripping out the original ordering by tag mechanism doesn't amount to
much.  The use of ordering-by-tag was pretty half-assed there anyway.
If you think exporting full ordering information from filesystem to
the lower layers is worthwhile, please go ahead.  It would be very
interesting to see how much actual difference it can make compared to
ordering-by-filesystem and if it's actually better and the added
complexity is manageable, there's no reason not to do that.

Thank you.

-- 
tejun
