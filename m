Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756210Ab0IUOyU (ORCPT <rfc822;w@1wt.eu>);
	Tue, 21 Sep 2010 10:54:20 -0400
Received: from atl.turmel.org ([74.117.157.138]:57360 "EHLO atl.turmel.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751413Ab0IUOyS (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 21 Sep 2010 10:54:18 -0400
Message-ID: <4C98C70B.3080407@turmel.org>
Date: Tue, 21 Sep 2010 10:54:03 -0400
From: Phil Turmel <philip@turmel.org>
User-Agent: Mozilla/5.0 (X11; U; Linux x86_64; en-US; rv:1.9.2.9) Gecko/20100916 Lightning/1.0b2 Thunderbird/3.1.3
MIME-Version: 1.0
To: Alan Stern <stern@rowland.harvard.edu>
CC: Jiri Kosina <jkosina@suse.cz>, Mat <jackdachef@gmail.com>,
        Guillaume Chazarain <guichaz@gmail.com>, linux-kernel@vger.kernel.org,
        Greg Kroah-Hartman <gregkh@suse.de>, Oliver Neukum <oliver@neukum.org>,
        Alan Ott <alan@signal11.us>, linux-usb@vger.kernel.org,
        linux-input@vger.kernel.org, Andreas Bombe <aeb@debian.org>,
        Alex Riesen <raa.lkml@gmail.com>,
        Gabriel C <nix.or.die@googlemail.com>
Subject: Re: [BUG, Regression, bisected] USB mouse causes bug on 1st insert,
 ignored on 2nd insert, lsusb stuck at usbdev_open
References: <Pine.LNX.4.44L0.1009211013460.1644-100000@iolanthe.rowland.org>
In-Reply-To: <Pine.LNX.4.44L0.1009211013460.1644-100000@iolanthe.rowland.org>
X-Enigmail-Version: 1.1.2
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 09/21/2010 10:30 AM, Alan Stern wrote:
> On Tue, 21 Sep 2010, Jiri Kosina wrote:
> 
>> I have just found out that it's actually CONFIG_USB_DYNAMIC_MINORS which 
>> makes the difference. When unset, the problem doesn't trigger, and 
>> usb_find_interface() always returns the proper interface. When 
>> CONFIG_USB_DYNAMIC_MINORS is being used, the oops happen.
>>
>> I'll look into that.
> 
> Apparently the problem is that intf->minors doesn't get initialized 
> properly.  This patch should fix it.  Everybody, please try it out.

Yes, this works for me.  (as did Jiri's version.)

Thank you both for the support.

Feel free to add my:

Tested-by: Philip J. Turmel <philip@turmel.org>
