Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754048Ab0HWPMa (ORCPT <rfc822;w@1wt.eu>);
	Mon, 23 Aug 2010 11:12:30 -0400
Received: from mail-gw0-f46.google.com ([74.125.83.46]:65443 "EHLO
	mail-gw0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751589Ab0HWPM2 convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 23 Aug 2010 11:12:28 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=mime-version:sender:in-reply-to:references:date
         :x-google-sender-auth:message-id:subject:from:to:cc:content-type
         :content-transfer-encoding;
        b=qrpqHGBgi+4zTonx/4jcV8MM0Qg2MVchnJx/rPpKJIsulPzH670UTemE7BMNZJw/fl
         A39fRgI0yvhRGeD8BAG9a9kjs6ix6Hitw9Mrwf3oifrr4K2g3QRAMJVJ8FOx8FnmSOif
         OYod+Ox9txRM/5Gg6TggqvXwlAlbe5Fnx/xGo=
MIME-Version: 1.0
In-Reply-To: <4C727BEB.9020100@scalableinformatics.com>
References: <594039.74663.qm@web111905.mail.gq1.yahoo.com>
	<1282144271.3035.31.camel@mulgrave.site>
	<AANLkTinRDMXqyDAVkcbioD=L7XO-47KHL2qjR+8KA5m3@mail.gmail.com>
	<1282148296.3035.49.camel@mulgrave.site>
	<4C6C1D70.7020502@vlnb.net>
	<41A1E2691BBB412BADCDE5F515CD8EDA@usish.com.cn>
	<8A96806D-6CD7-44AD-8A9D-143C098C95A4@uni-paderborn.de>
	<1282256949.30453.278.camel@haakon2.linux-iscsi.org>
	<4C701E08.2020005@vlnb.net>
	<1282423398.3015.39.camel@mulgrave.site>
	<AANLkTikcReFsYMhs1RkCHoRkL1+Q9WuptHj1xbx49YsA@mail.gmail.com>
	<1282508953.3042.102.camel@mulgrave.site>
	<4C727BEB.9020100@scalableinformatics.com>
Date: Mon, 23 Aug 2010 17:12:25 +0200
X-Google-Sender-Auth: C4E9e596E6Z-0vS0r-LPkBnoY1A
Message-ID: <AANLkTimttOUE5NiLc3cO5Eu3t70V9mnm+kSe25Ruh9ZB@mail.gmail.com>
Subject: Re: [Scst-devel] Fwd: Re: linuxcon 2010...
From: Bart Van Assche <bvanassche@acm.org>
To: landman@scalableinformatics.com
Cc: James Bottomley <James.Bottomley@suse.de>,
        Vladislav Bolkhovitin <vst@vlnb.net>, linux-scsi@vger.kernel.org,
        Chetan Loke <chetanloke@gmail.com>, linux-kernel@vger.kernel.org,
        scst-devel <scst-devel@lists.sourceforge.net>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Aug 23, 2010 at 3:47 PM, Joe Landman
<landman@scalableinformatics.com> wrote:
>
> James Bottomley wrote:
>
>> So the phrase "up to GigE" was deliberately in the above to exclude the
>> disputed infiniband results.  I'm not really interested in re-opening
>> the arguments over how to interpret those results.  The fact that SCST
>> and STGT were on par up to 1GbE is enough to refute the contention that
>> STGT is "fundamentally slow".
>
> We haven't tested this in at least 6 months, but we did test iSCSI over 10GbE using SCST and STGT.  This was one of the reasons we wound up going with SCST.  For the past several years, our performance on SCST was much higher than on STGT.
>
> If it helps, we can redo these tests with a modern kernel (2.6.35.x) and same backend/frontend.  We've been switching most of our IO performance testing to Jens Axboe's excellent fio tool.  I'd be happy to share our testing decks with anyone (and collaborate on generating a good useful set for general use)
>
> This said, I have to add in my support to SCST and its developers. Vlad, Bart, and the rest of the community have been very helpful to us.  We have been a consumer rather than a developer to date, so we have less of a dog in this fight than others.  We have nothing against LIO or STGT.  We will try them and see if they meet our needs.  SRP is a hard requirement, and it exists and works great in SCST.  So for us, a solution which gives us the best of all worlds would be one where we don't have to give up what works well for us, and gets us new capabilities/features.  This is more of a wish-list ... we have to keep using what works well for us.
>
> Our interest in STGT is that we would like a working iSER.  Vlad has suggested a method that we will explore a little later on (next
> month).  The LIO folks do look like they have some interesting capabilities beyond this, so we will look.  But without SRP, and a fast iSCSI, their really isn't much choice for us in the near term.

(resending as plain text)

There is an important design difference between SCST and LIO: SCST by
defaults creates multiple threads to process the I/O operations for a
storage target, while LIO only creates a single thread per storage
target. This makes SCST perform measurably faster.

Bart.
