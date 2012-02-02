Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754522Ab2BBJ35 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 2 Feb 2012 04:29:57 -0500
Received: from esgaroth.petrovitsch.at ([78.47.184.11]:6096 "EHLO
	esgaroth.petrovitsch.priv.at" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1754069Ab2BBJ3z (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 2 Feb 2012 04:29:55 -0500
X-DKIM: Sendmail DKIM Filter v2.8.3 unknown-host q129SfjO013928
Subject: RE: Memory corruption due to word sharing
From: Bernd Petrovitsch <bernd@petrovitsch.priv.at>
To: "Boehm, Hans" <hans.boehm@hp.com>
Cc: Linus Torvalds <torvalds@linux-foundation.org>,
        Torvald Riegel <triegel@redhat.com>, Jan Kara <jack@suse.cz>,
        LKML <linux-kernel@vger.kernel.org>,
        "linux-ia64@vger.kernel.org" <linux-ia64@vger.kernel.org>,
        "dsterba@suse.cz" <dsterba@suse.cz>,
        "ptesarik@suse.cz" <ptesarik@suse.cz>,
        "rguenther@suse.de" <rguenther@suse.de>,
        "gcc@gcc.gnu.org" <gcc@gcc.gnu.org>
Date: Thu, 02 Feb 2012 10:28:42 +0100
In-Reply-To: <A3E67C2071F49C4CBC4F17E6D77CDDD232754151@G4W3299.americas.hpqcorp.net>
References: <20120201151918.GC16714@quack.suse.cz>
	 <CA+55aFy55Q=+pFCZcS9cOM6SL+ZT3sNDB+c4qFvVqwwSpTqJ7g@mail.gmail.com>
	 <1328118174.15992.6206.camel@triegel.csb>
	 <CA+55aFw=z2SKFGoSE5e_0ZmKcAAjK5q0DBM4PaxBH2D9tuikzA@mail.gmail.com>
	 <A3E67C2071F49C4CBC4F17E6D77CDDD232754151@G4W3299.americas.hpqcorp.net>
Content-Type: text/plain; charset="UTF-8"
X-Mailer: Evolution 3.0.3 (3.0.3-1.fc15) 
Content-Transfer-Encoding: 7bit
Message-ID: <1328174924.12177.17.camel@thorin>
Mime-Version: 1.0
X-DCC-wuwien-Metrics: esgaroth.petrovitsch.priv.at; whitelist
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mit, 2012-02-01 at 21:04 +0000, Boehm, Hans wrote:
[...]
> The C11 memory model potentially adds overhead in only two cases:
> 
> 1. When current code involves touching a field that wouldn't otherwise
> be touched.  There are odd cases in which this measurably slows down
> code, but I think all agree that we need it.  In addition to
> bitfields, it can affect speculatively promoting a value to a register
> in a loop, which at least older versions of gcc also do.

Just adding an -f option for this and/or activating it only for -O5 (or
whatever the highest level is) and - in case that feature is activated -
emit warnings if bitfields (and/or any other data types that might be
affected)?

Kind regards,
	Bernd
-- 
Bernd Petrovitsch                  Email : bernd@petrovitsch.priv.at
                     LUGA : http://www.luga.at

