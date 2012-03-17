Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757469Ab2CQSPG (ORCPT <rfc822;w@1wt.eu>);
	Sat, 17 Mar 2012 14:15:06 -0400
Received: from ironport2-out.teksavvy.com ([206.248.154.181]:48378 "EHLO
	ironport2-out.teksavvy.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1753992Ab2CQSOp (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 17 Mar 2012 14:14:45 -0400
X-IronPort-Anti-Spam-Filtered: true
X-IronPort-Anti-Spam-Result: ArwBAKU/KE8Y9geI/2dsb2JhbAAMgVOCPbt0hkyBK4NngQcEnyI
X-IronPort-AV: E=Sophos;i="4.73,1,1325480400"; 
   d="scan'208";a="168605855"
Message-ID: <4F64D493.9010404@teksavvy.com>
Date: Sat, 17 Mar 2012 14:14:43 -0400
From: Mark Lord <kernel@teksavvy.com>
User-Agent: Mozilla/5.0 (X11; Linux i686; rv:10.0.2) Gecko/20120216 Thunderbird/10.0.2
MIME-Version: 1.0
To: Shaohua Li <shli@kernel.org>
CC: NeilBrown <neilb@suse.de>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "linux-raid@vger.kernel.org" <linux-raid@vger.kernel.org>,
        "axboe@kernel.dk" <axboe@kernel.dk>
Subject: Re: [patch 0/7] Add TRIM support for raid linear/0/1/10
References: <20120312030412.375458948@fusionio.com> <20120314132422.3aeb6d49@notabene.brown> <4F6006C3.4010204@kernel.org>
In-Reply-To: <4F6006C3.4010204@kernel.org>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 12-03-13 10:47 PM, Shaohua Li wrote:
> On 3/14/12 10:24 AM, NeilBrown wrote:
>>  On Mon, 12 Mar 2012 11:04:12 +0800 Shaohua Li <shli@fusionio.com> wrote:
..
>>  Also I wonder about handling failure in RAID1.
>>  I think the code will currently treat it like a write error, and
>>  maybe record a bad block (then fail the device is writing the badblock
>>  record fails). Is that what were want?
> Mainly to simplify the code. And I thought a normal discard should not fail.
> If it fails, something is wrong, marked it as badblock maybe not bad.

That sounds like a VERY bad idea.
Failures happen for lots of reasons,
but generic comm errors are not an excuse to suddenly mark sectors as bad.
