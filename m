Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757302Ab0GMVuE (ORCPT <rfc822;w@1wt.eu>);
	Tue, 13 Jul 2010 17:50:04 -0400
Received: from rtp-iport-1.cisco.com ([64.102.122.148]:30443 "EHLO
	rtp-iport-1.cisco.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753209Ab0GMVuA (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 13 Jul 2010 17:50:00 -0400
X-Greylist: delayed 579 seconds by postgrey-1.27 at vger.kernel.org; Tue, 13 Jul 2010 17:50:00 EDT
Authentication-Results: rtp-iport-1.cisco.com; dkim=neutral (message not signed) header.i=none
X-IronPort-Anti-Spam-Filtered: true
X-IronPort-Anti-Spam-Result: AvsEAId6PExAZnwM/2dsb2JhbACfYXGlTJpMhScEg32EUA
X-IronPort-AV: E=Sophos;i="4.55,198,1278288000"; 
   d="scan'208";a="131993305"
Message-ID: <4C3CDDD4.6010009@cisco.com>
Date: Tue, 13 Jul 2010 15:42:44 -0600
From: "David S. Ahern" <daahern@cisco.com>
User-Agent: Mozilla/5.0 (X11; U; Linux x86_64; en-US; rv:1.9.1.10) Gecko/20100621 Fedora/3.0.5-1.fc13 Lightning/1.0b2pre Thunderbird/3.0.5
MIME-Version: 1.0
To: Zachary Amsden <zamsden@redhat.com>
CC: Marcelo Tosatti <mtosatti@redhat.com>, KVM <kvm@vger.kernel.org>,
        Avi Kivity <avi@redhat.com>, Glauber Costa <glommer@redhat.com>,
        Linux-kernel <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH 09/18] Robust TSC compensation
References: <1278987938-23873-1-git-send-email-zamsden@redhat.com> <1278987938-23873-10-git-send-email-zamsden@redhat.com> <20100713203418.GA903@amt.cnet> <4C3CD77B.9050108@redhat.com>
In-Reply-To: <4C3CD77B.9050108@redhat.com>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org



On 07/13/10 15:15, Zachary Amsden wrote:

>> What prevents a vcpu from seeing its TSC go backwards, in case the first
>> write in the 5 second window is smaller than the victim vcpu's last
>> visible TSC value ?
>>    
> 
> Nothing, unfortunately.  However, the TSC would already have to be out
> of sync in order for the problem to occur.  It can never happen in
> normal circumstances on a stable hardware TSC except in one case;
> migration.  During the CPU state transfer phase of migration, however,

What about across processor sockets? Aren't CPUs brought up at different
points such that their TSCs start at different times?

David

