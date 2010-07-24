Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752234Ab0GXViy (ORCPT <rfc822;w@1wt.eu>);
	Sat, 24 Jul 2010 17:38:54 -0400
Received: from mail-iw0-f174.google.com ([209.85.214.174]:39802 "EHLO
	mail-iw0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750898Ab0GXViu (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 24 Jul 2010 17:38:50 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=mime-version:in-reply-to:references:date:message-id:subject:from:to
         :cc:content-type;
        b=A74+LP+EhUKfZ5XWrPSFwaD0pCfcfZFW1gZ3ukLxhnHKL8iilmpGZH/ne9wZh+htUK
         ThdwVbN5BjJtEoJd+deAwjBKQz4UEPEc3Cv4Nxh+nAKyqhvJHf2hzVhzM7AuWTC0twmL
         ZsfRB1WBbYC/nwAxHBQ6fyal+7O5V4t+n/J3w=
MIME-Version: 1.0
In-Reply-To: <SNT125-W4469FAC3FE110BB4882949C3A40@phx.gbl>
References: <4C4AB952.9030705@kernel.org>
	<SNT125-W4469FAC3FE110BB4882949C3A40@phx.gbl>
Date: Sat, 24 Jul 2010 17:38:49 -0400
Message-ID: <AANLkTi=-0Hdp2dfK_RB=w-W8Qm8O42dDM0ybEcRtEMdn@mail.gmail.com>
Subject: Re: support for drives larger than 2TiB
From: Greg Freemyer <greg.freemyer@gmail.com>
To: Yuhong Bao <yuhongbao_386@hotmail.com>
Cc: tj@kernel.org, jeff@garzik.org, ben.collins@ubuntu.com,
        linux-ide@vger.kernel.org, linux-kernel@vger.kernel.org,
        hmh@debian.org
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sat, Jul 24, 2010 at 2:40 PM, Yuhong Bao <yuhongbao_386@hotmail.com> wrote:
>
>> However, 2TiB limit is
>> inherent in the BIOS programming interface and currently the only way
>> to overcome it is using a completely different BIOS interface (EFI,
>> that is).
> Nope, look at the Int13 extensions, it already support 64-bit LBA.
>
> Yuhong Bao

64-bit LBA?  I assume you meant 48-bit LBA from ATA-7.  It will
address up to PBs I believe.  (KB, MB, GB, TB, PB, ....)

But I've seen lots of "48-bit LBA" supporting controllers that hit
limits at 500GB, 1TB, etc. and needed new firmware updates.

Secondly, if you look at the table on the right of
http://en.wikipedia.org/wiki/Master_boot_record#Disk_partitioning you
see that the starting sector of a partition is defined with a 32-bit
value.

ie. 2TB with 512 byte sectors.

The normal solution is to move to a GPT which requires EFI if you want
to boot from it.

Greg
