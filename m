Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754765Ab1A1EPN (ORCPT <rfc822;w@1wt.eu>);
	Thu, 27 Jan 2011 23:15:13 -0500
Received: from mail-vw0-f46.google.com ([209.85.212.46]:35530 "EHLO
	mail-vw0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754682Ab1A1EPL convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 27 Jan 2011 23:15:11 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=mime-version:in-reply-to:references:from:date:message-id:subject:to
         :cc:content-type:content-transfer-encoding;
        b=g7lwR7UJeRSj2LiLDJK30UZY4nG4GVSAB14d2EOrfUxkCEypv7x9MLlIhOqA+IqQUP
         +qIG8juurdAaH0t6SuZRGw9wypKTD8H/8s8+k00v7w25q30PWsdbSYuBmW8yWnj8QiU7
         Yc5OY2sl2SGHIk6IloMM1UgNq52YMn6XIINcs=
MIME-Version: 1.0
In-Reply-To: <4D421A68.9000607@teksavvy.com>
References: <4D40C8D1.8090202@teksavvy.com> <20110127033011.GH21311@dastard>
 <4D40EB2F.2050809@teksavvy.com> <4D418B57.1000501@teksavvy.com>
 <alpine.DEB.2.00.1101271040000.31246@p34.internal.lan> <4D419765.4070805@teksavvy.com>
 <4D41CA16.8070001@hardwarefreak.com> <4D41EA04.7010506@teksavvy.com>
 <20110128001735.GO21311@dastard> <4D421A68.9000607@teksavvy.com>
From: David Rees <drees76@gmail.com>
Date: Thu, 27 Jan 2011 20:14:50 -0800
Message-ID: <AANLkTinO1JsX_3NDHS=ew5u2C7VcCHT1Y1Yabnz=RQLO@mail.gmail.com>
Subject: Re: xfs: very slow after mount, very slow at umount
To: Mark Lord <kernel@teksavvy.com>
Cc: Dave Chinner <david@fromorbit.com>, Stan Hoeppner <stan@hardwarefreak.com>,
        Justin Piszcz <jpiszcz@lucidpixels.com>,
        Christoph Hellwig <hch@infradead.org>, Alex Elder <aelder@sgi.com>,
        Linux Kernel <linux-kernel@vger.kernel.org>, xfs@oss.sgi.com
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Jan 27, 2011 at 5:22 PM, Mark Lord <kernel@teksavvy.com> wrote:
> But I just don't know.  My working theory, likely entirely wrong,
> is that if I have N streams active, odds are that each of those
> streams might get assigned to different AGs, given sufficient AGs >= N.
>
> Since the box often has 3-7 recording streams active,
> I'm trying it out with 8 AGs now.

As suggested before - why are you messing with AGs instead of allocsize?

I suspect that with the default configuration, XFS was trying to
maximize throughput by reducing seeks with multiple processes writing
streams.

But now, you're telling XFS that it's OK to write in up to 8 different
locations on the disk without worrying about seek performance.

I think this is likely to result in overall worse performance at the
worst time - under write load.

If you are trying to optimize single thread read performance by
minimizing file fragments, why don't you simply figure out at what
point increasing allocsize stops increasing read performance?

I suspect that the the defaults do good job because even if your file
are fragmented in 64MB chunks because you have multiple streams
writing, those chunks are very likely to be very close together so
there isn't much of a seek penalty.

-Dave
