Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755471Ab0LAOhy (ORCPT <rfc822;w@1wt.eu>);
	Wed, 1 Dec 2010 09:37:54 -0500
Received: from nbd.name ([46.4.11.11]:33747 "EHLO nbd.name"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752345Ab0LAOhw (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 1 Dec 2010 09:37:52 -0500
Message-ID: <4CF65DB9.3050007@openwrt.org>
Date: Wed, 01 Dec 2010 15:37:45 +0100
From: Felix Fietkau <nbd@openwrt.org>
User-Agent: Mozilla/5.0 (Macintosh; U; Intel Mac OS X 10.6; en-US; rv:1.9.2.12) Gecko/20101027 Thunderbird/3.1.6
MIME-Version: 1.0
To: Joe Perches <joe@perches.com>
CC: "Luis R. Rodriguez" <mcgrof@gmail.com>,
        linux-wireless <linux-wireless@vger.kernel.org>,
        ath9k-devel@venema.h4ckr.net, peter@stuge.se,
        linux-kernel@vger.kernel.org
Subject: Re: [ath9k-devel] [PATCH wireless-next] ath: Rename ath_print to
 ath_debug
References: <5febb0e1fba0ec2bb77f6ade8b251ba0edf4614c.1290988277.git.joe@perches.com>	 <AANLkTinc251WbwuLqFbOZ5ipNGZW7=wub3DoWwy42=+e@mail.gmail.com>	 <20101129060732.5130.qmail@stuge.se> <4CF42C17.2070500@openwrt.org>	 <1291081185.16349.133.camel@Joe-Laptop> <4CF464D6.2020507@openwrt.org>	 <1291148375.18026.342.camel@Joe-Laptop>	 <AANLkTik2qtGUgkZYSjcEH9jHHsevKnxOvz4s6On94U9o@mail.gmail.com> <1291213675.1845.12.camel@Joe-Laptop>
In-Reply-To: <1291213675.1845.12.camel@Joe-Laptop>
X-Enigmail-Version: 1.1.1
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 2010-12-01 3:27 PM, Joe Perches wrote:
> On Tue, 2010-11-30 at 23:56 -0800, Luis R. Rodriguez wrote:
>> On Tue, Nov 30, 2010 at 12:19 PM, Joe Perches <joe@perches.com> wrote:
>> > Poor function naming is just that.
>> > It reduces readability and the uses are counter expectation.
>> The name is perfect, we use it to print anything, even non-debugging stuff.
> 
> 'fraid not.
> 
> ath/debug.h
> 
> #ifdef CONFIG_ATH_DEBUG
> void ath_print(struct ath_common *common, int dbg_mask, const char *fmt, ...)
> 	__attribute__ ((format (printf, 3, 4)));
> #else
> static inline void __attribute__ ((format (printf, 3, 4)))
> ath_print(struct ath_common *common, int dbg_mask, const char *fmt, ...)
> {
> }
> #endif /* CONFIG_ATH_DEBUG */
Now we're getting closer to something worth fixing. IMHO we should
change the code so that ath_print(common, ATH_DBG_FATAL, ...) prints
something even with CONFIG_ATH_DEBUG unset. To get this done, some
renaming would make sense here.

- Felix
