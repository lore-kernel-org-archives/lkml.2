Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1946533Ab2LFS0N (ORCPT <rfc822;w@1wt.eu>);
	Thu, 6 Dec 2012 13:26:13 -0500
Received: from terminus.zytor.com ([198.137.202.10]:52541 "EHLO mail.zytor.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S932276Ab2LFS0K (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 6 Dec 2012 13:26:10 -0500
Message-ID: <50C0E339.4030607@zytor.com>
Date: Thu, 06 Dec 2012 10:26:01 -0800
From: "H. Peter Anvin" <hpa@zytor.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:17.0) Gecko/17.0 Thunderbird/17.0
MIME-Version: 1.0
To: Bjorn Helgaas <bhelgaas@google.com>
CC: Yinghai Lu <yinghai@kernel.org>, Matthew Garrett <mjg59@srcf.ucam.org>,
        linux-kernel@vger.kernel.org, linux-pci@vger.kernel.org,
        linux-efi@vger.kernel.org, dwmw2@infradead.org,
        "Eric W. Biederman" <ebiederm@xmission.com>
Subject: Re: Use PCI ROMs from EFI boot services
References: <1345739803-21017-1-git-send-email-mjg@redhat.com> <CAErSpo6dn_0b8Ngx9VT=ARs_UXQftEx=2Kczeqemtmo0XyKzuQ@mail.gmail.com> <20121203200241.GG5906@thinkpad-t410> <CAE9FiQVdpmmExrPrLf7HYVuo0cTY9Xjn6bWzObbuSSeQ-e1PbA@mail.gmail.com> <50BFE88D.1000800@zytor.com> <CAE9FiQXwZAAMkWYT8EjsewpuZ-OWqoaFscyzGS_pSuO9C3bf9A@mail.gmail.com> <CAE9FiQX+aJi5XEyjfjc=K4eXLbQNqE-vd+coyt1dmuujsi_eoQ@mail.gmail.com> <CAErSpo7-hUbvvCYPSwtSYKMKWqu99A5H5R4004rSj5Bmv0593g@mail.gmail.com>
In-Reply-To: <CAErSpo7-hUbvvCYPSwtSYKMKWqu99A5H5R4004rSj5Bmv0593g@mail.gmail.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 12/06/2012 10:19 AM, Bjorn Helgaas wrote:
> On Wed, Dec 5, 2012 at 5:52 PM, Yinghai Lu <yinghai@kernel.org> wrote:
>> On Wed, Dec 5, 2012 at 4:51 PM, Yinghai Lu <yinghai@kernel.org> wrote:
>>> On Wed, Dec 5, 2012 at 4:36 PM, H. Peter Anvin <hpa@zytor.com> wrote:
>>>> On 12/05/2012 04:15 PM, Yinghai Lu wrote:
>>>>>
>>>>
>>>> I don't see why that isn't the right fix.  We copy the data into
>>>> boot_params early in the boot; that *is* the official copy as far as the
>>>> kernel is concerned.
>>>>
>>>> So this patch very much seems like The Right Thing.
>>>
>>> it moves boot_params from __initdata  to data.
>>
>>     should be from __initdata to bss
>>
>>> and just for using pointer to setup_data.
>>>
>>> should add setup_data pointer instead. so will not waste (4096 - 8) bytes.
>
> I'm not following the whole discussion here, but my impression is that
> what's in my -next branch is acceptable
> (http://git.kernel.org/?p=linux/kernel/git/helgaas/pci.git;a=commitdiff;h=328949ff10f2e3fcb11472571294beed39488342)
>
> If not, please explain further and provide a patch to fix it.
>

NAK on this bit:

+       if (boot_params.hdr.version < 0x0209)
+               return 0;

This field is kernel->bootloader documentation.  If a nonmaching value 
somehow leaks into the kernel, the kernel could either panic("Bootloader 
written by moron") or it should clear some fields, but littering the 
kernel with these kinds of tests is just plain braindead.

	-hpa


-- 
H. Peter Anvin, Intel Open Source Technology Center
I work for Intel.  I don't speak on their behalf.

