Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752677Ab3ABL0r (ORCPT <rfc822;w@1wt.eu>);
	Wed, 2 Jan 2013 06:26:47 -0500
Received: from smtp02.citrix.com ([66.165.176.63]:21885 "EHLO
	SMTP02.CITRIX.COM" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752134Ab3ABL0p (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 2 Jan 2013 06:26:45 -0500
X-IronPort-AV: E=Sophos;i="4.84,394,1355097600"; 
   d="scan'208";a="2272329"
Message-ID: <50E41973.9050705@citrix.com>
Date: Wed, 2 Jan 2013 11:26:43 +0000
From: Andrew Cooper <andrew.cooper3@citrix.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:10.0.11) Gecko/20121127 Icedove/10.0.11
MIME-Version: 1.0
To: "Eric W. Biederman" <ebiederm@xmission.com>
CC: "x86@kernel.org" <x86@kernel.org>,
        "konrad.wilk@oracle.com" <konrad.wilk@oracle.com>,
        Daniel Kiper <daniel.kiper@oracle.com>,
        "H. Peter Anvin" <hpa@zytor.com>,
        "kexec@lists.infradead.org" <kexec@lists.infradead.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "virtualization@lists.linux-foundation.org" 
	<virtualization@lists.linux-foundation.org>,
        "mingo@redhat.com" <mingo@redhat.com>,
        "jbeulich@suse.com" <jbeulich@suse.com>,
        "maxim.uvarov@oracle.com" <maxim.uvarov@oracle.com>,
        "tglx@linutronix.de" <tglx@linutronix.de>,
        "xen-devel@lists.xensource.com" <xen-devel@lists.xensource.com>,
        "vgoyal@redhat.com" <vgoyal@redhat.com>
Subject: Re: [Xen-devel] [PATCH v3 00/11] xen: Initial kexec/kdump implementation
References: <1356574740-6806-1-git-send-email-daniel.kiper@oracle.com> <50DBC856.6030208@zytor.com> <791b4922-078f-4adc-b3f3-0651f2266147@email.android.com> <50DC58C4.3000307@citrix.com> <874nj7qsor.fsf@xmission.com>
In-Reply-To: <874nj7qsor.fsf@xmission.com>
Content-Type: text/plain; charset="ISO-8859-1"; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 27/12/12 18:02, Eric W. Biederman wrote:
> Andrew Cooper<andrew.cooper3@citrix.com>  writes:
>
>> On 27/12/2012 07:53, Eric W. Biederman wrote:
>>> The syscall ABI still has the wrong semantics.
>>>
>>> Aka totally unmaintainable and umergeable.
>>>
>>> The concept of domU support is also strange.  What does domU support even mean, when the dom0 support is loading a kernel to pick up Xen when Xen falls over.
>> There are two requirements pulling at this patch series, but I agree
>> that we need to clarify them.
> It probably make sense to split them apart a little even.
>
>

Thinking about this split, there might be a way to simply it even more.

/sbin/kexec can load the "Xen" crash kernel itself by issuing hypercalls 
using /dev/xen/privcmd.  This would remove the need for the dom0 kernel 
to distinguish between loading a crash kernel for itself and loading a 
kernel for Xen.

Or is this just a silly idea complicating the matter?

~Andrew
