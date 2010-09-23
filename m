Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756744Ab0IWXkM (ORCPT <rfc822;w@1wt.eu>);
	Thu, 23 Sep 2010 19:40:12 -0400
Received: from core.signal11.us ([64.251.29.136]:37827 "EHLO core.signal11.us"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756730Ab0IWXkJ (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 23 Sep 2010 19:40:09 -0400
Message-ID: <4C9BE552.6080404@signal11.us>
Date: Thu, 23 Sep 2010 19:40:02 -0400
From: Alan Ott <alan@signal11.us>
User-Agent: Mozilla/5.0 (X11; U; Linux x86_64; en-US; rv:1.9.1.10) Gecko/20100528 Thunderbird/3.0.5
MIME-Version: 1.0
To: Ville Tervo <ville.tervo@nokia.com>
Cc: Jiri Kosina <jkosina@suse.cz>,
        Stefan Achatz <erazor_de@users.sourceforge.net>,
        Antonio Ospite <ospite@studenti.unina.it>,
        Alexey Dobriyan <adobriyan@gmail.com>, Tejun Heo <tj@kernel.org>,
        Alan Stern <stern@rowland.harvard.edu>,
        Greg Kroah-Hartman <gregkh@suse.de>,
        Marcel Holtmann <marcel@holtmann.org>,
        Stephane Chatty <chatty@enac.fr>, Michael Poole <mdpoole@troilus.org>,
        "David S. Miller" <davem@davemloft.net>,
        Bastien Nocera <hadess@hadess.net>,
        Eric Dumazet <eric.dumazet@gmail.com>,
        "linux-input@vger.kernel.org" <linux-input@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "linux-usb@vger.kernel.org" <linux-usb@vger.kernel.org>,
        "linux-bluetooth@vger.kernel.org" <linux-bluetooth@vger.kernel.org>,
        "netdev@vger.kernel.org" <netdev@vger.kernel.org>
Subject: Re: [PATCH v4 0/2] Get and Set Feature Reports on HIDRAW (USB and   Bluetooth)
References: <1281442367.12579.206.camel@localhost.localdomain> <1281990059-3562-1-git-send-email-alan@signal11.us> <20100923162521.GA15641@null>
In-Reply-To: <20100923162521.GA15641@null>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
X-DSPAM-Result: Whitelisted
X-DSPAM-Processed: Thu Sep 23 19:40:07 2010
X-DSPAM-Confidence: 0.9899
X-DSPAM-Probability: 0.0000
X-DSPAM-Signature: 4c9be557274477486663427
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 09/23/2010 12:25 PM, Ville Tervo wrote:
> Hi Alan,
>
> On Mon, Aug 16, 2010 at 10:20:57PM +0200, ext Alan Ott wrote:
>    
>> This is version 4. Built against 2.6.35+ revision 320b2b8de12698 .
>>      
>
> I gave a try to to this patch using your test tool [1] and very old BT
> keyboard. I don't have anything else ATM to test with. Is there some BT hid
> devices which support setting and getting features?
>    

A keyboard is the only BT device I've used which has feature reports.

> Shouldn't HIDIOCSFEATURE's bt version have similar wait as HIDIOCGFEATURE to
> get report status back from the device? or is there even any status coming back
> in successful case? Sorry I'm a newbie with HID and trying to understand how
> this should work.
>
> Now it just returns num of send bytes even if the remote device returned some
> error. Which one is the expected behavior?
>    

I made it function the same as the existing hidp_output_raw_report(). 
Nothing in net/bluetooth/hidp/core.c is acked at all. I'm not sure of 
the reasons.

Jiri, Marcel, any ideas?

> Other problem is that Get report is getting now handshake from set report.
>
>
>    

Yeah, that makes sense. I hadn't considered the set_report failing. In 
that case, I guess it means we _must_ wait for an ack for sent packets.

Anyone else agree or disagree?

Alan.


