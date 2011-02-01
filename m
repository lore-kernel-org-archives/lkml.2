Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752582Ab1BAVon (ORCPT <rfc822;w@1wt.eu>);
	Tue, 1 Feb 2011 16:44:43 -0500
Received: from mail-iy0-f174.google.com ([209.85.210.174]:64862 "EHLO
	mail-iy0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751971Ab1BAVom convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 1 Feb 2011 16:44:42 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=mime-version:in-reply-to:references:date:message-id:subject:from:to
         :cc:content-type:content-transfer-encoding;
        b=u94ZWURFpS5onSG9tlw8AerudbvyIPRK78n1/SS3cco8yEraJ68CAK3XUWwTjAzLDy
         QpQ+aDW3aa4ChXcxx6o8yrFbEHW3gy21eID8tKE06TNszL0f7V7G53W8eeik9znruvnl
         M/AEl+vulODByEOZeSUeBoij+G6BxKEfV71Qc=
MIME-Version: 1.0
In-Reply-To: <20110201180749.GA19382@tassilo.jf.intel.com>
References: <20110131105412.7252a09c@katamari>
	<20110131163639.GA32095@tassilo.jf.intel.com>
	<4D4759BD.2000006@gmail.com>
	<20110201180749.GA19382@tassilo.jf.intel.com>
Date: Tue, 1 Feb 2011 15:44:41 -0600
Message-ID: <AANLkTimLZv4+zfMf0MWwPthG1Osnq3EFEg824u7DF6bK@mail.gmail.com>
Subject: Re: b44 driver causes panic when using swiotlb
From: Robert Hancock <hancockrwd@gmail.com>
To: Andi Kleen <ak@linux.intel.com>
Cc: Chuck Ebbert <cebbert@redhat.com>, linux-kernel@vger.kernel.org,
        David Woodhouse <dwmw2@infradead.org>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Feb 1, 2011 at 12:07 PM, Andi Kleen <ak@linux.intel.com> wrote:
> On Mon, Jan 31, 2011 at 06:54:21PM -0600, Robert Hancock wrote:
>> On 01/31/2011 10:36 AM, Andi Kleen wrote:
>> >On Mon, Jan 31, 2011 at 10:54:12AM -0500, Chuck Ebbert wrote:
>> >>The b44 driver is triggering this panic in swiotlb_map_page():
>> >>
>> >>         if (!dma_capable(dev, dev_addr, size))
>> >>                 panic("map_single: bounce buffer is not DMA'ble");
>> >>
>> >>The kernel log says the bounce buffers are at 0xdb400000, but b44 can
>> >>only do DMA to the first 1GB of memory:
>> >
>> >b44 needs to use GFP_DMA then and do its own custom bouncing.
>> >The standard pci_map_* bounce buffering is only designed for at least
>> >32bit capable devices.
>>
>> That seems wrong - it's a documented API and that restriction isn'
>
> Please read the documentation. When PCI DMA cannot handle it
> it returns failure. That is what happened here.

Apparently not, given that it hit a panic inside the swiotlb code..
