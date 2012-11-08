Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756738Ab2KHTpk (ORCPT <rfc822;w@1wt.eu>);
	Thu, 8 Nov 2012 14:45:40 -0500
Received: from mx1.redhat.com ([209.132.183.28]:15066 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756572Ab2KHTpj (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 8 Nov 2012 14:45:39 -0500
Date: Thu, 8 Nov 2012 14:45:22 -0500
From: Vivek Goyal <vgoyal@redhat.com>
To: "Eric W. Biederman" <ebiederm@xmission.com>
Cc: Matthew Garrett <mjg@redhat.com>, Mimi Zohar <zohar@linux.vnet.ibm.com>,
        Khalid Aziz <khalid@gonehiking.org>, kexec@lists.infradead.org,
        horms@verge.net.au, Dave Young <dyoung@redhat.com>,
        "H. Peter Anvin" <hpa@zytor.com>,
        linux kernel mailing list <linux-kernel@vger.kernel.org>,
        Dmitry Kasatkin <dmitry.kasatkin@intel.com>,
        Roberto Sassu <roberto.sassu@polito.it>,
        Kees Cook <keescook@chromium.org>, Peter Jones <pjones@redhat.com>
Subject: Re: Kdump with signed images
Message-ID: <20121108194522.GC27586@redhat.com>
References: <1351780159.15708.17.camel@falcor>
 <20121101144304.GA15821@redhat.com>
 <20121101145225.GB10269@srcf.ucam.org>
 <20121102132318.GA3300@redhat.com>
 <87boffd727.fsf@xmission.com>
 <20121105180353.GC28720@redhat.com>
 <87mwyv96mn.fsf@xmission.com>
 <20121106193419.GH4548@redhat.com>
 <87k3tynvc0.fsf@xmission.com>
 <20121108194050.GB27586@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20121108194050.GB27586@redhat.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Nov 08, 2012 at 02:40:50PM -0500, Vivek Goyal wrote:
> On Tue, Nov 06, 2012 at 03:51:59PM -0800, Eric W. Biederman wrote:
> 
> [..]
> 
> Thnking more about executable signature verification, I have another question.
> 
> While verifyign the signature, we will have to read the whole executable
> in memory. That sounds bad as we are in kernel mode and will not be killed
> and if sombody is trying to execute a malformed exceptionally large
> executable, system will start killing other processess. We can potentially
> lock all the memory in kernel just by trying to execute a signed huge
> executable. Not good.
> 

Also, even if we try to read in whole executable, can't an hacker modify
pages in swap disk and then they will be faulted back in and bingo hacker
is running its unsigned code. (assuming root has been compromised otherwise
why do we have to do all this exercise).

Thanks
Vivek
