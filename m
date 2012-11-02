Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752692Ab2KBT4L (ORCPT <rfc822;w@1wt.eu>);
	Fri, 2 Nov 2012 15:56:11 -0400
Received: from li9-11.members.linode.com ([67.18.176.11]:59042 "EHLO
	imap.thunk.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750949Ab2KBT4J convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 2 Nov 2012 15:56:09 -0400
Date: Fri, 2 Nov 2012 15:56:00 -0400
From: "Theodore Ts'o" <tytso@mit.edu>
To: Lasse =?iso-8859-1?Q?K=E4rkk=E4inen?= <ljkarkk2@cc.hut.fi>
Cc: linux-kernel@vger.kernel.org
Subject: Re: urandom is too slow
Message-ID: <20121102195600.GA32632@thunk.org>
Mail-Followup-To: Theodore Ts'o <tytso@mit.edu>,
	Lasse =?iso-8859-1?Q?K=E4rkk=E4inen?= <ljkarkk2@cc.hut.fi>,
	linux-kernel@vger.kernel.org
References: <508FEA5A.7010406@cc.hut.fi>
 <20121030185403.GA5044@thunk.org>
 <20121030213850.7b987ddf@pyramind.ukuu.org.uk>
 <50931D6D.2080402@cc.hut.fi>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
In-Reply-To: <50931D6D.2080402@cc.hut.fi>
User-Agent: Mutt/1.5.21 (2010-09-15)
Content-Transfer-Encoding: 8BIT
X-SA-Exim-Connect-IP: <locally generated>
X-SA-Exim-Mail-From: tytso@thunk.org
X-SA-Exim-Scanned: No (on imap.thunk.org); SAEximRunCond expanded to false
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Nov 02, 2012 at 03:10:05AM +0200, Lasse Kärkkäinen wrote:
> Thank you for your answers, they should be very helpful for someone
> who is actually blanking or shredding their disks. However, I am
> just genuinely interested on why is no better CSPRNG algorithm used
> in the kernel (is it simply because no-one sent a patch or am I
> missing something?).

The answer is that the goal of /dev/urandom is not to be a
cryptographic random number generator (CRNG); a CRNG relies on the
security of the cryptographic primitive for its strength.  For
example, a CRNG which is based on DES or AES encrypting an
incrementing counter using a secret key, is fundamentally reliant on
the strength of DES or AES.  If DES were to be broken, for example, an
attacker would be able to determine secret key and thus predict all
future outputs of a DES-based CRNG.

The design of the /dev/random and /dev/urandom is to take advantage of
the kernel's access to unpredictability from the hardware, and to
avoid being "brittle" even in the face of a discovery of a weakness of
its cryptographic primitives.

Regards,

						- Ted
