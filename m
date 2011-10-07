Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759913Ab1JGLSp (ORCPT <rfc822;w@1wt.eu>);
	Fri, 7 Oct 2011 07:18:45 -0400
Received: from casper.infradead.org ([85.118.1.10]:53838 "EHLO
	casper.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1759808Ab1JGLSo convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 7 Oct 2011 07:18:44 -0400
Subject: Re: [PATCH 07/12] perf_events: add LBR software filter support for
 Intel X86
From: Peter Zijlstra <peterz@infradead.org>
To: Stephane Eranian <eranian@google.com>
Cc: Andi Kleen <andi@firstfloor.org>, linux-kernel@vger.kernel.org,
        mingo@elte.hu, acme@redhat.com, ming.m.lin@intel.com,
        robert.richter@amd.com, ravitillo@lbl.gov
Date: Fri, 07 Oct 2011 13:18:26 +0200
In-Reply-To: <CABPqkBTxxS-vuAycDJO-aJNE4EpCLF8xyPtJ1Jzv26f15HJC8A@mail.gmail.com>
References: <1317912555-9559-1-git-send-email-eranian@google.com>
	 <1317912555-9559-8-git-send-email-eranian@google.com>
	 <20111006153229.GJ14482@one.firstfloor.org>
	 <CABPqkBSNejhZ_ciyLTUFAybBqqGB-8QzVrPj8OTbAhQ_+mj4aw@mail.gmail.com>
	 <CABPqkBReqBhFFKsLPfbzFHL7hs2hXSJ8tTZuP9D-2N2MGiB9Mw@mail.gmail.com>
	 <1317984122.31132.6.camel@twins>
	 <CABPqkBTxxS-vuAycDJO-aJNE4EpCLF8xyPtJ1Jzv26f15HJC8A@mail.gmail.com>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 8BIT
X-Mailer: Evolution 3.0.3- 
Message-ID: <1317986306.31132.10.camel@twins>
Mime-Version: 1.0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, 2011-10-07 at 12:49 +0200, Stephane Eranian wrote:
> > You could still fuzz it after the cpu passed through and before the
> > kernel reads the LBR. Its a narrow window, but quite feasible.
> >
> Yeah, depending on the depth of the LBR. But then what happens, you
> decode an instruction that is not what was executed. 

Right, and Andi's concern is that this might cause our instruction
decoder to blow up, or worse.

The whole false profile thing isn't really a problem, I mean, that's
what you get for poking at your own instruction stream.
