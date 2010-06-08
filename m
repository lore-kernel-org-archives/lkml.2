Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755474Ab0FHS7p (ORCPT <rfc822;w@1wt.eu>);
	Tue, 8 Jun 2010 14:59:45 -0400
Received: from 0122700014.0.fullrate.dk ([95.166.99.235]:46789 "EHLO kernel.dk"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754320Ab0FHS7n (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 8 Jun 2010 14:59:43 -0400
Message-ID: <4C0E931A.2030509@fusionio.com>
Date: Tue, 08 Jun 2010 20:59:38 +0200
From: Jens Axboe <jaxboe@fusionio.com>
User-Agent: Mozilla/5.0 (X11; U; Linux x86_64; en-US; rv:1.9.1.9) Gecko/20100423 Thunderbird/3.0.4
MIME-Version: 1.0
To: Miklos Szeredi <miklos@szeredi.hu>
CC: akpm@linux-foundation.org, torvalds@linux-foundation.org,
       linux-fsdevel@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH 2/2] pipe: remove bogus check from "set size" fcntl
References: <E1OLznJ-0003rR-OZ@pomaz-ex.szeredi.hu> <E1OLzoX-0003sA-2Y@pomaz-ex.szeredi.hu> <E1OM0Vn-0003xX-E5@pomaz-ex.szeredi.hu>
In-Reply-To: <E1OM0Vn-0003xX-E5@pomaz-ex.szeredi.hu>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 2010-06-08 17:14, Miklos Szeredi wrote:
> On Tue, 08 Jun 2010, Miklos Szeredi wrote:
>> From: Miklos Szeredi <mszeredi@suse.cz>
>>
>> As it stands this check compares the number of pages to the page size.
>> This makes no sense and makes the fcntl fail in almost any sane case.
>>
>> Fix it by removing the check completely, round_pipe_size() will make
>> sure that nr_pages >= 1 anyway.
> 
> Hmm, not quite true.  It can actually return zero if round_pipe_size()
> overflows unsigned int.
> 
> Updated patch below.

Thanks, I'll get these tested and merged asap. The copy code
apparently wasn't well tested. And this fcntl() bug snuck in with the
API changes :/

-- 
Jens Axboe

