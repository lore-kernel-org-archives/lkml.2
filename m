Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754961Ab0D1STH (ORCPT <rfc822;w@1wt.eu>);
	Wed, 28 Apr 2010 14:19:07 -0400
Received: from mail-px0-f174.google.com ([209.85.212.174]:63656 "EHLO
	mail-px0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751406Ab0D1STD convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 28 Apr 2010 14:19:03 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=mime-version:in-reply-to:references:date:message-id:subject:from:to
         :cc:content-type:content-transfer-encoding;
        b=q7FOi2D6II8PrKP11ui2VogAbfI+iMkilgYkG3GGhTaeTNXE6g9WBXA7glPQqbNjBz
         2W2/FTcTP7zyw3uabnDX8svogW0S5VjhVrERo/hDcUgoAQh/Di2qMtreLNU3Mev+fjuh
         eQAmS00tnU9sfBOeMnl7+7JHVDhLTU0xEMqQ4=
MIME-Version: 1.0
In-Reply-To: <20100329110339P.fujita.tomonori@lab.ntt.co.jp>
References: <1269822285.8653.251.camel@localhost>
	 <20100329105129Y.fujita.tomonori@lab.ntt.co.jp>
	 <1269827928.8653.307.camel@localhost>
	 <20100329110339P.fujita.tomonori@lab.ntt.co.jp>
Date: Wed, 28 Apr 2010 20:19:02 +0200
Message-ID: <u2kf6ca9fed1004281119g865f263cr26df59e620f6129f@mail.gmail.com>
Subject: Re: [PATCH] rt28xx: Make PCI_{MAP,UNMAP}_SINGLE type-safe
From: drago01 <drago01@gmail.com>
To: FUJITA Tomonori <fujita.tomonori@lab.ntt.co.jp>
Cc: ben@decadent.org.uk, bzolnier@gmail.com, gregkh@suse.de,
       linux-wireless@vger.kernel.org, linux-kernel@vger.kernel.org
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Mar 29, 2010 at 4:04 AM, FUJITA Tomonori
<fujita.tomonori@lab.ntt.co.jp> wrote:
> On Mon, 29 Mar 2010 02:58:48 +0100
> Ben Hutchings <ben@decadent.org.uk> wrote:
>
>> On Mon, 2010-03-29 at 10:52 +0900, FUJITA Tomonori wrote:
>> > On Mon, 29 Mar 2010 01:24:45 +0100
>> > Ben Hutchings <ben@decadent.org.uk> wrote:
>> >
>> > > To avoid recurrence of bugs such as <http://bugs.debian.org/575726>,
>> > > change the type of the first parameter to linux_pci_{map,unmap}_single()
>> > > from void * to struct rt_rtmp_adapter *.  Also do not define the macros
>> > > PCI_{MAP,UNMAP}_SINGLE() when building the rt2870sta driver; they are
>> > > not used and if they were that would be a bug.
>> > >
>> > > Signed-off-by: Ben Hutchings <ben@decadent.org.uk>
>> > > ---
>> > >  drivers/staging/rt2860/rt_linux.h    |   14 +++++---------
>> > >  drivers/staging/rt2860/rt_pci_rbus.c |   12 ++++--------
>> > >  2 files changed, 9 insertions(+), 17 deletions(-)
>> >
>> > I think using dma_map_single directly instead of inventing a wrapper
>> > function make the code more readable.
>>
>> These functions are not quite simple wrappers, unfortunately.  So while
>> I think that is worth doing it is a separate change.
>
> Well, the current wrapper functions looks terrible. Needs to fix them
> before moving the driver out of the staging anyway, I think.

The driver is not expected to make it ever out of staging ... unless
someone ports it to mac80211 ... the in kernel rt2x00 drivers are the
longer term solutions for supporting this hardware.
