Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754963Ab1DOAtm (ORCPT <rfc822;w@1wt.eu>);
	Thu, 14 Apr 2011 20:49:42 -0400
Received: from ironport2-out.teksavvy.com ([206.248.154.181]:26608 "EHLO
	ironport2-out.pppoe.ca" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1754871Ab1DOAtj (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 14 Apr 2011 20:49:39 -0400
X-IronPort-Anti-Spam-Filtered: true
X-IronPort-Anti-Spam-Result: ApIBAOGVp01Ld/sX/2dsb2JhbAAMhEPVLJE+gSmDTXgElB8
X-IronPort-AV: E=Sophos;i="4.64,214,1301889600"; 
   d="scan'208";a="106469766"
Message-ID: <4DA79621.5050904@teksavvy.com>
Date: Thu, 14 Apr 2011 20:49:37 -0400
From: Mark Lord <kernel@teksavvy.com>
User-Agent: Mozilla/5.0 (X11; U; Linux i686; en-GB; rv:1.9.2.15) Gecko/20110303 Thunderbird/3.1.9
MIME-Version: 1.0
To: Linus Torvalds <torvalds@linux-foundation.org>
CC: Milton Miller <miltonm@bga.com>, Nick Piggin <npiggin@kernel.dk>,
        Alexander Viro <viro@zeniv.linux.org.uk>,
        Dipankar Sarma <dipankar@in.ibm.com>,
        "Paul E. McKenney" <paulmck@linux.vnet.ibm.com>,
        linux-fsdevel@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH] fs: synchronize_rcu when unregister_filesystem success
 not failure
References: <4DA48AF4.5080803@teksavvy.com> <20110413004938.GE3682@thunk.org> <4DA5ADA6.5060301@teksavvy.com> <5A35771F-49B6-491E-B012-DBE68907E382@mit.edu> <ext4-masq@mdm.bga.com> <fs-unreg-rcu@mdm.bga.com> <BANLkTi=Tt8HRmqODM_qPAbGMeQ9UvVDXfA@mail.gmail.com>
In-Reply-To: <BANLkTi=Tt8HRmqODM_qPAbGMeQ9UvVDXfA@mail.gmail.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 11-04-14 11:52 AM, Linus Torvalds wrote:
> On Thu, Apr 14, 2011 at 8:41 AM, Milton Miller <miltonm@bga.com> wrote:
>>
>> While checking unregister_filesystem for saftey vs extra calls for
>> "ext4: register ext2 and ext3 alias after ext4" I realized that
>> the synchronize_rcu() was called on the error path but not on
>> the success path.
> 
> Good catch.
> 
> I think this is the bug that then caused us to do commit d863b50ab013
> ("vfs: call rcu_barrier after ->kill_sb()")
> 
> That said, that commit says that "synchronize_rcu()" isn't enough, and
> uses rcu_barrier().
> 
> Which _should_ mean that there are no actual users that care about RCU
> events by the time you actually hit "unregister_filesystem()".

Is that true of older kernels?  (eg. 2.6.38 has the same bug)

IOW, is this a -stable candidate?
