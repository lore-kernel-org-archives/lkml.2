Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755701Ab1KYOCb (ORCPT <rfc822;w@1wt.eu>);
	Fri, 25 Nov 2011 09:02:31 -0500
Received: from moutng.kundenserver.de ([212.227.17.10]:56004 "EHLO
	moutng.kundenserver.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755290Ab1KYOCa (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 25 Nov 2011 09:02:30 -0500
From: Arnd Bergmann <arnd@arndb.de>
To: myungjoo.ham@gmail.com
Subject: Re: [RFC PATCH 0/3] introduce: Multistate Switch Class
Date: Fri, 25 Nov 2011 14:02:27 +0000
User-Agent: KMail/1.12.2 (Linux/3.2.0-rc1+; KDE/4.3.2; x86_64; ; )
Cc: linux-kernel@vger.kernel.org, Mike Lockwood <lockwood@android.com>,
        Arve =?iso-8859-1?q?Hj=F8nnev=E5g?= <arve@android.com>,
        Kyungmin Park <kyungmin.park@samsung.com>,
        Donggeun Kim <dg77.kim@samsung.com>, Greg KH <gregkh@suse.de>,
        Linus Walleij <linus.walleij@linaro.org>
References: <CAJ0PZbQBXF1f7F27bkkT_ezFFtFi7kRVbF5WZXn+ZenZj2hT7w@mail.gmail.com>
In-Reply-To: <CAJ0PZbQBXF1f7F27bkkT_ezFFtFi7kRVbF5WZXn+ZenZj2hT7w@mail.gmail.com>
MIME-Version: 1.0
Content-Type: Text/Plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Message-Id: <201111251402.28016.arnd@arndb.de>
X-Provags-ID: V02:K0:C6TNYykHs8eDxyoNu27YcHptOWpCD7On1zB/qOd0XLF
 7tZdwr8JPkbTGo4jhGb4BrWGwZzNV8Yae4fLn9ItbonnE9V09f
 ARJGVE4j9BlzyGsASCo3g41U5d7lNe+OIFo5pA7wJhsW9RoOLK
 Edc/gzkF0UVjWoYKi8/vuDzt/gLEc5lNbDE9jr3iaNLa+ijVth
 ZGcgJNVM01Q4OnXDlT0UZuWAd2pKK21GU6nYdH3qbESZekwEYE
 QRweKg1nxHjhuw36K4tSidiOX1OX+C4hTBe//rgy49O/wzZ/M7
 yyOF20DWKRmT8poIQW2yEUMYLl3/gH4H7lWCXRWXgonxfcGiE9
 /zeTPksmDEzjJgXmGBgs=
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thursday 24 November 2011, MyungJoo Ham wrote:
> For switch ports, which may have different types of cables
> (USB, TA, HDMI, Analog A/V, and others), we often have seperated device
> drivers that detect the state changes at the port and device drivers that
> do something according to the state changes.
> 
> For example, when MAX8997-MUIC detects a Charger cable insertion, another
> device driver (such as MAX8903 charger, MAX8997 charger, Charger Manager,
> or board file) needs to set charger current limit accordingly and when
> MAX8997-MUIC detects a HDMI cable insertion, multimedia device drivers
> need to do some operations accordingly.
> 
> This patchset supports the usage of notifier for passing such information
> between device drivers.
> 
> Another issue is that at a single switch port, there might be multiple
> and heterogeneous cables attached at the same time. Besides, the state
> (Attached or Detached) of each cable may alter independently.
> 
> In order to address such issues, Android kernel's "Switch" class seems to
> be a good basis and we have implemented "Multistate Switch Class" based on
> it. The "Switch" class code of Android kernel is GPL as well.

How does this relate to the new "pinmux" subsystem that Linus Walleij
maintains? Would it be useful to integrate your driver into pinmux
instead of starting a new subsystem?

	Arnd
