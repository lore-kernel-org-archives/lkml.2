Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754058Ab2IOOyg (ORCPT <rfc822;w@1wt.eu>);
	Sat, 15 Sep 2012 10:54:36 -0400
Received: from nm39-vm6.bullet.mail.ne1.yahoo.com ([98.138.229.166]:20079 "HELO
	nm39-vm6.bullet.mail.ne1.yahoo.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with SMTP id S1753544Ab2IOOyf convert rfc822-to-8bit
	(ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sat, 15 Sep 2012 10:54:35 -0400
X-Greylist: delayed 349 seconds by postgrey-1.27 at vger.kernel.org; Sat, 15 Sep 2012 10:54:34 EDT
X-Yahoo-Newman-Property: ymail-3
X-Yahoo-Newman-Id: 935874.7922.bm@omp1011.mail.ne1.yahoo.com
DomainKey-Signature: a=rsa-sha1; q=dns; c=nofws;
  s=s1024; d=yahoo.com;
  h=X-YMail-OSG:Received:X-Mailer:Message-ID:Date:From:Reply-To:Subject:To:Cc:MIME-Version:Content-Type:Content-Transfer-Encoding;
  b=pXMQNK8LK6S/GVOSXnKHtke5jhsLcYxg0IDJ5llCUd5BqecI7jQok5mg8vIcQyiLSjSjo568mT886HDirzpTE4wSn871Iy4Nr5mVYqX1/6Azcnm5OZn3GcJoVGKYxnliM/YqKMs7kNGDSMAkg9+/cr2ZV1OXjjVKHdS9/Y1LKm4=;
X-YMail-OSG: _BucvWoVM1lJqOFr.ff8_RD_6E6v5ztZukZJmKhGUByIFrn
 6JyC88LO2VbP11CSulCEhMTpj2kUXTBzWPIFd_9OmhTaHqyuT8_UcmRMa.If
 VlGl6fBeNjDkxAcmfEDIfGzOZ.9FZjwLpvMVrqxFlLNOMtM8AjEUBQFYTcl.
 bqT8ZxdNDopZN2pdywuE3vWJMAvwAXw7bAtJqv9i.8lkVeB_8IejzV6.XcnA
 sQiPfH8y1suzHTKc.d1STGGhVjEbSMMxvmudkIFqjwm8FOir.gjqdJDJv.wA
 4cZIH6Md.9jKPeS0z9SaVf30RZPpXumE7dHMV6z4Sxmy0LJ1GRN8fT1c5X50
 AmREJFHX1H2axuCMqJu9i3NvMujuMeEJWoZRyREWtDN9y3ChWmH6uFqjXzxL
 LgwgEDKEkhpJuY88Su_wY8XCyTf4jBjWjOqTH8ChhrnywaiBRjPkAUEEj8Fq
 0koUB5FTyUq7Zs2kZ
X-Mailer: YahooMailWebService/0.8.121.416
Message-ID: <1347720524.66204.YahooMailNeo@web120302.mail.ne1.yahoo.com>
Date: Sat, 15 Sep 2012 07:48:44 -0700 (PDT)
From: Chris Rankin <rankincj@yahoo.com>
Reply-To: Chris Rankin <rankincj@yahoo.com>
Subject: [BUG][3.5.4] No keyboard without i8042_nokbd=1 parameter
To: "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Cc: "linux-input@vger.kernel.org" <linux-input@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi,

I have recently upgraded my oldest PC from 3.4.8 to 3.5.4, but was puzzled to discover that the keyboard no longer worked unless I also added the i8042_nokbd=1 boot parameter. It turns out that 3.4.8 didn't use the i8042 keyboard device anyway:

>From 3.4.8:
...

i8042 aux: probe of 00:07 failed with error -16
i8042: PNP: PS/2 Controller [PNP0303] at 0x60,0x64 irq 1
i8042: PNP: PS/2 appears to have AUX port disabled, if this is incorrect please boot with i8042.nopnp
serio: i8042 KBD port at 0x60,0x64 irq 1
mousedev: PS/2 mouse device common for all mice
TCP: cubic registered
Registering the dns_resolver key type
Using IPI Shortcut mode
Freeing unused kernel memory: 268k freed
Write protecting the kernel text: 1628k
Write protecting the kernel read-only data: 580k
input: AT Translated Set 2 keyboard as /devices/platform/i8042/serio0/input/input0
...

Hence adding the i8042_nokbd=1 parameter merely forces the kernel to do again what it used to do automatically.Does anyone have any theories as to why the 3.5.x kernel now needs help to set the keyboard up correctly, please?

Thanks,
Chris

