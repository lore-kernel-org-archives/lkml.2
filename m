Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752586Ab1GUJTh (ORCPT <rfc822;w@1wt.eu>);
	Thu, 21 Jul 2011 05:19:37 -0400
Received: from acheron.ifi.lmu.de ([129.187.214.135]:60119 "EHLO
	acheron.ifi.lmu.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752378Ab1GUJTe (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 21 Jul 2011 05:19:34 -0400
From: Michael Brade <brade@informatik.uni-muenchen.de>
To: linux-kernel@vger.kernel.org
Subject: 2.6.39, 3.0.0-rc7+: complete system freeze with rsync on big directory
Date: Thu, 21 Jul 2011 11:19:15 +0200
User-Agent: KMail/1.9.10 (enterprise35 0.20100827.1168748)
Organization: =?iso-8859-1?q?Ludwig-Maximilians-Universit=E4t?= =?iso-8859-1?q?_M=FCnchen?=
MIME-Version: 1.0
Content-Type: Text/Plain;
  charset="us-ascii"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <201107211119.15496.brade@informatik.uni-muenchen.de>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi,

this is perfectly reproducible: with vanilla 2.6.39.x and 3.0.0 from 
yesterday's git my system completely freezes after a minute or so when I do

   rsync -cavSH -n /source/ /dest/

Watching htop, it freezes only after the caches are full but not immediately 
when the caches are full. No Alt-SysRq-magic is working anymore, nothing 
responds at all after the freeze. This is on tty1, no X server running.

Note the -n which means dry run. I also mounted both directories read-only, so 
it's not the write commands. I am using XFS on both directories, one is 
mounted with iscsi, the other is local and encrypted with loop-aes. The 
directory size is >20 GB, 4000-6000 files. I first noticed it when a 
cp -a /source /dest froze the system.

When I go back to 2.6.37.6 it works fine. I didn't try 2.6.38 yet.

I am running this on a Dell Vostro, amd64, 6 GB RAM, 8x Intel Core i7 CPU Q 
740 @ 1.73GHz.

Any ideas how to debug this despite the freeze? Do you need my kernel config? 
Do you need any other info? Please CC me.

thanks,
   Michael

