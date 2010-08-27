Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752758Ab0H0UPV (ORCPT <rfc822;w@1wt.eu>);
	Fri, 27 Aug 2010 16:15:21 -0400
Received: from exprod5og113.obsmtp.com ([64.18.0.26]:44104 "EHLO
	exprod5og113.obsmtp.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751141Ab0H0UPT convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 27 Aug 2010 16:15:19 -0400
MIME-Version: 1.0
In-Reply-To: <AANLkTinZLdSTVenJ=ShK9-f27eMQSyv=j6vYK+F3K96s@mail.gmail.com>
References: <AANLkTimoCn9uWQ1NTJAhRu7cq1MA+oo6E5p30zeXA3f1@mail.gmail.com>
	<4C779111.8000803@kernel.org>
	<AANLkTinZLdSTVenJ=ShK9-f27eMQSyv=j6vYK+F3K96s@mail.gmail.com>
Date: Fri, 27 Aug 2010 15:15:15 -0500
Message-ID: <AANLkTi=xAbbbyOLWG=3fJzeJo8FsvnQR5+M-LbG8cqtX@mail.gmail.com>
Subject: Re: [PATCH] scatterlist: prevent invalid free when alloc fails
From: Jeffrey Carlyle <jeff.carlyle@motorola.com>
To: Tejun Heo <tj@kernel.org>
Cc: torvalds@osdl.org, linux-kernel@vger.kernel.org, jaxboe@fusionio.com,
        OLUSANYA SOYANNWO <olusanya.soyannwo@motorola.com>,
        Hu Tao <taohu@motorola.com>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8BIT
X-CFilter-Loop: Reflected
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Aug 27, 2010 at 2:45 PM, Jeffrey Carlyle
<jeff.carlyle@motorola.com> wrote:
> On Fri, Aug 27, 2010 at 5:18 AM, Tejun Heo <tj@kernel.org> wrote:
>> On 08/26/2010 06:04 PM, Jeffrey Carlyle wrote:
>>> diff --git a/lib/scatterlist.c b/lib/scatterlist.c
>>> index a5ec428..acf2c6e 100644
>>> --- a/lib/scatterlist.c
>>> +++ b/lib/scatterlist.c
>>> @@ -163,7 +163,7 @@ void __sg_free_table(struct sg_table *table,
>>> unsigned int max_ents,
>>>               return;
>>>
>>>       sgl = table->sgl;
>>> -     while (table->orig_nents) {
>>> +     while (table->orig_nents && sgl) {
>>>               unsigned int alloc_size = table->orig_nents;
>>>               unsigned int sg_size;
>>
>> Why is this change necessary?
>
> Well the problem we were seeing manifested itself when we called
> free_fn on a NULL value. This was a naive attempt at avoiding that. If
> the logic in __sg_alloc_table is corrected, I agree that we shouldn't
> need this.

Actually, please disregard the comment about trying to free NULL. I
don't think we need to add the "&& sgl" under any circumstances.
