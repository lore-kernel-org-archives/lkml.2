Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S934013Ab1JEAby (ORCPT <rfc822;w@1wt.eu>);
	Tue, 4 Oct 2011 20:31:54 -0400
Received: from out3.smtp.messagingengine.com ([66.111.4.27]:41356 "EHLO
	out3.smtp.messagingengine.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S933803Ab1JEAbw (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 4 Oct 2011 20:31:52 -0400
X-Sasl-enc: 2qXrGyRGdcjntkg7dO1MjVtMV9Nv0FcQ4nacLzF5TnXQ 1317774432
Date: Tue, 4 Oct 2011 21:27:07 -0300
From: Henrique de Moraes Holschuh <hmh@hmh.eng.br>
To: Heiko Carstens <heiko.carstens@de.ibm.com>
Cc: Jiri Kosina <jkosina@suse.cz>, "H. Peter Anvin" <hpa@zytor.com>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
Subject: Re: kernel.org status: establishing a PGP web of trust
Message-ID: <20111005002707.GA20062@khazad-dum.debian.net>
References: <4E8655CD.90107@zytor.com>
 <alpine.LRH.2.00.1110031316260.14853@twin.jikos.cz>
 <20111004125134.GB2803@osiris.boeblingen.de.ibm.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20111004125134.GB2803@osiris.boeblingen.de.ibm.com>
X-GPG-Fingerprint: 1024D/1CDB0FE3 5422 5C61 F6B7 06FB 7E04  3738 EE25 DE3F
 1CDB 0FE3
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 04 Oct 2011, Heiko Carstens wrote:
> > I have a question here. In case people are 'reasonably certain' that the 
> > old key has never been jeoparadized, why are they required to create a new 
> > key?

You do that when your key is either old, or weaker than the requested keys.
In the kernel.org case, if your old key is not RSA/4096...

If your old key is already RSA/4096, there are some reasons to
create a new key:

 1. "Just in case the old key was compromised", in which case you should
    revoke the old key soon.

 2. To use different keys for different purposes.

 3. To have a backup key (when proper use of subkeys is not enough to
    protect the main key) -- you better think about this carefully: how safe
    can you make the backup key storage, and _how fast_ you will notice
    should someone manage to access it?

 4. When prepararing for a key rollover in the near future (in which case
    the keys are cross-signed, and you keep collecting signatures on BOTH
    keys until the old one is decomissioned).

> > (if the old key would have been compromised, the attacker could as well 
> > generate a new key and sign it with the old key himself, so I fail to see 
> > any benefit of this PGP excercise).

Yes, he could.  The signature from the old key is used to assert that you
indeed have control of the old private key, but it cannot assert that you
are the only party that has control of the old private key.

> > It doesn't make too much sense to force people to live with two different 
> > personalities in this "PGP web of trust" world just for the sake of 
> > kernel.org, does it?
> 
> Also same question here. And as far as I can tell nobody has given an
> answer yet.

That depends, you might want to have separate keys for separate purposes
(which only makes sense if key usage will be different enough to cause
different key exposure to risks).

In any case, if you'll have different keys, it is good practice to use the
UID comment field to disclose the purpose of the key.

-- 
  "One disk to rule them all, One disk to find them. One disk to bring
  them all and in the darkness grind them. In the Land of Redmond
  where the shadows lie." -- The Silicon Valley Tarot
  Henrique Holschuh
