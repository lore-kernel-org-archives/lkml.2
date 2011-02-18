Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756778Ab1BRIli (ORCPT <rfc822;w@1wt.eu>);
	Fri, 18 Feb 2011 03:41:38 -0500
Received: from mail-fx0-f46.google.com ([209.85.161.46]:58751 "EHLO
	mail-fx0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753393Ab1BRIlf (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 18 Feb 2011 03:41:35 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=subject:from:to:cc:in-reply-to:references:content-type:date
         :message-id:mime-version:x-mailer:content-transfer-encoding;
        b=V2NWxZLaK/IuNx709TmsYkCArXaofluP24IOd0j1swm2n4K3yLgywKxfOl0g1deS25
         m9dpzqCmNzVcSALeLM/MrygxjCqqU+ROFOwUvBJmVWY8CMj6OtWaTgsCyzhuGodOUgsP
         88O9/cpLlsULrnN9zh+7RfqWjablxSbhI3pO4=
Subject: Re: BUG: Bad page map in process udevd (anon_vma: (null)) in
 2.6.38-rc4
From: Eric Dumazet <eric.dumazet@gmail.com>
To: "Eric W. Biederman" <ebiederm@xmission.com>,
        Linus Torvalds <torvalds@linux-foundation.org>
Cc: Octavian Purdila <opurdila@ixiacom.com>,
        David Miller <davem@davemloft.net>, Ingo Molnar <mingo@elte.hu>,
        Michal Hocko <mhocko@suse.cz>, linux-mm@kvack.org,
        LKML <linux-kernel@vger.kernel.org>
In-Reply-To: <m17hcx7wca.fsf@fess.ebiederm.org>
References: <20110216185234.GA11636@tiehlicka.suse.cz>
	 <20110216193700.GA6377@elte.hu>
	 <AANLkTinDxxbVjrUViCs=UaMD9Wg9PR7b0ShNud5zKE3w@mail.gmail.com>
	 <AANLkTi=xnbcs5BKj3cNE_aLtBO7W5m+2uaUacu7M8g_S@mail.gmail.com>
	 <20110217090910.GA3781@tiehlicka.suse.cz>
	 <AANLkTikPKpNHxDQAYBd3fiQsmVozLtCVDsNn=+eF_q2r@mail.gmail.com>
	 <20110217163531.GF14168@elte.hu> <m1pqqqfpzh.fsf@fess.ebiederm.org>
	 <AANLkTinB=EgDGNv-v-qD-MvHVAmstfP_CyyLNhhotkZx@mail.gmail.com>
	 <m1sjvm822m.fsf@fess.ebiederm.org>
	 <AANLkTimzP0UNRXutkt1zJ+OGhmeg6ga87HFyMuZQmpMj@mail.gmail.com>
	 <m17hcx7wca.fsf@fess.ebiederm.org>
Content-Type: text/plain; charset="UTF-8"
Date: Fri, 18 Feb 2011 09:41:25 +0100
Message-ID: <1298018485.2595.44.camel@edumazet-laptop>
Mime-Version: 1.0
X-Mailer: Evolution 2.30.3 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

So I confirm previous kernels had a bug too in rollback_registered()

The "single" list was left as is before exiting.

default_device_exit_batch() seems OK, because the rtnl_unlock() acted as
a barrier in this respect : devices were removed from dev_kill_list
before exiting default_device_exit_batch()

Following this mail, please find two patches.

One from Linus to address bug introduced in commit 443457242beb6
(net: factorize
sync-rcu call in unregister_netdevice_many) in 2.6.38-rc1

A second one to address old bugs, so that stable teams can fix previous
kernels (2.6.33 and up)
Offending commit was 9b5e383c11b08784 (net: Introduce
unregister_netdevice_many())

Of course this second patch is also needed for current linux-2.6

Thanks


