Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755811Ab1EYT24 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 25 May 2011 15:28:56 -0400
Received: from na3sys010aog112.obsmtp.com ([74.125.245.92]:39384 "HELO
	na3sys010aog112.obsmtp.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with SMTP id S1754744Ab1EYT2y convert rfc822-to-8bit
	(ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 25 May 2011 15:28:54 -0400
MIME-Version: 1.0
In-Reply-To: <20110525080409.GA16582@infradead.org>
References: <alpine.DEB.2.00.1105241650230.29780@chino.kir.corp.google.com>
 <alpine.DEB.2.00.1105241651350.29780@chino.kir.corp.google.com> <20110525080409.GA16582@infradead.org>
From: Roland Dreier <roland@kernel.org>
Date: Wed, 25 May 2011 12:28:33 -0700
X-Google-Sender-Auth: EyrMz7u3wHPqAiLo-Z62pN9LKa8
Message-ID: <BANLkTi=Jc11hO3KXWFUaX1pia-MGa2SV+A@mail.gmail.com>
Subject: Re: [patch 3/6] scsi, fnic: require DMA support for Cisco FNIC
To: Christoph Hellwig <hch@infradead.org>
Cc: David Rientjes <rientjes@google.com>,
        "James E.J. Bottomley" <James.Bottomley@suse.de>,
        Pekka Enberg <penberg@kernel.org>, Christoph Lameter <cl@linux.com>,
        linux-scsi@vger.kernel.org, linux-kernel@vger.kernel.org,
        Abhijeet Joglekar <abjoglek@cisco.com>,
        Joe Eykholt <jeykholt@cisco.com>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, May 25, 2011 at 1:04 AM, Christoph Hellwig <hch@infradead.org> wrote:
>> The Cisco FNIC driver requires creating a SLAB_CACHE_DMA cache, which is
>> not possible if CONFIG_ZONE_DMA is disasbled.  Avoid compiling it without
>> DMA support.
>
> And you're sure it actually needs it and isn't some sort of typo?  It
> might help to Cc the maintainer to figure that out.

Yes, almost certainly it is due to a misunderstanding of what
SLAB_CACHE_DMA means.
(fnic is a modern PCIe device that doesn't have 24-bit DMA restrictions ;)

So the correct fix would likely be to delete the SLAB_CACHE_DMA from the driver.

In any case cc'ing Cisco people as hch suggested...

 - R.
