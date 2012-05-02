Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752486Ab2EBJ2r (ORCPT <rfc822;w@1wt.eu>);
	Wed, 2 May 2012 05:28:47 -0400
Received: from mail-bk0-f46.google.com ([209.85.214.46]:63273 "EHLO
	mail-bk0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750988Ab2EBJ2q (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 2 May 2012 05:28:46 -0400
Date: Wed, 2 May 2012 11:28:38 +0200
From: Andi Shyti <andi.shyti@gmail.com>
To: jonghwa3.lee@samsung.com
Cc: sameo@linux.intel.com, linux-kernel@vger.kernel.org, cw00.choi@samsung.com,
        Chiwoong byun <woong.byun@samsung.com>,
        Kyungmin Park <kyungmin.park@samsung.com>,
        MyungJoo Ham <myungjoo.ham@samsung.com>
Subject: Re: [PATCH] MFD : add MAX77686 mfd driver
Message-ID: <20120502092838.GA16327@andi>
Mail-Followup-To: jonghwa3.lee@samsung.com, sameo@linux.intel.com,
	linux-kernel@vger.kernel.org, cw00.choi@samsung.com,
	Chiwoong byun <woong.byun@samsung.com>,
	Kyungmin Park <kyungmin.park@samsung.com>,
	MyungJoo Ham <myungjoo.ham@samsung.com>
References: <1335776022-4571-1-git-send-email-jonghwa3.lee@samsung.com>
 <20120430091748.GA2460@andi>
 <4FA0BFFF.8090306@samsung.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <4FA0BFFF.8090306@samsung.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi,

On Wed, May 02, 2012 at 02:02:55PM +0900, jonghwa3.lee@samsung.com wrote:
> On 2012-04-30 18:17, Andi Shyti wrote:
> > Hi,
> > 
> >> +	mutex_lock(&max77686->iolock);
> >> +	ret = i2c_smbus_read_i2c_block_data(i2c, reg, count, buf);
> >> +	mutex_unlock(&max77686->iolock);
> > 
> > Is it relly necessay to lock whenever you read/write from/to the
> > i2c bus? Considering also that these are exported function,
> > someone else may lock here before, so we can have a double
> > locking on the same mutex.
> 
> These exported functions will be used in 77686 area only, so there is no
> overlap locking.

OK... I think this could be a reason more to not over-use mutexes :)

When you call i2c_smbus_* functions you are not accessing to any
private data, all the new data is allocated in a new area. The
smbus_xfer function should take care by himself that the global
data are locked correctly. If not, is not up to your driver to do
it.
If, instead, you are taking care about the concurrency in the
bus, this should be somehow managed by the chip itself.
In my opinion you are abusing a bit of mutex_lock/unlock.

Andi

P.S. copied and paste your reply at the bottom of my previous
comment.
