Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758281Ab0JTGqz (ORCPT <rfc822;w@1wt.eu>);
	Wed, 20 Oct 2010 02:46:55 -0400
Received: from wolverine02.qualcomm.com ([199.106.114.251]:50993 "EHLO
	wolverine02.qualcomm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756414Ab0JTGqx (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 20 Oct 2010 02:46:53 -0400
X-IronPort-AV: E=McAfee;i="5400,1158,6141"; a="58512426"
Message-ID: <8720b0b367107614c4b07a21ff215785.squirrel@www.codeaurora.org>
In-Reply-To: <874c7b4e0f4fcbc99d074b23595454e5.squirrel@www.codeaurora.org>
References: <1286635573-30035-1-git-send-email-tlinder@codeaurora.org>
    <20101010081012.GB18531@linux.intel.com>
    <874c7b4e0f4fcbc99d074b23595454e5.squirrel@www.codeaurora.org>
Date: Tue, 19 Oct 2010 23:48:56 -0700 (PDT)
Subject: Re: [PATCH v5] usb: usb3.0 ch9 definitions
From: tlinder@codeaurora.org
To: tlinder@codeaurora.org
Cc: "Matthew Wilcox" <willy@linux.intel.com>,
        "Tatyana Brokhman" <tlinder@codeaurora.org>, linux-usb@vger.kernel.org,
        linux-arm-msm@vger.kernel.org, "Greg Kroah-Hartman" <gregkh@suse.de>,
        "Sarah Sharp" <sarah.a.sharp@linux.intel.com>,
        linux-kernel@vger.kernel.org
User-Agent: SquirrelMail/1.4.17
MIME-Version: 1.0
Content-Type: text/plain;charset=iso-8859-1
Content-Transfer-Encoding: 8bit
X-Priority: 3 (Normal)
Importance: Normal
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Matthew

Bellow is the reply we received from Intel regarding this issue:

"Errata 10.007 in the “Q1-09 USB3_Errata.pdf” file defines a correction of
the SuperSpeed USB Device Capability structure in section 10.13.1 that
changes bLength from 12 to 10 bytes, and bFunctionalitySupport from 8 to
3."

Best Regards
Tanya Brokhman

> Hi Matthew
>
> Page 10-57 you're referring to defines the SuperSpeed USB Device
> Capability descriptor for Hub Class. The descriptor itself is defined in
> ch9 section 9.6.2.2 and the wReserved is not defined there. Thus the total
> length of the descriptor is 10 bytes and not 12.
> IMO we should follow the definition in ch9. It seems that ch 10 has a typo
> in it. You're right about the errata. I found no reference to this issue
> either.
> I'll contact USB-IF regarding this issue.
> Thanks for bringing this up!
>
> Best regards
> Tanya Brokhman
>
>> On Sat, Oct 09, 2010 at 04:46:12PM +0200, Tatyana Brokhman wrote:
>>> +/*
>>> + * SuperSpeed USB Capability descriptor: Defines the set of SuperSpeed
>>> USB
>>> + * specific device level capabilities
>>> + */
>>> +#define		USB_SS_CAP_TYPE		3
>>> +struct usb_ss_cap_descriptor {		/* Link Power Management */
>>> +	__u8  bLength;
>>> +	__u8  bDescriptorType;
>>> +	__u8  bDevCapabilityType;
>>> +	__u8  bmAttributes;
>>> +#define USB_LTM_SUPPORT			(1 << 1) /* supports LTM */
>>> +	__le16 wSpeedSupported;
>>> +#define USB_LOW_SPEED_OPERATION		(1)	 /* Low speed operation */
>>> +#define USB_FULL_SPEED_OPERATION	(1 << 1) /* Full speed operation */
>>> +#define USB_HIGH_SPEED_OPERATION	(1 << 2) /* High speed operation */
>>> +#define USB_5GBPS_OPERATION		(1 << 3) /* Operation at 5Gbps */
>>> +	__u8  bFunctionalitySupport;
>>> +	__u8  bU1devExitLat;
>>> +	__le16 bU2DevExitLat;
>>> +} __attribute__((packed));
>>> +
>>> +#define USB_DT_USB_SS_CAP_SIZE	10
>>
>> Hang on, if we're looking at page 10-57 of "USB 3 0
>> (11132008)-final.pdf",
>> it's 12 bytes long with the last two bytes being wReserved.  Is there
>> an erratum that changes this?  I just looked through
>> "USB3_Errata [June 2010].pdf" and don't see any errata that look
>> germane.
>>
>>
>
>
> --
> To unsubscribe from this list: send the line "unsubscribe linux-usb" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
>


