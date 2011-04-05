Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753150Ab1DENdm (ORCPT <rfc822;w@1wt.eu>);
	Tue, 5 Apr 2011 09:33:42 -0400
Received: from bombadil.infradead.org ([18.85.46.34]:39142 "EHLO
	bombadil.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752022Ab1DENdk convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 5 Apr 2011 09:33:40 -0400
Subject: Re: [patch 05/15] sched: unthrottle cfs_rq(s) who ran out of quota
 at period refresh
From: Peter Zijlstra <peterz@infradead.org>
To: Paul Turner <pjt@google.com>
Cc: linux-kernel@vger.kernel.org, Bharata B Rao <bharata@linux.vnet.ibm.com>,
        Dhaval Giani <dhaval.giani@gmail.com>,
        Balbir Singh <balbir@linux.vnet.ibm.com>,
        Vaidyanathan Srinivasan <svaidy@linux.vnet.ibm.com>,
        Srivatsa Vaddagiri <vatsa@in.ibm.com>,
        Kamalesh Babulal <kamalesh@linux.vnet.ibm.com>,
        Ingo Molnar <mingo@elte.hu>, Pavel Emelyanov <xemul@openvz.org>,
        Nikhil Rao <ncrao@google.com>
In-Reply-To: <1302010093.2225.1328.camel@twins>
References: <20110323030326.789836913@google.com>
	 <20110323030449.142198821@google.com>  <1302010093.2225.1328.camel@twins>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 8BIT
Date: Tue, 05 Apr 2011 15:33:29 +0200
Message-ID: <1302010409.2225.1337.camel@twins>
Mime-Version: 1.0
X-Mailer: Evolution 2.30.3 
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 2011-04-05 at 15:28 +0200, Peter Zijlstra wrote:
> There's something fishy there, it looks like ->runtime can end up being
> ->quota in case of overrun > 1, that shouldn't be possible, the
> refresh timer should never over-fill the bucket.

General confusion reigns after reading all those patches, but I think I
might have been wrong there.
