Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757364Ab2CRCDe (ORCPT <rfc822;w@1wt.eu>);
	Sat, 17 Mar 2012 22:03:34 -0400
Received: from mail-qa0-f53.google.com ([209.85.216.53]:57915 "EHLO
	mail-qa0-f53.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756883Ab2CRCDd convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 17 Mar 2012 22:03:33 -0400
MIME-Version: 1.0
In-Reply-To: <4F64D493.9010404@teksavvy.com>
References: <20120312030412.375458948@fusionio.com>
	<20120314132422.3aeb6d49@notabene.brown>
	<4F6006C3.4010204@kernel.org>
	<4F64D493.9010404@teksavvy.com>
Date: Sun, 18 Mar 2012 10:03:31 +0800
X-Google-Sender-Auth: 9XnNRY8rAgagN7Xu-I_WfwvQI1A
Message-ID: <CANejiEU5t+Gq-4c=imR9CUNbs32jdLjBZrBw4PWy_UCRGp0==g@mail.gmail.com>
Subject: Re: [patch 0/7] Add TRIM support for raid linear/0/1/10
From: Shaohua Li <shli@kernel.org>
To: Mark Lord <kernel@teksavvy.com>
Cc: NeilBrown <neilb@suse.de>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "linux-raid@vger.kernel.org" <linux-raid@vger.kernel.org>,
        "axboe@kernel.dk" <axboe@kernel.dk>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

2012/3/18 Mark Lord <kernel@teksavvy.com>:
> On 12-03-13 10:47 PM, Shaohua Li wrote:
>> On 3/14/12 10:24 AM, NeilBrown wrote:
>>>  On Mon, 12 Mar 2012 11:04:12 +0800 Shaohua Li <shli@fusionio.com> wrote:
> ..
>>>  Also I wonder about handling failure in RAID1.
>>>  I think the code will currently treat it like a write error, and
>>>  maybe record a bad block (then fail the device is writing the badblock
>>>  record fails). Is that what were want?
>> Mainly to simplify the code. And I thought a normal discard should not fail.
>> If it fails, something is wrong, marked it as badblock maybe not bad.
>
> That sounds like a VERY bad idea.
> Failures happen for lots of reasons,
> but generic comm errors are not an excuse to suddenly mark sectors as bad.
Not sure if I got it, but we treat discard similar like write. Did you
mean discard
request error is common?
