Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751398Ab1JYED6 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 25 Oct 2011 00:03:58 -0400
Received: from mail-yw0-f46.google.com ([209.85.213.46]:45245 "EHLO
	mail-yw0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750926Ab1JYED4 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 25 Oct 2011 00:03:56 -0400
Content-Type: text/plain; charset=utf-8; format=flowed; delsp=yes
To: "Chris Friesen" <chris.friesen@genband.com>
Cc: linux-kernel@vger.kernel.org, "Jiri Kosina" <jkosina@suse.cz>,
        linux-input@vger.kernel.org, linux-usb@vger.kernel.org
Subject: Re: Linux USB HID should ignore values outside Logical
 Minimum/Maximum range
References: <op.v3q34la3dsdv5o@localhost> <4EA5913D.7090004@genband.com>
 <CACGt9ymGUAzjkZJCePnO+7cyKsi8-rtpno9ebjKtoCXj-tCALg@mail.gmail.com>
Date: Tue, 25 Oct 2011 02:03:50 -0200
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
From: =?utf-8?Q?Denilson_Figueiredo_de_S=C3=A1?= <denilsonsa@gmail.com>
Message-ID: <op.v3v2wozfdsdv5o@localhost>
In-Reply-To: <CACGt9ymGUAzjkZJCePnO+7cyKsi8-rtpno9ebjKtoCXj-tCALg@mail.gmail.com>
User-Agent: Opera Mail/11.51 (Linux)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 24 Oct 2011 14:39:31 -0200, Denilson Figueiredo de Sá wrote:
> On Mon, Oct 24, 2011 at 14:24, Chris Friesen wrote:
>> On 10/22/2011 05:42 AM, Denilson Figueiredo de Sá wrote:
>>
>>> It may even happen to send an out-of-range value for one axis, but a
>>> valid value for another axis. The code should be prepared for that
>>> (ignore one, but keep the other).
>>
>> In this case what should be used for the "invalid" axis value?  The  
>> previous value?

> I haven't tested that on Windows (yet), so I don't know how it
> behaves. If I test it, I'll post my results here.

I've modified the firmware of my device to do some more tests. I've  
modified it to send invalid values in X axis, but keep Y axis with valid  
values.

In Linux, the pointer moved to the right-most position of the screen  
(which is consistent with the behavior I previously described), not  
ignoring the out-of-range value.

In Windows, the pointer moved to the left-most position of the screen. It  
means Windows can't send a movement of only one axis, and fills the other  
axis with zero when receiving an invalid value. This behavior doesn't seem  
very helpful.


If anyone cares, this was the firmware modification for this test:
https://bitbucket.org/denilsonsa/atmega8-magnetometer-usb-mouse/changeset/31027323fa0b

-- 
Denilson Figueiredo de Sá
Rio de Janeiro - Brasil
