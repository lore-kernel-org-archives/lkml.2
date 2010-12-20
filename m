Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933053Ab0LTTjX (ORCPT <rfc822;w@1wt.eu>);
	Mon, 20 Dec 2010 14:39:23 -0500
Received: from mail-bw0-f45.google.com ([209.85.214.45]:35250 "EHLO
	mail-bw0-f45.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932601Ab0LTTjW (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 20 Dec 2010 14:39:22 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=mime-version:in-reply-to:references:date:message-id:subject:from:to
         :cc:content-type;
        b=Dw0qPlvucNlPrcnDdYv941c6pTTUvrbgU7Ycu/BOK3hGfKk/EekW71TZfc0XXPjIxT
         abWWRzRKfInBVRFUn1VIj3O/qbkdKewyicRiI0EBO0IeikP0tYDtLSujG+u1r4svwRIu
         6KWPeb2fckkJMjmOfPQB130CLKEkVTkR6xqFQ=
MIME-Version: 1.0
In-Reply-To: <AANLkTim1KBK5cCL_yr0yNyVVW3tz0xa9WA42NmHL1+Dq@mail.gmail.com>
References: <1291953342-4905-1-git-send-email-fernando.lugo@ti.com>
	<1291953342-4905-4-git-send-email-fernando.lugo@ti.com>
	<AANLkTimOoL6OL4ft1c=U4p7HzvoSNg7n3BT0TJQdFL63@mail.gmail.com>
	<AANLkTim1KBK5cCL_yr0yNyVVW3tz0xa9WA42NmHL1+Dq@mail.gmail.com>
Date: Mon, 20 Dec 2010 21:39:09 +0200
Message-ID: <AANLkTinAB7k946O+pr3RGmUuBSE=Dtb5mxarM_0HKedB@mail.gmail.com>
Subject: Re: [PATCHv2 3/4] staging: tidspbridge - remove disabling twl when
 printing DSP stack
From: Felipe Contreras <felipe.contreras@gmail.com>
To: "Guzman Lugo, Fernando" <fernando.lugo@ti.com>
Cc: omar.ramirez@ti.com, linux-kernel@vger.kernel.org, nm@ti.com,
        ohad@wizery.com
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sat, Dec 11, 2010 at 9:25 PM, Guzman Lugo, Fernando
<fernando.lugo@ti.com> wrote:
> On Fri, Dec 10, 2010 at 9:43 AM, Felipe Contreras
> <felipe.contreras@gmail.com> wrote:
>> On Fri, Dec 10, 2010 at 5:55 AM, Fernando Guzman Lugo
>> <fernando.lugo@ti.com> wrote:
>>> Now the SHM segments are not in lock tlbs, instead
>>> they are in translation tables. So we cannot disable
>>> twl in order to get the DSP stack dump. Also add a check
>>> for __get_free_page allocation.
>>
>> Why?
>
> Dsp trace dump is not working if twl is disabled.

DSP trace dump is not working anyway; it never has.

Maybe in some internal or custom tree, but not on upstream, and not
with public firmware.

>> This means there's a possibility that there will be lingering entries
>> in the translation tables, and that the DSP side would be able to
>> corrupt kernel memory.
>
> The thing is that not all shared memory is mapped into tlbs, there is
> still some area which is mapped into twl, I could have added that to
> tlbs too, but with iommu migrations all the entries are in twl, so
> that would work after that patches, so there is no point doing that.
>
> The kernel was fixed with the change of use __get_free_page instead of
> kmalloc for the dummy page. With the change it could corrupt userspace
> pathces but just in the wierd case where you have enable DSP dump
> option, and that the fault have happend in an atomic context in the
> DSP side, thats is very rare case and it is more useful having this
> feature working. A final solution to that can be exporting a new API
> in iommu module to clean up all the twl entries, after that we just
> insert the dummy page and algo the area where the DSP dumps the trace.
> I can make the changes after iommu patches are merged.

Instead of __get_free_page we could use no page at all and pass only '0', no?

And yeah, the final solution would be to clean all the twl entries and
extra tlb's through some iommu API. In the meantime there's no point
in trying to fix a bug that can't be solved upstream anyway and adding
the potential to corrupt user-space memory while doing so.

Cheers.

-- 
Felipe Contreras
