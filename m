Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754773Ab2BEEVN (ORCPT <rfc822;w@1wt.eu>);
	Sat, 4 Feb 2012 23:21:13 -0500
Received: from mail-bk0-f46.google.com ([209.85.214.46]:63006 "EHLO
	mail-bk0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754131Ab2BEEVM (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 4 Feb 2012 23:21:12 -0500
MIME-Version: 1.0
From: Dongsheng Song <dongsheng.song@gmail.com>
Date: Sun, 5 Feb 2012 12:20:51 +0800
Message-ID: <CAE8XmWo6vyL69hA+sHUygit7x3DF2yHUNttCM9iSuRq=TWGx0A@mail.gmail.com>
Subject: High 'Creating block layer request' or '[sleep_on_page] ' latency
To: linux-kernel@vger.kernel.org
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi all,

I have observed many high 'Creating block layer request' or
'[sleep_on_page] ' latency on Linux 3.2.4 and btrfs.

Cause                           Maximum          Percentage
synchronous write               14590.0 msec          5.9 %
[btrfs_pin_log_trans]           12743.8 msec          7.8 %
[lock_rename]                    2624.6 msec          1.1 %
Creating a file                  1835.7 msec          3.2 %
Creating block layer request     1835.2 msec         53.8 %
Reading directory content        1674.0 msec          4.8 %
[sleep_on_page]                  1661.9 msec         21.0 %
Reading from file                1626.9 msec          2.2 %
Opening file                      118.7 msec          0.2 %

Cause                           Maximum         Percentage
Creating block layer request    3716.4 msec         55.1 %
[sleep_on_page]                  606.5 msec         27.7 %
Reading from file                571.9 msec          4.4 %
Page fault                       550.8 msec          6.8 %
Pagecache sync readahead         108.3 msec          0.2 %
synchronous write                103.0 msec          0.8 %
Creating a file                   88.3 msec          3.1 %
[btrfs_tree_lock]                 58.2 msec          0.1 %
[btrfs_pin_log_trans]             33.8 msec          0.1 %

Is there something wrong ?

Regards,
Dongsheng
