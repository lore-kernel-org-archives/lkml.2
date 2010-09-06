Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755443Ab0IFSKh (ORCPT <rfc822;w@1wt.eu>);
	Mon, 6 Sep 2010 14:10:37 -0400
Received: from mail-iw0-f174.google.com ([209.85.214.174]:64398 "EHLO
	mail-iw0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754908Ab0IFSKb (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 6 Sep 2010 14:10:31 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=mime-version:date:message-id:subject:from:to:cc:content-type;
        b=GgbFt20ggc3iQqo4o63tPbGbmlKWrjYAjUqehftAunXjQyZtc3ECTrTF87OfTARhzp
         nbN1vabzymiJqUCskyIvyMYqasgftRc9JUCXMEx3Js/hx/udDk7uJ5BqI/fLmRWoyAww
         ZndROlcNT0EHk18Dlzu4myEKXvCiz7P0MOv8c=
MIME-Version: 1.0
Date: Tue, 7 Sep 2010 03:10:30 +0900
Message-ID: <AANLkTinnHiCodvHrSxiMCAQXAETczRiZ+sDu2aQXSeG0@mail.gmail.com>
Subject: [PATCH] USB: otg: twl4030: fix phy initialization(v1)
From: venki kaps <venkiece2005@gmail.com>
To: tom.leiming@gmail.com, greg@kroah.com
Cc: linux-usb@vger.kernel.org, linux-omap@vger.kernel.org,
        linux-kernel@vger.kernel.org,
        David Brownell <dbrownell@users.sourceforge.net>,
        Felipe Balbi <me@felipebalbi.com>, Anand Gadiyar <gadiyar@ti.com>,
        venkiece2005@gmail.com
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Dear USB experts,

  Is the same fix valid for omap3430 + 2.6.32 Kernel?

  I have been facing mp3 playback idle current consumption 20mA more
after booting without USB cable connected
  but If USB cable detach and attach happen, then able to hit proper
values otherwise irrespective of cold/warm reset
  the current values increases to 20mA.

  with cable,
      OTG_SYSCONFIG standby mode of operation - SMART idle
      HSOTGUSB_STANDBY - SMART standby

  without cable,
        OTG_SYSCONFIG standby mode of operation - SMART idle
        HSOTGUSB_STANDBY - Active

  Even i have applied  patch but still the same issue.

  If i use __twl4030_phy_power(twl, 0) at the end of USB LDO initialization,
  then able to hit proper values but USB ADC values are getting in correct
  with Travel adapter (Charger power supply) which means temperature
  shows 84 instead of 26~30 degrees.

  Queries,
  -----------
   - Is Errata 1.164 fix : OTG idle will work on 3430?
   - USBOTG_SUSPEND is enabled in Kernel 32, will it give any impact?
   - Is there anything missed from Power management idle path (or)
    USB OTG controller/Transreceiver driver part?

  Could you please provide the best approach to solve my issue?

  Best Regards,
  Venkappa
