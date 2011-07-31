Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752964Ab1GaCmS (ORCPT <rfc822;w@1wt.eu>);
	Sat, 30 Jul 2011 22:42:18 -0400
Received: from out2.smtp.messagingengine.com ([66.111.4.26]:33448 "EHLO
	out2.smtp.messagingengine.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752559Ab1GaCmM (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 30 Jul 2011 22:42:12 -0400
X-Sasl-enc: aYaKjf6NH8avPwvipMG8Bwpf0AH9We08Jnk5LcpGvn9I 1312080131
Date: Sat, 30 Jul 2011 23:42:09 -0300
From: Henrique de Moraes Holschuh <hmh@hmh.eng.br>
To: Bryan Donlan <bdonlan@gmail.com>
Cc: Linus Torvalds <torvalds@linux-foundation.org>,
        George Spelvin <linux@horizon.com>, linux-kernel@vger.kernel.org,
        mpm@selenic.com, tytso@mit.edu
Subject: Re: [PATCH 1/2] random: Add support for architectural random hooks
Message-ID: <20110731024208.GA30593@khazad-dum.debian.net>
References: <20110730234630.7270.qmail@science.horizon.com>
 <CAF_S4t8TFour-Yw1T+qdG9mCzy9+tGBR0hQG83+ra6PRzPhNHQ@mail.gmail.com>
 <CA+55aFyimDdpCRER_7pc30S-QLhUkt0z-Y=gD48f7t=FxxFh7g@mail.gmail.com>
 <CAF_S4t9PhDQBBfaLLaq1sE9YkJvQq5Q+ULegpD0aoTnv0CPutw@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <CAF_S4t9PhDQBBfaLLaq1sE9YkJvQq5Q+ULegpD0aoTnv0CPutw@mail.gmail.com>
X-GPG-Fingerprint: 1024D/1CDB0FE3 5422 5C61 F6B7 06FB 7E04  3738 EE25 DE3F
 1CDB 0FE3
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sat, 30 Jul 2011, Bryan Donlan wrote:
> In any case though, what about my suggestion - don't mess with urandom
> at all, and let udev replace the /dev/urandom device node with one
> directed to a fast hwrng device if one is detected? This has zero

Now, THAT would be unsafe, and a nasty way to go about it.

If you really don't want to touch /dev/.random, make it simple: either
export the embedded RNG as high-bandwidth /dev/hwrandom and let
userspace postprocess it and reroute it back to /dev/random as needed,
or do the same with a kernel thread.

-- 
  "One disk to rule them all, One disk to find them. One disk to bring
  them all and in the darkness grind them. In the Land of Redmond
  where the shadows lie." -- The Silicon Valley Tarot
  Henrique Holschuh
