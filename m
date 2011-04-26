Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754890Ab1DZMid (ORCPT <rfc822;w@1wt.eu>);
	Tue, 26 Apr 2011 08:38:33 -0400
Received: from mx1.redhat.com ([209.132.183.28]:52482 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752694Ab1DZMic (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 26 Apr 2011 08:38:32 -0400
Date: Tue, 26 Apr 2011 15:38:24 +0300
From: Gleb Natapov <gleb@redhat.com>
To: "Paul E. McKenney" <paulmck@linux.vnet.ibm.com>
Cc: avi@redhat.com, kvm@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: RCU+KVM: making CPU guest mode a quiescent state.
Message-ID: <20110426123824.GD22443@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hello Paul,

I have a question about RCU + KVM. KVM does not hold any references to RCU
protected data when it switches CPU into a guest mode. In fact switching
to a guest mode is very similar to exiting to userspase from RCU point
of view. In addition CPU may stay in a guest mode for quite a long time
(up to one time slice). It looks like it will be beneficial to treat guest
mode as quiescent state, just like user-mode execution. How can this be
done? I was trying to find how RCU knows about cpu entering user-mode,
but it seems that it does this by checking CPU mode in a timer interrupt
(update_process_times()->rcu_check_callbacks()). This will not work for
guest mode detection since timer interrupt will kick CPU out of a guest
mode and timer interrupt will always see CPU in kernel mode. Do we have
a simple function to call to notify RCU that CPU passed quiescent state
which we can call just before entering guest?

--
			Gleb.
