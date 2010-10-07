Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933107Ab0JGOCS (ORCPT <rfc822;w@1wt.eu>);
	Thu, 7 Oct 2010 10:02:18 -0400
Received: from terminus.zytor.com ([198.137.202.10]:59049 "EHLO mail.zytor.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754540Ab0JGOCR (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 7 Oct 2010 10:02:17 -0400
Message-ID: <4CADD257.7080203@zytor.com>
Date: Thu, 07 Oct 2010 06:59:51 -0700
From: "H. Peter Anvin" <hpa@zytor.com>
User-Agent: Mozilla/5.0 (X11; U; Linux x86_64; en-US; rv:1.9.2.9) Gecko/20100921 Fedora/3.1.4-1.fc13 Thunderbird/3.1.4
MIME-Version: 1.0
To: Stephane Eranian <eranian@google.com>
CC: mingo@elte.hu, Hans.Rosenfeld@amd.com, robert.richter@amd.com,
        tglx@linutronix.de, linux-kernel@vger.kernel.org,
        Andreas.Herrmann3@amd.com, peterz@infradead.org, fweisbec@gmail.com,
        rostedt@goodmis.org, acme@redhat.com,
        Peter Zijlstra <a.p.zijlstra@chello.nl>, eranian@gmail.com
Subject: Re: [RFC 0/3] Basic support for LWP
References: <1286212172-654419-1-git-send-email-hans.rosenfeld@amd.com>	<alpine.LFD.2.00.1010042358520.2556@localhost6.localdomain6>	<20101005145155.GD173@escobedo.osrc.amd.com>	<alpine.LFD.2.00.1010051730060.2556@localhost6.localdomain6>	<20101005182739.GE173@escobedo.osrc.amd.com>	<20101005190501.GA21916@elte.hu>	<20101006073558.GJ13563@erda.amd.com>	<AANLkTi=T0QmcKeZcgcR+GKk-9OwQUB_x8XdHiNuU7tE_@mail.gmail.com> <AANLkTimwVuosF24_gBOTpMydfcj-SQPFyZM4uu=vEPbL@mail.gmail.com>
In-Reply-To: <AANLkTimwVuosF24_gBOTpMydfcj-SQPFyZM4uu=vEPbL@mail.gmail.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 10/07/2010 03:46 AM, Stephane Eranian wrote:
> 
> As for the patch itself, I am not an expert at xsave/xrstor, but it seems to
> me you could decouple LWP from FPU. I think  Brian had the same comment.
> I suspect this can be done and it will certainly look cleaner.
> 

Well, once you're using XSAVE you're not decoupled from the FPU.  Worse,
if you're using XSAVE and not honoring CR0.TS you have a major design flaw.

Nothing that can't be dealt with, but still...

-- 
H. Peter Anvin, Intel Open Source Technology Center
I work for Intel.  I don't speak on their behalf.

