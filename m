Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755311Ab0LOVHq (ORCPT <rfc822;w@1wt.eu>);
	Wed, 15 Dec 2010 16:07:46 -0500
Received: from mx1.redhat.com ([209.132.183.28]:9035 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751309Ab0LOVHn (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 15 Dec 2010 16:07:43 -0500
From: Vivek Goyal <vgoyal@redhat.com>
To: linux-kernel@vger.kernel.org, jaxboe@fusionio.com,
        paulmck@linux.vnet.ibm.com
Cc: vgoyal@redhat.com, oleg@redhat.com
Subject: [PATCH 0/2] blk-throttle: Couple of more fixes
Date: Wed, 15 Dec 2010 16:07:33 -0500
Message-Id: <1292447255-10698-1-git-send-email-vgoyal@redhat.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Jens,

Please find attached couple of more fixes for blk-throttle code. These are
based on top of "for-linus" branch of your block tree. 

Oleg had pointed out couple of race conditions in cgroup weight update code.
I think these race conditions are hard to hit and not disastrous so I would
not be too concerned about pushing these patches in 2.6.37 and can queue
up for 2.6.38.

Paul,

Based on discussion in other mail thread, I have used xchg() based
implementation for updating and processing limtis.  Can you please have a look
if it is correct implementation and do I need any ACCESS_ONCE() or barriers
somewhere. If this implementation is not correct then I can go back to atomic
variable based implementation as suggested by you in other mail thread.
Appreciate the help.

Thanks
Vivek

Vivek Goyal (2):
  blk-throttle: process limit change only through one function
  blk-throttle: Some cleanups and race fixes in limit update code

 block/blk-throttle.c |  104 ++++++++++++++++++++------------------------------
 1 files changed, 41 insertions(+), 63 deletions(-)

