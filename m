Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752239Ab1EDIdu (ORCPT <rfc822;w@1wt.eu>);
	Wed, 4 May 2011 04:33:50 -0400
Received: from mail-gw0-f46.google.com ([74.125.83.46]:63475 "EHLO
	mail-gw0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751291Ab1EDIdp convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 4 May 2011 04:33:45 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=mime-version:in-reply-to:references:from:date:message-id:subject:to
         :cc:content-type:content-transfer-encoding;
        b=uanrApxMmwvwo06Bya8A+hoAytG/7rvDHGRTiJ6gM4NcPb8GrRCxxCEZVqV+NefZIh
         tMZ3nZfZ9IOygsVFM54NwGXSo2KoH5M6K3Cvb+Yamq0UsiAVit+ph/jS2/zWs5iSvWVY
         tPDc/6Npmb8IBen8P0+4SZf8JgHA179qhyxqY=
MIME-Version: 1.0
In-Reply-To: <AE90C24D6B3A694183C094C60CF0A2F6D8AD0D@saturn3.aculab.com>
References: <1304458235-28473-1-git-send-email-sven@narfation.org> <AE90C24D6B3A694183C094C60CF0A2F6D8AD0D@saturn3.aculab.com>
From: Mike Frysinger <vapier.adi@gmail.com>
Date: Wed, 4 May 2011 04:33:24 -0400
Message-ID: <BANLkTimctgbto3dsnJ3d3r7NggS0KF9_Sw@mail.gmail.com>
Subject: Re: [PATCH] atomic: add *_dec_not_zero
To: David Laight <David.Laight@aculab.com>
Cc: Sven Eckelmann <sven@narfation.org>, linux-kernel@vger.kernel.org,
        linux-arch@vger.kernel.org, linux-mips@linux-mips.org,
        linux-m32r@ml.linux-m32r.org, linux-ia64@vger.kernel.org,
        linux-parisc@vger.kernel.org, linux-cris-kernel@axis.com,
        linux-s390@vger.kernel.org, linux-sh@vger.kernel.org, x86@kernel.org,
        Chris Metcalf <cmetcalf@tilera.com>,
        David Howells <dhowells@redhat.com>, linux-m68k@vger.kernel.org,
        linux-am33-list@redhat.com, linux-alpha@vger.kernel.org,
        sparclinux@vger.kernel.org, uclinux-dist-devel@blackfin.uclinux.org,
        linuxppc-dev@lists.ozlabs.org, linux-arm-kernel@lists.infradead.org
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, May 4, 2011 at 04:05, David Laight wrote:
>> Introduce an *_dec_not_zero operation.  Make this a special case of
>> *_add_unless because batman-adv uses atomic_dec_not_zero in different
>> places like re-broadcast queue or aggregation queue management. There
>> are other non-final patches which may also want to use this macro.
>
> Isn't there a place where a default definition of this can be
> defined? Instead of adding it separately to every architecture.

that's what asm-generic is for.  if the arch isnt using it, it's
either because the arch needs to convert to it, or they're using SMP
and asm-generic doesnt yet support that for atomic.h.

for example, the Blackfin port only needed updating for the SMP case.
in the non-SMP case, we're getting the def from asm-generic/atomic.h.
-mike
