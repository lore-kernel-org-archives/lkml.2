Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753463Ab1C0MSs (ORCPT <rfc822;w@1wt.eu>);
	Sun, 27 Mar 2011 08:18:48 -0400
Received: from wolverine01.qualcomm.com ([199.106.114.254]:34126 "EHLO
	wolverine01.qualcomm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753410Ab1C0MSq (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 27 Mar 2011 08:18:46 -0400
X-IronPort-AV: E=McAfee;i="5400,1158,6297"; a="82328024"
From: "Tanya Brokhman" <tlinder@codeaurora.org>
To: <balbi@ti.com>
Cc: <gregkh@suse.de>, <linux-arm-msm@vger.kernel.org>, <ablay@codeaurora.org>,
        "'open list:USB GADGET/PERIPH...'" <linux-usb@vger.kernel.org>,
        "'open list'" <linux-kernel@vger.kernel.org>
References: <1300867372-20811-1-git-send-email-tlinder@codeaurora.org> <20110325134730.GO2609@legolas.emea.dhcp.ti.com>
In-Reply-To: <20110325134730.GO2609@legolas.emea.dhcp.ti.com>
Subject: RE: [PATCH 1/5 v8] usb: Adding SuperSpeed support to dummy_hcd
Date: Sun, 27 Mar 2011 14:19:25 +0200
Message-ID: <000201cbec79$3a7dc4f0$af794ed0$@org>
MIME-Version: 1.0
Content-Type: text/plain;
	charset="us-ascii"
Content-Transfer-Encoding: 7bit
X-Mailer: Microsoft Office Outlook 12.0
Thread-Index: Acvq8y4BC/tBOaOZQa6Ntjml0mol2wBgxJ7A
Content-Language: en-us
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi

> >
> >  MODULE_DESCRIPTION (DRIVER_DESC);
> >  MODULE_AUTHOR ("David Brownell");
> > @@ -220,6 +223,7 @@ static inline struct dummy *gadget_dev_to_dummy
> (struct device *dev)
> >  }
> >
> >  static struct dummy			*the_controller;
> > +static struct dummy			*the_ss_controller;
> 
> the only thing I don't like, is why you splitted the ss controller to a
> separate controller. Why don't you use the same ? From SW perspective,
> we can treat SS and HS/FS/LS controllers as one unit.
> 

Actually I'm not sure about that... Because SS controller handles things a
bit differently than HS/FS/LS. For example look at set_ss_link_state(), the
port status is reported differently than for HS/FS/LS devices.
It could be done, I mean spare the the_ss_controller variable and use
the_controller, and we did that at first, but later on we decided to go back
to this implementation since the code got too complex. Since dummy_hcd.c is
used for debugging purposes we decided that simplicity is the better
approach here.


Best regards,
Tanya Brokhman
Consultant for Qualcomm Innovation Center, Inc.
Qualcomm Innovation Center, Inc. is a member of Code Aurora Forum




