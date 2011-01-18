Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752091Ab1ARO0h (ORCPT <rfc822;w@1wt.eu>);
	Tue, 18 Jan 2011 09:26:37 -0500
Received: from www.wytron.com.tw ([211.75.82.101]:57204 "EHLO
	www.wytron.com.tw" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751742Ab1ARO0g (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 18 Jan 2011 09:26:36 -0500
Message-ID: <4D35A307.5070706@wytron.com.tw>
Date: Tue, 18 Jan 2011 22:26:15 +0800
From: Thomas Chou <thomas@wytron.com.tw>
User-Agent: Mozilla/5.0 (X11; U; Linux i686; en-US; rv:1.9.2.13) Gecko/20101209 Fedora/3.1.7-0.35.b3pre.fc14 Thunderbird/3.1.7
MIME-Version: 1.0
To: Walter Goossens <waltergoossens@home.nl>
CC: Grant Likely <grant.likely@secretlab.ca>,
        Dmitry Torokhov <dmitry.torokhov@gmail.com>,
        linux-kernel@vger.kernel.org, nios2-dev@sopc.et.ntust.edu.tw,
        linux-input@vger.kernel.org, devicetree-discuss@lists.ozlabs.org
Subject: Re: [PATCH] alter_ps2: Add devicetree support
References: <4D040D1C.2020705@home.nl> <1295245760-4566-1-git-send-email-thomas@wytron.com.tw> <AANLkTi=8+Q5dm+5Pa-cYkmaBWQ4S7jgjZOL0ovtmrdxB@mail.gmail.com> <4D34AEC3.60801@home.nl> <20110117220244.GA17963@angua.secretlab.ca> <4D34D046.20708@home.nl>
In-Reply-To: <4D34D046.20708@home.nl>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
X-SA-Exim-Connect-IP: 192.168.1.250
X-SA-Exim-Mail-From: thomas@wytron.com.tw
X-SA-Exim-Scanned: No (on www.wytron.com.tw); SAEximRunCond expanded to false
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 01/18/2011 07:27 AM, Walter Goossens wrote:
>> so, instead of trying to us a 'generic' value like "altera,altera_ps2"
>> which has a bunch of ambiguity about which hardware actually
>> implements the behaviour, the values "altera,altera_ps2-1" and
>> "altera,altera_ps2-3" become the de-facto 'generic' values without any
>> messiness or ambiguity about what they mean.
>>
>> Plus, each .dts file still specifies the exact version that is
>> implemented on the board so that the driver can still fixup
>> version-specific bugs if any are discovered in the future.
>>
> Ahh ok.
> That does look like a good solution. I'll try and cook something up for
> that.

Hi Walter,

Can we use "kind" and "version" attribute of a sopcinfo file to build 
the match string? This way, your dts converter won't need update for 
each new component.

eg,

kind="altera_avalon_spi" version="9.0" ==> "altera","avalon-spi-9.0"

kind="altera_up_avalon_ps2_classic" version="6.1" ==>
   "altera","up-avalon-ps2-classic-6.1"

- Thomas
