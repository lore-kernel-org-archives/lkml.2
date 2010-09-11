Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751437Ab0IKSLg (ORCPT <rfc822;w@1wt.eu>);
	Sat, 11 Sep 2010 14:11:36 -0400
Received: from mail-qw0-f46.google.com ([209.85.216.46]:51292 "EHLO
	mail-qw0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750930Ab0IKSLf (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 11 Sep 2010 14:11:35 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=mime-version:in-reply-to:references:date:message-id:subject:from:to
         :content-type;
        b=KdeZLqhSUN2SQW7T3/JfgXB+bnNYelfwGDnj2dyX+cOPwoEkT37IiaJXQlPEB0b21t
         khr1BSXrl3USF5WK8EMtOL8Cwd9T4WwsCZNR/Cb+mPVJAqS7rWnh6lyPS6u1T0N7nTWC
         lDL73DDznW1BexPj643Qulkb4ascrz8a47CfM=
MIME-Version: 1.0
In-Reply-To: <20100911191146.7d38eba9@schatten.dmk.lab>
References: <AANLkTi=OCjV2DF9XAobz_B5Jy_ZQF1j=sBxUkyOc1Q5V@mail.gmail.com>
	<AANLkTinvdy2fCREqsBCLSA2EVF6J6kvmBSLwMYwv7Odq@mail.gmail.com>
	<AANLkTi=tfxaNnhSEpSF3g__WZcMD8aZFkML5h0Ha9tgh@mail.gmail.com>
	<20100911191146.7d38eba9@schatten.dmk.lab>
Date: Sat, 11 Sep 2010 20:11:34 +0200
Message-ID: <AANLkTikWb43Vfs4s9ux2jBaLRtMSg+pZ7KEoev3pXMPB@mail.gmail.com>
Subject: Re: 2458 days of Linux development - some stats and thoughts
From: Jan III Sobieski <jan3sobi3ski@gmail.com>
To: Florian Mickler <florian@mickler.org>, LKML <linux-kernel@vger.kernel.org>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

2010/9/11 Florian Mickler <florian@mickler.org>:
> On Sat, 11 Sep 2010 00:04:18 +0200
> Jan III Sobieski <jan3sobi3ski@gmail.com> wrote:
>
>> I added regressions stats - total number of regressions for each
>> kernel and number of regressions not fixed yet. It is interesting that
>> the number of not fixed regressions is really low.
>>
>
> What should I do with these numbers, when I don't know
> how they are created? What do they signify? What is their relevance?
> What uncertainty is connected to these numbers? What follows? Why are
> they created? How are they related?

This is just simple stat based on diffs. For example - 2.6.32


32	1096601	534042	315020	228772	781581	305270	1086851	543792	1630643	85
 	8	882149	463400	1345549	82,52%	160	28


32 - version
1096601 - insertions for whole 2.6.32 patch
534042 - deletions for whole 2.6.32 patch
315020 - insertions in drivers/staging dir
228772 - deletions in drivers/staging dir
781581 - insertions in base (without staging - most people doesn't use
it and doesn't care about this code - it's just a noise in diff's)
305270 - deletions in base
1086851 - sum of base insertions and deletions
543792 - sum of staging insertions and deletions
1630643 - sum of insertions and deletions in whole patch
85 - how many days took to develop this kernel
8 - how many rc's was produced
882149 - insertions from latest -next tree for 2.6.32
463400 - deletions from latest -next tree for 2.6.32
1345549 - sum of above for latest -next tree for 2.6.32
82,52% - how many changed lines was tested in -next tree
160	- total number of regressions tracked for 2.6.32
28 - regressions that are not fixed yet

I see a trend in the latest kernels (since 2.6.32) to minimize sum of
changes in base (without drivers/staging) - average is less than
1086851 lines changed and regressions dropped down bellow 160 for each
release. From 2.6.24 to 2.6.31 there were a lot more changes in base
and total number of regressions for each version was above 160 (with
one exception).

You can also see some dependency between number of regressions and
percent of changes coveraged in -next tree.

But this is just random stats - you can see whatever you want ;)

>
> Cheers,
> Flo
>

-- 
Jan III Sobieski
