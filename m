Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757642Ab1DJROd (ORCPT <rfc822;w@1wt.eu>);
	Sun, 10 Apr 2011 13:14:33 -0400
Received: from mail-qw0-f46.google.com ([209.85.216.46]:49412 "EHLO
	mail-qw0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754720Ab1DJROc convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 10 Apr 2011 13:14:32 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=mime-version:date:message-id:subject:from:to:content-type
         :content-transfer-encoding;
        b=TnEQcRPGxw9p2CBZHl8JUp0hfJgy532vdo7UM7PoGV3dzqWlGV/XfnfQVfBAao8Ouy
         El6cfbq9iDQlF48JsjpsY24xW3incXbwh/voZJM5g3As23FRKphOV4UFev/T7lWLd7F8
         tmDhFvm4uJifRkWOv8AOBF5u2ZFbahSeSZ6Nw=
MIME-Version: 1.0
Date: Sun, 10 Apr 2011 19:14:31 +0200
Message-ID: <BANLkTi=n+ckDXVk6rN=Mgh+BApbrPqPfmg@mail.gmail.com>
Subject: Crash with kfree(null) on MacBook? kobject_set_name_vargs
From: =?UTF-8?B?UmFmYcWCIE1pxYJlY2tp?= <zajec5@gmail.com>
To: Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        Andy Botting <andy@andybotting.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

I'm writing new axi bus driver and one of the early testers reported
it crashing for him. Andy is using MacBook and backtrace+debugging
pretty clearly point to kfree being called on null string.

The most interesting part of code is:
axi_info("[axi_register_cores][%d] current name: %s\n", i, core->dev.kobj.name);
axi_info("[axi_register_cores][%d] calling dev_set_name with %d, %d
for 0x%03X\n", i, 0/*bus->busnumber*/, dev_id, core->id.id);
err = dev_set_name(&core->dev, "axi%d:%d", 0/*bus->busnumber*/, dev_id);
axi_info("[axi_register_cores][%d] dev_set_name result: %d\n", i, err);

The result is:
[axi_register_cores][1] current name: (null)
[axi_register_cores][1] calling dev_set_name with 0, 0 for 0x812
BUG: unable to handle kernel paging request at ffffeba400000000
IP: [<ffffffff8108c4d4>] kfree+0x2a/0x8a

Whole code: http://pastie.org/1779473
Whole result: http://pastie.org/1779416

Can you help me with this issue, please? On my machine everything goes fine:
[axi_register_cores][1] current name: (null)
[axi_register_cores][1] calling dev_set_name with 0, 0 for 0x812
[axi_register_cores][1] dev_set_name result: 0
[axi_register_cores][1] Register dev for core 0x812

bcopeland on #linux-wireless suggested turning on SLAB or SLUB. Is
this going to provide some interesting info?

-- 
Rafał
