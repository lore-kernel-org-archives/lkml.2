Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755431Ab0CQSot (ORCPT <rfc822;w@1wt.eu>);
	Wed, 17 Mar 2010 14:44:49 -0400
Received: from terminus.zytor.com ([198.137.202.10]:41731 "EHLO mail.zytor.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754132Ab0CQSos (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 17 Mar 2010 14:44:48 -0400
Message-ID: <4BA122EA.9030305@zytor.com>
Date: Wed, 17 Mar 2010 11:43:54 -0700
From: "H. Peter Anvin" <hpa@zytor.com>
User-Agent: Mozilla/5.0 (X11; U; Linux x86_64; en-US; rv:1.9.1.8) Gecko/20100301 Fedora/3.0.3-1.fc12 Thunderbird/3.0.3
MIME-Version: 1.0
To: Alan Cox <alan@lxorguk.ukuu.org.uk>
CC: Simon Kagstrom <simon.kagstrom@netinsight.net>, x86@kernel.org,
       linux-serial@vger.kernel.org, linux-kernel@vger.kernel.org,
       mingo@redhat.com, tglx@linutronix.de, alan@linux.intel.com,
       akpm@linux-foundation.org
Subject: Re: [PATCH 1/2]: serial8250: Use native_io_delay on the x86
References: <20100317132849.7d49939b@marrow.netinsight.se>	<20100317133050.54851ff8@marrow.netinsight.se>	<4BA11EAA.20506@zytor.com> <20100317183608.600bcdf0@lxorguk.ukuu.org.uk>
In-Reply-To: <20100317183608.600bcdf0@lxorguk.ukuu.org.uk>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 03/17/2010 11:36 AM, Alan Cox wrote:
>
> You just need a write to something on the ISA bus which is 'safe' so that
> you don't end up reading back what you wrote to an non-existant port as
> some old chipsets will return the last ISA result when you do this rather
> than 0xff.

Ah... floating bus syndrome.  So how about writing 0xff to the SCR 
register in the same register range?

	-hpa
