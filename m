Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932346Ab2DYWbc (ORCPT <rfc822;w@1wt.eu>);
	Wed, 25 Apr 2012 18:31:32 -0400
Received: from shards.monkeyblade.net ([198.137.202.13]:54520 "EHLO
	shards.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932107Ab2DYWbb (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 25 Apr 2012 18:31:31 -0400
Date: Wed, 25 Apr 2012 18:31:21 -0400 (EDT)
Message-Id: <20120425.183121.1283820821646106475.davem@davemloft.net>
To: hpa@linux.intel.com
Cc: tj@kernel.org, htmldeveloper@gmail.com, linux-kernel@vger.kernel.org,
        akpm@linux-foundation.org, mingo@elte.hu, linux-mm@kvack.org
Subject: Re: [BUG]memblock: fix overflow of array index
From: David Miller <davem@davemloft.net>
In-Reply-To: <4F987ACB.8050604@linux.intel.com>
References: <CAHnt0GXW-pyOUuBLB1n6qBP4WNGpET9er_HbJ29s5j5DE1xAdA@mail.gmail.com>
	<20120425222819.GF8989@google.com>
	<4F987ACB.8050604@linux.intel.com>
X-Mailer: Mew version 6.5 on Emacs 24.0.95 / Mule 6.0 (HANACHIRUSATO)
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
X-Greylist: Sender succeeded SMTP AUTH, not delayed by milter-greylist-4.2.6 (shards.monkeyblade.net [198.137.202.13]); Wed, 25 Apr 2012 15:31:23 -0700 (PDT)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: "H. Peter Anvin" <hpa@linux.intel.com>
Date: Wed, 25 Apr 2012 15:29:31 -0700

> On 04/25/2012 03:28 PM, Tejun Heo wrote:
>> 
>> All indexes in memblock are integers.  Changing that particular one to
>> unsigned int doesn't fix anything.  I think it just makes things more
>> confusing.  If there ever are cases w/ more then 2G memblocks, we're
>> going for 64bit not unsigned.
>> 
> 
> I would expect there to be plenty of memblocks larger than 2G?

Yes, but not the array indexes into those memblock entries, which is
what this patch is about.
