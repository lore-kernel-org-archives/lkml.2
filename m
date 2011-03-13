Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755559Ab1CMSNM (ORCPT <rfc822;w@1wt.eu>);
	Sun, 13 Mar 2011 14:13:12 -0400
Received: from mail-ww0-f44.google.com ([74.125.82.44]:60554 "EHLO
	mail-ww0-f44.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751378Ab1CMSNK (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 13 Mar 2011 14:13:10 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=googlemail.com; s=gamma;
        h=sender:message-id:date:from:reply-to:user-agent:mime-version:to:cc
         :subject:references:in-reply-to:content-type
         :content-transfer-encoding;
        b=bfN6Ict4t+z7c2/57WD7agTl1Z44x/tcbbMwBzKF+1+PfPdEUbZi+yQG0v2nPW/aUe
         lGGbpguUZh/STwKP9vV9/jr7lV8FdOWtahDbf9hTYSd16ofWNCDDIB+/g/I9tkvlkIrX
         MJjahweBSyKIBacdoiBOA7Nfc5IIsCfEvQBAA=
Message-ID: <4D7D0933.9010502@linaro.org>
Date: Sun, 13 Mar 2011 18:13:07 +0000
From: Andy Green <andy@warmcat.com>
Reply-To: andy.green@linaro.org
User-Agent: Mozilla/5.0 (X11; U; Linux x86_64; en-US; rv:1.9.2.14) Gecko/20110302 Fedora/3.1.8-3.fc16 Thunderbird/3.1.8
MIME-Version: 1.0
To: Greg KH <greg@kroah.com>
CC: "Rafael J. Wysocki" <rjw@sisk.pl>, linux-usb@vger.kernel.org,
        linux-kernel@vger.kernel.org, patches@linaro.org
Subject: Re: [RFC PATCH 3/4] PLATFORM: Introduce async platform_data attach
 api
References: <20110312222633.27020.19543.stgit@otae.warmcat.com> <201103131141.07380.rjw@sisk.pl> <4D7CB15A.6030203@linaro.org> <201103131353.54612.rjw@sisk.pl> <4D7CC4D0.90305@linaro.org> <20110313161528.GB10718@kroah.com> <4D7CFB3B.8060008@linaro.org> <20110313174811.GA11504@kroah.com>
In-Reply-To: <20110313174811.GA11504@kroah.com>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 03/13/2011 05:48 PM, Somebody in the thread at some point said:
> On Sun, Mar 13, 2011 at 05:13:31PM +0000, Andy Green wrote:
>> So when there's a bit more of Device Tree in evidence, are you going
>> to accept Device-tree based patches in usbnet etc along these lines,
>> or does that trigger the "do it in userspace" response, in which
>> case we are both wasting each others' time continuing to discuss
>> this at all?
>
> As mentioned numerous times before, network naming stuff happens in
> userspace, not in the kernel, so no matter what infrastructure is added,

The naming of that network interface happens in smsc95xx, in kernel: it 
uses a dodgy heuristic to choose between usb%d eth%d and others and gets 
it wrong in this case due to stuff outside its view.  There's nothing 
golden and wonderful about that which needs protecting from outside hints.

> insisting on naming the network device 'eth0' is not going to happen
> within the kernel.  Please use the tools we have today to do this with
> no kernel changes.
>
> As for other changes, it all depends on what you need to accomplish,
> right?  Those will be gladly reviewed on a case-by-case basis.

The immediate thing I would have liked to accomplish is to help smsc95xx 
make the right decision about naming and to use the MAC address in 
platform_data.  It seemed this was a general issue though, so I 
generalized how it was done.  But I don't have examples on my desk of 
boards with soldered-on USB other than smsc95xx Ethernet bridge.

At least, I am grateful we get down to brass tacks now and you clearly 
reject allowing the driver to take guidance to act more appropriately 
for its environment in the first place.  Therefore, this won't get fixed 
by Device Tree either.

So, we don't need to discuss this any further: thanks again for your time.

-Andy
