Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753460Ab0EKWWv (ORCPT <rfc822;w@1wt.eu>);
	Tue, 11 May 2010 18:22:51 -0400
Received: from mail-px0-f174.google.com ([209.85.212.174]:35281 "EHLO
	mail-px0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753404Ab0EKWWu convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 11 May 2010 18:22:50 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=mime-version:in-reply-to:references:date:message-id:subject:from:to
         :cc:content-type:content-transfer-encoding;
        b=nhQpcQcAZ29xKANFytxiwPlJJP+R4VHCZChy8d1Tn0CozIavazPqdxpvnv96v/cOSD
         l8QG+r+JbaHiv1JnBrabMOZUzFouLiYHiLiiNvBQrDS1VxXQVB4A/s79kcTgp1qBbzq7
         m2TRUf4CSs4EfuSMIM/h/qc6gW6rnkCAoCn3Q=
MIME-Version: 1.0
In-Reply-To: <89k77n$noi3t4@fmsmga001.fm.intel.com>
References: <AANLkTilSNZ11CaRUH5s3w6NoAnDQ5t7U9Y0Ce-iHpq3O@mail.gmail.com>
	 <89kc63$grtht6@fmsmga002.fm.intel.com>
	 <20100511104818.8382a7de.akpm@linux-foundation.org>
	 <89khjo$fd26d3@orsmga002.jf.intel.com>
	 <20100511113555.a78c9c8e.akpm@linux-foundation.org>
	 <89kc63$grv1m8@fmsmga002.fm.intel.com>
	 <20100511121001.0731a9c2.akpm@linux-foundation.org>
	 <89k77n$noi3t4@fmsmga001.fm.intel.com>
Date: Wed, 12 May 2010 08:22:49 +1000
Message-ID: <AANLkTikM916RlCBudL9_Pw--cpiu5mg_xcLFG9N1l9tL@mail.gmail.com>
Subject: Re: DRM Error on Acer Aspire One
From: Dave Airlie <airlied@gmail.com>
To: Chris Wilson <chris@chris-wilson.co.uk>
Cc: Andrew Morton <akpm@linux-foundation.org>,
       Jaswinder Singh Rajput <jaswinderlinux@gmail.com>,
       dri-devel@lists.freedesktop.org, Dave Airlie <airlied@linux.ie>,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
       Keith Packard <keithp@keithp.com>, Eric Anholt <eric@anholt.net>,
       Ingo Molnar <mingo@elte.hu>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, May 12, 2010 at 5:57 AM, Chris Wilson <chris@chris-wilson.co.uk> wrote:
> On Tue, 11 May 2010 12:10:01 -0700, Andrew Morton <akpm@linux-foundation.org> wrote:
>> On Tue, 11 May 2010 19:52:31 +0100
>> Chris Wilson <chris@chris-wilson.co.uk> wrote:
>>
>> > On Tue, 11 May 2010 11:35:55 -0400, Andrew Morton <akpm@linux-foundation.org> wrote:
>> > > No, io_mapping_map_atomic_wc() cannot be used from [soft]irq context:
>> > > it hardwires use of KM_USER0.  I suggest that io_mapping_create_wc(),
>> > > io_mapping_map_atomic_wc() etc be changed so that the caller passes in the
>> > > KM_foo kmap slot index.
>> >
>> > Argh, sorry for the noise, read the mail in the wrong order. Thanks for
>> > the review. It would be sensible to go with your simpler patch whilst
>> > io_mapping_map_atomic_wc() is improved.
>>
>> OK.  I'll be sending a bunch of fixes Linuswards in an hour or two.
>> Should I include this?
>
> Yes.
>
> Acked-by: Chris Wilson <chris@chris-wilson.co.uk>
>

I'm not sure pushing this in at this point is a good idea, if I'm
reading it correctly we've no idea what KM_IRQ is being used for, and
this codepath is called from non-irq contexts just as much as irq
contexts.

I'd rather we just backout the hangcheck stuff touching copies at all
at this point, and try again doing it properly with a slow work or
something for later.

Dave.
