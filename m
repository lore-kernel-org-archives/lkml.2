Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756036Ab0IHV3K (ORCPT <rfc822;w@1wt.eu>);
	Wed, 8 Sep 2010 17:29:10 -0400
Received: from terminus.zytor.com ([198.137.202.10]:54983 "EHLO mail.zytor.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755694Ab0IHV3C (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 8 Sep 2010 17:29:02 -0400
Message-ID: <4C880001.8000908@zytor.com>
Date: Wed, 08 Sep 2010 14:28:33 -0700
From: "H. Peter Anvin" <hpa@zytor.com>
User-Agent: Mozilla/5.0 (X11; U; Linux x86_64; en-US; rv:1.9.2.8) Gecko/20100806 Fedora/3.1.2-1.fc13 Thunderbird/3.1.2
MIME-Version: 1.0
To: Yinghai Lu <yinghai@kernel.org>
CC: Ingo Molnar <mingo@elte.hu>, Thomas Gleixner <tglx@linutronix.de>,
        Torsten Kaiser <just.for.lkml@googlemail.com>,
        Linus Torvalds <torvalds@linux-foundation.org>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        Andrew Morton <akpm@linux-foundation.org>
Subject: Re: [PATCH] x86, setup: fix earlyprintk=serial,0x3f8,115200
References: <AANLkTinRRiW1VUzS+3T82=q8PsoRn78Cgn_X8gSduM0U@mail.gmail.com> <AANLkTi=652CHVZz8TAqCOiOLO2XyUHd6_i3vWNgbVzKA@mail.gmail.com> <4C7B0578.8090807@kernel.org> <4C7B05A6.4010801@kernel.org>
In-Reply-To: <4C7B05A6.4010801@kernel.org>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 08/29/2010 06:13 PM, Yinghai Lu wrote:
> 
> earlyprintk could take io port.
> 
> So we need to handle this case in setup code too, otherwise 0x3f8
> will be treated as baud rate.
> 

What about a non-hexadecimal port?  It seems more logical to me to move
the strncmp() up and test that before using simple_strtoull().

	-hpa
