Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756098Ab2HGToH (ORCPT <rfc822;w@1wt.eu>);
	Tue, 7 Aug 2012 15:44:07 -0400
Received: from mail-gh0-f174.google.com ([209.85.160.174]:42136 "EHLO
	mail-gh0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752095Ab2HGToE (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 7 Aug 2012 15:44:04 -0400
MIME-Version: 1.0
In-Reply-To: <20120807143656.GA22791@khazad-dum.debian.net>
References: <1343176370-5856-1-git-send-email-ccross@android.com>
	<CAK5ve-LY1iw7CanrMSZ0PtK=Fk9Au9tXnmaOuZ5P7vnP+5VAgA@mail.gmail.com>
	<CAMbhsRS-TiBE92nL0Cwc-ssZAMaHE2ET0UE8h7RU3VG6F6+Xtw@mail.gmail.com>
	<CAK5ve-+11J4HRepAmK-Y0Pq55XhAwa8Ehpw8=KvRdu4Cy90FDQ@mail.gmail.com>
	<20120726035958.GB7235@kroah.com>
	<CAK5ve-LbNeJngQPE=893-ChJXEWJHg9km1Ev6GZYx4=Zrrxg9g@mail.gmail.com>
	<20120726165112.GA23857@kroah.com>
	<CAK5ve-KFsFwnvd3TwAvTuBfEdTV8PeNBkVpdQT9NYXH2sN+mBA@mail.gmail.com>
	<CAMbhsRS82FM90sD52qTTdOFJCoR4GyP+v6bwv+4NKhjn-sqh-Q@mail.gmail.com>
	<CAK5ve-KvdokobzjmuXSsEZxrJcr7i4xHOXJGvMqCSOZ69G_5zw@mail.gmail.com>
	<20120807143656.GA22791@khazad-dum.debian.net>
Date: Tue, 7 Aug 2012 12:44:02 -0700
X-Google-Sender-Auth: NjJa3Ysj66HL004H_WssDpShRbY
Message-ID: <CAMbhsRT8U5rDuSQQ3_d44LsOUivyGviqMBOLV+Xpe7==90FGQw@mail.gmail.com>
Subject: Re: [PATCH] leds: triggers: send uevent when changing triggers
From: Colin Cross <ccross@android.com>
To: Henrique de Moraes Holschuh <hmh@hmh.eng.br>
Cc: Bryan Wu <bryan.wu@canonical.com>, Greg KH <gregkh@linuxfoundation.org>,
        linux-kernel@vger.kernel.org, Richard Purdie <rpurdie@rpsys.net>,
        linux-leds@vger.kernel.org
Content-Type: text/plain; charset=ISO-8859-1
X-System-Of-Record: true
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Aug 7, 2012 at 7:36 AM, Henrique de Moraes Holschuh
<hmh@hmh.eng.br> wrote:
> On Tue, 07 Aug 2012, Bryan Wu wrote:
<snip>

>> Greg, Richard and Henrique, can I take you guys' Ack here?
>
> Yes, you have my Acked-by, provided that the uevent is NOT sent before
> the led is fully registered (I cannot check right now if the patch does
> this right or not.  I apologise in advance if this was an unecessary
> question).
>
> I don't care whether the uevent gets sent right after registration, or
> only when the trigger *changes* after registering.  But someone might,
> so it would be nice to document this.
>
> Considering Greg's answer, maybe it would be best to resend the patch
> with the point above clarified in the commit message or in the in-tree
> documentation of the LED class?

led_trigger_set_default is called last from led_classdev_register, so
it will send a uevent during registration but after it is fully
registered.  I will resend the patch with the clarification.
