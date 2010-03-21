Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753020Ab0CUN1R (ORCPT <rfc822;w@1wt.eu>);
	Sun, 21 Mar 2010 09:27:17 -0400
Received: from relay02.digicable.hu ([92.249.128.188]:46130 "EHLO
	relay02.digicable.hu" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751900Ab0CUN1P (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 21 Mar 2010 09:27:15 -0400
Date: Sun, 21 Mar 2010 14:27:10 +0100
From: Gabor Gombas <gombasg@digikabel.hu>
To: Ingo Molnar <mingo@elte.hu>
Cc: Anthony Liguori <anthony@codemonkey.ws>, Avi Kivity <avi@redhat.com>,
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
Message-ID: <20100321132709.GA7962@twister.home>
Mail-Followup-To: Ingo Molnar <mingo@elte.hu>,
	Anthony Liguori <anthony@codemonkey.ws>,
	Avi Kivity <avi@redhat.com>,
	"Zhang, Yanmin" <yanmin_zhang@linux.intel.com>,
	Peter Zijlstra <a.p.zijlstra@chello.nl>,
	Sheng Yang <sheng@linux.intel.com>, linux-kernel@vger.kernel.org,
	kvm@vger.kernel.org, Marcelo Tosatti <mtosatti@redhat.com>,
	oerg Roedel <joro@8bytes.org>,
	Jes Sorensen <Jes.Sorensen@redhat.com>,
	Gleb Natapov <gleb@redhat.com>, Zachary Amsden <zamsden@redhat.com>,
	ziteng.huang@intel.com, Arnaldo Carvalho de Melo <acme@redhat.com>,
	Fr?d?ric Weisbecker <fweisbec@gmail.com>
References: <4BA00F1F.1090907@codemonkey.ws>
 <20100317081041.GC16374@elte.hu>
 <4BA1E24B.6090904@redhat.com>
 <20100318085607.GB2157@elte.hu>
 <4BA1FC80.2000401@redhat.com>
 <20100318105013.GB24464@elte.hu>
 <4BA20EB8.60707@redhat.com>
 <20100318114821.GB13168@elte.hu>
 <4BA23E61.4080003@codemonkey.ws>
 <20100318161310.GA447@elte.hu>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20100318161310.GA447@elte.hu>
X-Copyright: Forwarding or publishing without permission is prohibited.
X-Original: 94.21.185.220
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Mar 18, 2010 at 05:13:10PM +0100, Ingo Molnar wrote:

> > Why does Linux AIO still suck?  Why do we not have a proper interface in 
> > userspace for doing asynchronous file system operations?
> 
> Good that you mention it, i think it's an excellent example.
> 
> The suckage of kernel async IO is for similar reasons: there's an ugly package 
> separation problem between the kernel and between glibc - and between the apps 
> that would make use of it.

No, kernel async IO sucks because it still does not play well with
buffered I/O. Last time I checked (about a year ago or so), AIO syscall
latencies were much worse when buffered I/O was used compared to direct
I/O. Unfortunately, to achieve good performance with direct I/O, you
need a HW RAID card with lots of on-board cache.

Gabor
