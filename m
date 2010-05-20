Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755359Ab0ETW0K (ORCPT <rfc822;w@1wt.eu>);
	Thu, 20 May 2010 18:26:10 -0400
Received: from ogre.sisk.pl ([217.79.144.158]:53303 "EHLO ogre.sisk.pl"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754808Ab0ETW0G (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 20 May 2010 18:26:06 -0400
From: "Rafael J. Wysocki" <rjw@sisk.pl>
To: Tejun Heo <tj@kernel.org>
Subject: Re: [PATCH 1/8] PM: Add suspend block api.
Date: Fri, 21 May 2010 00:27:31 +0200
User-Agent: KMail/1.12.4 (Linux/2.6.34-rjw; KDE/4.3.5; x86_64; ; )
Cc: Oleg Nesterov <oleg@redhat.com>,
       Arve =?iso-8859-1?q?Hj=F8nnev=E5g?= <arve@android.com>,
       linux-pm@lists.linux-foundation.org, linux-kernel@vger.kernel.org,
       Alan Stern <stern@rowland.harvard.edu>, Len Brown <len.brown@intel.com>,
       Pavel Machek <pavel@ucw.cz>, Randy Dunlap <rdunlap@xenotime.net>,
       Jesse Barnes <jbarnes@virtuousgeek.org>, Magnus Damm <damm@igel.co.jp>,
       Nigel Cunningham <nigel@tuxonice.net>,
       Cornelia Huck <cornelia.huck@de.ibm.com>,
       Ming Lei <tom.leiming@gmail.com>, Wu Fengguang <fengguang.wu@intel.com>,
       Andrew Morton <akpm@linux-foundation.org>,
       Maxim Levitsky <maximlevitsky@gmail.com>, linux-doc@vger.kernel.org
References: <1272429119-12103-1-git-send-email-arve@android.com> <20100430172618.GA9043@redhat.com> <4BF4F31D.8070900@kernel.org>
In-Reply-To: <4BF4F31D.8070900@kernel.org>
MIME-Version: 1.0
Content-Type: Text/Plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Message-Id: <201005210027.31910.rjw@sisk.pl>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thursday 20 May 2010, Tejun Heo wrote:
> Hello,
> 
> (sorry about late reply)
> 
> On 04/30/2010 07:26 PM, Oleg Nesterov wrote:
> > Currently _cpu_down() can't flush and/or stop the frozen cwq->thread.
> > 
> > IIRC this is fixable, but needs the nasty complications. We should
> > thaw + stop the frozen cwq->thread, then move the pending works to
> > another CPU.
> 
> Oh, this isn't an issue w/ cmwq.  While frozen all new works are
> collected into per-cpu delayed worklist and while frozen trustee in
> charge of the cpu will keep waiting.  Once thawed, trustee will
> execute all works including the delayed ones unbound to any cpu.

So, does it require any intrusive changes to make it possible to create
multithread freezable workqueues?

Rafael
