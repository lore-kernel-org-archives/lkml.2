Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756897Ab0DNVMw (ORCPT <rfc822;w@1wt.eu>);
	Wed, 14 Apr 2010 17:12:52 -0400
Received: from mail-ew0-f220.google.com ([209.85.219.220]:35049 "EHLO
	mail-ew0-f220.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755749Ab0DNVMu convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 14 Apr 2010 17:12:50 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=mime-version:in-reply-to:references:date:message-id:subject:from:to
         :cc:content-type:content-transfer-encoding;
        b=wGuaK08ta1eOh+LAJkUOQamqDip7wgs54oKY/1OIl+aKUcutGkFxCYaXVQszwheJiJ
         EpIbQVpVQGraWf4wUhliOOEYEi4qVfzvchYnYxGTs9L9Qz99HSGU4looci3jic0qsPiF
         rOOelXAIjn10ZSbMuRNVZbMnTO4icc6v8qW5U=
MIME-Version: 1.0
In-Reply-To: <20100414210143.GB5753@phenom.dumpdata.com>
References: <20100414183826.GA25962@sequoia.sous-sol.org>
	 <Pine.LNX.4.44L0.1004141622410.1716-100000@iolanthe.rowland.org>
	 <20100414210143.GB5753@phenom.dumpdata.com>
Date: Wed, 14 Apr 2010 22:12:48 +0100
Message-ID: <y2z74fd948d1004141412z1bb8424ekae627356bd8cc408@mail.gmail.com>
Subject: Re: USB transfer_buffer allocations on 64bit systems
From: Pedro Ribeiro <pedrib@gmail.com>
To: Konrad Rzeszutek Wilk <konrad.wilk@oracle.com>
Cc: Alan Stern <stern@rowland.harvard.edu>, Chris Wright <chrisw@sous-sol.org>,
       USB list <linux-usb@vger.kernel.org>, Greg KH <gregkh@suse.de>,
       Kernel development list <linux-kernel@vger.kernel.org>,
       iommu@lists.linux-foundation.org, Andi Kleen <andi@firstfloor.org>,
       Daniel Mack <daniel@caiaq.de>,
       Andrew Morton <akpm@linux-foundation.org>,
       David Woodhouse <dwmw2@infradead.org>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 14 April 2010 22:01, Konrad Rzeszutek Wilk <konrad.wilk@oracle.com> wrote:
> On Wed, Apr 14, 2010 at 04:29:22PM -0400, Alan Stern wrote:
>> On Wed, 14 Apr 2010, Chris Wright wrote:
>>
>> > So dma_map_single is the case that's failing, but you think the mask is
>> > correct?  What about the direction?
>>
>> The mask and direction are unquestionably correct.  The mask is set up
>> by pci_setup_device() and not changed thereafter.  Furthermore, the
>> audio works okay until another device (a DVB tuner) is plugged in.
>
> Could the driver for the DVB tuner change the PCI mask? That is, change
> the pci mask way after it has been initialized (don't laugh, this did
> happend - as I remember 4 months fix was posted on the DRM mailing list
> for this).
>

I can also trigger the bug on mount and unmount of a USB stick, albeit
its not as intensive.

Pedro
