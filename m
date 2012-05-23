Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756484Ab2EWQVM (ORCPT <rfc822;w@1wt.eu>);
	Wed, 23 May 2012 12:21:12 -0400
Received: from na3sys009aog133.obsmtp.com ([74.125.149.82]:51463 "EHLO
	na3sys009aog133.obsmtp.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752872Ab2EWQVJ convert rfc822-to-8bit
	(ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 23 May 2012 12:21:09 -0400
MIME-Version: 1.0
In-Reply-To: <20120523091954.GA8730@tbergstrom-lnx.Nvidia.com>
References: <1337227884.2066.9.camel@pgaikwad-dt2> <20120517062131.GA9305@gmail.com>
 <1337316517.22560.19.camel@pgaikwad-dt2> <20120518112104.GL20304@tbergstrom-lnx.Nvidia.com>
 <CAJOA=zM_o1Nqw55xxFvw6KssM50Q+7yyo41rUSH2Aoo1neTMjg@mail.gmail.com>
 <20120521084642.GV20304@tbergstrom-lnx.Nvidia.com> <4FBB5A72.2080101@codethink.co.uk>
 <20120522120851.GI8730@tbergstrom-lnx.Nvidia.com> <CAJOA=zNic19Eyq-RJpj_pM94wpqY7co0dtKu1O+27B-wZMm=MA@mail.gmail.com>
 <20120523091954.GA8730@tbergstrom-lnx.Nvidia.com>
From: "Turquette, Mike" <mturquette@ti.com>
Date: Wed, 23 May 2012 09:20:46 -0700
Message-ID: <CAJOA=zPf8L7D5Sbi6R_gWU8HxKy7C-FiyUuUTvv-kvquf8q+_A@mail.gmail.com>
Subject: Re: Clock register in early init
To: Peter De Schrijver <pdeschrijver@nvidia.com>
Cc: Ben Dooks <ben.dooks@codethink.co.uk>,
        Prashant Gaikwad <pgaikwad@nvidia.com>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "linux-arm-kernel@lists.infradead.org" 
	<linux-arm-kernel@lists.infradead.org>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, May 23, 2012 at 2:19 AM, Peter De Schrijver
<pdeschrijver@nvidia.com> wrote:
> On Tue, May 22, 2012 at 07:37:15PM +0200, Turquette, Mike wrote:
>> On Tue, May 22, 2012 at 5:08 AM, Peter De Schrijver
>> <pdeschrijver@nvidia.com> wrote:
>> >> We had at-least that on the older Samsung parts and they where still
>> >> growing. I would suggest that in a multi-kernel image situation the
>> >> more data that can be discarded after init-time the better.
>> >>
>> >> Also, __initdata gets gathered into one place so there's no possibility
>> >> of page fragmentation there. If you mean fragmentation of the memory
>> >> map, then allocate the size of all the clocks you know of at init time
>> >> in one go.
>> >>
>> >
>> > That would work, except that clocks are needed before kmalloc is available.
>> >
>>
>> Is static initialization the only way to solve this problem?  What
>> about using the bootmem allocator for early init clocks?
>>
>
> If it can be handled inside the framework somehow. I would want to avoid
> having several places where clocks inside the same SoC are initialized.
>

I'll look into the bootmem thing.  Paul mentioned that a long time
ago.  Hopefully it can be done in such a way as to expose the same
interfaces as the dynamic allocation routines.  I'll keep you Cc'd.

Regards,
Mike

> Cheers,
>
> Peter.
