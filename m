Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753758Ab2K2NsH (ORCPT <rfc822;w@1wt.eu>);
	Thu, 29 Nov 2012 08:48:07 -0500
Received: from ud10.udmedia.de ([194.117.254.50]:37278 "EHLO
	mail.ud10.udmedia.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753039Ab2K2NsF (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 29 Nov 2012 08:48:05 -0500
Date: Thu, 29 Nov 2012 14:47:52 +0100
From: Markus Trippelsdorf <markus@trippelsdorf.de>
To: paulmck@linux.vnet.ibm.com
Cc: linux-kernel@vger.kernel.org
Subject: kernel/rcutree.c:2850:13: warning: array subscript is above array
 bounds
Message-ID: <20121129134752.GB219@x4>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

With gcc-4.8 I get:

  CC      kernel/rcutree.o
  kernel/rcutree.c: In function ‘rcu_init_one’:
  kernel/rcutree.c:2850:13: warning: array subscript is above array bounds [-Warray-bounds]
     rsp->level[i] = rsp->level[i - 1] + rsp->levelcnt[i - 1];
                  ^
2849    for (i = 1; i < rcu_num_lvls; i++)
2850           rsp->level[i] = rsp->level[i - 1] + rsp->levelcnt[i - 1];

At first I thought that the warning was bogus, but rcu_num_lvls isn't static
and gets modified prior to the for loop.

-- 
Markus
