Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757956Ab1LNXZA (ORCPT <rfc822;w@1wt.eu>);
	Wed, 14 Dec 2011 18:25:00 -0500
Received: from mail-qy0-f174.google.com ([209.85.216.174]:58875 "EHLO
	mail-qy0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753526Ab1LNXY6 convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 14 Dec 2011 18:24:58 -0500
MIME-Version: 1.0
In-Reply-To: <4EE92FA4.3030006@zytor.com>
References: <1323896791-10858-1-git-send-email-mjg@redhat.com>
 <1323896791-10858-4-git-send-email-mjg@redhat.com> <CAGTjWtCpt_1h6XMwCFkx1TQnQbagtSuFBejcp6XNr4yhKgNuLg@mail.gmail.com>
 <20111214223950.GA29264@srcf.ucam.org> <CAGTjWtARm_OA0qy2Cvtc-rrPFpH2+2QdFw4CvBAo-PJsfX6t6w@mail.gmail.com>
 <4EE92A97.5080606@zytor.com> <CAGTjWtD33=EdOdMCy_TgX=fG0ZiUZTFTOP=Eyv3d7F-46u2pGQ@mail.gmail.com>
 <4EE92FA4.3030006@zytor.com>
From: Mike Waychison <mikew@google.com>
Date: Wed, 14 Dec 2011 15:24:36 -0800
Message-ID: <CAGTjWtA5_Xk6EMF6UmTTfWGCM+3imoGXn5awP4ANM4w=NgO=-Q@mail.gmail.com>
Subject: Re: [PATCH 3/4] EFI: Add support for variables longer than 1024 bytes
To: "H. Peter Anvin" <hpa@zytor.com>
Cc: Matthew Garrett <mjg59@srcf.ucam.org>, linux-kernel@vger.kernel.org,
        x86@kernel.org
X-System-Of-Record: true
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Dec 14, 2011 at 3:22 PM, H. Peter Anvin <hpa@zytor.com> wrote:
> On 12/14/2011 03:06 PM, Mike Waychison wrote:
>> On Wed, Dec 14, 2011 at 3:00 PM, H. Peter Anvin <hpa@zytor.com> wrote:
>>> On 12/14/2011 02:57 PM, Mike Waychison wrote:
>>>>
>>>> Well,l we could *not* support returning all the data field for
>>>> datasize > 1024, and simply truncate the field.  We are limited by
>>>> PAGE_SIZE by sysfs here anyway (so we don't really want to have a
>>>> variable size memcpy in efivar_show_raw).
>>>>
>>>
>>> That may be the biggest reason to avoid sysfs.  As far as I know sysfs
>>> doesn't allow seq_file to be used.
>>>
>>
>> Completely agreed.  I don't think a seq_file is warranted in this case
>> in particular, but the dummification of the interfaces in sysfs sure
>> makes it hard to do anything that isn't a "single value string".
>>
>
> Well, seq_file is a good way to deal with arbitrary length data.
>

seq_file maps well to arbitrary record counts (keeping records
self-consistent), but not so well for arbitrarily large records.
