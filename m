Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756355Ab0KWTES (ORCPT <rfc822;w@1wt.eu>);
	Tue, 23 Nov 2010 14:04:18 -0500
Received: from mail-qw0-f46.google.com ([209.85.216.46]:52751 "EHLO
	mail-qw0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755486Ab0KWTEO convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 23 Nov 2010 14:04:14 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=mime-version:in-reply-to:references:date:message-id:subject:from:to
         :cc:content-type:content-transfer-encoding;
        b=rsF16oGH//5lUAQ7xofBiTFup9IsbUQqjL/JdiCZY5Q9tzOVFL8T+9u47sVJ/Dlxdg
         4pjKbo21pzM/KOQHccVXcSV+plviwwsYtSw8vaZXLVnLm9ptOX/yiw7C73YsW8c9qKRw
         BPU3QP5tpedeoIg2wDEDrEpcqwxspG5Il6u80=
MIME-Version: 1.0
In-Reply-To: <20101123091551.f3ed937f.randy.dunlap@oracle.com>
References: <20101123140609.2b6503ff.sfr@canb.auug.org.au>
	<AANLkTi===xonvuovLS5Ch=coMDjzLQ4XSsPRDowDJ4L2@mail.gmail.com>
	<20101123091551.f3ed937f.randy.dunlap@oracle.com>
Date: Tue, 23 Nov 2010 20:04:12 +0100
Message-ID: <AANLkTikLJW0be+kVgEnAZDbiDMVbYOrA7f5VYs+KHSe_@mail.gmail.com>
Subject: Re: linux-next: Tree for November 23
From: Zimny Lech <napohybelskurwysynom2010@gmail.com>
To: Randy Dunlap <randy.dunlap@oracle.com>
Cc: Stephen Rothwell <sfr@canb.auug.org.au>, linux-next@vger.kernel.org,
        LKML <linux-kernel@vger.kernel.org>, linux-scsi@vger.kernel.org
Content-Type: text/plain; charset=ISO-8859-2
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

2010/11/23 Randy Dunlap <randy.dunlap@oracle.com>:
> On Tue, 23 Nov 2010 16:43:22 +0100 Zimny Lech wrote:
>
>> Ave
>>
>> 2010/11/23 Stephen Rothwell <sfr@canb.auug.org.au>:
>> > Hi all,
>> >
>> > Changes since 20101122:
>> >
>>
>>
>> Random config generator has failed :)
>
> Hi,
> What do you mean by this?

This is what I get from "make" after "make randconfig".

>  I'm not seeing any randconfig generator problems.
> Are you using any options or inputs to kconfig?

No.

I'm using script below to build kernel - nothing really unusual. Log
and config for this failed build are attached to previous email

import os, sys, time
from hexer_io import *

