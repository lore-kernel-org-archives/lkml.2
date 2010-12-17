Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751659Ab0LQBQ0 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 16 Dec 2010 20:16:26 -0500
Received: from terminus.zytor.com ([198.137.202.10]:53318 "EHLO mail.zytor.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751039Ab0LQBQY (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 16 Dec 2010 20:16:24 -0500
Message-ID: <4D0AB9CB.2090906@zytor.com>
Date: Thu, 16 Dec 2010 17:15:55 -0800
From: "H. Peter Anvin" <hpa@zytor.com>
User-Agent: Mozilla/5.0 (X11; U; Linux x86_64; en-US; rv:1.9.2.13) Gecko/20101209 Fedora/3.1.7-0.35.b3pre.fc14 Thunderbird/3.1.7
MIME-Version: 1.0
To: Vivek Goyal <vgoyal@redhat.com>
CC: Yinghai Lu <yinghai@kernel.org>,
        "Eric W. Biederman" <ebiederm@xmission.com>,
        Stanislaw Gruszka <sgruszka@redhat.com>, Ingo Molnar <mingo@elte.hu>,
        Thomas Gleixner <tglx@linutronix.de>, Maxim Uvarov <muvarov@gmail.com>,
        linux-kernel@vger.kernel.org, Neil Horman <nhorman@redhat.com>
Subject: Re: kdump broken on 2.6.37-rc4
References: <4D01377B.5070809@kernel.org> <20101213100848.GA2237@redhat.com> <4D0663F0.2060103@kernel.org> <4D06783C.6040009@zytor.com> <20101214224135.GB19693@redhat.com> <20101215103954.GA2243@redhat.com> <4D09958D.2040907@kernel.org> <20101216143925.GA13870@redhat.com> <4D0A3E31.4000109@zytor.com> <4D0A4C51.3070008@kernel.org> <20101216220117.GA2485@redhat.com>
In-Reply-To: <20101216220117.GA2485@redhat.com>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 12/16/2010 02:01 PM, Vivek Goyal wrote:
> 
> Yinghai, 
> 
> On my system above change works fine and I can boot into second kernel. So
> it will boil down to knowing what are the exact constraints on heap for
> decompression and for 32bit can we allow heap upto 896MB or not.
> 

By the way, 896 MiB is almost certainly too aggressive; the vmalloc area
is adjustable and there are other bits that can chew off a few MiB of
address space.  I would suggest we either make it 512 or 768 MiB *and*
fix the brk limit.

Opinions?

	-hpa
