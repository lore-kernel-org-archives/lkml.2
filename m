Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753203Ab1EPI6m (ORCPT <rfc822;w@1wt.eu>);
	Mon, 16 May 2011 04:58:42 -0400
Received: from mail-iy0-f174.google.com ([209.85.210.174]:37209 "EHLO
	mail-iy0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752885Ab1EPI6l (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 16 May 2011 04:58:41 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=mime-version:in-reply-to:references:date:message-id:subject:from:to
         :cc:content-type;
        b=bxQrw9/+v5CrPJhoZfNOO4G4Ajy/ymlnRsHK7Gm7ZAyXEwB6dkFXq/CLqZgZOKIue6
         MlzocHfjp5mliv8LJ4T1g3gTOjLI7JYIWiJeC34lHoG+qq+dkFI/WcubiHn0Pb0V0fEx
         K+KNekq9r5g/zqbnXMgnrs9jGzYYk4d9+QpSk=
MIME-Version: 1.0
In-Reply-To: <1305536016.19230.3.camel@e102109-lin.cambridge.arm.com>
References: <BANLkTikefReiFUggT8iPv0mOmY=+OOOS-A@mail.gmail.com>
	<BANLkTim-FmuENeU_Cai+nYnTP+uJTEn3PA@mail.gmail.com>
	<BANLkTi=S3VR1mxc0bsL4+N3ksHeo3scg3A@mail.gmail.com>
	<009c01cc108b$4635c7d0$d2a15770$@com>
	<BANLkTi=wg=RgyEWzL9_fwUymhFDaccQCfw@mail.gmail.com>
	<BANLkTin9RLjsgu=frPGXL8mL8p8LPz-10w@mail.gmail.com>
	<BANLkTik=M8uwnmHABqYBkeVDk56UMrnkMg@mail.gmail.com>
	<BANLkTi=VesNU8ye=ntq-LAzBPG4pVYZPQQ@mail.gmail.com>
	<BANLkTik6c8-g8FrXZy8-V35W6-Th++5p_A@mail.gmail.com>
	<BANLkTi=bYzYrHx+P=yTH_0VTiQaGZHeB9A@mail.gmail.com>
	<BANLkTinv6aSQMgh9ce1xaQ14_aHDPvFTxw@mail.gmail.com>
	<1305536016.19230.3.camel@e102109-lin.cambridge.arm.com>
Date: Mon, 16 May 2011 16:58:40 +0800
Message-ID: <BANLkTinB8eHU-Oy7QEkkmh88OKMfqrX2-Q@mail.gmail.com>
Subject: =?UTF-8?B?UmU6IOetlOWkjTogcHJvYmxlbSB3aXRoIGttZW1sZWFr?=
From: =?UTF-8?Q?Am=C3=A9rico_Wang?= <xiyou.wangcong@gmail.com>
To: Catalin Marinas <catalin.marinas@arm.com>
Cc: ttlxzz ccc <boyzccc@gmail.com>, linux-kernel@vger.kernel.org
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, May 16, 2011 at 4:53 PM, Catalin Marinas
<catalin.marinas@arm.com> wrote:
> On Mon, 2011-05-16 at 08:18 +0100, ttlxzz ccc wrote:
>> I'm very glad to find the reason of this problem. It's just because
>> the CONFIG_FRAME_POINTER is not set :).
>>
>> And in dump_stack() which is defined in arch/x86/kernel/dumpstack.c,
>> CONFIG_FRAME_POINTER control whether to get the bp.
>>
>> Now I enable CONFIG_FRAME_POINTER and I can see the full backtrace. :)
>
> It's good you found it. I thought STACKTRACE on x86_64 would set the
> necessary options like FRAME_POINTER so that it works properly. Kmemleak
> only sets STACKTRACE.
>

I am wondering why STACKTRACE doesn't select FRAME_POINTER on x86_64,
which seems necessary...
