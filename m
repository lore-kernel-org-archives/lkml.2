Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760664Ab0JGOF1 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 7 Oct 2010 10:05:27 -0400
Received: from hera.kernel.org ([140.211.167.34]:36141 "EHLO hera.kernel.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754540Ab0JGOF0 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 7 Oct 2010 10:05:26 -0400
Message-ID: <4CADD3A3.5090401@kernel.org>
Date: Thu, 07 Oct 2010 16:05:23 +0200
From: Tejun Heo <tj@kernel.org>
User-Agent: Mozilla/5.0 (X11; U; Linux i686 (x86_64); en-US; rv:1.9.2.9) Gecko/20100915 Lightning/1.0b2 Thunderbird/3.1.4
MIME-Version: 1.0
To: Torsten Kaiser <just.for.lkml@googlemail.com>
CC: lkml <linux-kernel@vger.kernel.org>
Subject: Re: -mm: xfs lockdep warning
References: <201009161546.16909.ruirui.r.yang@tieto.com>	<20100917005227.GJ24409@dastard>	<20100920191355.GA28443@infradead.org>	<AANLkTi=45J+=ytj=NC4bYTVJFRakNQQiFd35K7mrf+Gq@mail.gmail.com>	<4CA997DF.5030008@kernel.org>	<20101004092107.GJ4681@dastard>	<AANLkTi=3jjoCtYoK0endt8OM=omygO284WN2ZQZ=jceo@mail.gmail.com>	<4CAB5779.5020901@kernel.org>	<AANLkTineNfy+hfnK-sjHNB+h05oC4qbJ+81pg95Bmn=b@mail.gmail.com>	<4CAC366E.7070609@kernel.org>	<4CAC38D9.8020407@kernel.org>	<AANLkTikw=ObzgWu35fsuriC-jVrzDRHRfFJeT8-4-ndY@mail.gmail.com>	<4CAC934E.2030807@kernel.org>	<AANLkTinrBeMDyQJaYJFALTPpOgEaAy7yoPdyQ0Gpay3G@mail.gmail.com>	<4CACC0CD.5000001@kernel.org>	<4CADAB97.4020500@kernel.org> <AANLkTikRZZMq9GkaCn_BB7H=F0iGj3P-XbiaEU3RoN5V@mail.gmail.com>
In-Reply-To: <AANLkTikRZZMq9GkaCn_BB7H=F0iGj3P-XbiaEU3RoN5V@mail.gmail.com>
X-Enigmail-Version: 1.1.1
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-4.2.3 (hera.kernel.org [127.0.0.1]); Thu, 07 Oct 2010 14:05:25 +0000 (UTC)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hello,

On 10/07/2010 03:21 PM, Torsten Kaiser wrote:
>> Can you test whether the following patch fix the issue?
> 
> Yes. After adding this patch to 2.6.36-rc6 it survived my testcase. It
> first seems to get stuck again, but after less then a minute the
> system recovered and all compiles finished successfully.
> 
> I suspect the combination of CFLAGs, the gcc version and maybe even
> changes in KOffice from 2.2.1 to 2.2.2 are import for my testcase. It
> looks like at the start of the complies something is really eating an
> enormous amount of memory and I did not hit such a case with earlier
> kernels.

It's great to hear that the patch helped but would you be able to
repeat the same test w/ 2.6.35 and see whether there's any noticeable
difference?  Some level of stuttering is expected if the system is hit
with sudden huge spike of memory pressure but let's see if it has
regressed somehow.

Thanks.

-- 
tejun
