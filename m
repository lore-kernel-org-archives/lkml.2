Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754243Ab0CROoR (ORCPT <rfc822;w@1wt.eu>);
	Thu, 18 Mar 2010 10:44:17 -0400
Received: from mail-qy0-f200.google.com ([209.85.221.200]:38471 "EHLO
	mail-qy0-f200.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753724Ab0CROoP (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 18 Mar 2010 10:44:15 -0400
Message-ID: <4BA23C3A.7030308@codemonkey.ws>
Date: Thu, 18 Mar 2010 09:44:10 -0500
From: Anthony Liguori <anthony@codemonkey.ws>
User-Agent: Mozilla/5.0 (X11; U; Linux x86_64; en-US; rv:1.9.1.5) Gecko/20091209 Fedora/3.0-4.fc12 Lightning/1.0pre Thunderbird/3.0
MIME-Version: 1.0
To: Ingo Molnar <mingo@elte.hu>
CC: Avi Kivity <avi@redhat.com>,
       "Zhang, Yanmin" <yanmin_zhang@linux.intel.com>,
       Peter Zijlstra <a.p.zijlstra@chello.nl>,
       Sheng Yang <sheng@linux.intel.com>, linux-kernel@vger.kernel.org,
       kvm@vger.kernel.org, Marcelo Tosatti <mtosatti@redhat.com>,
       oerg Roedel <joro@8bytes.org>, Jes Sorensen <Jes.Sorensen@redhat.com>,
       Gleb Natapov <gleb@redhat.com>, Zachary Amsden <zamsden@redhat.com>,
       ziteng.huang@intel.com, Arnaldo Carvalho de Melo <acme@redhat.com>,
       Fr?d?ric Weisbecker <fweisbec@gmail.com>
Subject: Re: [RFC] Unify KVM kernel-space and user-space code into a single
 project
References: <20100316105021.GA14344@elte.hu> <4B9F671D.5060001@redhat.com> <20100316112500.GA5337@elte.hu> <4B9F77E7.2060101@redhat.com> <20100316122903.GA8831@elte.hu> <4B9F7C6A.3070207@redhat.com> <20100316130840.GA24808@elte.hu> <4B9FBA8B.8020200@codemonkey.ws> <20100316173940.GA23859@elte.hu> <4BA00F1F.1090907@codemonkey.ws> <20100317081041.GC16374@elte.hu>
In-Reply-To: <20100317081041.GC16374@elte.hu>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 03/17/2010 03:10 AM, Ingo Molnar wrote:
>   - move a clean (and minimal) version of the Qemu code base to tools/kvm/, in
>     the upstream kernel repo, and work on that from that point on.
>    

QEMU is about 600k LOC.  We have a mechanism to compile out portions of 
the code but a lot things are tied together in an intimate way.  In the 
long run, we're working on adding stronger interfaces such that we can 
split components out into libraries that are consumable by other 
applications.

Simplying forking the device model won't work.  Well more than half of 
our contributors are not coming from KVM developers/users.  If you just 
fork the device models, you start to lose a ton of fixes (look at Xen 
and VirtualBox).

So feel free to either 1) apply my previous patch and then start working 
on a "clean (and minimal)" QEMU or 2) wait to commit my previous patch 
and start sending patches to clean up QEMU.

Absolute none of this is going to give you a VirtualBox like GUI for QEMU.

Regards,

Anthony Liguori
