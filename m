Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933544Ab0EDSla (ORCPT <rfc822;w@1wt.eu>);
	Tue, 4 May 2010 14:41:30 -0400
Received: from mail.parknet.co.jp ([210.171.160.6]:58037 "EHLO
	mail.parknet.co.jp" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932269Ab0EDSl3 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 4 May 2010 14:41:29 -0400
From: OGAWA Hirofumi <hirofumi@mail.parknet.co.jp>
To: Fredrick Prashanth John Berchmans <fredrickprashanth@gmail.com>
Cc: Christoph Hellwig <hch@infradead.org>, linux-kernel@vger.kernel.org
Subject: Re: nfs accesses of FAT fs folders causes deadlock on lock_super
References: <x2gd4f60c3c1005032259p8be864bcucff91618016a0eb@mail.gmail.com>
	<20100504103232.GA25054@infradead.org>
	<t2gd4f60c3c1005041101o5720e1e4k69b4a7b76296e70f@mail.gmail.com>
Date: Wed, 05 May 2010 03:41:27 +0900
In-Reply-To: <t2gd4f60c3c1005041101o5720e1e4k69b4a7b76296e70f@mail.gmail.com>
	(Fredrick Prashanth John Berchmans's message of "Tue, 4 May 2010
	11:01:22 -0700")
Message-ID: <87mxwfy0fc.fsf@devron.myhome.or.jp>
User-Agent: Gnus/5.13 (Gnus v5.13) Emacs/23.1.93 (gnu/linux)
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Fredrick Prashanth John Berchmans <fredrickprashanth@gmail.com> writes:

> On Tue, May 4, 2010 at 3:32 AM, Christoph Hellwig <hch@infradead.org> wrote:
>> On Mon, May 03, 2010 at 10:59:42PM -0700, Fredrick Prashanth John Berchmans wrote:
>>> The box was running kernel version 2.6.27.10.
>>> But I think the FAT code has not changed much.
>>
>> But the nfsd code has and now doesn't call lookup from the filldir
>> callback anymore.
>>
>>
>
> I see from nfsd code, it seems the compose_entry_fh still calls
> lookup_one_len, which is now
> called from encode_entryplus_baggage instead of entry_encode.
> Am I right?

As far as I can see, nfsd is buffering the result of readdir, then do
jobs (encode_fh, etc.) with it on other context of readdir.

Aren't you missing a buffering of nfsd_buffered_readdir()?

Thanks.
-- 
OGAWA Hirofumi <hirofumi@mail.parknet.co.jp>
