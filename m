Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751824Ab0KWEa6 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 22 Nov 2010 23:30:58 -0500
Received: from mail-wy0-f174.google.com ([74.125.82.174]:47281 "EHLO
	mail-wy0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751017Ab0KWEa4 convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 22 Nov 2010 23:30:56 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=mime-version:sender:in-reply-to:references:date
         :x-google-sender-auth:message-id:subject:from:to:cc:content-type
         :content-transfer-encoding;
        b=MN/T48E2cQzxBH7NjBPFuCKx8ARpP5aDDFL6rP7CFd9mE09WxXFCRmVzOoCziiPAjO
         s4jsf2XBq9l1b4Iw0Ufj+FVpo3KnAqI9Ct/PBNOMqiJoeQ2KEGJD9u97OMYityJJavXp
         3sbX4eHy9fgqWwVmNnPUOZo9BOw1vSvXsmr1g=
MIME-Version: 1.0
In-Reply-To: <AANLkTimCBX7FSBByeOmCp_ofYvmFeE8OF85OzB5tfjhw@mail.gmail.com>
References: <1290470763.3008.252.camel@localhost>
	<AANLkTi=MM-GVGcswHfLXE-6JFHiXUT4k-wt61rqwkjAf@mail.gmail.com>
	<AANLkTimCBX7FSBByeOmCp_ofYvmFeE8OF85OzB5tfjhw@mail.gmail.com>
Date: Tue, 23 Nov 2010 13:30:54 +0900
X-Google-Sender-Auth: VPVhPKCP-WpiqDazSkjUaJiyuZk
Message-ID: <AANLkTikbHsOpv858ts-h9oB8NvK+Tk6wf9sX8HWfecqD@mail.gmail.com>
Subject: Re: [RFC] persistent store
From: Kyungmin Park <kmpark@infradead.org>
To: Tony Luck <tony.luck@intel.com>
Cc: Jim Keniston <jkenisto@linux.vnet.ibm.com>, linux-kernel@vger.kernel.org
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Nov 23, 2010 at 12:10 PM, Tony Luck <tony.luck@intel.com> wrote:
> On Mon, Nov 22, 2010 at 5:37 PM, Tony Luck <tony.luck@intel.com> wrote:
>> Yes - I assume here that the last "data_size" bytes will be enough
>> to be useful. But in your case it most likely won't be.  You could
>> lie about how much space you allow and then include some oops
>> parsing code to get the vital bits out of what is passed to you. Not
>> pretty - but it would work. If there are many such devices with limited
>> capacity, then it would make sense to include this parsing code
>> in this generic layer.
>
> Sorry - finding the good bits from the console log is architecture
> dependent ... so it can't be done (easily) in the generic code.

FYI:

Now we use ramoops for this purpose. Even tough ramoops uses volatile
memory, it's safe soft-reset and watchdog reset.
To overcome limiataion of ramoops. not persist, I'm working on mmcoops
as persistent oops record.

As the discussed story. it covers the previous oops devices,
mtdoops(drivers/mtd/mtdoops.c), ramoops (drivers/char/ramoops.c) and
mmcoops (drivers/mmc/card/mmc_oops.c).

Actually I tried to enable the lcdoops, display oops message at LCD.
but it doesn't work since not much time to display LCD.

Thank you,
Kyungmin Park


>
> -Tony
> --
> To unsubscribe from this list: send the line "unsubscribe linux-kernel" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
> Please read the FAQ at  http://www.tux.org/lkml/
>
