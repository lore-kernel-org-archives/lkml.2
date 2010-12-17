Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755377Ab0LQR53 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 17 Dec 2010 12:57:29 -0500
Received: from terminus.zytor.com ([198.137.202.10]:48531 "EHLO mail.zytor.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755156Ab0LQR51 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 17 Dec 2010 12:57:27 -0500
Message-ID: <4D0BA45A.7020402@zytor.com>
Date: Fri, 17 Dec 2010 09:56:42 -0800
From: "H. Peter Anvin" <hpa@zytor.com>
User-Agent: Mozilla/5.0 (X11; U; Linux x86_64; en-US; rv:1.9.2.13) Gecko/20101209 Fedora/3.1.7-0.35.b3pre.fc14 Thunderbird/3.1.7
MIME-Version: 1.0
To: Vivek Goyal <vgoyal@redhat.com>
CC: Yinghai <yinghai@kernel.org>, Stanislaw Gruszka <sgruszka@redhat.com>,
        Ingo Molnar <mingo@elte.hu>, Thomas Gleixner <tglx@linutronix.de>,
        Maxim Uvarov <muvarov@gmail.com>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        Neil Horman <nhorman@redhat.com>
Subject: Re: kdump broken on 2.6.37-rc4
References: <20101209124117.GA6032@redhat.com> <4D01377B.5070809@kernel.org> <20101213100848.GA2237@redhat.com> <4D0663F0.2060103@kernel.org> <4D06783C.6040009@zytor.com> <20101214224135.GB19693@redhat.com> <20101215103954.GA2243@redhat.com> <4D09958D.2040907@kernel.org> <4D0AD976.3020504@zytor.com> <3C6B7683-9CDC-4C4A-A32A-56227DE01387@kernel.org> <20101217170146.GC9568@redhat.com>
In-Reply-To: <20101217170146.GC9568@redhat.com>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 12/17/2010 09:01 AM, Vivek Goyal wrote:
> On Thu, Dec 16, 2010 at 07:58:48PM -0800, Yinghai wrote:
>> Please don't do that to 64 bit
>>
>> My big system with 1024g memory and a lot of cards with rhel 6 to make kdump work must have crashkernel=512m and second kernel need to take pci=nomsi
>>
> 
> I agree here that we should not do it for 64 bit.
> 
> - Just because we need it for 32 bit does not mean we should limit it for
>   64bit. And we do want to have the capability to boot the kernel from as
>   high memory as possible so creating another aritificial limit is counter
>   to that.
> 
> - I would not worry too much about backward compatibility and allow
>   booting 32bit kernel till 768MB. The reason being that most of the
>   distros use same kernel for crash dumping as regular kernel. Maintainig
>   two separate kernels is big hassle.
> 
>   So a small set of people who run into issue, would need to change kernel
>   command line "crashkernel=128M@64M" or something similar.
> 

Do we have actual testing for how high the 64-bit kernel will load?  I'm
assuming that the usage of a 32-bit kdump kernel for a 64-bit main
kernel is nonexistent.

	-hpa
