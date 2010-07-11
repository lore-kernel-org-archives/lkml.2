Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752294Ab0GKIhH (ORCPT <rfc822;w@1wt.eu>);
	Sun, 11 Jul 2010 04:37:07 -0400
Received: from mail-ww0-f44.google.com ([74.125.82.44]:50781 "EHLO
	mail-ww0-f44.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751500Ab0GKIhE (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 11 Jul 2010 04:37:04 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=subject:from:to:cc:in-reply-to:references:content-type:date
         :message-id:mime-version:x-mailer:content-transfer-encoding;
        b=L8V998Kzuys2okVawvW/stviJFhqoMse2q7T4WXDy4IcBhSv3ZwUkwsgn4YEyogm/n
         1ugyH0IMWnDufMUgW+tSDFu+QxoLYXpwyBTY050VOM1563CmYxcNGX6ZcLESxEg2pQrv
         IakgMsK+2SyMpyflc8Tm1LTXGxJ8ZlgnHq68c=
Subject: Re: [PATCH] tproxy: nf_tproxy_assign_sock() can handle tw sockets
From: Eric Dumazet <eric.dumazet@gmail.com>
To: David Miller <davem@davemloft.net>
Cc: felipewd@gmail.com, kaber@trash.net, linux-kernel@vger.kernel.org,
       netdev@vger.kernel.org
In-Reply-To: <20100710.123011.260095467.davem@davemloft.net>
References: <1278695580.2696.55.camel@edumazet-laptop>
	 <AANLkTil39xHOhcdAo4h_jWtx_UuYdFHGdQVAdwPMd7QJ@mail.gmail.com>
	 <1278742649.2538.17.camel@edumazet-laptop>
	 <20100710.123011.260095467.davem@davemloft.net>
Content-Type: text/plain; charset="UTF-8"
Date: Sun, 11 Jul 2010 10:36:59 +0200
Message-ID: <1278837419.2538.131.camel@edumazet-laptop>
Mime-Version: 1.0
X-Mailer: Evolution 2.28.3 
Content-Transfer-Encoding: 8bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Le samedi 10 juillet 2010 à 12:30 -0700, David Miller a écrit :
> From: Eric Dumazet <eric.dumazet@gmail.com>
> Date: Sat, 10 Jul 2010 08:17:29 +0200
> 
> > Strange thing with your crash report is CR2 value, with unexpected value
> > of 000000000b388000 while RAX value is dce8dce85d415d41
> > 
> > Faulting instruction is :
> > 
> > 48 83 b8 b0 00 00 00 00   cmpq   $0x0,0xb0(%rax)
> > 
> > So I would have expected CR2 being RAX+0xb0, but its not.
> 
> It could be corruption from elsewhere.  Those last four hex
> digits (0x5d415d41) are "]A]A" in ascii, but that could just
> be coincidence.
> 

x86 being litle endian, string is "A]A]" followed by another "XYXY"
pattern (non ASCII chars : 0xE8, 0xDC, 0xE8, 0xDC, "èÜèÜ" in ISO8859)



