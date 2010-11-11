Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753987Ab0KKPiu (ORCPT <rfc822;w@1wt.eu>);
	Thu, 11 Nov 2010 10:38:50 -0500
Received: from canuck.infradead.org ([134.117.69.58]:42395 "EHLO
	canuck.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751233Ab0KKPiu convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 11 Nov 2010 10:38:50 -0500
Subject: Re: [PATCH 03/20] x86, mce: Add persistent MCE event
From: Peter Zijlstra <peterz@infradead.org>
To: Borislav Petkov <bp@amd64.org>
Cc: Ingo Molnar <mingo@elte.hu>, Ben Gamari <bgamari@gmail.com>,
        "acme@infradead.org" <acme@infradead.org>,
        "fweisbec@gmail.com" <fweisbec@gmail.com>,
        "rostedt@goodmis.org" <rostedt@goodmis.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
In-Reply-To: <20101111133442.GA21803@aftab>
References: <1288885016-18295-1-git-send-email-bp@amd64.org>
	 <1288885016-18295-4-git-send-email-bp@amd64.org> <87lj50vq0s.fsf@gmail.com>
	 <20101110222157.GA23945@elte.hu> <20101111061725.GA19321@aftab>
	 <20101111085825.GB18789@elte.hu>  <20101111133442.GA21803@aftab>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 8BIT
Date: Thu, 11 Nov 2010 16:38:50 +0100
Message-ID: <1289489930.2084.138.camel@laptop>
Mime-Version: 1.0
X-Mailer: Evolution 2.30.3 
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 2010-11-11 at 14:34 +0100, Borislav Petkov wrote:
> 3) enable the persistent event and stash its fd in some /sysfs member
> which the RAS daemon reads out and mmaps. This last one actually sounds
> pretty neat. 

Right, stashing the thing in sysfs, which you can open()+mmap() seems
the best way. Not sure you want to make it a RAS specific place, maybe a
generic persistent buffer place.

You'll get multiple files anyway, one per cpu, so maybe something like:

/sysfs/persistent_buffer/ras[0..n]


