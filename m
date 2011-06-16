Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755915Ab1FPHda (ORCPT <rfc822;w@1wt.eu>);
	Thu, 16 Jun 2011 03:33:30 -0400
Received: from mail-vx0-f174.google.com ([209.85.220.174]:53414 "EHLO
	mail-vx0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755946Ab1FPHdR convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 16 Jun 2011 03:33:17 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=mime-version:sender:in-reply-to:references:date
         :x-google-sender-auth:message-id:subject:from:to:cc:content-type
         :content-transfer-encoding;
        b=l3bcHD4j1NMPeJhUY0uNCMpDJG6vBzcE58VIUr2gaMBzDWwHy9AzUlA5y616rFcB0c
         wD7n4x5RoeOZTNKClY68pMvBG0pnRz9zMIqcj83jfQTSgsnkhnVFbmH2l0Qe4xCUaaP2
         NX0sWTR2vhbLMA9SZgT7RDTPCpdzzcbX7/z6c=
MIME-Version: 1.0
In-Reply-To: <20110616072452.GA15366@elte.hu>
References: <1308153214.7566.6.camel@jaguar>
	<4DF8DE26.1070301@redhat.com>
	<BANLkTi=SHENDBHdtFY_7_qtfqJb_+qKJSw@mail.gmail.com>
	<BANLkTinMDz-sqaX0cyWEoLXt70dowxofvg@mail.gmail.com>
	<4DF92C80.3030106@codemonkey.ws>
	<7A30A509-47AA-4E72-ABF3-937005900F9D@suse.de>
	<BANLkTi=Jm_50m6qyfQPCF0PuwUfuDNwMtg@mail.gmail.com>
	<20110616072452.GA15366@elte.hu>
Date: Thu, 16 Jun 2011 10:33:16 +0300
X-Google-Sender-Auth: U2gd5VpfM45UrKqG58ht9pMIM1U
Message-ID: <BANLkTikkgsZFLq-X0L2mzKucJetGyOmJNQ@mail.gmail.com>
Subject: Re: [ANNOUNCE] Native Linux KVM tool v2
From: Pekka Enberg <penberg@kernel.org>
To: Ingo Molnar <mingo@elte.hu>
Cc: Alexander Graf <agraf@suse.de>, Anthony Liguori <anthony@codemonkey.ws>,
        Prasad Joshi <prasadjoshi124@gmail.com>, Avi Kivity <avi@redhat.com>,
        linux-kernel@vger.kernel.org, kvm@vger.kernel.org,
        Andrew Morton <akpm@linux-foundation.org>,
        Linus Torvalds <torvalds@linux-foundation.org>,
        Sasha Levin <levinsasha928@gmail.com>,
        Cyrill Gorcunov <gorcunov@gmail.com>, Asias He <asias.hejun@gmail.com>,
        Jens Axboe <jaxboe@fusionio.com>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Ingo,

On Thu, Jun 16, 2011 at 10:24 AM, Ingo Molnar <mingo@elte.hu> wrote:
>  - executing AIO in the vcpu thread eats up precious vcpu execution
>   time: combined QCOW2 throughput would be limited by a single
>   core's performance, and any time spent on QCOW2 processing would
>   not be spent running the guest CPU. (In such a model we certainly
>   couldnt do more intelligent, CPU-intense storage solutions like on
>   the fly compress/decompress of QCOW2 data.)

Most image formats have optional on-the-fly compression/decompression
so we'd need to keep the current I/O thread scheme anyway.

> I'd only consider KAIO it if it provides some *real* measurable
> performance advantage of at least 10% in some important usecase.
> A few percent probably wouldnt be worth it.

I've only been following AIO kernel development from the sidelines but
I really haven't seen any reports of significant gains over
read()/write() from a thread pool. Are there any such reports?

                          Pekka
