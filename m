Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753527Ab0K0UxO (ORCPT <rfc822;w@1wt.eu>);
	Sat, 27 Nov 2010 15:53:14 -0500
Received: from mail-qy0-f174.google.com ([209.85.216.174]:37673 "EHLO
	mail-qy0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753380Ab0K0UxL convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 27 Nov 2010 15:53:11 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=googlemail.com; s=gamma;
        h=mime-version:reply-to:in-reply-to:references:date:message-id
         :subject:from:to:content-type:content-transfer-encoding;
        b=HCWynQcQoQTRa3G3mObJyYGTVdIE11/Ra5yDJ3aWqdS0lcv1/xncDq1D3NK9D/asaZ
         Lu2kowa6oQD3mPK5MQbFZTMMY1ME8bYqeEUUg/loia/JndZsVVfDMd0Ofk5wrBsxnq2q
         SK+kOC/XpAJasyZ1tMSjCUlB1RolZT2Y0icgE=
MIME-Version: 1.0
Reply-To: sedat.dilek@gmail.com
In-Reply-To: <AANLkTi=F_Zteh9Sbxiea=rDj7HGOxYkfu5=Aa71R+ufG@mail.gmail.com>
References: <AANLkTi=F_Zteh9Sbxiea=rDj7HGOxYkfu5=Aa71R+ufG@mail.gmail.com>
Date: Sat, 27 Nov 2010 21:53:10 +0100
Message-ID: <AANLkTinkUXFnV=HQy80RXBe96kzp+k1LKbypsi+qQ9AU@mail.gmail.com>
Subject: Re: [PATCH 00/46] rcu-walk and dcache scaling
From: Sedat Dilek <sedat.dilek@googlemail.com>
To: Nick Piggin <npiggin@kernel.dk>, LKML <linux-kernel@vger.kernel.org>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sat, Nov 27, 2010 at 8:20 PM, Sedat Dilek <sedat.dilek@googlemail.com> wrote:
> Hi,
>
> I wanted to give your patchset a try (on top of latest linux-next).
>
> Unfortunately, the build breaks here:
>
> /home/sd/src/linux-2.6/linux-2.6.37-rc3/debian/build/source_i386_none/fs/cifs/inode.c:807:
> error: ‘dcache_inode_lock’ undeclared (first use in this function)
> /home/sd/src/linux-2.6/linux-2.6.37-rc3/debian/build/source_i386_none/fs/cifs/inode.c:807:
> error: (Each undeclared identifier is reported only once
> /home/sd/src/linux-2.6/linux-2.6.37-rc3/debian/build/source_i386_none/fs/cifs/inode.c:807:
> error: for each function it appears in.)
>
> Attached patch "fs-cifs-inode.c-Fix-error-dcache_inode_lock-undeclared.patch"
> should fix it.
>
> Kind Regards,
> - Sedat -
>
> Compile-tested-by: me
>
[ ... ]

Next breakage:

/home/sd/src/linux-2.6/linux-2.6.37-rc3/debian/build/source_i386_none/drivers/staging/pohmelfs/inode.c:834:
error: ‘psb’ undeclared (first use in this function)
/home/sd/src/linux-2.6/linux-2.6.37-rc3/debian/build/source_i386_none/drivers/staging/pohmelfs/inode.c:834:
error: (Each undeclared identifier is reported only once
/home/sd/src/linux-2.6/linux-2.6.37-rc3/debian/build/source_i386_none/drivers/staging/pohmelfs/inode.c:834:
error: for each function it appears in.)

- Sedat -

P.S.: Note to myself: Unset CONFIG_POHMELFS for testing-purposes.

[ debian/config/i386/none/config.686 ]
...
##
## file: drivers/staging/pohmelfs/Kconfig
##
# CONFIG_POHMELFS is not set
