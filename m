Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753178Ab0G3PqV (ORCPT <rfc822;w@1wt.eu>);
	Fri, 30 Jul 2010 11:46:21 -0400
Received: from e4.ny.us.ibm.com ([32.97.182.144]:44634 "EHLO e4.ny.us.ibm.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752022Ab0G3PqQ (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 30 Jul 2010 11:46:16 -0400
Subject: Re: [RFC PATCH v8 00/16] Provide a zero-copy method on KVM
 virtio-net.
From: Shirley Ma <mashirle@us.ibm.com>
To: Avi Kivity <avi@redhat.com>
Cc: xiaohui.xin@intel.com, netdev@vger.kernel.org, kvm@vger.kernel.org,
        linux-kernel@vger.kernel.org, mst@redhat.com, mingo@elte.hu,
        davem@davemloft.net, herbert@gondor.hengli.com.au,
        jdike@linux.intel.com
In-Reply-To: <4C525CD2.5080604@redhat.com>
References: <1280402088-5849-1-git-send-email-xiaohui.xin@intel.com>
	 <1280442682.9058.15.camel@localhost.localdomain>
	 <4C525CD2.5080604@redhat.com>
Content-Type: text/plain; charset="UTF-8"
Date: Fri, 30 Jul 2010 08:46:11 -0700
Message-ID: <1280504771.9058.25.camel@localhost.localdomain>
Mime-Version: 1.0
X-Mailer: Evolution 2.28.3 (2.28.3-1.fc12) 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hello Avi,

On Fri, 2010-07-30 at 08:02 +0300, Avi Kivity wrote:
> get_user_pages() is indeed slow.  But what about
> get_user_pages_fast()?
> 
> Note that when the page is first touched, get_user_pages_fast() falls 
> back to get_user_pages(), so the latency needs to be measured after 
> quite a bit of warm-up. 

Yes, I used get_user_pages_fast, however if falled back to
get_user_pages() when the apps doesn't allocate buffer on the same page.
If I run a single ping, the RTT is extremely high, but when running
multiple pings, the RTT time reduce significantly, but still it is not
as fast as copy from my initial test. I am thinking that we might need
to pre-pin memory pool.

Shirley

