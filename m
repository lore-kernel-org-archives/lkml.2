Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757331Ab2ENRSe (ORCPT <rfc822;w@1wt.eu>);
	Mon, 14 May 2012 13:18:34 -0400
Received: from diyaorg.dp.ua ([82.207.88.73]:34672 "EHLO diyaorg.dp.ua"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755420Ab2ENRSd (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 14 May 2012 13:18:33 -0400
Message-ID: <4FB13E43.5050604@oscada.org>
Date: Mon, 14 May 2012 20:17:55 +0300
From: Roman Savochenko <rom_as@oscada.org>
User-Agent: Mozilla/5.0 (X11; Linux i686; rv:10.0.3) Gecko/20120426 Thunderbird/10.0.3
MIME-Version: 1.0
To: linux-kernel@vger.kernel.org
Subject: Re: Regression-broken V4L2 radio API for BTTV cards (PV951)
References: <4EE9EB08.7060701@oscada.org>
In-Reply-To: <4EE9EB08.7060701@oscada.org>
Content-Type: text/plain; charset=KOI8-U; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 15.12.11 14:41, Roman Savochenko wrote:
> Start from kernel 2.6.39 my TV card's PV951 radio is not work.
> On 2.6.38 it still fine work and form 2.6.39 to present it is not.
> I have seen to source's different for BTTV code from 2.6.38 to 2.6.39
> and have not seen any functional changes then the problem is generic for
> radio API.
The problem appear by partial check for option "bttv radio=1". For that 
option /dev/radio0 is created but checking for radio into function 
check_mode() see only to device's flag ".has_radio", which clear for 
"ProVideo PV951 (42)" card.

Replacing card to "Pace TV & Radio Card (101)" resolve the problem for me.

I think for fix that behavior need set flag ".has_radio" or RADIO mask 
for flag "bttv radio=1".

Regards, Roman