class BuildKernel:
        def __init__(self, options, config):
                self.options = options
                self.config = config
                self.timestamp = ""

        def generate_timestamp(self):
                self.timestamp = time.strftime("%y-%m-%d-%H-%M-%S",
time.gmtime())
                print("timestamp = " + self.timestamp)

        def check_dirs(self):
                if not os.path.isdir(self.config["KERNEL_DIR"]):
                        print("KERNEL_DIR=" +
self.config["KERNEL_DIR"] + " doesn't exist")
                        sys.exit(1)
                if not os.path.isdir(self.config["KERNEL_OBJ_DIR"]):
                        print("KERNEL_OBJ_DIR=" +
self.config["KERNEL_OBJ_DIR"] + " doesn't exist")
                        sys.exit(1)
                if not os.path.isdir(self.config["HEXER_DIR"] + "/builds/"):
                        os.system("mkdir " + self.config["HEXER_DIR"]
+ "/builds/")

        def kernel_make_mrproper(self):
                print("make mrproper")
                os.system("cd " + self.config["KERNEL_DIR"] + " &&
LANG=\"C\" make mrproper &> /dev/null")
                os.system("cd " + self.config["KERNEL_DIR"] + " &&
LANG=\"C\" make O=" + self.config["KERNEL_OBJ_DIR"] + " mrproper &>
/dev/null")

        def kernel_make_clean(self):
                print("make clean")
                os.system("cd " + self.config["KERNEL_DIR"] + " &&
LANG=\"C\" make O=" + self.config["KERNEL_OBJ_DIR"] + " clean &>
/dev/null")

        def kernel_make_randconfig(self):
                print("make randconfig")
                os.system("cd " + self.config["KERNEL_DIR"] + " &&
LANG=\"C\" make O=" + self.config["KERNEL_OBJ_DIR"] + " randconfig &>
/dev/null")
                os.system("cp " + self.config["KERNEL_OBJ_DIR"] +
"/.config " + self.config["HEXER_DIR"] + "/builds/" + self.timestamp +
"-config")

        def kernel_make(self):
                print("make")
                os.system("cd " + self.config["KERNEL_DIR"] + " &&
LANG=\"C\" make O=" + self.config["KERNEL_OBJ_DIR"] + " &> " +
self.config["HEXER_DIR"] + "/builds/" + self.timestamp + "-buildlog")

        def build_random_kernel(self, loop):
                while True:
                        IOStopFile.get_stop_file(self.config)
                        self.generate_timestamp()
                        #self.kernel_make_clean()
                        self.kernel_make_randconfig()
                        self.kernel_make()
                        if not loop:
                                break

        def build(self):
                self.kernel_make_mrproper()
                if self.options.mode == "brk":
                        self.build_random_kernel(self.options.loop)

        def run(self):
                self.check_dirs()
                self.build()


>
>
>> USB Gadget Support (USB_GADGET) [Y/n/?] y
>>   Debugging messages (DEVELOPMENT) (USB_GADGET_DEBUG) [Y/n/?] y
>>   Debugging information files (DEVELOPMENT) (USB_GADGET_DEBUG_FILES) [N/y/?] n
>>   Debugging information files in debugfs (DEVELOPMENT)
>> (USB_GADGET_DEBUG_FS) [Y/n/?] y
>>   Maximum VBUS Power usage (2-500 mA) (USB_GADGET_VBUS_DRAW) [2] 2
>>   USB Peripheral Controller
>>   > 1. Renesas R8A66597 USB Peripheral Controller (USB_GADGET_R8A66597)
>>     2. Renesas M66592 USB Peripheral Controller (USB_GADGET_M66592)
>>   choice[1-2?]: 1
>>   USB Gadget Drivers
>>     1. Gadget Zero (DEVELOPMENT) (USB_ZERO)
>>     2. Audio Gadget (EXPERIMENTAL) (USB_AUDIO)
>>   > 3. Ethernet Gadget (with CDC Ethernet support) (USB_ETH)
>>     4. Serial Gadget (with CDC ACM and CDC OBEX support) (USB_G_SERIAL)
>>     5. Printer Gadget (USB_G_PRINTER)
>>     6. CDC Composite Device (Ethernet and ACM) (USB_CDC_COMPOSITE)
>>     7. HID Gadget (USB_G_HID)
>>     8. EHCI Debug Device Gadget (USB_G_DBGP)
>>   choice[1-8?]: 3
>>     RNDIS support (USB_ETH_RNDIS) [Y/n/?] (NEW) aborted!
>>
>> Console input/output is redirected. Run 'make oldconfig' to update
>> configuration.
>>
>> make[3]: *** [silentoldconfig] Error 1
>> make[2]: *** [silentoldconfig] Error 2
>> make[1]: *** No rule to make target `include/config/auto.conf', needed
>> by `include/config/kernel.release'.  Stop.
>> make: *** [sub-make] Error 2
>
>
> ---
> ~Randy
> *** Remember to use Documentation/SubmitChecklist when testing your code ***
>



-- 
Slawa!
N.P.S.

Chwa³a tobie, Szatanie, cze¶æ na wysoko¶ciach
Nieba, gdzie królowa³e¶, chwa³a w g³êboko¶ciach
Piek³a, gdzie zwyciê¿ony, trwasz w dumnym milczeniu!
Uczyñ, niechaj ma dusza spocznie z Tob± w cieniu
Drzewa Wiedzy, gdy swoje konary rozwinie,
Jak sklepienie ko¶cio³a, który nie przeminie!
