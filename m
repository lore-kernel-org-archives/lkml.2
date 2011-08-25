Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753224Ab1HYPJC (ORCPT <rfc822;w@1wt.eu>);
	Thu, 25 Aug 2011 11:09:02 -0400
Received: from mail09.linbit.com ([212.69.161.110]:32912 "EHLO
	mail09.linbit.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752899Ab1HYPI7 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 25 Aug 2011 11:08:59 -0400
From: Philipp Reisner <philipp.reisner@linbit.com>
To: linux-kernel@vger.kernel.org, Jens Axboe <axboe@kernel.dk>
Cc: drbd-dev@lists.linbit.com
Subject: [RFC 000/118] drbd: part 1 of adding multiple volume support to drbd
Date: Thu, 25 Aug 2011 17:06:56 +0200
Message-Id: <1314284934-17999-1-git-send-email-philipp.reisner@linbit.com>
X-Mailer: git-send-email 1.7.4.1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This the first request for review of drbd-8.4. The complete set has 
500 patches. In this first series there are only 118 of these.

The most noticeable change is the support for multiple replicated volumes in
a single DRBD connection.  Write-ordering is obeyed among all writes in all
volumes in a single connection.  This feature is really important for users
who use DRBD for mirroring over longer distances. (Protocol A).

0001 - 0012  cleanups
0013 - 0026  replace the hash tables of drbd_requests with two interval trees
0027         have a look at the idr_for_each_entry(). Outside of drbd's directory.
0028 - 0035  introduced a new object which represents a DRBD connection;
             move a view members from the device object to the new conenction
             object
0036 - 0041  Introduce volume numbers into the protocol
0042 - 0052  cleanups; renames; 
0053         Improvements to handling of conflicting writes
0054 - 0060  cleanups; renames; 
0061 - 0064  code reorganisation
0065         IO latency bugfix
0066 - 0099  moving members from the device object to the connection object;
             converting function from the device object to the connection obj
0100 - 0118  work on the state engine to match the new object model
