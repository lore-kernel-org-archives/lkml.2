Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753024Ab1CULAO (ORCPT <rfc822;w@1wt.eu>);
	Mon, 21 Mar 2011 07:00:14 -0400
Received: from mail-ew0-f46.google.com ([209.85.215.46]:35488 "EHLO
	mail-ew0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752650Ab1CULAL (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 21 Mar 2011 07:00:11 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=message-id:date:from:user-agent:mime-version:to:cc:subject
         :references:in-reply-to:content-type:content-transfer-encoding;
        b=x8utISbCgsQKPw/rxcPJVdwhrvvCgADBiruMwWYM6hiTvlOHg5DS4LuJzTZA2cqsBg
         tuti+gIRezB5MWdiWf0IEFfCNAcsTGHRI3xhuA7H67UgD+Ibw+qlrMxCy38dDJmoE58Y
         VBNUiihqMR/yxNHiVgjVMSM+mt55aQknYMGGs=
Message-ID: <4D872FB6.5000605@gmail.com>
Date: Mon, 21 Mar 2011 12:00:06 +0100
From: roel <roel.kluin@gmail.com>
User-Agent: Mozilla/5.0 (X11; U; Linux x86_64; en-US; rv:1.9.2.14) Gecko/20110223 Thunderbird/3.1.8
MIME-Version: 1.0
To: FUJITA Tomonori <fujita.tomonori@lab.ntt.co.jp>
CC: James.Bottomley@suse.de, linux-scsi@vger.kernel.org,
        akpm@linux-foundation.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH] osst: wrong index used in inner loop
References: <4D8509D1.6080107@gmail.com> <20110321100300P.fujita.tomonori@lab.ntt.co.jp>
In-Reply-To: <20110321100300P.fujita.tomonori@lab.ntt.co.jp>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 21-03-11 02:02, FUJITA Tomonori wrote:
> On Sat, 19 Mar 2011 20:53:53 +0100
> roel <roel.kluin@gmail.com> wrote:
> 
>> Index i was already used in the outer loop.
>>
>> Signed-off-by: Roel Kluin <roel.kluin@gmail.com>
>> ---
>>  drivers/scsi/osst.c |    5 +++--
>>  1 files changed, 3 insertions(+), 2 deletions(-)
>>
>> I'm not sure if this is the right fix, maybe a break or return
>> is missing?
> 
> What are you trying to fix with this patch?

`i' is used as an index in both the outer loop at 4689 and the
inner loop at 4705.

if the UNIT_ATTENTION branch is taken `i' is overwritten after the
loop at 4705 and becomes ST_NBR_PARTITIONS + 1, i.e. 5.

So the loop at 4689 may not loop ten times when the UNIT_ATTENTION
branch is taken. It may loop 5 times or more than ten or hot spin,
dependent how often the UNIT_ATTENTION branch is taken. I'm not
familiar with this driver, but it looked buggy to me.

Roel
