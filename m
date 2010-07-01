Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755853Ab0GAMru (ORCPT <rfc822;w@1wt.eu>);
	Thu, 1 Jul 2010 08:47:50 -0400
Received: from mail-qy0-f174.google.com ([209.85.216.174]:58071 "EHLO
	mail-qy0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755501Ab0GAMrs convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 1 Jul 2010 08:47:48 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=mime-version:in-reply-to:references:date:message-id:subject:from:to
         :content-type:content-transfer-encoding;
        b=JhEJaLliNK6QVbxIdw8l1NeP2/fyv0Z1EE/mItpGftEiUp7lnEFhzG/45sNbZIkoGP
         PJ3pSkMYVEek5Oex2ZC/Ij44t3znfIvifNKQdsg+oKSvhuvtPWeoAYX+dycx5j/t1n0r
         32eQbfJHYYQGJ/vs0R7pHgJIowPHBzn/V92nM=
MIME-Version: 1.0
In-Reply-To: <20100701062605.GA1051@liondog.tnic>
References: <AANLkTingidlvRUaD4FwNDybaZ29Qrr_507Pto1vVqo-a@mail.gmail.com>
	<20100630063844.GB27891@liondog.tnic>
	<AANLkTilrpslDI4hFzbZRTJCd3JnkbGqN7fvsMEl9wJ9_@mail.gmail.com>
	<20100701062605.GA1051@liondog.tnic>
Date: Thu, 1 Jul 2010 06:47:46 -0600
Message-ID: <AANLkTimbNLYLZ5UFDnenFS2RwfF4IKynf_qpmfE5Befs@mail.gmail.com>
Subject: Re: 2.6.34 Northbridge Chipset Errors on HP Proliant 4 x Opteron in 
	x86_64 mode
From: Jeffrey Merkey <jeffmerkey@gmail.com>
To: Borislav Petkov <bp@alien8.de>, Jeffrey Merkey <jeffmerkey@gmail.com>,
       linux-kernel@vger.kernel.org
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Jul 1, 2010 at 12:26 AM, Borislav Petkov <bp@alien8.de> wrote:
> From: Jeffrey Merkey <jeffmerkey@gmail.com>
> Date: Wed, Jun 30, 2010 at 01:21:04PM -0600
>
>> >
>> > It looks like you don't have extended PCI config space accesses enabled
>> > on that machine. Can you send me the whole dmesg?
>> >
>>
>> Here is the complete dmesg log of the Northbridge chip error messages.
>>  The drives report IO problems before the chip error message happens.
>
> Jun 29 02:02:08 cloudstream kernel: Northbridge Error, node 0, core: 0
> Jun 29 02:02:08 cloudstream kernel: ECC/ChipKill ECC error.
> Jun 29 02:02:08 cloudstream kernel: EDAC amd64 MC0: CE ERROR_ADDRESS= 0xc7358280
> Jun 29 02:02:08 cloudstream kernel: EDAC amd64: get_channel_from_ecc_syndrome: error reading F3x180.
> Jun 29 02:02:08 cloudstream kernel: EDAC MC0: CE page 0xc7358, offset 0x280, grain 0, syndrome 0xa4c1, row 3, channel 0, label "": amd64_edac
> Jun 29 02:03:21 cloudstream kernel: Northbridge Error, node 0
> Jun 29 02:03:21 cloudstream kernel: ECC/ChipKill ECC error.
> Jun 29 02:03:21 cloudstream kernel: EDAC amd64 MC0: CE ERROR_ADDRESS= 0xc7358280
> Jun 29 02:03:21 cloudstream kernel: EDAC amd64: get_channel_from_ecc_syndrome: error reading F3x180.
> Jun 29 02:03:21 cloudstream kernel: EDAC MC0: CE page 0xc7358, offset 0x280, grain 0, syndrome 0xa4c1, row 3, channel 0, label "": amd64_edac
>
> Right, this is the ECC happening. I asked about the dmesg because of
> the "error reading F3x180" but you have a K8 machine so no extended PCI
> config space there. And the error message is wrong there, I will move
> that F3x180 read behind a family check since it makes no sense to access
> that on K8.
>
> Thanks.
>
> --
> Regards/Gruss,
>    Boris.
>

OK.  Glad to be of help.  I cleaned the DIMM contacts with a pencil
eraser and the errors seem to have gone away.

Jeff
