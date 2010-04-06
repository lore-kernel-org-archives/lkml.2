Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752603Ab0DFPCp (ORCPT <rfc822;w@1wt.eu>);
	Tue, 6 Apr 2010 11:02:45 -0400
Received: from mail-pv0-f174.google.com ([74.125.83.174]:40451 "EHLO
	mail-pv0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751104Ab0DFPCk (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 6 Apr 2010 11:02:40 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=mime-version:in-reply-to:references:date:message-id:subject:from:to
         :cc:content-type;
        b=wJb2N+3elvxk8/IgScKgfCuckI3HH0dwjPW2dctv4omwr3h8rJYUxMpfkrvTf65xzj
         9xyAIQpLh6Ja8GSNEzQyca1WMQDg19JRW1zcxpGML9jE12baxiCfKXigjAWYi6spJdHB
         WT8lBd9Irw+VdABA9K1bsVxV5jn2pz+WqbBoA=
MIME-Version: 1.0
In-Reply-To: <l2y5f6c52c61004060737me670f6e2t6071444c4fd1318b@mail.gmail.com>
References: <l2y5f6c52c61004060737me670f6e2t6071444c4fd1318b@mail.gmail.com>
Date: Tue, 6 Apr 2010 20:32:39 +0530
Message-ID: <g2s9ff7a3bc1004060802va38aa361s6abd07e8c992dd56@mail.gmail.com>
Subject: Re: why choose 896MB to the start point of ZONE_HIGHMEM
From: Joel Fernandes <agnel.joel@gmail.com>
To: hayfeng Lee <teklife.kernel@gmail.com>
Cc: linux-kernel@vger.kernel.org, linux-kernel@zh-kernel.org,
       kernelnewbies@nl.linux.org
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Hayfeng,

On Tue, Apr 6, 2010 at 8:07 PM, hayfeng Lee <teklife.kernel@gmail.com> wrote:
> hello,every one.
> I have a question:
> Why does linux choose 896MB to do a start point of ZONE_HIGHMEM and
> the end point of ZONE_NORMAL. Just for experience?
> What is the advantages?

This is not an advantage but a limitation of 32 bit processor and
architecture. Only physical memory in first 896MB  is directly mapped
to the kernel virtual memory address space. This is called
ZONE_NORMAL. To access any physical memory in ZONE_HIGHMEM, the kernel
has to set up page table entries to indirectly map the physical memory
into a virtual memory address (I think around 128MB or so worth page
table entries are reused for this purpose). On the other hand, on 64
bit architectures, the entire physical memory is directly mapped and
accessible to the kernel. ZONE_HIGHMEM doesn't exist on 64 bit.

Take the above with a grain of salt, someone with a better knowledge
about this intrusive topic can be give a more detailed explanation :)

Hope this helps, thanks,
-Joel
