Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932411Ab1ESWhK (ORCPT <rfc822;w@1wt.eu>);
	Thu, 19 May 2011 18:37:10 -0400
Received: from mail-wy0-f174.google.com ([74.125.82.174]:44095 "EHLO
	mail-wy0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754538Ab1ESWhH convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 19 May 2011 18:37:07 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=mime-version:sender:in-reply-to:references:date
         :x-google-sender-auth:message-id:subject:from:to:cc:content-type
         :content-transfer-encoding;
        b=AlMUEZ3ohJ+9tS9LUo/a9vz0/S6ZnQTPHdzEyKaErpQa8IuHd01XHR+dkzzYDAkB9U
         ZmqAeL11QK3uoIGJx5kyhtmJBbNVF2T0a19ZCh2Kqus/TG3bOe7TKBxOumlM91MuAfis
         7izWbVfXKBNsjuP2YKf6uEnoA01yjuD1Thj0k=
MIME-Version: 1.0
In-Reply-To: <87boyyo0gr.fsf@macbook.be.48ers.dk>
References: <1305725244-5327-1-git-send-email-benjamin.tissoires@enac.fr>
	<87boyyo0gr.fsf@macbook.be.48ers.dk>
Date: Fri, 20 May 2011 00:37:05 +0200
X-Google-Sender-Auth: S82uf5YlrfR2nq-e5nQXNywBB2w
Message-ID: <BANLkTikPXHswWQqQHqd8fegotqoZPLErsQ@mail.gmail.com>
Subject: Re: [PATCH] hid-multitouch: Add support for Lumio panels
From: Benjamin Tissoires <benjamin.tissoires@enac.fr>
To: Peter Korsgaard <jacmet@sunsite.dk>
Cc: Dmitry Torokhov <dmitry.torokhov@gmail.com>,
        Henrik Rydberg <rydberg@euromail.se>, Jiri Kosina <jkosina@suse.cz>,
        Stephane Chatty <chatty@lii-enac.fr>, linux-input@vger.kernel.org,
        linux-kernel@vger.kernel.org
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Peter,

your device presents Contact ID, Tip Switch, In Range and Confidence.
I would say that Win 7 would treat it as a multitouch screen, so this
might work with hid-multitouch. Please note that's the first time I
see a report descriptor with only one touch reported for a multitouch
screen.

For the configuration, the device may emulate a mouse by default, and
hid-multitouch is able to switch to the multitouch mode. You will
loose the right click, but it can be enabled in gnome at least
(accessibility settings).

Can you just replace in hid-ids.h:
- #define USB_DEVICE_ID_CRYSTALTOUCH  0x0006
+ #define USB_DEVICE_ID_CRYSTALTOUCH  0x0005

and see if it's working?
If you prefer, I can make a new patch, but I'll need to know which
kernel you are running (tree and branch). A 2.6.39 and above would be
great.

Cheers,
Benjamin

On Thu, May 19, 2011 at 23:16, Peter Korsgaard <jacmet@sunsite.dk> wrote:
>>>>>> "Benjamin" == Benjamin Tissoires <benjamin.tissoires@enac.fr> writes:
>
>  Benjamin> This patch enables support for Lumio optical devices.
>  Benjamin> Signed-off-by: Benjamin Tissoires <benjamin.tissoires@enac.fr>
>
>  Benjamin> diff --git a/drivers/hid/hid-ids.h b/drivers/hid/hid-ids.h
>  Benjamin> index 2e46eb2..a8c46b0 100644
>  Benjamin> --- a/drivers/hid/hid-ids.h
>  Benjamin> +++ b/drivers/hid/hid-ids.h
>  Benjamin> @@ -411,6 +411,9 @@
>  Benjamin>  #define USB_DEVICE_ID_DINOVO_MINI   0xc71f
>  Benjamin>  #define USB_DEVICE_ID_LOGITECH_MOMO_WHEEL2  0xca03
>
>  Benjamin> +#define USB_VENDOR_ID_LUMIO         0x202e
>  Benjamin> +#define USB_DEVICE_ID_CRYSTALTOUCH  0x0006
>  Benjamin> +
>
> Does this require any special configuration of the touchscreen
> controller? I have a 202e:0005 device which afaik normally doesn't send
> any multi touch events.
>
> HID descriptors:
>
> Bus 001 Device 021: ID 202e:0005
> Device Descriptor:
>  bLength                18
>  bDescriptorType         1
>  bcdUSB               2.00
>  bDeviceClass            0 (Defined at Interface level)
>  bDeviceSubClass         0
>  bDeviceProtocol         0
>  bMaxPacketSize0        64
>  idVendor           0x202e
>  idProduct          0x0005
>  bcdDevice            2.00
>  iManufacturer           1 LUMIO Inc
>  iProduct                2 LUMIO CrystalTouch ver 1.1C
>  iSerial                 0
>  bNumConfigurations      1
>  Configuration Descriptor:
>    bLength                 9
>    bDescriptorType         2
>    wTotalLength          116
>    bNumInterfaces          4
>    bConfigurationValue     1
>    iConfiguration          0
>    bmAttributes         0x80
>      (Bus Powered)
>    MaxPower              500mA
>    Interface Descriptor:
>      bLength                 9
>      bDescriptorType         4
>      bInterfaceNumber        0
>      bAlternateSetting       0
>      bNumEndpoints           2
>      bInterfaceClass         3 Human Interface Device
>      bInterfaceSubClass      0 No Subclass
>      bInterfaceProtocol      0 None
>      iInterface              0
>        HID Device Descriptor:
>          bLength                 9
>          bDescriptorType        33
>          bcdHID               1.10
>          bCountryCode            0 Not supported
>          bNumDescriptors         1
>          bDescriptorType        34 Report
>          wDescriptorLength      38
>          Report Descriptor: (length is 38)
>            Item(Global): Usage Page, data= [ 0xa0 0xff ] 65440
>                            (null)
>            Item(Local ): Usage, data= [ 0x05 ] 5
>                            (null)
>            Item(Main  ): Collection, data= [ 0x01 ] 1
>                            Application
>            Item(Local ): Usage, data= [ 0xa6 ] 166
>                            (null)
>            Item(Local ): Usage, data= [ 0xa7 ] 167
>                            (null)
>            Item(Global): Logical Minimum, data= [ 0x80 ] 128
>            Item(Global): Logical Maximum, data= [ 0x7f ] 127
>            Item(Global): Report Size, data= [ 0x08 ] 8
>            Item(Global): Report Count, data= [ 0x40 ] 64
>            Item(Main  ): Input, data= [ 0x02 ] 2
>                            Data Variable Absolute No_Wrap Linear
>                            Preferred_State No_Null_Position Non_Volatile Bitfield
>            Item(Local ): Usage, data= [ 0x33 ] 51
>                            (null)
>            Item(Global): Report Size, data= [ 0x08 ] 8
>            Item(Global): Report Count, data= [ 0x40 ] 64
>            Item(Main  ): Output, data= [ 0x00 ] 0
>                            Data Array Absolute No_Wrap Linear
>                            Preferred_State No_Null_Position Non_Volatile Bitfield
>            Item(Local ): Usage, data= [ 0x33 ] 51
>                            (null)
>            Item(Global): Report Size, data= [ 0x08 ] 8
>            Item(Global): Report Count, data= [ 0x08 ] 8
>            Item(Main  ): Feature, data= [ 0x00 ] 0
>                            Data Array Absolute No_Wrap Linear
>                            Preferred_State No_Null_Position Non_Volatile Bitfield
>            Item(Main  ): End Collection, data=none
>      Endpoint Descriptor:
>        bLength                 7
>        bDescriptorType         5
>        bEndpointAddress     0x81  EP 1 IN
>        bmAttributes            3
>          Transfer Type            Interrupt
>          Synch Type               None
>          Usage Type               Data
>        wMaxPacketSize     0x0040  1x 64 bytes
>        bInterval               2
>      Endpoint Descriptor:
>        bLength                 7
>        bDescriptorType         5
>        bEndpointAddress     0x02  EP 2 OUT
>        bmAttributes            3
>          Transfer Type            Interrupt
>          Synch Type               None
>          Usage Type               Data
>        wMaxPacketSize     0x0040  1x 64 bytes
>        bInterval               2
>    Interface Descriptor:
>      bLength                 9
>      bDescriptorType         4
>      bInterfaceNumber        1
>      bAlternateSetting       0
>      bNumEndpoints           1
>      bInterfaceClass         3 Human Interface Device
>      bInterfaceSubClass      0 No Subclass
>      bInterfaceProtocol      0 None
>      iInterface              0
>        HID Device Descriptor:
>          bLength                 9
>          bDescriptorType        33
>          bcdHID               1.11
>          bCountryCode            0 Not supported
>          bNumDescriptors         1
>          bDescriptorType        34 Report
>          wDescriptorLength      64
>          Report Descriptor: (length is 64)
>            Item(Global): Usage Page, data= [ 0x01 ] 1
>                            Generic Desktop Controls
>            Item(Local ): Usage, data= [ 0x06 ] 6
>                            Keyboard
>            Item(Main  ): Collection, data= [ 0x01 ] 1
>                            Application
>            Item(Global): Usage Page, data= [ 0x07 ] 7
>                            Keyboard
>            Item(Local ): Usage Minimum, data= [ 0xe0 ] 224
>                            Control Left
>            Item(Local ): Usage Maximum, data= [ 0xe7 ] 231
>                            GUI Right
>            Item(Global): Logical Minimum, data= [ 0x00 ] 0
>            Item(Global): Logical Maximum, data= [ 0x01 ] 1
>            Item(Global): Report Size, data= [ 0x01 ] 1
>            Item(Global): Report Count, data= [ 0x08 ] 8
>            Item(Main  ): Input, data= [ 0x02 ] 2
>                            Data Variable Absolute No_Wrap Linear
>                            Preferred_State No_Null_Position Non_Volatile Bitfield
>            Item(Global): Report Count, data= [ 0x01 ] 1
>            Item(Global): Report Size, data= [ 0x08 ] 8
>            Item(Main  ): Input, data= [ 0x03 ] 3
>                            Constant Variable Absolute No_Wrap Linear
>                            Preferred_State No_Null_Position Non_Volatile Bitfield
>            Item(Global): Report Count, data= [ 0x05 ] 5
>            Item(Global): Report Size, data= [ 0x01 ] 1
>            Item(Global): Report Count, data= [ 0x06 ] 6
>            Item(Global): Report Size, data= [ 0x08 ] 8
>            Item(Global): Logical Minimum, data= [ 0x00 ] 0
>            Item(Global): Logical Maximum, data= [ 0x65 ] 101
>            Item(Global): Usage Page, data= [ 0x07 ] 7
>                            Keyboard
>            Item(Local ): Usage Minimum, data= [ 0x00 ] 0
>                            No Event
>            Item(Local ): Usage Maximum, data= [ 0x65 ] 101
>                            Keyboard Application (Windows Key for Win95 or Compose)
>            Item(Main  ): Input, data= [ 0x00 ] 0
>                            Data Array Absolute No_Wrap Linear
>                            Preferred_State No_Null_Position Non_Volatile Bitfield
>            Item(Global): Usage Page, data= [ 0xa0 0xff ] 65440
>                            (null)
>            Item(Local ): Usage, data= [ 0xa5 ] 165
>                            (null)
>            Item(Global): Logical Minimum, data= [ 0x80 ] 128
>            Item(Global): Logical Maximum, data= [ 0x7f ] 127
>            Item(Global): Report Size, data= [ 0x08 ] 8
>            Item(Global): Report Count, data= [ 0x08 ] 8
>            Item(Main  ): Feature, data= [ 0x02 ] 2
>                            Data Variable Absolute No_Wrap Linear
>                            Preferred_State No_Null_Position Non_Volatile Bitfield
>            Item(Main  ): End Collection, data=none
>      Endpoint Descriptor:
>        bLength                 7
>        bDescriptorType         5
>        bEndpointAddress     0x86  EP 6 IN
>        bmAttributes            3
>          Transfer Type            Interrupt
>          Synch Type               None
>          Usage Type               Data
>        wMaxPacketSize     0x0008  1x 8 bytes
>        bInterval               1
>    Interface Descriptor:
>      bLength                 9
>      bDescriptorType         4
>      bInterfaceNumber        2
>      bAlternateSetting       0
>      bNumEndpoints           1
>      bInterfaceClass         3 Human Interface Device
>      bInterfaceSubClass      0 No Subclass
>      bInterfaceProtocol      0 None
>      iInterface              0
>        HID Device Descriptor:
>          bLength                 9
>          bDescriptorType        33
>          bcdHID               1.11
>          bCountryCode            0 Not supported
>          bNumDescriptors         1
>          bDescriptorType        34 Report
>          wDescriptorLength      85
>          Report Descriptor: (length is 85)
>            Item(Global): Usage Page, data= [ 0x01 ] 1
>                            Generic Desktop Controls
>            Item(Local ): Usage, data= [ 0x02 ] 2
>                            Mouse
>            Item(Main  ): Collection, data= [ 0x01 ] 1
>                            Application
>            Item(Local ): Usage, data= [ 0x01 ] 1
>                            Pointer
>            Item(Main  ): Collection, data= [ 0x00 ] 0
>                            Physical
>            Item(Global): Usage Page, data= [ 0x09 ] 9
>                            Buttons
>            Item(Local ): Usage Minimum, data= [ 0x01 ] 1
>                            Button 1 (Primary)
>            Item(Local ): Usage Maximum, data= [ 0x03 ] 3
>                            Button 3 (Tertiary)
>            Item(Global): Logical Minimum, data= [ 0x00 ] 0
>            Item(Global): Logical Maximum, data= [ 0x01 ] 1
>            Item(Global): Report Count, data= [ 0x03 ] 3
>            Item(Global): Report Size, data= [ 0x01 ] 1
>            Item(Main  ): Input, data= [ 0x02 ] 2
>                            Data Variable Absolute No_Wrap Linear
>                            Preferred_State No_Null_Position Non_Volatile Bitfield
>            Item(Global): Report Count, data= [ 0x01 ] 1
>            Item(Global): Report Size, data= [ 0x05 ] 5
>            Item(Main  ): Input, data= [ 0x01 ] 1
>                            Constant Array Absolute No_Wrap Linear
>                            Preferred_State No_Null_Position Non_Volatile Bitfield
>            Item(Global): Usage Page, data= [ 0x01 ] 1
>                            Generic Desktop Controls
>            Item(Local ): Usage, data= [ 0x30 ] 48
>                            Direction-X
>            Item(Local ): Usage, data= [ 0x31 ] 49
>                            Direction-Y
>            Item(Global): Logical Minimum, data= [ 0x00 0x00 ] 0
>            Item(Global): Logical Maximum, data= [ 0xff 0x0f ] 4095
>            Item(Global): Physical Minimum, data= [ 0x00 0x00 ] 0
>            Item(Global): Physical Maximum, data= [ 0xff 0x7f ] 32767
>            Item(Global): Unit, data= [ 0x00 0x00 ] 0
>                            System: None, Unit: (None)
>            Item(Global): Report Size, data= [ 0x10 ] 16
>            Item(Global): Report Count, data= [ 0x02 ] 2
>            Item(Main  ): Input, data= [ 0x62 ] 98
>                            Data Variable Absolute No_Wrap Linear
>                            No_Preferred_State Null_State Non_Volatile Bitfield
>            Item(Global): Usage Page, data= [ 0x01 ] 1
>                            Generic Desktop Controls
>            Item(Local ): Usage, data= [ 0x88 ] 136
>                            System Menu Exit
>            Item(Global): Logical Minimum, data= [ 0x81 ] 129
>            Item(Global): Logical Maximum, data= [ 0x7f ] 127
>            Item(Global): Report Size, data= [ 0x08 ] 8
>            Item(Global): Report Count, data= [ 0x01 ] 1
>            Item(Main  ): Input, data= [ 0x06 ] 6
>                            Data Variable Relative No_Wrap Linear
>                            Preferred_State No_Null_Position Non_Volatile Bitfield
>            Item(Global): Usage Page, data= [ 0xff ] 255
>                            Vendor Specific
>            Item(Local ): Usage, data= [ 0x02 ] 2
>                            (null)
>            Item(Global): Report Count, data= [ 0x02 ] 2
>            Item(Global): Report Size, data= [ 0x08 ] 8
>            Item(Main  ): Input, data= [ 0x01 ] 1
>                            Constant Array Absolute No_Wrap Linear
>                            Preferred_State No_Null_Position Non_Volatile Bitfield
>            Item(Main  ): End Collection, data=none
>            Item(Main  ): End Collection, data=none
>      Endpoint Descriptor:
>        bLength                 7
>        bDescriptorType         5
>        bEndpointAddress     0x85  EP 5 IN
>        bmAttributes            3
>          Transfer Type            Interrupt
>          Synch Type               None
>          Usage Type               Data
>        wMaxPacketSize     0x0008  1x 8 bytes
>        bInterval               1
>    Interface Descriptor:
>      bLength                 9
>      bDescriptorType         4
>      bInterfaceNumber        3
>      bAlternateSetting       0
>      bNumEndpoints           1
>      bInterfaceClass         3 Human Interface Device
>      bInterfaceSubClass      0 No Subclass
>      bInterfaceProtocol      0 None
>      iInterface              0
>        HID Device Descriptor:
>          bLength                 9
>          bDescriptorType        33
>          bcdHID               1.11
>          bCountryCode            0 Not supported
>          bNumDescriptors         1
>          bDescriptorType        34 Report
>          wDescriptorLength      89
>          Report Descriptor: (length is 89)
>            Item(Global): Usage Page, data= [ 0x0d ] 13
>                            Digitizer
>            Item(Local ): Usage, data= [ 0x04 ] 4
>                            Touch Screen
>            Item(Main  ): Collection, data= [ 0x01 ] 1
>                            Application
>            Item(Local ): Usage, data= [ 0x22 ] 34
>                            Finger
>            Item(Main  ): Collection, data= [ 0x00 ] 0
>                            Physical
>            Item(Local ): Usage, data= [ 0x42 ] 66
>                            Tip Switch
>            Item(Global): Logical Minimum, data= [ 0x00 ] 0
>            Item(Global): Logical Maximum, data= [ 0x01 ] 1
>            Item(Global): Report Size, data= [ 0x01 ] 1
>            Item(Global): Report Count, data= [ 0x01 ] 1
>            Item(Main  ): Input, data= [ 0x02 ] 2
>                            Data Variable Absolute No_Wrap Linear
>                            Preferred_State No_Null_Position Non_Volatile Bitfield
>            Item(Global): Report Count, data= [ 0x03 ] 3
>            Item(Main  ): Input, data= [ 0x03 ] 3
>                            Constant Variable Absolute No_Wrap Linear
>                            Preferred_State No_Null_Position Non_Volatile Bitfield
>            Item(Local ): Usage, data= [ 0x32 ] 50
>                            In Range
>            Item(Local ): Usage, data= [ 0x47 ] 71
>                            Confidence
>            Item(Global): Report Count, data= [ 0x02 ] 2
>            Item(Main  ): Input, data= [ 0x02 ] 2
>                            Data Variable Absolute No_Wrap Linear
>                            Preferred_State No_Null_Position Non_Volatile Bitfield
>            Item(Global): Report Count, data= [ 0x0a ] 10
>            Item(Main  ): Input, data= [ 0x03 ] 3
>                            Constant Variable Absolute No_Wrap Linear
>                            Preferred_State No_Null_Position Non_Volatile Bitfield
>            Item(Global): Usage Page, data= [ 0x01 ] 1
>                            Generic Desktop Controls
>            Item(Global): Logical Maximum, data= [ 0xff 0x7f ] 32767
>            Item(Global): Unit, data= [ 0x11 ] 17
>                            System: SI Linear, Unit: Centimeter
>            Item(Global): Unit Exponent, data= [ 0x0e ] 14
>                            Unit Exponent: 14
>            Item(Global): Physical Maximum, data= [ 0x5d 0x14 ] 5213
>            Item(Global): Report Size, data= [ 0x10 ] 16
>            Item(Global): Report Count, data= [ 0x01 ] 1
>            Item(Local ): Usage, data= [ 0x30 ] 48
>                            Direction-X
>            Item(Main  ): Input, data= [ 0x02 ] 2
>                            Data Variable Absolute No_Wrap Linear
>                            Preferred_State No_Null_Position Non_Volatile Bitfield
>            Item(Local ): Usage, data= [ 0x31 ] 49
>                            Direction-Y
>            Item(Global): Physical Maximum, data= [ 0x75 0x0b ] 2933
>            Item(Main  ): Input, data= [ 0x02 ] 2
>                            Data Variable Absolute No_Wrap Linear
>                            Preferred_State No_Null_Position Non_Volatile Bitfield
>            Item(Global): Usage Page, data= [ 0x0d ] 13
>                            Digitizer
>            Item(Local ): Usage, data= [ 0x51 ] 81
>                            Contact ID
>            Item(Global): Report Size, data= [ 0x10 ] 16
>            Item(Global): Report Count, data= [ 0x01 ] 1
>            Item(Main  ): Input, data= [ 0x02 ] 2
>                            Data Variable Absolute No_Wrap Linear
>                            Preferred_State No_Null_Position Non_Volatile Bitfield
>            Item(Local ): Usage, data= [ 0x55 ] 85
>                            Maximum Contact Number
>            Item(Global): Logical Minimum, data= [ 0x00 ] 0
>            Item(Global): Logical Maximum, data= [ 0x08 ] 8
>            Item(Global): Report Size, data= [ 0x08 ] 8
>            Item(Global): Report Count, data= [ 0x01 ] 1
>            Item(Main  ): Feature, data= [ 0x02 ] 2
>                            Data Variable Absolute No_Wrap Linear
>                            Preferred_State No_Null_Position Non_Volatile Bitfield
>            Item(Main  ): End Collection, data=none
>            Item(Main  ): End Collection, data=none
>      Endpoint Descriptor:
>        bLength                 7
>        bDescriptorType         5
>        bEndpointAddress     0x87  EP 7 IN
>        bmAttributes            3
>          Transfer Type            Interrupt
>          Synch Type               None
>          Usage Type               Data
>        wMaxPacketSize     0x0008  1x 8 bytes
>        bInterval               1
> Device Status:     0x0001
>  Self Powered
>
> --
> Bye, Peter Korsgaard
> --
> To unsubscribe from this list: send the line "unsubscribe linux-input" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
>
