Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753035Ab2F2WaK (ORCPT <rfc822;w@1wt.eu>);
	Fri, 29 Jun 2012 18:30:10 -0400
Received: from terminus.zytor.com ([198.137.202.10]:50602 "EHLO mail.zytor.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751054Ab2F2WaI (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 29 Jun 2012 18:30:08 -0400
Message-ID: <4FEE2C4B.7040405@zytor.com>
Date: Fri, 29 Jun 2012 15:29:31 -0700
From: "H. Peter Anvin" <hpa@zytor.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:13.0) Gecko/20120605 Thunderbird/13.0
MIME-Version: 1.0
To: Cyclonus J <cyclonusj@gmail.com>
CC: Konrad Rzeszutek Wilk <konrad.wilk@oracle.com>,
        marmarek@invisiblethingslab.com, xen-devel@lists.xensource.com,
        x86@kernel.org, Jason Garrett-Glaser <jason@x264.com>,
        linux-kernel@vger.kernel.org, rostedt@goodmis.org, mingo@redhat.com,
        tglx@linutronix.de, "Siddha, Suresh B" <suresh.b.siddha@intel.com>
Subject: Re: [Xen-devel] [PATCH] x86 fixes for 3.3 impacting distros (v1).
References: <1328888091-9692-1-git-send-email-konrad.wilk@oracle.com> <CABS55+BFrDUV-WR=nx+d6+ZJngpuZnh41DZ3NYU4adFqaxqaNA@mail.gmail.com> <20120510153457.GB6389@phenom.dumpdata.com> <20120627231755.GA1021@gmail.com> <20120628142836.GE8956@phenom.dumpdata.com> <4FEC6D44.8080807@zytor.com> <20120629215225.GA7544@gmail.com>
In-Reply-To: <20120629215225.GA7544@gmail.com>
X-Enigmail-Version: 1.4.2
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 06/29/2012 02:52 PM, Cyclonus J wrote:
> 
> Peter,
> 
> hmm, It looks like option 1 doesn't have any perf regression, but it is still
> not acceptable? That is fine. If you prefer to have a software PAT table lookup, could you provide
> some details so I can try to get something align that direction?
> 

It has no perf regression, but it really buries deep in the code a
strange abstraction which only happens to work on Xen and is confusing
as hell.

The idea with a software PAT table is that the PAT numbers used by the
kernel should come from a table in the kernel instead of being
hard-coded.  That might take some work, and it remains to be seen if it
is practical.

It *may* be that we need to hard-code 0 as WB, still, but that should be
true on any sane platform.

	-hpa
