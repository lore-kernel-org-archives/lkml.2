Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932256Ab2IXUIP (ORCPT <rfc822;w@1wt.eu>);
	Mon, 24 Sep 2012 16:08:15 -0400
Received: from mail-pa0-f46.google.com ([209.85.220.46]:36814 "EHLO
	mail-pa0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932180Ab2IXUIO (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 24 Sep 2012 16:08:14 -0400
Date: Mon, 24 Sep 2012 13:08:09 -0700
From: Tejun Heo <tj@kernel.org>
To: Deepawali Verma <dverma249@gmail.com>
Cc: Chinmay V S <cvs268@gmail.com>, Daniel Taylor <Daniel.Taylor@wdc.com>,
        anish singh <anish198519851985@gmail.com>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Subject: Re: Work queue questions
Message-ID: <20120924200809.GC29689@google.com>
References: <CAK7N6vpuJnnAp2xCUG_20aSVzT9aXhZRFrkVtfO3qOKE7gZ0Eg@mail.gmail.com>
 <5A9BC72FD5CEC94EA024CED8E31D701A4C572F72@wdscexmb03.sc.wdc.com>
 <CAK7N6vpLpNM-tfhxpmym_eW+VpF+jnBe+uB=E0mSBk+CtMWp+w@mail.gmail.com>
 <5A9BC72FD5CEC94EA024CED8E31D701A4C572FAE@wdscexmb03.sc.wdc.com>
 <CAHCeSFp2=CzO1-dw_Ym_s4Pn04nsC_kQUerFJ+uFLh8iinX+Ug@mail.gmail.com>
 <CAK-9PRB7KvPNgcsXiNG08-7OdrkkNc2ushusXh9rVm93J0xcHA@mail.gmail.com>
 <CAHCeSFqmeOkKySxMUXgtnev+HL-NC6MdmeuDYONymYaNczb7RA@mail.gmail.com>
 <CAHCeSFq31fQuZd+Phgx-dQ1AEeDTh268WH14bDqEKqneOLpqxQ@mail.gmail.com>
 <20120924181025.GG7694@google.com>
 <CAHCeSFr4stF6BNGL7=7oPYzKqOZ-Ya8VUD02rjFRq1thMULFXw@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <CAHCeSFr4stF6BNGL7=7oPYzKqOZ-Ya8VUD02rjFRq1thMULFXw@mail.gmail.com>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hello,

On Mon, Sep 24, 2012 at 08:57:40PM +0100, Deepawali Verma wrote:
> May be I misunderstood, I read in the documentation about max_active.
> In this case, max_active is 1, but I created three workqueues, do you

I see.  Why are you doing that?  Is there ordering requirement?  Why
not just use system_unbound_wq?

> mean to say for this case, single thread can process three requests
> queued up in the three different workqueues.

In the following execution log you posted,

  kworker/u:1-21    [000]   110.964895: task_event: MYTASKJOB2381 XStarted
  kworker/u:1-21    [000]   110.964909: task_event: MYTASKJOB2381 Xstopped
  kworker/u:1-21    [000]   110.965137: task_event: MYTASKJOB2382 XStarted
  kworker/u:1-21    [000]   110.965154: task_event: MYTASKJOB2382 Xstopped
  kworker/u:5-3724  [000]   110.965311: task_event: MYTASKJOB2383 XStarted
  kworker/u:5-3724  [000]   110.965325: task_event: MYTASKJOB2383 Xstopped

The first two got executed on the same worker thread but the third one
is on a different one.  It really looks like you just don't have large
enough work for scheduler to interleave them or migrate workers to
different CPUs.

Thanks.

-- 
tejun
