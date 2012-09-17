Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932276Ab2IQUrb (ORCPT <rfc822;w@1wt.eu>);
	Mon, 17 Sep 2012 16:47:31 -0400
Received: from mail-wi0-f172.google.com ([209.85.212.172]:65179 "EHLO
	mail-wi0-f172.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756030Ab2IQUr3 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 17 Sep 2012 16:47:29 -0400
Date: Mon, 17 Sep 2012 22:47:24 +0200
From: Jiri Pirko <jiri@resnulli.us>
To: Stephen Hemminger <shemminger@vyatta.com>
Cc: netdev@vger.kernel.org, davem@davemloft.net, mlindner@marvell.com,
        linux-kernel@vger.kernel.org
Subject: Re: [patch net] sky2: fix rx filter setup on link up
Message-ID: <20120917204724.GA1749@minipsycho.orion>
References: <1347894617-13614-1-git-send-email-jiri@resnulli.us>
 <20120917091214.5cd9b0f5@nehalam.linuxnetplumber.net>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20120917091214.5cd9b0f5@nehalam.linuxnetplumber.net>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Mon, Sep 17, 2012 at 06:12:14PM CEST, shemminger@vyatta.com wrote:
>On Mon, 17 Sep 2012 17:10:17 +0200
>Jiri Pirko <jiri@resnulli.us> wrote:
>
>> In my case I have following problem. sky2_set_multicast() sets registers
>> GM_MC_ADDR_H[1-4] correctly to:
>> 0000 0800 0001 0410
>> However, when adapter gets link and sky2_link_up() is called, the values
>> are for some reason different:
>> 0000 0800 0016 0410
>
>Rather than papering over the problem, it would be better to
>trace back what is setting those registers and fix that code.

Yes, I did that. No code at sky2.[ch] is writing to this registers other
than sky2_set_multicast() and sky2_gmac_reset() (I hooked on sky2_write*()).
So I strongly believe this is a HW issue (maybe only issue of my revision
"Yukon-2 EC chip revision 2")

>
>> This in my case prevents iface to be able to receive packets with dst mac
>> 01:80:C2:00:00:02 (LACPDU dst mac), which I set up previously by
>> SIOCADDMULTI.
>> 
>> So remember computed rx_filter data and write it to GM_MC_ADDR_H[1-4] on
>> link_up.
>>
>
>Please do some more root cause analysis. Just save/restoring the
>registers is just a temporary workaround.
