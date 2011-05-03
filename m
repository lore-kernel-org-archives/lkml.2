Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755486Ab1ECAlQ (ORCPT <rfc822;w@1wt.eu>);
	Mon, 2 May 2011 20:41:16 -0400
Received: from mail.parknet.co.jp ([210.171.160.6]:58986 "EHLO
	mail.parknet.co.jp" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754496Ab1ECAlP (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 2 May 2011 20:41:15 -0400
From: OGAWA Hirofumi <hirofumi@mail.parknet.co.jp>
To: linux-kernel@vger.kernel.org
Subject: Re: unable to handle kernel paging request when inserting FAT32 formatted flash media
References: <20110502064945.GA12197@mac.home>
	<20110502065529.GA12397@mac.home> <87y62pf9xg.fsf@devron.myhome.or.jp>
	<87r58hf866.fsf@devron.myhome.or.jp>
	<20110502170122.GA14096@eazy.amigager.de>
	<87k4e9ey9k.fsf@devron.myhome.or.jp> <20110502203327.GA19507@mac.home>
	<87bozkg3ng.fsf@devron.myhome.or.jp>
Date: Tue, 03 May 2011 09:41:11 +0900
In-Reply-To: <87bozkg3ng.fsf@devron.myhome.or.jp> (OGAWA Hirofumi's message of
	"Tue, 03 May 2011 07:04:51 +0900")
Message-ID: <8762psfwew.fsf@devron.myhome.or.jp>
User-Agent: Gnus/5.13 (Gnus v5.13) Emacs/24.0.50 (gnu/linux)
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

OGAWA Hirofumi <hirofumi@mail.parknet.co.jp> writes:

> Tino Keitel <tino.keitel@tikei.de> writes:
>
>>> > Yes, it is reproducible. It happens with a CF card from a Canon DSLR as
>>> > well as with a SD card from a little Fuji cam. Configs are attached.
>>> 
>>> .config didn't have interest part for now. Could you send another oops,
>>> and vfat.ko, fat.ko? I'd like to see more detail by assembler, current
>>> oops is unclear...
>>
>> Another Oops, this time with the SD card, and the modules are attached.
>>
>>> And if possible, git bisect is appreciate.
>>
>> Lack of spare time currently, sorry.
>
> OK. Thanks for your help.

It seems to be interesting exception.

before relocation (from fat.ko)
    8656:	74 51                	je     86a9 <fat_build_inode+0x2e9>
    8658:	49 c7 c6 00 00 00 00 	mov    $0x0,%r14
    865f:	b2 b6                	mov    $0xb6,%dl
    8661:	80 3d 00 00 00 00 00 	cmpb   $0x0,0x0(%rip) <-- exception
    8668:	74 3f                	je     86a9 <fat_build_inode+0x2e9>
    866a:	49 8d 44 24 08       	lea    0x8(%r12),%rax

after relocation (from oops)

  20:	74 51                	je     73 <a+0x73>
  22:	49 c7 c6 d8 91 13 a0 	mov    $0xffffffffa01391d8,%r14
  29:	b2 b6                	mov    $0xb6,%dl
  2b:	3d fc 9b 00 00       	cmp    $0x9bfc,%eax
  30:	00 74 3f 49          	add    %dh,0x49(%rdi,%rdi,1)
  34:	8d 44 24 08          	lea    0x8(%rsp),%eax

relocation info would be this
  0x0000000000006883  X86_64_32S      000000000000000000    +253 .rodata.str1.1

Although I'm not sure at all for now, I'm guessing something wrong
happened around relocation.

Thanks.
-- 
OGAWA Hirofumi <hirofumi@mail.parknet.co.jp>
