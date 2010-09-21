Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757733Ab0IUQId (ORCPT <rfc822;w@1wt.eu>);
	Tue, 21 Sep 2010 12:08:33 -0400
Received: from mail-fx0-f46.google.com ([209.85.161.46]:59462 "EHLO
	mail-fx0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754115Ab0IUQIb (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 21 Sep 2010 12:08:31 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=googlemail.com; s=gamma;
        h=message-id:date:from:user-agent:mime-version:to:cc:subject
         :references:in-reply-to:content-type:content-transfer-encoding;
        b=FDvmTHGKycYtwW+bvc+wP1um65/bXDCju0CdDH5pEVlwO00KW4KBPylH+oHHuo55xi
         0TBYESSHm+qOLeUcZhuLsSSA7kAcpKD2Iiq3Yt9mldmJWXqY03V4zqbERQ6SsLVBTdhv
         76kSsbfjgUjZ1pxTvHCgEPLU0+fqpGyitp0Rc=
Message-ID: <4C98D892.7030605@googlemail.com>
Date: Tue, 21 Sep 2010 18:08:50 +0200
From: Gabriel C <nix.or.die@googlemail.com>
User-Agent: Mozilla/5.0 (X11; U; Linux x86_64; en-US; rv:1.9.2.9) Gecko/20100913 Lanikai/3.1.3
MIME-Version: 1.0
To: Phil Turmel <philip@turmel.org>
CC: Alan Stern <stern@rowland.harvard.edu>, Jiri Kosina <jkosina@suse.cz>,
        Mat <jackdachef@gmail.com>, Guillaume Chazarain <guichaz@gmail.com>,
        linux-kernel@vger.kernel.org, Greg Kroah-Hartman <gregkh@suse.de>,
        Oliver Neukum <oliver@neukum.org>, Alan Ott <alan@signal11.us>,
        linux-usb@vger.kernel.org, linux-input@vger.kernel.org,
        Andreas Bombe <aeb@debian.org>, Alex Riesen <raa.lkml@gmail.com>
Subject: Re: [BUG, Regression, bisected] USB mouse causes bug on 1st insert,
 ignored on 2nd insert, lsusb stuck at usbdev_open
References: <Pine.LNX.4.44L0.1009211013460.1644-100000@iolanthe.rowland.org> <4C98C70B.3080407@turmel.org>
In-Reply-To: <4C98C70B.3080407@turmel.org>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 21.09.2010 16:54, Phil Turmel wrote:

> On 09/21/2010 10:30 AM, Alan Stern wrote:
>> On Tue, 21 Sep 2010, Jiri Kosina wrote:
>>
>>> I have just found out that it's actually CONFIG_USB_DYNAMIC_MINORS which 
>>> makes the difference. When unset, the problem doesn't trigger, and 
>>> usb_find_interface() always returns the proper interface. When 
>>> CONFIG_USB_DYNAMIC_MINORS is being used, the oops happen.
>>>
>>> I'll look into that.
>>
>> Apparently the problem is that intf->minors doesn't get initialized 
>> properly.  This patch should fix it.  Everybody, please try it out.
> 
> Yes, this works for me.  (as did Jiri's version.)


Both versions of the patch are working fine for me too also.

> 
> Thank you both for the support.
> 
> Feel free to add my:
> 
> Tested-by: Philip J. Turmel <philip@turmel.org>


And mine if you wish.
Tested-by: Gabriel Craciunescu  <nix.or.die@googlemail.com>

