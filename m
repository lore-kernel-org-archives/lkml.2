Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756898Ab2KHUr3 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 8 Nov 2012 15:47:29 -0500
Received: from e1.ny.us.ibm.com ([32.97.182.141]:59167 "EHLO e1.ny.us.ibm.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756504Ab2KHUr2 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 8 Nov 2012 15:47:28 -0500
Message-ID: <1352407597.30800.92.camel@falcor.watson.ibm.com>
Subject: Re: Kdump with signed images
From: Mimi Zohar <zohar@linux.vnet.ibm.com>
To: Vivek Goyal <vgoyal@redhat.com>
Cc: "Eric W. Biederman" <ebiederm@xmission.com>,
        Matthew Garrett <mjg@redhat.com>, Khalid Aziz <khalid@gonehiking.org>,
        kexec@lists.infradead.org, horms@verge.net.au,
        Dave Young <dyoung@redhat.com>, "H. Peter Anvin" <hpa@zytor.com>,
        linux kernel mailing list <linux-kernel@vger.kernel.org>,
        Dmitry Kasatkin <dmitry.kasatkin@intel.com>,
        Roberto Sassu <roberto.sassu@polito.it>,
        Kees Cook <keescook@chromium.org>, Peter Jones <pjones@redhat.com>
Date: Thu, 08 Nov 2012 15:46:37 -0500
In-Reply-To: <20121108194050.GB27586@redhat.com>
References: <20121101135356.GA15659@redhat.com>
	 <1351780159.15708.17.camel@falcor> <20121101144304.GA15821@redhat.com>
	 <20121101145225.GB10269@srcf.ucam.org> <20121102132318.GA3300@redhat.com>
	 <87boffd727.fsf@xmission.com> <20121105180353.GC28720@redhat.com>
	 <87mwyv96mn.fsf@xmission.com> <20121106193419.GH4548@redhat.com>
	 <87k3tynvc0.fsf@xmission.com> <20121108194050.GB27586@redhat.com>
Content-Type: text/plain; charset="UTF-8"
X-Mailer: Evolution 3.2.3 (3.2.3-3.fc16) 
Content-Transfer-Encoding: 7bit
Mime-Version: 1.0
X-Content-Scanned: Fidelis XPS MAILER
x-cbid: 12110820-6078-0000-0000-000011AF51D1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 2012-11-08 at 14:40 -0500, Vivek Goyal wrote:
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
> I was looking at IMA and they seem to be using kernel_read() for reading
> page in and update digest. IIUC, that means page is read from disk,
> brought in cache and if needed will be read back from disk. But that
> means hacker can try to do some timing tricks and try to replace disk image
> after signature verification and run unsigned program.

For the reason you mentioned, the signature verification is deferred to
bprm, after the executable has been locked from modification.  Any
subsequent changes to the file would cause the file to be re-appraised.

The goal of EVM/IMA-appraisal is to detect file tampering and enforce
file data/metadata integrity.  If EVM/IMA-appraisal fail, then as a last
resort, we fall back and rely on IMA measurement/attestation at least to
detect it.

Mimi

> So how do we go about it. Neither of the approaches sound appealing
> to me.
> 
> Thanks
> Vivek



