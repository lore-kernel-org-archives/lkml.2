Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753236Ab2FLNHE (ORCPT <rfc822;w@1wt.eu>);
	Tue, 12 Jun 2012 09:07:04 -0400
Received: from mail-pz0-f46.google.com ([209.85.210.46]:57701 "EHLO
	mail-pz0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751696Ab2FLNHA (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 12 Jun 2012 09:07:00 -0400
Date: Tue, 12 Jun 2012 22:06:54 +0900
From: Takuya Yoshikawa <takuya.yoshikawa@gmail.com>
To: Arnd Bergmann <arnd@arndb.de>
Cc: Takuya Yoshikawa <yoshikawa.takuya@oss.ntt.co.jp>,
        bhutchings@solarflare.com, grundler@parisc-linux.org, avi@redhat.com,
        mtosatti@redhat.com, linux-net-drivers@solarflare.com,
        netdev@vger.kernel.org, linux-kernel@vger.kernel.org,
        linux-arch@vger.kernel.org, kvm@vger.kernel.org
Subject: Re: [PATCH 1/4] drivers/net/ethernet/sfc: Add efx_ prefix to
 set_bit_le()
Message-Id: <20120612220654.fd0246e6e687f7c79e5c988c@gmail.com>
In-Reply-To: <201206111409.16093.arnd@arndb.de>
References: <20120611212735.f92ea521.yoshikawa.takuya@oss.ntt.co.jp>
	<20120611212901.2b4d0a17.yoshikawa.takuya@oss.ntt.co.jp>
	<201206111409.16093.arnd@arndb.de>
X-Mailer: Sylpheed 3.2.0beta3 (GTK+ 2.24.6; x86_64-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 11 Jun 2012 14:09:15 +0000
Arnd Bergmann <arnd@arndb.de> wrote:

> On Monday 11 June 2012, Takuya Yoshikawa wrote:
> > 
> >  /* Set bit in a little-endian bitfield */
> > -static inline void set_bit_le(unsigned nr, unsigned char *addr)
> > +static inline void efx_set_bit_le(unsigned nr, unsigned char *addr)
> >  {
> >         addr[nr / 8] |= (1 << (nr % 8));
> >  }
> >  
> >  /* Clear bit in a little-endian bitfield */
> > -static inline void clear_bit_le(unsigned nr, unsigned char *addr)
> > +static inline void efx_clear_bit_le(unsigned nr, unsigned char *addr)
> >  {
> >         addr[nr / 8] &= ~(1 << (nr % 8));
> >  }
> 
> Hmm, any reason why we're not just using the existing non-atomic
> __set_bit_le() here? I think the helpers in sfc and tulip can
> just get removed if you use those.

__set_bit_le() assumes long word alignment and does endian conversion
when needed.

To be honest, I am a bit scared of changing drivers which I cannot test
on real hardware.

	Takuya
