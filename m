Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753634Ab1FXNH3 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 24 Jun 2011 09:07:29 -0400
Received: from cantor2.suse.de ([195.135.220.15]:32955 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751701Ab1FXNH2 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 24 Jun 2011 09:07:28 -0400
Message-ID: <4E048C0D.7020403@suse.cz>
Date: Fri, 24 Jun 2011 15:07:25 +0200
From: Michal Marek <mmarek@suse.cz>
User-Agent: Mozilla/5.0 (X11; U; Linux x86_64; en-US; rv:1.9.2.17) Gecko/20110414 SUSE/3.1.10 Thunderbird/3.1.10
MIME-Version: 1.0
To: Joe Perches <joe@perches.com>
Cc: Markus Trippelsdorf <markus@trippelsdorf.de>,
        Nick Bowler <nbowler@elliptictech.com>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        Mike Frysinger <vapier@gentoo.org>, Sam Ravnborg <sam@ravnborg.org>,
        Artem Bityutskiy <Artem.Bityutskiy@nokia.com>
Subject: Re: __packed vs. __attribute__((packed)) in kernel headers
References: <20110622063441.GA1740@x4.trippels.de>	 <20110623134209.GA10813@elliptictech.com>	 <20110623150209.GA12413@x4.trippels.de> <1308848277.6688.7.camel@Joe-Laptop>
In-Reply-To: <1308848277.6688.7.camel@Joe-Laptop>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 23.6.2011 18:57, Joe Perches wrote:
> On Thu, 2011-06-23 at 17:02 +0200, Markus Trippelsdorf wrote:
>> On 2011.06.23 at 09:42 -0400, Nick Bowler wrote:
>>> On 2011-06-22 08:34 +0200, Markus Trippelsdorf wrote:
>>>> One possible solution would be to let the "scripts/headers_install.pl"
>>>> script automatically substitute __packed with __attribute__((packed)):
>>>>
>>>> diff --git a/scripts/headers_install.pl b/scripts/headers_install.pl
> []
>> I'm not an expert of Perl regular expressions, but maybe this:
>>   $line =~ s/\s__packed;$/ __attribute__((packed));/g
>> is a little bit closer to the intention?
>
> Maybe:
>
> s/\b__packed\b/__attribute__((packed))/g

Markus, will you post a patch with this fix?


> though this argues against redefining
> gcc __attributes__ in the first place.

It's a handy shortcut, so why not have it. Although I don't understand 
why checkpatch.pl has to warn about __attribute__((packed)).

Michal
