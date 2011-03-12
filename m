Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753691Ab1CLCaY (ORCPT <rfc822;w@1wt.eu>);
	Fri, 11 Mar 2011 21:30:24 -0500
Received: from out5.smtp.messagingengine.com ([66.111.4.29]:37453 "EHLO
	out5.smtp.messagingengine.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1753501Ab1CLCaV (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 11 Mar 2011 21:30:21 -0500
X-Sasl-enc: uBjIo6t1j9nmorAtnWpwbgmIGN5uvaHMHC+CFUMvZprx 1299897012
Date: Fri, 11 Mar 2011 23:30:02 -0300
From: Henrique de Moraes Holschuh <hmh@hmh.eng.br>
To: Burt Triplett <burt@pbjtriplett.org>
Cc: linux-kernel@vger.kernel.org
Subject: BITS handling of CPU microcode updates
Message-ID: <20110312023001.GB27550@khazad-dum.debian.net>
References: <4D65EE74.1050709@pbjtriplett.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <4D65EE74.1050709@pbjtriplett.org>
X-GPG-Fingerprint: 1024D/1CDB0FE3 5422 5C61 F6B7 06FB 7E04  3738 EE25 DE3F
 1CDB 0FE3
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Burt,

The BITS handling of Intel CPU microcode updates does not match either the
official documentation I cold find, or the Linux kernel code.

The documentation clearly states that microcode revision levels are a
*signed* 32-bit number, and that implies it should be subject to signed
comparisons.

The Linux kernel code considers it an unsigned 32-bit number, and does an
unsigned comparison (this is likely a bug).

And the BITS code mentions something called a "BWG", and will always install
a microcode with a revision < 0, it will never install a microcode with a
revision of zero, and does a normal version comparison if the revision is
greater than zero.

AFAIK, just like extended signatures (which are yet to be seen in the wild),
microcoes with negative or zero revision levels have never been published to
operating system vendors, so those discrepancies have had, so far, no impact
in the field.  But they could well be latent bugs.

Can you please clarify what is the correct behaviour ?

-- 
  "One disk to rule them all, One disk to find them. One disk to bring
  them all and in the darkness grind them. In the Land of Redmond
  where the shadows lie." -- The Silicon Valley Tarot
  Henrique Holschuh
