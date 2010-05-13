Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758906Ab0EMNIX (ORCPT <rfc822;w@1wt.eu>);
	Thu, 13 May 2010 09:08:23 -0400
Received: from bombadil.infradead.org ([18.85.46.34]:59821 "EHLO
	bombadil.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1758858Ab0EMNIP convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 13 May 2010 09:08:15 -0400
Subject: Re: [PATCH RFC tip/core/rcu 23/23] vhost: add __rcu annotations
From: Peter Zijlstra <peterz@infradead.org>
To: paulmck@linux.vnet.ibm.com
Cc: "Michael S. Tsirkin" <mst@redhat.com>, linux-kernel@vger.kernel.org,
       mingo@elte.hu, laijs@cn.fujitsu.com, dipankar@in.ibm.com,
       akpm@linux-foundation.org, mathieu.desnoyers@polymtl.ca,
       josh@joshtriplett.org, dvhltc@us.ibm.com, niv@us.ibm.com,
       tglx@linutronix.de, rostedt@goodmis.org, Valdis.Kletnieks@vt.edu,
       dhowells@redhat.com, eric.dumazet@gmail.com,
       Arnd Bergmann <arnd@relay.de.ibm.com>, Arnd Bergmann <arnd@arndb.de>
In-Reply-To: <20100512230057.GH2303@linux.vnet.ibm.com>
References: <20100512213317.GA15085@linux.vnet.ibm.com>
	 <1273700022-16523-23-git-send-email-paulmck@linux.vnet.ibm.com>
	 <20100512214847.GD22930@redhat.com>
	 <20100512230057.GH2303@linux.vnet.ibm.com>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 8BIT
Date: Thu, 13 May 2010 15:07:23 +0200
Message-ID: <1273756043.5605.3542.camel@twins>
Mime-Version: 1.0
X-Mailer: Evolution 2.28.3 
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 2010-05-12 at 16:00 -0700, Paul E. McKenney wrote:
> Any thoughts?  One approach would be to create a separate lockdep class
> for vhost workqueue state, similar to the approach used in instrument
> rcu_read_lock() and friends. 

workqueue_struct::lockdep_map, its held while executing worklets.

lock_is_held(&vhost_workqueue->lockdep_map), should do as you want.
