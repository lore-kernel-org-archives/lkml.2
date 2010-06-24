Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753603Ab0FXGOn (ORCPT <rfc822;w@1wt.eu>);
	Thu, 24 Jun 2010 02:14:43 -0400
Received: from 0122700014.0.fullrate.dk ([95.166.99.235]:57951 "EHLO kernel.dk"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751782Ab0FXGOm (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 24 Jun 2010 02:14:42 -0400
Message-ID: <4C22F7D0.6070105@kernel.dk>
Date: Thu, 24 Jun 2010 08:14:40 +0200
From: Jens Axboe <axboe@kernel.dk>
MIME-Version: 1.0
To: Tao Ma <tao.ma@oracle.com>
CC: akpm@linux-foundation.org, linux-kernel@vger.kernel.org, stable@kernel.org,
       hch@lst.de, linux-fsdevel@vger.kernel.org
Subject: Re: [PATCH v2] block: Don't count_vm_events for discard bio in submit_bio.
References: <20100623124046.4dec96d1.akpm@linux-foundation.org> <1277339295-6524-1-git-send-email-tao.ma@oracle.com>
In-Reply-To: <1277339295-6524-1-git-send-email-tao.ma@oracle.com>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 2010-06-24 02:28, Tao Ma wrote:
> Hi Andrew,
>> Yes, that's a buglet.
>>
>> Note that Christoph's "[PATCH, RFC] block: don't allocate a payload for
>> discard request" will fix it in a better way.  That patch is in
>> linux-next now, but I expect it will be taken out again (quickly,
>> please) because Mike has found a number of problems with it.  
> ok, I haven't noticed that. thanks for the info.
>>
>> Your patch looks like a decent temporary fix for mainline, and a
>> permanent one for -stable.
> I am sorry, but I made a mistake. BIO_RW_DISCARD is a enum for bit offset.
> So the right check should be rw & (1 << BIO_RW_DISCARD).
> I have regenerated the patch. Sorry for the inconvenience.

Thanks, this one looks good. Applied.

-- 
Jens Axboe

