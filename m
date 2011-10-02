Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753873Ab1JBSUN (ORCPT <rfc822;w@1wt.eu>);
	Sun, 2 Oct 2011 14:20:13 -0400
Received: from out2.smtp.messagingengine.com ([66.111.4.26]:39453 "EHLO
	out2.smtp.messagingengine.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751708Ab1JBSUK (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 2 Oct 2011 14:20:10 -0400
X-Sasl-enc: zXkrOxZmDaiD0trbydklsXMZmXANNjRP/D9oAU3eX+zy 1317579609
Date: Sun, 2 Oct 2011 15:20:06 -0300
From: Henrique de Moraes Holschuh <hmh@hmh.eng.br>
To: "H. Peter Anvin" <hpa@zytor.com>
Cc: "Rafael J. Wysocki" <rjw@sisk.pl>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        Greg KH <gregkh@suse.de>
Subject: Re: kernel.org status: establishing a PGP web of trust
Message-ID: <20111002182005.GB16368@khazad-dum.debian.net>
References: <4E8655CD.90107@zytor.com>
 <201110012333.55428.rjw@sisk.pl>
 <4E8793B6.8030405@zytor.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <4E8793B6.8030405@zytor.com>
X-GPG-Fingerprint: 1024D/1CDB0FE3 5422 5C61 F6B7 06FB 7E04  3738 EE25 DE3F
 1CDB 0FE3
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sat, 01 Oct 2011, H. Peter Anvin wrote:
> On 10/01/2011 02:33 PM, Rafael J. Wysocki wrote:
> > 
> > OK, how long should the new key be valid?
> > 
> 
> That is a good question.  At the very least you want it to be valid for
> long enough that you will be able to get enough signatures on a new key
> *before* your old key expires.  As such I would recommend 3-5 years
> depending on how much you trust yourself to keep the key secure.
> 
> Some people have decided to opt for an unlimited key, but that
> *requires* that you have a way to revoke the old key, which is why we
> are considering a key revocation escrow service.

You can update the key expirity date at any time[1].  However, such
updates can still leave you with a lot of expired signatures, it all
depends on how the signers will set the expirity date of their
signatures when they sign your key...

This happened to my 0x1cdb0fe3 key.  It is still part of the strong set,
but it used to have much better connectivity.  It was necessary to
extend its service life, and about 3/4 of the signatures in it had
expire dates in sync with its original validity, and have now expired.

As for the key revocation escrow service, it should be kept offline and
very well protected.  If someone revokes all those keys at once, it can
cause a large service disruption at the very least.

It is also good to keep in mind that any sane security model extends the
loss of trust on a key to all signatures it has ever made and will ever
make, unless you have extra information (such as timestamp signatures
made by a still-trusted key).

On a somewhat related note, gpg supports subkeys.  When using subkeys,
you will only need the main key to sign other keys.  That means you can
have a large validity on a strong key (say: 10yr for RSA/4096) and keep
it always offline (in encrypted media, of course), and have subkeys on a
simple token or encrypted removable media for day-to-day use.

subkeys can be made to expire a lot more often (say, 1yr or 2yr
validity) without any major disadvantages, you just upload a new subkey
to the keyservers a few months before the current ones will expire.  You
can also revoke subkeys without any detrimental effects to the main key
and to your connectivity to the web of trust.

[1] that doesn't mean it will be easy to get people to accept such an
update after the key expired.  I don't think the keysevers will allow an
expired key to be "unexpired", for example.

-- 
  "One disk to rule them all, One disk to find them. One disk to bring
  them all and in the darkness grind them. In the Land of Redmond
  where the shadows lie." -- The Silicon Valley Tarot
  Henrique Holschuh
