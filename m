Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756699Ab2BAQiN (ORCPT <rfc822;w@1wt.eu>);
	Wed, 1 Feb 2012 11:38:13 -0500
Received: from out3-smtp.messagingengine.com ([66.111.4.27]:37882 "EHLO
	out3-smtp.messagingengine.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1756547Ab2BAQiL (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 1 Feb 2012 11:38:11 -0500
X-Sasl-enc: /uWbiaJ+GEdaIf50PyD2qwUGEFzqvQt6vpB5eszY8Mlp 1328114290
Subject: Re: Memory corruption due to word sharing
From: Colin Walters <walters@verbum.org>
To: Jan Kara <jack@suse.cz>
Cc: LKML <linux-kernel@vger.kernel.org>, linux-ia64@vger.kernel.org,
        Linus Torvalds <torvalds@linux-foundation.org>, dsterba@suse.cz,
        ptesarik@suse.cz, rguenther@suse.de, gcc@gcc.gnu.org
Date: Wed, 01 Feb 2012 11:37:45 -0500
In-Reply-To: <20120201151918.GC16714@quack.suse.cz>
References: <20120201151918.GC16714@quack.suse.cz>
Content-Type: text/plain; charset="UTF-8"
X-Mailer: Evolution 3.0.3 (3.0.3-1.fc15) 
Content-Transfer-Encoding: 7bit
Message-ID: <1328114266.5355.44.camel@lenny>
Mime-Version: 1.0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 2012-02-01 at 16:19 +0100, Jan Kara wrote:

> I've raised the issue with our GCC guys and they said to me that: "C does
> not provide such guarantee, nor can you reliably lock different
> structure fields with different locks if they share naturally aligned
> word-size memory regions.  The C++11 memory model would guarantee this,
> but that's not implemented nor do you build the kernel with a C++11
> compiler."

That's interesting.  So it seems like there are two solutions:

1) Use the same lock for a given bitfield
2) Split up the bitfield into different words


