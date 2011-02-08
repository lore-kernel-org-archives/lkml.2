Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755142Ab1BHQ2K (ORCPT <rfc822;w@1wt.eu>);
	Tue, 8 Feb 2011 11:28:10 -0500
Received: from mail-bw0-f46.google.com ([209.85.214.46]:64030 "EHLO
	mail-bw0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754847Ab1BHQ2I (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 8 Feb 2011 11:28:08 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-type:content-disposition:in-reply-to:user-agent;
        b=frVmaqsB/c47KuyghBN+q3Y/xsR563sF4l+R7h7s+8Rf/iyZ11Eg8DAl5AYXrXQD4m
         JyF/gNXcL++OglQI9usw4PaKzB8rb2WzezKTg4Bh3uXTSaTg/44qYSnZbC5WQS6rx9QC
         TFuaBxpBWpZorEbDLFTWxkl/Ppab0pHCdTC+U=
Date: Tue, 8 Feb 2011 19:28:02 +0300
From: Anton Vorontsov <cbouatmailru@gmail.com>
To: Lars-Peter Clausen <lars@metafoo.de>
Cc: Grazvydas Ignotas <notasas@gmail.com>,
        Rodolfo Giometti <giometti@linux.it>, linux-kernel@vger.kernel.org
Subject: Re: [PATCH 00/14] POWER: BQ27x00: New Properties, fixes, bq27000
 support
Message-ID: <20110208162802.GA29842@oksana.dev.rtsoft.ru>
References: <1296953291-10373-1-git-send-email-lars@metafoo.de>
 <AANLkTimN1ACy=rREGhvAqTwfywHb7_Td7ZeKosQc9txC@mail.gmail.com>
 <4D4F4B18.6030502@metafoo.de>
 <AANLkTimgejf7D9LWyxa=W7Hc4MTWEotMnr7h2SC9iPCQ@mail.gmail.com>
 <4D516BBB.5090506@metafoo.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
In-Reply-To: <4D516BBB.5090506@metafoo.de>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Feb 08, 2011 at 05:13:47PM +0100, Lars-Peter Clausen wrote:
> On 02/08/2011 12:40 PM, Grazvydas Ignotas wrote:
> > That works. However I wonder about the delay, I've experimentally
> > determined that bq27500 refreshes in about a second, so before this
> > series I could for example run 'watch -n 1 cat current_now' and see
> > current changes almost in realtime (when toggling backlight, for
> > example). Maybe we could have different cache timeout for different
> > chips or have quickly changing properties (like current and voltage)
> > bypass the cache.
> 
> Looking at the datasheet confirms that the bq27500 updates the current register
> every second. The bq27000 updates it only every 5.12 seconds.
> I think reducing the the cache time for bq27500 to 1 second would render the
> cache mostly useless, but maybe it makes sense to bypass the cache for voltage
> and current on the bq27500.

Nope, it's not useless. I.e. for `cat /sys/class/power_supply/*/*`.
Actually, it was only the purpose for caching the battery values.

So, 1 second is OK.

p.s. Lars, on the next resend, can you please remove "POWER:"
prefix from the patch description line, bound the commit message
width to 76 symbols, and add all the collected Acked-by lines.
That way I can just pull your tree.

Thanks!

-- 
Anton Vorontsov
Email: cbouatmailru@gmail.com
