Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754987Ab1BHQMU (ORCPT <rfc822;w@1wt.eu>);
	Tue, 8 Feb 2011 11:12:20 -0500
Received: from mailhost.informatik.uni-hamburg.de ([134.100.9.70]:59354 "EHLO
	mailhost.informatik.uni-hamburg.de" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1753498Ab1BHQMT (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 8 Feb 2011 11:12:19 -0500
Message-ID: <4D516BBB.5090506@metafoo.de>
Date: Tue, 08 Feb 2011 17:13:47 +0100
From: Lars-Peter Clausen <lars@metafoo.de>
User-Agent: Mozilla/5.0 (X11; U; Linux x86_64; en-US; rv:1.9.1.16) Gecko/20101226 Icedove/3.0.11
MIME-Version: 1.0
To: Grazvydas Ignotas <notasas@gmail.com>
CC: Anton Vorontsov <cbouatmailru@gmail.com>,
        Rodolfo Giometti <giometti@linux.it>, linux-kernel@vger.kernel.org
Subject: Re: [PATCH 00/14] POWER: BQ27x00: New Properties, fixes, bq27000
 support
References: <1296953291-10373-1-git-send-email-lars@metafoo.de>	<AANLkTimN1ACy=rREGhvAqTwfywHb7_Td7ZeKosQc9txC@mail.gmail.com>	<4D4F4B18.6030502@metafoo.de> <AANLkTimgejf7D9LWyxa=W7Hc4MTWEotMnr7h2SC9iPCQ@mail.gmail.com>
In-Reply-To: <AANLkTimgejf7D9LWyxa=W7Hc4MTWEotMnr7h2SC9iPCQ@mail.gmail.com>
X-Enigmail-Version: 1.0.1
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 02/08/2011 12:40 PM, Grazvydas Ignotas wrote:
> That works. However I wonder about the delay, I've experimentally
> determined that bq27500 refreshes in about a second, so before this
> series I could for example run 'watch -n 1 cat current_now' and see
> current changes almost in realtime (when toggling backlight, for
> example). Maybe we could have different cache timeout for different
> chips or have quickly changing properties (like current and voltage)
> bypass the cache.

Looking at the datasheet confirms that the bq27500 updates the current register
every second. The bq27000 updates it only every 5.12 seconds.
I think reducing the the cache time for bq27500 to 1 second would render the
cache mostly useless, but maybe it makes sense to bypass the cache for voltage
and current on the bq27500.

- Lars

