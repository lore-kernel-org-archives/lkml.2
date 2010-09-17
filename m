Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752280Ab0IQHci (ORCPT <rfc822;w@1wt.eu>);
	Fri, 17 Sep 2010 03:32:38 -0400
Received: from out2.smtp.messagingengine.com ([66.111.4.26]:37562 "EHLO
	out2.smtp.messagingengine.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1750742Ab0IQHch (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 17 Sep 2010 03:32:37 -0400
Message-Id: <1284708756.2702.1395472601@webmail.messagingengine.com>
X-Sasl-Enc: XhFwuwM0GYEXtvq18EJy3kCQmNHNFOHyXDegmg+wJN3P 1284708756
From: "Robert Mueller" <robm@fastmail.fm>
To: "Shaohua Li" <shaohua.li@intel.com>
Cc: "Christoph Lameter" <cl@linux.com>,
        "KOSAKI Motohiro" <kosaki.motohiro@jp.fujitsu.com>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "Bron Gondwana" <brong@fastmail.fm>, "linux-mm" <linux-mm@kvack.org>,
        "Mel Gorman" <mel@csn.ul.ie>
MIME-Version: 1.0
Content-Transfer-Encoding: 7bit
Content-Type: text/plain; charset="us-ascii"
X-Mailer: MessagingEngine.com Webmail Interface
In-Reply-To: <1284703264.3408.1.camel@sli10-conroe.sh.intel.com>
References: <1284349152.15254.1394658481@webmail.messagingengine.com>
 <20100916184240.3BC9.A69D9226@jp.fujitsu.com>
 <alpine.DEB.2.00.1009161153210.22849@router.home>
 <1284684653.10161.1395434085@webmail.messagingengine.com>
 <1284703264.3408.1.camel@sli10-conroe.sh.intel.com>
Reply-To: robm@fastmail.fm
Subject: Re: Default zone_reclaim_mode = 1 on NUMA kernel is bad for
 file/email/web servers
Date: Fri, 17 Sep 2010 17:32:36 +1000
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

> > I don't think this is any fault of how the software works. It's a
> > *very* standard "pre-fork child processes, allocate incoming
> > connections to a child process, open and mmap one or more files to
> > read data from them". That's not exactly a weird programming model,
> > and it's bad that the kernel is handling that case very badly with
> > everything default.
>
> maybe you incoming connection always happen on one CPU and you do the
> page allocation in that cpu, so some nodes use out of memory but
> others have a lot free. Try bind the child process to different nodes
> might help.

There's are 5000+ child processes (it's a cyrus IMAP server). Neither
the parent of any of the children are bound to any particular CPU. It
uses a standard fcntl lock to make sure only one spare child at a time
calls accept(). I don't think that's the problem.

Rob
