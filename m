Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755001Ab1EBTfe (ORCPT <rfc822;w@1wt.eu>);
	Mon, 2 May 2011 15:35:34 -0400
Received: from mail-fx0-f46.google.com ([209.85.161.46]:58844 "EHLO
	mail-fx0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753262Ab1EBTfa (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 2 May 2011 15:35:30 -0400
Message-ID: <4DBF077B.8080903@sieker.io>
Date: Mon, 02 May 2011 21:35:23 +0200
From: "Adi J. Sieker" <adi@core.adi.io>
User-Agent: Mozilla/5.0 (X11; U; Linux i686; en-US; rv:1.9.2.14) Gecko/20110223 Lightning/1.0b2 Thunderbird/3.1.8
MIME-Version: 1.0
To: Alan Stern <stern@rowland.harvard.edu>
CC: Oliver Neukum <oliver@neukum.org>, USB list <linux-usb@vger.kernel.org>,
        linux-input@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: USB keyboard recognized as HID keyboard but doesn't work
References: <Pine.LNX.4.44L0.1105021001490.2106-100000@iolanthe.rowland.org>
In-Reply-To: <Pine.LNX.4.44L0.1105021001490.2106-100000@iolanthe.rowland.org>
Content-Type: multipart/mixed;
 boundary="------------080400010404060005080102"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This is a multi-part message in MIME format.
--------------080400010404060005080102
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit

On 02/05/11 16:04, Alan Stern wrote:
> On Sun, 1 May 2011, Adi J. Sieker wrote:
>
>> On 01/05/11 09:53, Oliver Neukum wrote:
>>> Am Samstag, 30. April 2011, 22:23:05 schrieb Adi J. Sieker:
>>>> Hello,
>>>>
>>>> the lovely folks from #kernelnewbies suggested I write this mail since
>>>> they are at a loss.
>>>> I recently got a new USB keyboard which works fine in the BIOS and also
>>>> in VBox Windows guests, but not on the host.
>>>>
>>>> The keyboard is a Keysonic KSK-8003 UX product details here:
>>>> http://maxpoint.de/de/products/keyboards.php?pid=1_3_7&we_objectID=1220
>>>>
>>>> The menu key and the backspace keys do work. The num lock led is on,
>>>> though I can't switch num lock off.
>>>> If I attch the keyboard to a VirtualBox VM running WindowsXP as a guest,
>>>> it works as expected in the VM.
>>> This indicates that it is working on the USB level.
>>>
>>>> I'm running 2.6.32-27-generic #49-Ubuntu. I tried the Ubuntu 10.10
>>>> LiveCD and that also didn't work. I haven't tried 11.04 yet though.
>>> Do you get anything on the event device? What does udev say when you
>>> plug in the device?
>
> ...
>
>> one thing I found out is that this keyboard has some special anti
>> ghosting function for some keys. Where you can press multiple keys
>> simultaneously
>> and they are all recognized. This is apparently great for gaming. Which
>> I'm not interested in...
>
> Something else that might help is a usbmon trace showing what happens
> when you plug in the keyboard.  Instructions are in the kernel source
> file Documentation/usb/usbmon.txt.  In particular, while running the
> test try pressing some of the normal keys that don't work.
>

The attached file usbmon-working.out is the output when I pressed the 
backspace key. When I press any of the non working keys which is 
everything but the backspace and menu key. I don't get any output even 
when using 0u.

> Also, it would help to see the output from "lsusb -v" for this device
> -- but you'll have to unbind it from the usbhid driver first.
>

When attaching the keyboard I get 2 devices in
/sys/bus/usb/drivers/usbhid/2-1.1:1.0  and
/sys/bus/usb/drivers/usbhid/2-1.1:1.1

The output is in the attached lsusb.txt.

Cheers
   Adi


--------------080400010404060005080102
Content-Type: text/plain;
 name="lsusb.txt"
Content-Transfer-Encoding: 7bit
Content-Disposition: attachment;
 filename="lsusb.txt"

root@mini:/sys/bus/usb/drivers/usbhid# ls 
1-1.2.2.1:1.0  bind  module  new_id  uevent  unbind
root@mini:/sys/bus/usb/drivers/usbhid# ls
1-1.2.2.1:1.0  2-1.1:1.0  2-1.1:1.1  bind  module  new_id  uevent  unbind
root@mini:/sys/bus/usb/drivers/usbhid# echo -n 2-1.1:1.0 >unbind 
root@mini:/sys/bus/usb/drivers/usbhid# echo -n 2-1.1:1.1 >unbind
root@mini:/sys/bus/usb/drivers/usbhid# lsusb
Bus 002 Device 006: ID 060b:0230 Solid Year 
Bus 002 Device 004: ID 0a5c:5801 Broadcom Corp. 
Bus 002 Device 003: ID 413c:8187 Dell Computer Corp. 
Bus 002 Device 002: ID 8087:0020  
Bus 002 Device 001: ID 1d6b:0002 Linux Foundation 2.0 root hub
Bus 001 Device 008: ID 1058:0704 Western Digital Technologies, Inc. 
Bus 001 Device 007: ID 046d:c024 Logitech, Inc. MX300 Optical Mouse
Bus 001 Device 006: ID 0409:005a NEC Corp. HighSpeed Hub
Bus 001 Device 005: ID 413c:2513 Dell Computer Corp. 
Bus 001 Device 004: ID 413c:2513 Dell Computer Corp. 
Bus 001 Device 003: ID 05ca:1814 Ricoh Co., Ltd 
Bus 001 Device 002: ID 8087:0020  
Bus 001 Device 001: ID 1d6b:0002 Linux Foundation 2.0 root hub
root@mini:/sys/bus/usb/drivers/usbhid# lsusb -v -s 002:006

Bus 002 Device 006: ID 060b:0230 Solid Year 
Device Descriptor:
  bLength                18
  bDescriptorType         1
  bcdUSB               1.10
  bDeviceClass            0 (Defined at Interface level)
  bDeviceSubClass         0 
  bDeviceProtocol         0 
  bMaxPacketSize0         8
  idVendor           0x060b Solid Year
  idProduct          0x0230 
  bcdDevice            2.20
  iManufacturer           1 KB
  iProduct                2 USB Keyboard
  iSerial                 0 
  bNumConfigurations      1
  Configuration Descriptor:
    bLength                 9
    bDescriptorType         2
    wTotalLength           59
    bNumInterfaces          2
    bConfigurationValue     1
    iConfiguration          0 
    bmAttributes         0xa0
      (Bus Powered)
      Remote Wakeup
    MaxPower              100mA
    Interface Descriptor:
      bLength                 9
      bDescriptorType         4
      bInterfaceNumber        0
      bAlternateSetting       0
      bNumEndpoints           1
      bInterfaceClass         3 Human Interface Device
      bInterfaceSubClass      1 Boot Interface Subclass
      bInterfaceProtocol      1 Keyboard
      iInterface              0 
        HID Device Descriptor:
          bLength                 9
          bDescriptorType        33
          bcdHID               1.10
          bCountryCode            0 Not supported
          bNumDescriptors         1
          bDescriptorType        34 Report
          wDescriptorLength      75
          Report Descriptor: (length is 75)
            Item(Global): Usage Page, data= [ 0x01 ] 1
                            Generic Desktop Controls
            Item(Local ): Usage, data= [ 0x06 ] 6
                            Keyboard
            Item(Main  ): Collection, data= [ 0x01 ] 1
                            Application
            Item(Global): Usage Page, data= [ 0x07 ] 7
                            Keyboard
            Item(Local ): Usage Minimum, data= [ 0xe0 ] 224
                            Control Left
            Item(Local ): Usage Maximum, data= [ 0xe7 ] 231
                            GUI Right
            Item(Global): Logical Minimum, data= [ 0x00 ] 0
            Item(Global): Logical Maximum, data= [ 0x01 ] 1
            Item(Global): Report Size, data= [ 0x01 ] 1
            Item(Global): Report Count, data= [ 0x08 ] 8
            Item(Main  ): Input, data= [ 0x02 ] 2
                            Data Variable Absolute No_Wrap Linear
                            Preferred_State No_Null_Position Non_Volatile Bitfield
            Item(Global): Report Count, data= [ 0x01 ] 1
            Item(Global): Report Size, data= [ 0x08 ] 8
            Item(Main  ): Input, data= [ 0x01 ] 1
                            Constant Array Absolute No_Wrap Linear
                            Preferred_State No_Null_Position Non_Volatile Bitfield
            Item(Global): Report Count, data= [ 0x03 ] 3
            Item(Global): Report Size, data= [ 0x01 ] 1
            Item(Global): Usage Page, data= [ 0x08 ] 8
                            LEDs
            Item(Local ): Usage Minimum, data= [ 0x01 ] 1
                            NumLock
            Item(Local ): Usage Maximum, data= [ 0x03 ] 3
                            Scroll Lock
            Item(Main  ): Output, data= [ 0x02 ] 2
                            Data Variable Absolute No_Wrap Linear
                            Preferred_State No_Null_Position Non_Volatile Bitfield
            Item(Global): Report Count, data= [ 0x05 ] 5
            Item(Global): Report Size, data= [ 0x01 ] 1
            Item(Main  ): Output, data= [ 0x01 ] 1
                            Constant Array Absolute No_Wrap Linear
                            Preferred_State No_Null_Position Non_Volatile Bitfield
            Item(Global): Report Count, data= [ 0x06 ] 6
            Item(Global): Report Size, data= [ 0x08 ] 8
            Item(Global): Logical Maximum, data= [ 0xff 0x00 ] 255
            Item(Global): Usage Page, data= [ 0x07 ] 7
                            Keyboard
            Item(Local ): Usage Minimum, data= [ 0x00 ] 0
                            No Event
            Item(Local ): Usage Maximum, data= [ 0x91 ] 145
                            LANG 2 (Hanja Conversion, Korea)
            Item(Main  ): Input, data= [ 0x00 ] 0
                            Data Array Absolute No_Wrap Linear
                            Preferred_State No_Null_Position Non_Volatile Bitfield
            Item(Local ): Usage, data= [ 0x00 ] 0
                            No Event
            Item(Global): Logical Minimum, data= [ 0x00 ] 0
            Item(Global): Logical Maximum, data= [ 0xff 0x00 ] 255
            Item(Global): Report Size, data= [ 0x08 ] 8
            Item(Global): Report Count, data= [ 0x08 ] 8
            Item(Main  ): Feature, data= [ 0x00 ] 0
                            Data Array Absolute No_Wrap Linear
                            Preferred_State No_Null_Position Non_Volatile Bitfield
            Item(Main  ): End Collection, data=none
      Endpoint Descriptor:
        bLength                 7
        bDescriptorType         5
        bEndpointAddress     0x81  EP 1 IN
        bmAttributes            3
          Transfer Type            Interrupt
          Synch Type               None
          Usage Type               Data
        wMaxPacketSize     0x0008  1x 8 bytes
        bInterval              10
    Interface Descriptor:
      bLength                 9
      bDescriptorType         4
      bInterfaceNumber        1
      bAlternateSetting       0
      bNumEndpoints           1
      bInterfaceClass         3 Human Interface Device
      bInterfaceSubClass      0 No Subclass
      bInterfaceProtocol      0 None
      iInterface              0 
        HID Device Descriptor:
          bLength                 9
          bDescriptorType        33
          bcdHID               1.10
          bCountryCode            0 Not supported
          bNumDescriptors         1
          bDescriptorType        34 Report
          wDescriptorLength     108
          Report Descriptor: (length is 108)
            Item(Global): Usage Page, data= [ 0x01 ] 1
                            Generic Desktop Controls
            Item(Local ): Usage, data= [ 0x80 ] 128
                            System Control
            Item(Main  ): Collection, data= [ 0x01 ] 1
                            Application
            Item(Global): Report ID, data= [ 0x01 ] 1
            Item(Local ): Usage Minimum, data= [ 0x81 ] 129
                            System Power Down
            Item(Local ): Usage Maximum, data= [ 0x83 ] 131
                            System Wake Up
            Item(Global): Logical Minimum, data= [ 0x00 ] 0
            Item(Global): Logical Maximum, data= [ 0x01 ] 1
            Item(Global): Report Count, data= [ 0x03 ] 3
            Item(Global): Report Size, data= [ 0x01 ] 1
            Item(Main  ): Input, data= [ 0x02 ] 2
                            Data Variable Absolute No_Wrap Linear
                            Preferred_State No_Null_Position Non_Volatile Bitfield
            Item(Global): Report Count, data= [ 0x01 ] 1
            Item(Global): Report Size, data= [ 0x05 ] 5
            Item(Main  ): Input, data= [ 0x01 ] 1
                            Constant Array Absolute No_Wrap Linear
                            Preferred_State No_Null_Position Non_Volatile Bitfield
            Item(Main  ): End Collection, data=none
            Item(Global): Usage Page, data= [ 0x0c ] 12
                            Consumer
            Item(Local ): Usage, data= [ 0x01 ] 1
                            Consumer Control
            Item(Main  ): Collection, data= [ 0x01 ] 1
                            Application
            Item(Global): Report ID, data= [ 0x02 ] 2
            Item(Local ): Usage Minimum, data= [ 0x00 ] 0
                            Unassigned
            Item(Local ): Usage Maximum, data= [ 0xff 0x7f ] 32767
                            (null)
            Item(Global): Logical Minimum, data= [ 0x00 ] 0
            Item(Global): Logical Maximum, data= [ 0xff 0x7f ] 32767
            Item(Global): Report Count, data= [ 0x01 ] 1
            Item(Global): Report Size, data= [ 0x10 ] 16
            Item(Main  ): Input, data= [ 0x00 ] 0
                            Data Array Absolute No_Wrap Linear
                            Preferred_State No_Null_Position Non_Volatile Bitfield
            Item(Main  ): End Collection, data=none
            Item(Global): Usage Page, data= [ 0x01 ] 1
                            Generic Desktop Controls
            Item(Local ): Usage, data= [ 0x06 ] 6
                            Keyboard
            Item(Main  ): Collection, data= [ 0x01 ] 1
                            Application
            Item(Global): Report ID, data= [ 0x03 ] 3
            Item(Global): Report Count, data= [ 0x38 ] 56
            Item(Global): Report Size, data= [ 0x01 ] 1
            Item(Global): Logical Minimum, data= [ 0x00 ] 0
            Item(Global): Logical Maximum, data= [ 0x01 ] 1
            Item(Global): Usage Page, data= [ 0x07 ] 7
                            Keyboard
            Item(Local ): Usage Minimum, data= [ 0xe0 ] 224
                            Control Left
            Item(Local ): Usage Maximum, data= [ 0xe7 ] 231
                            GUI Right
            Item(Local ): Usage Minimum, data= [ 0x00 ] 0
                            No Event
            Item(Local ): Usage Maximum, data= [ 0x2f ] 47
                            [ and { (Bracket and Braces Left)
            Item(Main  ): Input, data= [ 0x02 ] 2
                            Data Variable Absolute No_Wrap Linear
                            Preferred_State No_Null_Position Non_Volatile Bitfield
            Item(Main  ): End Collection, data=none
            Item(Global): Usage Page, data= [ 0x01 ] 1
                            Generic Desktop Controls
            Item(Local ): Usage, data= [ 0x06 ] 6
                            Keyboard
            Item(Main  ): Collection, data= [ 0x01 ] 1
                            Application
            Item(Global): Report ID, data= [ 0x04 ] 4
            Item(Global): Report Count, data= [ 0x38 ] 56
            Item(Global): Report Size, data= [ 0x01 ] 1
            Item(Global): Logical Minimum, data= [ 0x00 ] 0
            Item(Global): Logical Maximum, data= [ 0x01 ] 1
            Item(Global): Usage Page, data= [ 0x07 ] 7
                            Keyboard
            Item(Local ): Usage Minimum, data= [ 0x30 ] 48
                            ] and } (Bracket and Braces Right)
            Item(Local ): Usage Maximum, data= [ 0x67 ] 103
                            Keypad = (Equal Sign)
            Item(Main  ): Input, data= [ 0x02 ] 2
                            Data Variable Absolute No_Wrap Linear
                            Preferred_State No_Null_Position Non_Volatile Bitfield
            Item(Main  ): End Collection, data=none
      Endpoint Descriptor:
        bLength                 7
        bDescriptorType         5
        bEndpointAddress     0x82  EP 2 IN
        bmAttributes            3
          Transfer Type            Interrupt
          Synch Type               None
          Usage Type               Data
        wMaxPacketSize     0x0008  1x 8 bytes
        bInterval              10
Device Status:     0x0000
  (Bus Powered)
root@mini:/sys/bus/usb/drivers/usbhid# 


--------------080400010404060005080102
Content-Type: text/plain;
 name="usbmon-working.out"
Content-Transfer-Encoding: 7bit
Content-Disposition: attachment;
 filename="usbmon-working.out"

f0486100 937500342 C Ii:2:007:1 0:8 8 = 00002a00 00000000
f0486100 937500404 S Ii:2:007:1 -115:8 8 <
f0486100 937564339 C Ii:2:007:1 0:8 8 = 00000000 00000000
f0486100 937564394 S Ii:2:007:1 -115:8 8 <

--------------080400010404060005080102--
