Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755231Ab1BVTds (ORCPT <rfc822;w@1wt.eu>);
	Tue, 22 Feb 2011 14:33:48 -0500
Received: from mail-qy0-f181.google.com ([209.85.216.181]:62177 "EHLO
	mail-qy0-f181.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751985Ab1BVTdr convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 22 Feb 2011 14:33:47 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=mime-version:in-reply-to:references:date:message-id:subject:from:to
         :cc:content-type:content-transfer-encoding;
        b=BGN5/o59cJS3wKwhmsNQFRe3T+AjDWXhAlfs/ZTvf7RKr3BSgEj2krYkyJCYFmjw9R
         iuv1htW0Dnjua2H6MbjYY3wxzJhE5WoPCHYKcGxYfe6Fk7gZsKR23B/Nhpapws+07FoV
         aflQJ0oUKayOAkueVSxT+ShZD9kddUZCHd03M=
MIME-Version: 1.0
In-Reply-To: <1298382263.6140.1196.camel@gandalf.stny.rr.com>
References: <1298380368.6140.1193.camel@gandalf.stny.rr.com>
	<1298381695.2211.486.camel@localhost>
	<1298382263.6140.1196.camel@gandalf.stny.rr.com>
Date: Tue, 22 Feb 2011 20:33:45 +0100
Message-ID: <AANLkTinNUnq7JQDpTzCv24A7T7fMn9iPFisQEBZGkELr@mail.gmail.com>
Subject: Re: [PATCH] rt2x00: Use ops name instead of device name
From: Ivo Van Doorn <ivdoorn@gmail.com>
To: Steven Rostedt <rostedt@goodmis.org>
Cc: Ben Hutchings <bhutchings@solarflare.com>,
        LKML <linux-kernel@vger.kernel.org>, netdev <netdev@vger.kernel.org>,
        Felix Fietkau <nbd@openwrt.org>,
        "John W. Linville" <linville@tuxdriver.com>, abogani@texware.it
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi,

On Tue, Feb 22, 2011 at 2:44 PM, Steven Rostedt <rostedt@goodmis.org> wrote:
> On Tue, 2011-02-22 at 13:34 +0000, Ben Hutchings wrote:
>
>> > 19:   73474106          0   IO-APIC-fasteoi   ata_piix, uhci_hcd:usb6, 0000:05:01.0
>
>> >     rt2x00dev->irq = pci_dev->irq;
>> > -   rt2x00dev->name = pci_name(pci_dev);
>> > +   rt2x00dev->name = ops->name;
>
>
>> But then how can users distinguish the IRQs for multiple devices handled
>> by the same driver?  (Probably unusual for WLAN devices, but still
>> possible.)
>>
>> I assume you can't use a net device name as there may be multiple net
>> devices per bus device?
>
> Honestly, I do not know this code well enough, but this patch seemed to
> solve the problem at hand. Hence I sent it out to the experts hoping
> they either take this patch or come up with a proper solution ;)
>
> In any case, just posting the pci address is not a pretty answer.

I just checked the other wireless drivers, and they all seem to use
the modulename. So I guess your patch is correct. You can add my:

Acked-by: Ivo van Doorn <IvDoorn@gmail.com>
