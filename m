Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752897Ab0LQEId (ORCPT <rfc822;w@1wt.eu>);
	Thu, 16 Dec 2010 23:08:33 -0500
Received: from terminus.zytor.com ([198.137.202.10]:33918 "EHLO mail.zytor.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752482Ab0LQEIc (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 16 Dec 2010 23:08:32 -0500
Message-ID: <4D0AE231.4010804@zytor.com>
Date: Thu, 16 Dec 2010 20:08:17 -0800
From: "H. Peter Anvin" <hpa@zytor.com>
User-Agent: Mozilla/5.0 (X11; U; Linux x86_64; en-US; rv:1.9.2.13) Gecko/20101209 Fedora/3.1.7-0.35.b3pre.fc14 Thunderbird/3.1.7
MIME-Version: 1.0
To: Yinghai <yinghai@kernel.org>
CC: Vivek Goyal <vgoyal@redhat.com>, Stanislaw Gruszka <sgruszka@redhat.com>,
        Ingo Molnar <mingo@elte.hu>, Thomas Gleixner <tglx@linutronix.de>,
        Maxim Uvarov <muvarov@gmail.com>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        Neil Horman <nhorman@redhat.com>
Subject: Re: kdump broken on 2.6.37-rc4
References: <20101207105053.GA2803@redhat.com> <4CFE89FE.1090901@kernel.org> <20101208141942.GA2335@redhat.com> <4D00823A.9050808@kernel.org> <20101209124117.GA6032@redhat.com> <4D01377B.5070809@kernel.org> <20101213100848.GA2237@redhat.com> <4D0663F0.2060103@kernel.org> <4D06783C.6040009@zytor.com> <20101214224135.GB19693@redhat.com> <20101215103954.GA2243@redhat.com> <4D09958D.2040907@kernel.org> <4D0AD976.3020504@zytor.com> <3C6B7683-9CDC-4C4A-A32A-56227DE01387@kernel.org>
In-Reply-To: <3C6B7683-9CDC-4C4A-A32A-56227DE01387@kernel.org>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 12/16/2010 07:58 PM, Yinghai wrote:
> Please don't do that to 64 bit
> 
> My big system with 1024g memory and a lot of cards with rhel 6 to make kdump work must have crashkernel=512m and second kernel need to take pci=nomsi
> 
> Thanks
> 

Hm, this seems like an epic FAIL.

First of all, the current code still limits it to 896 MiB, so 512 MiB is
not a significant restriction.

Second, this patch only applies if "crashkernel=" is not specified, so
it doesn't even apply to your situation.

Third, if you have to specify "crashkernel=" that means that there is
yet another problem here that should be fixed.

	-hpa
