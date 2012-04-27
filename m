Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932236Ab2D0RVj (ORCPT <rfc822;w@1wt.eu>);
	Fri, 27 Apr 2012 13:21:39 -0400
Received: from smtp103.prem.mail.ac4.yahoo.com ([76.13.13.42]:23831 "HELO
	smtp103.prem.mail.ac4.yahoo.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with SMTP id S1760843Ab2D0RVi (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 27 Apr 2012 13:21:38 -0400
X-Yahoo-Newman-Property: ymail-3
X-YMail-OSG: 8lJoVAcVM1kvBPyt8XMrPY2tOtiJHmFpULEBWwCgufFwo5S
 7LfOKCgbK5is_Yf9GeJKqwJU8s7mwxfhqu87POizV234cHP3KmpsGvRcwWpX
 akdXAoPo9k3nxt.Yh2AS_yfl_n9TqccDqsPZ_037KZq2BVzySXecPVR.sPKK
 RqL.AzYoAgGIsGIGeTwSEh4ZEbItWo29OgJ0KygfHN8OIquqTDkXENax8QqP
 9TxnCG2T5I4AhvQgod4SiMul1RS3HU_IJepQzuZPI_FifEG.DG1gPKnHnrNE
 B2.lFxf7mOa3RxWp5zTQHSsxYeiUZa2a4scSbIfrIyYphVHX2r_djqn.F5HT
 eWRdiQxzO8UvjeBVP0KYobfYWQVsFPGKZUjKOfzKmq4JtLPjUVQ62XRqLb_C
 FyHfTFt.im1hKE9cSAGnSRSAEejFt9v6dXXTN
X-Yahoo-SMTP: _Dag8S.swBC1p4FJKLCXbs8NQzyse1SYSgnAbY0-
Date: Fri, 27 Apr 2012 12:21:34 -0500 (CDT)
From: Christoph Lameter <cl@linux.com>
X-X-Sender: cl@router.home
To: Tejun Heo <tj@kernel.org>
cc: Yanmin Zhang <yanmin_zhang@linux.intel.com>,
        ShuoX Liu <shuox.liu@intel.com>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        Thomas Gleixner <tglx@linutronix.de>, Ingo Molnar <mingo@redhat.com>,
        "H. Peter Anvin" <hpa@zytor.com>
Subject: Re: [PATCH] percpu, x86: don't use PMD_SIZE as embedded atom_size
 on 32bit
In-Reply-To: <20120427165356.GA26595@google.com>
Message-ID: <alpine.DEB.2.00.1204271219320.32270@router.home>
References: <4F97BA98.6010001@intel.com> <20120425222429.GE8989@google.com> <1335405672.14538.135.camel@ymzhang.sh.intel.com> <20120426224946.GG27486@google.com> <1335488964.14538.159.camel@ymzhang.sh.intel.com> <1335516994.14538.160.camel@ymzhang.sh.intel.com>
 <20120427165356.GA26595@google.com>
User-Agent: Alpine 2.00 (DEB 1167 2008-08-23)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, 27 Apr 2012, Tejun Heo wrote:

> This patch makes x86_32 always use PAGE_SIZE as atom_size for embed
> first chunk allocator.

Would it not be easier to use the first #ifdef in the function to set
pcpu_chosen_fc = PCPU_FC_PAGE?

You could just skip the whole PCPU_FC_PAGE block in the CONFIG_X86_32
case.

