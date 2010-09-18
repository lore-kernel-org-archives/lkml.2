Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754445Ab0IRBmh (ORCPT <rfc822;w@1wt.eu>);
	Fri, 17 Sep 2010 21:42:37 -0400
Received: from out2.smtp.messagingengine.com ([66.111.4.26]:34686 "EHLO
	out2.smtp.messagingengine.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752179Ab0IRBmg (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 17 Sep 2010 21:42:36 -0400
X-Sasl-enc: DszX9PLrQsQWmUImrLFvNXLqi4y6BLz1VWqDlRzjU9GV 1284774155
Date: Fri, 17 Sep 2010 22:42:32 -0300
From: Henrique de Moraes Holschuh <hmh@hmh.eng.br>
To: "H. Peter Anvin" <hpa@linux.intel.com>
Cc: linux-kernel@vger.kernel.org, Greg Kroah-Hartman <gregkh@suse.de>
Subject: New compat_alloc_user_space() GPLness and fglrx
Message-ID: <20100918014232.GA17699@khazad-dum.debian.net>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
X-GPG-Fingerprint: 1024D/1CDB0FE3 5422 5C61 F6B7 06FB 7E04  3738 EE25 DE3F
 1CDB 0FE3
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

commit c41d68a513c71e35a14f66d71782d27a79a81ea6
compat: Make compat_alloc_user_space() incorporate the access_ok()

promotes compat_alloc_user_space() to EXPORT_SYMBOL_GPL, and moves it from
asm/compat.h to linux/compat.h.

This breaks AMD/ATI's proprietary fglrx GPU driver, which wants to use
compat_alloc_user_space(), and expects to find it in asm/compat.h.

Fixing this on the fglrx side is easy enough, one can simply audit the two
or three call sites in the fglrx glue and make sure they can use
arch_compat_alloc_user_space() safely.

But such a fix doesn't look right.  IMHO, either we don't want any non-GPL
module touching *_compat_alloc_user_space and compat_alloc_user_space, or it
would be better to let them use compat_alloc_user_space() in the interest of
overall security...

-- 
  "One disk to rule them all, One disk to find them. One disk to bring
  them all and in the darkness grind them. In the Land of Redmond
  where the shadows lie." -- The Silicon Valley Tarot
  Henrique Holschuh
