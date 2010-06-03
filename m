Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755403Ab0FCOnO (ORCPT <rfc822;w@1wt.eu>);
	Thu, 3 Jun 2010 10:43:14 -0400
Received: from mail-iw0-f174.google.com ([209.85.214.174]:62390 "EHLO
	mail-iw0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754563Ab0FCOnN convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 3 Jun 2010 10:43:13 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=mime-version:in-reply-to:references:date:message-id:subject:from:to
         :cc:content-type:content-transfer-encoding;
        b=B3xcj7THjtPtSAvTDwtk4n1MoxKiJ4uBVwZhaQbEQj+uTJ5x5JujVRh14ns9cFwPEr
         PSYoSuIhv5CWb1HdxxhVj6Dk6l4KpIY74XcLF32o6Ht/9mLIwQRzclyzHLMIdJQC0/eF
         4srkr8aPdHJpmJYgw/twrAUkSjQqBpgjDPdiU=
MIME-Version: 1.0
In-Reply-To: <20100603105438.7b8f3ee8@lxorguk.ukuu.org.uk>
References: <4C05F3BF.6090503@gmail.com>
	<AANLkTinyxtHQrsgvV0CMQZnyEelVnrpCTM05PLAj-ZYx@mail.gmail.com>
	<4C06ECAA.3060708@gmail.com>
	<4C06ED18.2010400@gmail.com>
	<4C06F1DD.8060004@gmail.com>
	<AANLkTilQuun1jQc394YM4QZtDSVeIwh67_Np0mkRDes4@mail.gmail.com>
	<4C06F6EA.6090701@gmail.com>
	<20100603013758.GA18755@srcf.ucam.org>
	<AANLkTik1cjxh1ItnqBXaxNcwa6we7ccJJZny-mAOAUjD@mail.gmail.com>
	<4C071048.9040209@gmail.com>
	<20100603021851.GA19546@srcf.ucam.org>
	<20100603105438.7b8f3ee8@lxorguk.ukuu.org.uk>
Date: Thu, 3 Jun 2010 08:43:11 -0600
Message-ID: <AANLkTin-x9bkzWO6jgKd4dbB10uzhbJQUlN9rnGnFHFI@mail.gmail.com>
Subject: Re: [PATCH]X86:reboot.c Add some dmi entries to pci_reboot_dmi_table.
From: Robert Hancock <hancockrwd@gmail.com>
To: Alan Cox <alan@lxorguk.ukuu.org.uk>
Cc: Matthew Garrett <mjg59@srcf.ucam.org>,
       "Justin P. Mattock" <justinmattock@gmail.com>, x86@kernel.org,
       tglx@linutronix.de, linux-kernel@vger.kernel.org
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Jun 3, 2010 at 3:54 AM, Alan Cox <alan@lxorguk.ukuu.org.uk> wrote:
> On Thu, 3 Jun 2010 03:18:51 +0100
> Matthew Garrett <mjg59@srcf.ucam.org> wrote:
>
>> On Wed, Jun 02, 2010 at 07:15:36PM -0700, Justin P. Mattock wrote:
>> > as soon as I change:
>> >
>> > int main() {
>> >     iopl(3);
>> >     outb(6, 0xcf9);
>> >     usleep(100);
>> >     outb(6, 0xcf9);
>> >     return 0;
>> > }
>> > (the above gave a command prompt
>> > with numerous tries)
>>
>> Ok, so it's not that straghtforward. Sigh. There's various hacky
>> workarounds we could do here, but Windows doesn't seem to do them so I
>> lean towards suspecting that there's something wrong with our keyboard
>> controller reboot mechanism. I'll try doing some more tracing.
>
> At least some PCs you need to issue the reboot outb calls on the boot
> processor so the userspace tests won't be reliable.

In that case you could presumably run them:

taskset 0x00000001 (program name)

and see if that changes anything.
