Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S965414Ab2J3SyJ (ORCPT <rfc822;w@1wt.eu>);
	Tue, 30 Oct 2012 14:54:09 -0400
Received: from li9-11.members.linode.com ([67.18.176.11]:58496 "EHLO
	imap.thunk.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S934001Ab2J3SyI convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 30 Oct 2012 14:54:08 -0400
Date: Tue, 30 Oct 2012 14:54:03 -0400
From: "Theodore Ts'o" <tytso@mit.edu>
To: Lasse =?iso-8859-1?Q?K=E4rkk=E4inen?= <ljkarkk2@cc.hut.fi>
Cc: linux-kernel@vger.kernel.org
Subject: Re: urandom is too slow
Message-ID: <20121030185403.GA5044@thunk.org>
Mail-Followup-To: Theodore Ts'o <tytso@mit.edu>,
	Lasse =?iso-8859-1?Q?K=E4rkk=E4inen?= <ljkarkk2@cc.hut.fi>,
	linux-kernel@vger.kernel.org
References: <508FEA5A.7010406@cc.hut.fi>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
In-Reply-To: <508FEA5A.7010406@cc.hut.fi>
User-Agent: Mutt/1.5.21 (2010-09-15)
Content-Transfer-Encoding: 8BIT
X-SA-Exim-Connect-IP: <locally generated>
X-SA-Exim-Mail-From: tytso@thunk.org
X-SA-Exim-Scanned: No (on imap.thunk.org); SAEximRunCond expanded to false
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Oct 30, 2012 at 04:55:22PM +0200, Lasse Kärkkäinen wrote:
> Apparently there has been little or no development on urandom even
> though the device is in widespread use for disk shredding and such
> use. The device emits data at rather slow rate of 19 MB/s even on
> modern hardware where other software-based PRNGs could do far
> better. An even better option seems to be utilizing AES for
> encrypting zeroes, using a random key, allowing for rates up to 500
> MB/s with hardware that has AES-NI instructions.
> 
> Why is urandom so slow and why isn't AES hardware acceleration utilized?

If you can use a software-based PRNG, you should use one in userspace.
The intended use of urandom is for cryptographic purposes (i.e.,
generating random session keys, long-term public keys, etc.).  If you
just want to wipe a disk, you shouldn't be using /dev/urandom for that
purpose.

Regards,

						- Ted
