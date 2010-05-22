Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757834Ab0EVSIN (ORCPT <rfc822;w@1wt.eu>);
	Sat, 22 May 2010 14:08:13 -0400
Received: from smtp-01.mandic.com.br ([200.225.81.132]:34326 "EHLO
	smtp-01.mandic.com.br" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755931Ab0EVSIM (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 22 May 2010 14:08:12 -0400
Message-ID: <4BF81D87.6010506@cesarb.net>
Date: Sat, 22 May 2010 15:08:07 -0300
From: Cesar Eduardo Barros <cesarb@cesarb.net>
User-Agent: Mozilla/5.0 (X11; U; Linux x86_64; en-US; rv:1.9.1.9) Gecko/20100330 Fedora/3.0.4-1.fc12 Thunderbird/3.0.4
MIME-Version: 1.0
To: linux-mm@kvack.org
CC: linux-kernel@vger.kernel.org
Subject: [PATCH 0/3] mm: Swap checksum
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Add support for checksumming the swap pages written to disk, using the
same checksum as btrfs (crc32c). Since the contents of the swap do not
matter after a shutdown, the checksum is kept in memory only.

Note that this code does not checksum the software suspend image.

Cesar Eduardo Barros (3):
       mm/swapfile.c: better messages for swap_info_get
       kernel/power/swap.c: do not use end_swap_bio_read
       mm: Swap checksum

  include/linux/swap.h |   31 +++++++-
  kernel/power/swap.c  |   21 +++++-
  mm/Kconfig           |   22 +++++
  mm/Makefile          |    1 +
  mm/page_io.c         |   92 ++++++++++++++++++--
  mm/swapcsum.c        |   94 +++++++++++++++++++++
  mm/swapfile.c        |  186 ++++++++++++++++++++++++++++++++++++++++--
  7 files changed, 429 insertions(+), 18 deletions(-)
  create mode 100644 mm/swapcsum.c

-- 
Cesar Eduardo Barros
cesarb@cesarb.net
cesar.barros@gmail.com
