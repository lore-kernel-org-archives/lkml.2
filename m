Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754091Ab1A0Kbi (ORCPT <rfc822;w@1wt.eu>);
	Thu, 27 Jan 2011 05:31:38 -0500
Received: from bombadil.infradead.org ([18.85.46.34]:54785 "EHLO
	bombadil.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753872Ab1A0Kbh convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 27 Jan 2011 05:31:37 -0500
Subject: Re: Q: perf_install_in_context/perf_event_enable are racy?
From: Peter Zijlstra <peterz@infradead.org>
To: Oleg Nesterov <oleg@redhat.com>
Cc: Frederic Weisbecker <fweisbec@gmail.com>, Ingo Molnar <mingo@elte.hu>,
        Alan Stern <stern@rowland.harvard.edu>,
        Arnaldo Carvalho de Melo <acme@redhat.com>,
        Paul Mackerras <paulus@samba.org>, Prasad <prasad@linux.vnet.ibm.com>,
        Roland McGrath <roland@redhat.com>, linux-kernel@vger.kernel.org
In-Reply-To: <20110126213317.GA7403@redhat.com>
References: <1295617185.28776.273.camel@laptop>
	 <20110121142616.GA31165@redhat.com> <1295622304.28776.293.camel@laptop>
	 <20110121204014.GA2870@nowhere> <20110124114234.GA12166@redhat.com>
	 <20110126175322.GA28617@redhat.com> <20110126184957.GA32578@redhat.com>
	 <1296068731.15234.6.camel@laptop> <1296070383.15234.10.camel@laptop>
	 <20110126211931.GA6778@redhat.com>  <20110126213317.GA7403@redhat.com>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 8BIT
Date: Thu, 27 Jan 2011 11:32:17 +0100
Message-ID: <1296124337.15234.71.camel@laptop>
Mime-Version: 1.0
X-Mailer: Evolution 2.30.3 
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 2011-01-26 at 22:33 +0100, Oleg Nesterov wrote:
> 
> This is what I had in mind initially but I didn't dare to add the
> new member into rq, it is only needed for perf. 

Right, but its a weakness in the task_oncpu_function_call()
implementation, wouldn't any user run into this problem eventually?
