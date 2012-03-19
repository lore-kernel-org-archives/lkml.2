Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1161264Ab2CSPQt (ORCPT <rfc822;w@1wt.eu>);
	Mon, 19 Mar 2012 11:16:49 -0400
Received: from smtp108.prem.mail.ac4.yahoo.com ([76.13.13.47]:46733 "HELO
	smtp108.prem.mail.ac4.yahoo.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with SMTP id S1161158Ab2CSPQr (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 19 Mar 2012 11:16:47 -0400
X-Yahoo-Newman-Property: ymail-3
X-YMail-OSG: aDY6uqsVM1naDFyFtBONPReyhj6hofIpklWyqe_trmx_MGu
 pyXZO1o0TugsYgJ0grAIs1FirecQfda_FQiAkncwAnqJ.ZWpFC5TPtokiAn4
 QRcmhg_25EUSMNxceuy95Gm_7Zm4JrfUf0q4WGC1j9vQ9054SHl514HVEz1L
 ho6W2VU5Ka8yd.v2MQgebBsissjPp8Ux78Evq25vlPjFd79tk1ncqXTyArfd
 yXaEC9wC4lQ9x1WRclH_db0hK6RGk31Zjnq21c0cXXar.9NNsMm..T6.8EzC
 KRknpzqfLRsaPabg4jkuQ8vv_EXlCnQu4isAEsPgqWz9jzdj_i3RtCmGVDOF
 wceMs69CZf2A8SmiIBRHV2aEb9luCJVGWb6AwBCv8SdGQV_UvjWbZCzky4fB
 L
X-Yahoo-SMTP: _Dag8S.swBC1p4FJKLCXbs8NQzyse1SYSgnAbY0-
Date: Mon, 19 Mar 2012 10:16:41 -0500 (CDT)
From: Christoph Lameter <cl@linux.com>
X-X-Sender: cl@router.home
To: Peter Zijlstra <a.p.zijlstra@chello.nl>
cc: Linus Torvalds <torvalds@linux-foundation.org>,
        Andrew Morton <akpm@linux-foundation.org>,
        Thomas Gleixner <tglx@linutronix.de>, Ingo Molnar <mingo@elte.hu>,
        Paul Turner <pjt@google.com>,
        Suresh Siddha <suresh.b.siddha@intel.com>,
        Mike Galbraith <efault@gmx.de>,
        "Paul E. McKenney" <paulmck@linux.vnet.ibm.com>,
        Lai Jiangshan <laijs@cn.fujitsu.com>, Dan Smith <danms@us.ibm.com>,
        Bharata B Rao <bharata.rao@gmail.com>,
        Lee Schermerhorn <Lee.Schermerhorn@hp.com>,
        Andrea Arcangeli <aarcange@redhat.com>, Rik van Riel <riel@redhat.com>,
        Johannes Weiner <hannes@cmpxchg.org>, linux-kernel@vger.kernel.org,
        linux-mm@kvack.org
Subject: Re: [RFC][PATCH 10/26] mm, mpol: Make mempolicy home-node aware
In-Reply-To: <1332165959.18960.340.camel@twins>
Message-ID: <alpine.DEB.2.00.1203191012530.17008@router.home>
References: <20120316144028.036474157@chello.nl> <20120316144240.763518310@chello.nl> <alpine.DEB.2.00.1203161333370.10211@router.home> <1331932375.18960.237.camel@twins> <alpine.DEB.2.00.1203190852380.16879@router.home> <1332165959.18960.340.camel@twins>
User-Agent: Alpine 2.00 (DEB 1167 2008-08-23)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 19 Mar 2012, Peter Zijlstra wrote:

> > A HOME_NODE policy would also help to ensure that existing applications
> > continue to work as expected. Given that people in the HPC industry and
> > elsewhere have been fine tuning around the scheduler for years this is a
> > desirable goal and ensures backward compatibility.
>
> I really have no idea what you're saying. Existing applications that use
> mbind/set_mempolicy already continue to function exactly like before,
> see how the new layer is below all that.

No they wont work the same way as before. Applications may be relying on
MPOL_DEFAULT behavior now expecting node local allocations. The home-node
functionality would cause a difference in behavior because it would
perform remote node allocs when a thread has been moved to a different
socket. The changes also cause migrations that may cause additional
latencies as well as change the location of memory in surprising ways for
the applications

