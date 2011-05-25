Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932386Ab1EYJlb (ORCPT <rfc822;w@1wt.eu>);
	Wed, 25 May 2011 05:41:31 -0400
Received: from wolverine01.qualcomm.com ([199.106.114.254]:24022 "EHLO
	wolverine01.qualcomm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753116Ab1EYJl3 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 25 May 2011 05:41:29 -0400
X-IronPort-AV: E=McAfee;i="5400,1158,6356"; a="93500048"
From: "Tanya Brokhman" <tlinder@codeaurora.org>
To: <balbi@ti.com>
Cc: "'Alan Stern'" <stern@rowland.harvard.edu>,
        "'Sarah Sharp'" <sarah.a.sharp@linux.intel.com>, <greg@kroah.com>,
        <linux-usb@vger.kernel.org>, <linux-arm-msm@vger.kernel.org>,
        <ablay@codeaurora.org>, "'open list'" <linux-kernel@vger.kernel.org>
References: <011d01cc19ff$616055c0$24210140$@org> <Pine.LNX.4.44L0.1105241012080.1913-100000@iolanthe.rowland.org> <013201cc1a96$bdda7910$398f6b30$@org> <20110525092124.GI14556@legolas.emea.dhcp.ti.com> <015801cc1abd$ca534e20$5ef9ea60$@org> <20110525092743.GK14556@legolas.emea.dhcp.ti.com>
In-Reply-To: <20110525092743.GK14556@legolas.emea.dhcp.ti.com>
Subject: RE: [PATCH v12 7/8] usb: Adding SuperSpeed support to dummy_hcd
Date: Wed, 25 May 2011 12:43:10 +0300
Message-ID: <018e01cc1ac0$2b09b040$811d10c0$@org>
MIME-Version: 1.0
Content-Type: text/plain;
	charset="US-ASCII"
Content-Transfer-Encoding: 7bit
X-Mailer: Microsoft Office Outlook 12.0
Thread-Index: AcwavfgSXdkLXPf/Q9usDBXgrzJtagAANRbw
Content-Language: en-us
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

> > But that's why we added the feature flag. Isn't leaving it FALSE the
> > same as removing the part that updates gadget speed? It is protected
> with #ifdef.
> 
> you mean the module parameter ? This will mean that users will have to
> remember another module parameter otherwise it will not work in some
> situations :-)
> 
> the module should work without that parameter :-)
> 

No, I'm afraid we're talking about different things here. 
As far as dummy_hcd is concerned:
Dummy_hcd has a new module parameter that should be set to true if the
developer wishes the gadget driver to be connected to a SS root hub. Since
at the moment most of the gadget drivers woun't work at SS connection (lack
of SS descriptors) the default of this parameter is true and thus the
connected gadget driver will be enumerated over a HS root hub. Users don't
have to remember t set anything in order to be able to work with dummy_hcd
and the existing gadget drivers just as they did up until now.

We did add a new feature flag (CONFIG_USB_GADGET_SUPERSPEED) that is set
during compilation. If that flag is defined, then (and only then!) will the
driver->speed be set to SS by composite_bind. Please keep in mind the
following:
1. if CONFIG_USB_GADGET_SUPERSPEED=true, existing gadget drivers are still
functional with dummy_hcd since as I already mentioned, they will be
enumerated through HS root hub and thus the gadget.speed will be set to HS.
This is true for all gadget drivers, including the once that don't define SS
descriptors.
2. if CONFIG_USB_GADGET_SUPERSPEED=false (which is the default) then all the
code that is added by this patch series will never be executed since
driver->speed won't be updated (and will remain HS). This is basically a way
to disable SS support in the gadget framework.

Hope this clears the confusion :)

Best regards,
Tanya Brokhman
Consultant for Qualcomm Innovation Center, Inc.
Qualcomm Innovation Center, Inc. is a member of Code Aurora Forum





