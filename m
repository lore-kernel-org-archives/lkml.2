Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932832Ab2EPCQ1 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 15 May 2012 22:16:27 -0400
Received: from rtits2.realtek.com ([60.250.210.242]:54725 "EHLO
	rtits2.realtek.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1758348Ab2EPCQ0 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 15 May 2012 22:16:26 -0400
X-SpamFilter-By: BOX Solutions SpamTrap 5.19 with qID q4G2G9YP009285, This message is released by code: ctaloc0852
Message-ID: <4FB30DE9.8040406@realsil.com.cn>
Date: Wed, 16 May 2012 10:16:09 +0800
From: edwin_rong <edwin_rong@realsil.com.cn>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:12.0) Gecko/20120430 Thunderbird/12.0.1
MIME-Version: 1.0
To: Greg KH <gregkh@linuxfoundation.org>
CC: "gregkh@suse.de" <gregkh@suse.de>,
        "devel@linuxdriverproject.org" <devel@linuxdriverproject.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH] staging: update TODO files for rts5139 & rts_pstor
References: <1337049392-8544-1-git-send-email-edwin_rong@realsil.com.cn> <20120515153931.GA25240@kroah.com>
In-Reply-To: <20120515153931.GA25240@kroah.com>
Content-Type: text/plain; charset="GB2312"
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 05/15/2012 11:39 PM, Greg KH wrote:
> On Tue, May 15, 2012 at 10:36:32AM +0800, edwin_rong@realsil.com.cn wrote:
>> From: edwin_rong <edwin_rong@realsil.com.cn>
>>
>> Recently we find that many warm-hearted people are helping improving the
>> coding style and something else of driver rts5139 & rts_pstor, which will
>> be replaced with one new refactored uniform Realtek cardreader driver in
>> the future, update the TODO file to inform people not to do modifications
>> to both of the drivers any more to avoid wasting their time and energy.
> Is there anything that you can point people to today for this "new
> driver"?  Given that there is no other driver at this point in time, I
> don't blame people for fixing up this one to work properly.  So until we
> see a new driver, I don't feel comfortable asking people to stop working
> here, do you?
>
> thanks,
>
> greg k-h
Hi Greg,

No, it's not polite to stop people helping you do some fixing work. I
totally agree your point, but my original purpose is to avoid people
wasting their time and energy :-)

About the "new driver", we make significant modifications and re-design
it with Object-Oriented theory, which is adopted in kernel everywhere.
We divide the driver into several portions: . "card component", which is
used to implement all kinds of card protocols in h/w-independent way;
."card manager component" which manipulate all the cardreader supported
cards; ."card reader component" which is responsible for concrete
operations of IC; ."scsi component", whose work is to accept SCSI
commands from SCSI subsystem and forward them to "card component" for
further process, and ."transport component" which hidden the specfic
physical interface from the compoents mentioned above.

As you have seen that there's 2 drivers "rts5139" and "rts_pstor" under
staging folder in Linux kernel code, the former drives USB-based card
reader, while the later supports PCIe-based card reader and both of them
are driver-based driver, which implement SD/MS/xD card protocol,
respectively, to support these series of cards. In fact, It doesn't need
to do so, since they are standard protocols, if we implement them in a
hardware-independent way, it can be reused, which decreases code redundance.

Also, we have to consider expansion issue of the driver, since our
company will design out new card reader ICs. Actually, the "new driver"
could, to some degree, be treated as an subsystem which supports all
Realtek cardreader ICs.


Thanks & BRs
Edwin


