Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1750833Ab0IEFBd (ORCPT <rfc822;w@1wt.eu>);
	Sun, 5 Sep 2010 01:01:33 -0400
Received: from out1.smtp.messagingengine.com ([66.111.4.25]:49558 "EHLO
	out1.smtp.messagingengine.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1750757Ab0IEFBc (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 5 Sep 2010 01:01:32 -0400
X-Sasl-enc: rH14QEp86yCVTebqVrR51G1PK6qOqYDPvP1SLzunF8NB 1283662891
Date: Sun, 5 Sep 2010 02:01:28 -0300
From: Henrique de Moraes Holschuh <hmh@hmh.eng.br>
To: linux-kernel <linux-kernel@vger.kernel.org>
Cc: Dmitry Adamushko <dmitry.adamushko@gmail.com>, Ingo Molnar <mingo@elte.hu>,
        Tigran Aivazian <tigran@aivazian.fsnet.co.uk>,
        Shaohua Li <shaohua.li@intel.com>, Simon Trimmer <simon@urbanmyth.org>
Subject: microcode_intel: how to test extended signature codepath?
Message-ID: <20100905050128.GA6922@khazad-dum.debian.net>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
X-GPG-Fingerprint: 1024D/1CDB0FE3 5422 5C61 F6B7 06FB 7E04  3738 EE25 DE3F
 1CDB 0FE3
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

I have noticed that there is no public Intel microcode file using the Intel
extended signature table.  This means there is some code in
microcode_intel.c that can't be easily field-tested.  In fact, for all I
know, it might never been tested at all or it has been left untested for
several years and could have bitrotted.

Does Intel have a different microcode file that has at least one extended
signature table we could use to test the kernel driver (and enhanced
userspace helpers)? Anyone knows how to obtain it?

I suppose I could create a hacked microcode file for testing purposes based
on the real microcode update entry for some processors and using some
impossible signatures so that the driver is forced to find the match though
the first, some middle, and the last extended signatures in the cooked up
table, but this is very sub-optimal for a large number of reasons, least of
all the fact that AFAIK I'd be forbidden to distribute it to anyone else
that needs to touch the code, and the fact that it would be as correct as my
understanding of the microcode datafile spec, which doesn't mean much.

Can anyone offer any help on this matter?

-- 
  "One disk to rule them all, One disk to find them. One disk to bring
  them all and in the darkness grind them. In the Land of Redmond
  where the shadows lie." -- The Silicon Valley Tarot
  Henrique Holschuh
