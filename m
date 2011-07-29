Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752403Ab1G2Ruu (ORCPT <rfc822;w@1wt.eu>);
	Fri, 29 Jul 2011 13:50:50 -0400
Received: from mail.vyatta.com ([76.74.103.46]:38969 "EHLO mail.vyatta.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752303Ab1G2Rus (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 29 Jul 2011 13:50:48 -0400
Date: Fri, 29 Jul 2011 10:50:58 -0700
From: Stephen Hemminger <shemminger@vyatta.com>
To: paulmck@linux.vnet.ibm.com
Cc: Michael Chan <mchan@broadcom.com>, linux-kernel@vger.kernel.org
Subject: RCU: how to suppress warnings from rcu_assign_pointer?
Message-ID: <20110729105058.2cb9fa86@nehalam.ftrdhcpuser.net>
In-Reply-To: <20110729003843.GA2373@linux.vnet.ibm.com>
References: <20110728142723.77a2c308@nehalam.ftrdhcpuser.net>
 <20110728214442.GV2403@linux.vnet.ibm.com>
 <20110728145510.0ec0db01@nehalam.ftrdhcpuser.net>
 <20110729003843.GA2373@linux.vnet.ibm.com>
Organization: Vyatta
X-Mailer: Claws Mail 3.7.9 (GTK+ 2.24.4; x86_64-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Gcc now generates warnings from rcu_assign_pointer when passed the
address of something for example:
	rcu_assign_pointer(dev_queue->qdisc, &noop_qdisc);
This warning is harmless and should be surpressed but there maybe
other cases where we want that Gcc warning.

I tried various combinations of in rcu_assign_pointer macro
  #pragma GCC diagnostic push
  #pragma GCC diagnostic ignored "-Wlogical-op"
  ...
  #pragma GCC diagnostic pop
but macro's and pragma's don't nest with the correct scope for
this.

Maybe some one with more Gcc foo and time to waste could take
a crack at it.


