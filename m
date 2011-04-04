Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754783Ab1DDPIJ (ORCPT <rfc822;w@1wt.eu>);
	Mon, 4 Apr 2011 11:08:09 -0400
Received: from mail-qy0-f181.google.com ([209.85.216.181]:54861 "EHLO
	mail-qy0-f181.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754269Ab1DDPIH convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 4 Apr 2011 11:08:07 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=googlemail.com; s=gamma;
        h=mime-version:reply-to:in-reply-to:references:date:message-id
         :subject:from:to:cc:content-type:content-transfer-encoding;
        b=N25/OjOeIo8/ryCXo+MZvT4SQxLmx+f0HglFxIK3VNS0jyfcsHaN5J+Bs5CsVHYyQU
         k6ymJ+qT551HSHkXTITV+/a7OJYt8U/SwK3sw6KItDT/mYpyTUniH4eyO+QP+yX0rnFK
         wVZFAR3XgpJn2FmabfZi2aRog8dkp1YPMbFhY=
MIME-Version: 1.0
Reply-To: sedat.dilek@gmail.com
In-Reply-To: <1301929346.1941.32.camel@Joe-Laptop>
References: <BANLkTikr62YPeDnkL3DKA1Nts5aRFxsO6Q@mail.gmail.com>
	<20110404122225.GA15883@srcf.ucam.org>
	<1301921369.1941.29.camel@Joe-Laptop>
	<20110404130036.GB16669@srcf.ucam.org>
	<BANLkTimqp6FwLJP3d3dYcx7-Ut9pMjdtFA@mail.gmail.com>
	<BANLkTimvi53PWhN9HO4f04p_U-vae8D5Hw@mail.gmail.com>
	<1301929346.1941.32.camel@Joe-Laptop>
Date: Mon, 4 Apr 2011 17:08:05 +0200
Message-ID: <BANLkTik19DczZ9uoSQSvv_zpv5fpUR7kCw@mail.gmail.com>
Subject: Re: linux-next: Tree for April 4 [BROKEN thinkpad_acpi]
From: Sedat Dilek <sedat.dilek@googlemail.com>
To: Joe Perches <joe@perches.com>
Cc: Matthew Garrett <mjg@redhat.com>, Stephen Rothwell <sfr@canb.auug.org.au>,
        linux-next@vger.kernel.org, LKML <linux-kernel@vger.kernel.org>,
        platform-driver-x86 <platform-driver-x86@vger.kernel.org>,
        ibm-acpi@hmh.eng.br
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Apr 4, 2011 at 5:02 PM, Joe Perches <joe@perches.com> wrote:
> On Mon, 2011-04-04 at 16:44 +0200, Sedat Dilek wrote:
>> > I have tried with solution #2 as it partially restores old behaviour
>> > (patch is attached).
>
> Partially?  Please explain.
>
>

>From [1] (platform-drivers-x86.git#linux-next):
...
 #ifdef CONFIG_THINKPAD_ACPI_DEBUG
 #define vdbg_printk dbg_printk
 static const char *str_supported(int is_supported);
 #else
-#define vdbg_printk(a_dbg_level, format, arg...) \
-       do { } while (0)
+#define vdbg_printk(a_dbg_level, format, arg...)       \
+       no_printk(format, ##arg)
 #endif
...

- Sedat -

[1] http://git.kernel.org/?p=linux/kernel/git/mjg59/platform-drivers-x86.git;a=blobdiff;f=drivers/platform/x86/thinkpad_acpi.c;h=d8f3e653e96d8d5ad2081e4794a8f70f852b20de;hp=a08561f5349ef038decaf8edcd73528f30f056a9;hb=2af915b1eda9a671973256540035f8a6da1d57b4;hpb=1ba77972006a7ad5fed0811aac3fed724e7c5a04
