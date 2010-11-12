Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932745Ab0KLRFA (ORCPT <rfc822;w@1wt.eu>);
	Fri, 12 Nov 2010 12:05:00 -0500
Received: from mx1.redhat.com ([209.132.183.28]:18792 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1757558Ab0KLRE7 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 12 Nov 2010 12:04:59 -0500
Message-ID: <4CDD73AF.8070505@redhat.com>
Date: Fri, 12 Nov 2010 12:04:47 -0500
From: Rik van Riel <riel@redhat.com>
User-Agent: Mozilla/5.0 (X11; U; Linux x86_64; en-US; rv:1.9.2.8) Gecko/20100806 Fedora/3.1.2-1.fc13 Lightning/1.0b2pre Thunderbird/3.1.2
MIME-Version: 1.0
To: Jeff Layton <jlayton@redhat.com>
CC: Andrew Morton <akpm@linux-foundation.org>, "Ted Ts'o" <tytso@mit.edu>,
        linux-kernel@vger.kernel.org, esandeen@redhat.com, jmoyer@redhat.com,
        linux-fsdevel@vger.kernel.org,
        Alexander Viro <viro@zeniv.linux.org.uk>, lmcilroy@redhat.com
Subject: Re: [PATCH] clear PageError bit in msync & fsync
References: <20101109114422.3918e7f6@annuminas.surriel.com>	<20101109142109.224267d0@corrin.poochiereds.net>	<4CD9A209.6070807@redhat.com>	<20101109210715.GJ3099@thunk.org>	<4CD9BA08.2000002@redhat.com>	<20101109134139.c6f9f6dc.akpm@linux-foundation.org>	<4CDCC457.9030400@redhat.com> <20101112105250.75f01670@tlielax.poochiereds.net>
In-Reply-To: <20101112105250.75f01670@tlielax.poochiereds.net>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 11/12/2010 10:52 AM, Jeff Layton wrote:

> Now, process A issues an fsync. He gets an error but his data was
> flushed to disk just fine. Is that also incorrect behavior?

I suspect it is better for fsync to return an error when
it wasn't process A's error (but there was an error), than
to pretend everything was just fine when in fact an error
did happen.

When getting an error, the program can retry the write
(to redirty the pages) and retry the IO by calling fsync
again.

If no real error happened, at worst it gets to do the
IO twice.

-- 
All rights reversed
