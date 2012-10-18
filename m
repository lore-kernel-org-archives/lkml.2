Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756599Ab2JRP27 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 18 Oct 2012 11:28:59 -0400
Received: from terminus.zytor.com ([198.137.202.10]:45903 "EHLO mail.zytor.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753341Ab2JRP25 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 18 Oct 2012 11:28:57 -0400
Message-ID: <50802030.8070107@zytor.com>
Date: Thu, 18 Oct 2012 08:28:48 -0700
From: "H. Peter Anvin" <hpa@zytor.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:16.0) Gecko/20121009 Thunderbird/16.0
MIME-Version: 1.0
To: Dan Magenheimer <dan.magenheimer@oracle.com>
CC: Konrad Wilk <konrad.wilk@oracle.com>, linux-acpi@vger.kernel.org,
        x86@kernel.org, xen-devel@lists.xensource.com,
        linux-kernel@vger.kernel.org, lenb@kernel.org
Subject: Re: [Xen-devel] Is: axe read_tscp pvops call. Was: Re: [RFC] ACPI
 S3 and Xen (suprisingly small\!).
References: <1350481786-4969-1-git-send-email-konrad.wilk@oracle.com> <507ED6C0.4020503@zytor.com> <20121017161036.GA10691@phenom.dumpdata.com> <507EE1C3.7070300@zytor.com> <20121017165452.GA22740@phenom.dumpdata.com> <507EEC53.1010309@zytor.com> <84b3cbf9-7c84-4d7e-a2d7-46b0d1cc5975@default>
In-Reply-To: <84b3cbf9-7c84-4d7e-a2d7-46b0d1cc5975@default>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 10/18/2012 08:22 AM, Dan Magenheimer wrote:
>
> It's a bit more complicated than that.  The problem is that if
> any patch is ever submitted to the kernel that uses the rdtscp
> instruction *in kernel space* in some clever way, the resultant
> kernel may not behave as expected (depending on how the instruction
> is used) on a 32-bit[1] PV kernel running on Xen, up to and including
> the possibility of data corruption.
>
> I don't know how one would implement it, but it's like a
> BUILD_BUG_ON is needed if any kernel developer uses rdtscp
> (one that never gets invoked by vdso code), that prints:
>
> "WARNING: Please do not use this instruction in the kernel
> without notifying the Xen maintainer as there is a possibility
> it may behave unpredictably in some Xen environments.
> See Documentation/.../xen_pv_limitations for detail."
>
> The other virtualization-unsafe instructions may have similar
> problems.
>

Good frakking God.  This is the sort of things that makes me think that 
Xen PV should just be thrown out of the kernel once and for all.

Do you notice that the document you just claimed doesn't even exist at 
this point, never mind being somehow enforced?  In other word, there is 
ABSOLUTELY NO WAY a mainline kernel developer can have any idea what 
amount of violence Xen does to the architecture that it is parasiting on.

	-hpa

-- 
H. Peter Anvin, Intel Open Source Technology Center
I work for Intel.  I don't speak on their behalf.

