Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756748Ab2KHTl3 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 8 Nov 2012 14:41:29 -0500
Received: from mx1.redhat.com ([209.132.183.28]:62052 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756676Ab2KHTl2 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 8 Nov 2012 14:41:28 -0500
Date: Thu, 8 Nov 2012 14:40:51 -0500
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
Message-ID: <20121108194050.GB27586@redhat.com>
References: <20121101135356.GA15659@redhat.com>
 <1351780159.15708.17.camel@falcor>
 <20121101144304.GA15821@redhat.com>
 <20121101145225.GB10269@srcf.ucam.org>
 <20121102132318.GA3300@redhat.com>
 <87boffd727.fsf@xmission.com>
 <20121105180353.GC28720@redhat.com>
 <87mwyv96mn.fsf@xmission.com>
 <20121106193419.GH4548@redhat.com>
 <87k3tynvc0.fsf@xmission.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <87k3tynvc0.fsf@xmission.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Nov 06, 2012 at 03:51:59PM -0800, Eric W. Biederman wrote:

[..]

Thnking more about executable signature verification, I have another question.

While verifyign the signature, we will have to read the whole executable
in memory. That sounds bad as we are in kernel mode and will not be killed
and if sombody is trying to execute a malformed exceptionally large
executable, system will start killing other processess. We can potentially
lock all the memory in kernel just by trying to execute a signed huge
executable. Not good.

I was looking at IMA and they seem to be using kernel_read() for reading
page in and update digest. IIUC, that means page is read from disk,
brought in cache and if needed will be read back from disk. But that
means hacker can try to do some timing tricks and try to replace disk image
after signature verification and run unsigned program.

So how do we go about it. Neither of the approaches sound appealing
to me.

Thanks
Vivek
