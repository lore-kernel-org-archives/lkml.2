Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758296Ab1F3F5q (ORCPT <rfc822;w@1wt.eu>);
	Thu, 30 Jun 2011 01:57:46 -0400
Received: from relay01.digicable.hu ([92.249.128.189]:59814 "EHLO
	relay01.digicable.hu" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751579Ab1F3F5k (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 30 Jun 2011 01:57:40 -0400
Message-ID: <4E0C1015.3020300@freemail.hu>
Date: Thu, 30 Jun 2011 07:56:37 +0200
From: =?ISO-8859-1?Q?N=E9meth_M=E1rton?= <nm127@freemail.hu>
User-Agent: Mozilla/5.0 (X11; U; Linux i686; hu-HU; rv:1.8.1.21) Gecko/20090402 SeaMonkey/1.1.16
MIME-Version: 1.0
To: Matt Chen <machen@novell.com>
CC: Greg KH <greg@kroah.com>, Matthew Wilcox <matthew@wil.cx>,
        Max Vozeler <max@vozeler.com>, Joe Perches <joe@perches.com>,
        David Chang <dchang@novell.com>, linux-usb@vger.kernel.org,
        usbip-devel@lists.sourceforge.net, devel@driverdev.osuosl.org,
        LKML <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH, RFC] USBIP protocol documentation
References: <4DDBF8BD.3000603@freemail.hu>	<20110524183448.GA18511@kroah.com>	<4DDC142E.6070003@freemail.hu>	<20110525031222.GB14290@haskell.muteddisk.com>	<4DDC93D5.9070607@freemail.hu>	<4DDDFDA7.6030900@freemail.hu>	<4E097A32.1000504@freemail.hu>	<20110629233435.GB37164@haskell.muteddisk.com> <BANLkTi=qXgnapyrsSANJ0XZuE=kz7QgsvA@mail.gmail.com>
In-Reply-To: <BANLkTi=qXgnapyrsSANJ0XZuE=kz7QgsvA@mail.gmail.com>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
X-Original: 178.164.175.29
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Matt Chen wrote:
> Hi Matt,
> 
> 
> 2011/6/30 matt mooney <mfm@muteddisk.com <mailto:mfm@muteddisk.com>>:
>> On 08:52 Tue 28 Jun     , N??meth M??rton wrote:
>>> From: M??rton N??meth <nm127@freemail.hu <mailto:nm127@freemail.hu>>
>>>
>>> USBIP v1.0.0 protocol documentation.
>>>
>>> Signed-off-by: M??rton N??meth <nm127@freemail.hu
> <mailto:nm127@freemail.hu>>
>>> ---
>>>
>>> Hi,
>>>
>>> I tried to document the USBIP protocol as implemented in the Linux
> kernel 3.0-rc2.
>>
>> Yeah, thanks for doing this. I am also documenting the protocol but am not
>> finished yet. We can use yours as the base if you would like although
> I have a
>> few suggestions.
>>
>> For one, the grammar needs to be cleaned up, but instead of me
> pointing out all
>> of the needed corrections, I will send in a grammar corrections patch
> on top of

Please go on with the corrections. I really started documenting the
current USBIP protocol because I think digging in the source code is
not the right way to describe a protocol. I'm happy that the review
of the USBIP protocol description started. Once we have documented the current
USBIP protocol I think we'll see more clearly its weaknesses.

What I think important to include in the protocol description is to
identify the unused fields and specify an exact value (usually zero) to
use for these fields. This makes possible future extension of the protocol
easy.

One more random thing which came to my mind is that I tend to think that
the current implementation is buggy when ISO packets are transmitted.
I have a hama AC-150 webcam which is not working well with USBIP. This
webcam usually sends smaller ISO packets so there is a gap between
the ISO packets in one single URB. The problem came up already in case
of usbmon, see https://bugzilla.kernel.org/show_bug.cgi?id=22182 and
http://git.kernel.org/?p=linux/kernel/git/torvalds/linux-2.6.git;a=commit;h=b17ea167c5fb50dcd5dce5b874a467f04eec886d
.

>> the finished document. I like that you did a time sequence diagram,
> which is
>> something I had neglected to include myself; however, I am not a big
> fan of how
>> you laid out the messages. I was planning on using packet diagrams.
> IMHO, it
>> makes understanding the message composition much easier allowing more
> insight to
>> be gathered from a cursory glance.
>>
>>
>>    Message Format
>>    --------------
>>         0               1               2               3
>>        +-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+
>>        |            Version            |            Opcode             |
>>        +-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+
>>        |                            Status                             |
>>        +-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+
>>        .                                                               .
>>        .                             Data                              .
>>        .                                                               .
>>        +-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+
>>
>>    Version: 16 bit
>>        Binary-coded decimal version number of the usbip-utils package from
>>        which the program was built.
>>
>>    Opcode: 16 bits
>>        ...
>>
> So as you mentioned, the message format is looked like below:
> 
> OP_REQ_DEVLIST Message Format
> 
>          0                 1               2                
> 3                 4
>         +-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+
>         | 0000 0000 1000 0000 | 1000 0000 0000 0101 |
>         +-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-
>         | 0000 0000 0000 0000   0000 0000 0000 0000 |
>         +-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-
>        
> Is this correct ?
> 
> Personally, I like this way to describe the protocol.  ;-)

This layout format what is used in other RFCs, too, is really a better
way to show the messages. I think, however, that we don't need to put
the values in binary format, we could just put one hexadecimal number
in the gaps, like this:

 OP_REQ_DEVLIST Message Format


     0               1               2               3
    +-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+
    |            0x0100             |            0x8005             |
    +-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+
    |                          0x00000000                           |
    +-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+

>> As you may or may not see, I was going to take a more generic approach
> and then
>> describe the fields on a per-op basis. Of course, the main point here
> is that
>> the protocol is documented, so I am not opposed to a different style
> being used.
>>
>> But if you insist on the current layout, do not put a value for the
> version
>> because it is not constant (and in fact no longer at 1.0.0). And the
> "Meaning"
>> header should be "Description" or something better.
>>
>> Hmm, taking another look the layout just seems to busy... I really do
> think we
>> should find a different way to format the information.
>>
>> Thanks,
>> matt
>>
>>> The description is a preliminary draft only, it may contain mistakes.
> I tried
>>> to document what I have understand from the source code and from the
> actual
>>> captured network traffic when the USBIP is in action. Please review
> it, correct it,
>>> point out the missing parts.
>>>
>>> During I have documented the protocol a question came into my mind:
> why do we
>>> have two different type of package when the URB completition handler
> is called,
>>> namely USB_RET_SUBMIT and USBIP_RET_UNLINK? As far as I can see this
> causes race
>>> condition because for one URB the completition handler is only called
> once. If
>>> the one URB is sent in with USB_CMD_SUBMIT and then unlinked with
> USB_CMD_UNLINK
>>> the completition handler is called only once. In the protocol,
> however, we have
>>> two different type of packets: USB_RET_SUBMIT and USBIP_RET_UNLINK.
> The status
>>> field of these messages may contain anything in this case depending
> on the timing.
>>>
>>> Regards,
>>>
>>>       M??rton N??meth
>>> ---
>>> diff -uprN staging-2.6.orig/drivers/staging/usbip/usbip_protocol.txt
> staging-2.6/drivers/staging/usbip/usbip_protocol.txt
>>> --- staging-2.6.orig/drivers/staging/usbip/usbip_protocol.txt
> 1970-01-01 01:00:00.000000000 +0100
>>> +++ staging-2.6/drivers/staging/usbip/usbip_protocol.txt    
>  2011-06-28 08:30:04.000000000 +0200
>>> @@ -0,0 +1,352 @@
>>> +PRELIMINARY DRAFT, MAY CONTAIN MISTAKES!
>>> +28 Jun 2011
>>> +
>>> +The USB/IP protocol follows a server/client architecture. The server
> exports the
>>> +USB devices and the clients imports them. The device driver for the
> exported
>>> +USB device runs on the client machine.
>>> +
>>> +The client may ask for the list of the exported USB devices. To get
> the list the
>>> +client opens a TCP/IP connection towards the server, and sends an
> OP_REQ_DEVLIST
>>> +packet on top of the TCP/IP connection (so the actual OP_REQ_DEVLIST
> may be sent
>>> +in one or more pieces at the low level transport layer). The server
> sends back
>>> +the OP_REP_DEVLIST packet which lists the exported USB devices.
> Finally the
>>> +TCP/IP connection is closed.
>>> +
>>> + virtual host controller                                 usb host
>>> +      "client"                                           "server"
>>> +  (imports USB devices)                             (exports USB
> devices)
>>> +          |                                                 |
>>> +          |                  OP_REQ_DEVLIST                 |
>>> +          | ----------------------------------------------> |
>>> +          |                                                 |
>>> +          |                  OP_REP_DEVLIST                 |
>>> +          | <---------------------------------------------- |
>>> +          |                                                 |
>>> +
>>> +Once the client knows the list of exported USB devices it may decide
> to use one
>>> +of them. First the client opens a TCP/IP connection towards the
> server and
>>> +sends an OP_REQ_IMPORT packet. The server replies with
> OP_REP_IMPORT. If the
>>> +import was successful the TCP/IP connection remains open and will be
> used
>>> +to trasfer the URB traffic between the client and the server. The
> client may
>>> +send two types of packets: the USBIP_CMD_SUBMIT to submit an URB, and
>>> +USBIP_CMD_UNLINK to unlink a previously submitted URB. The answers
> of the
>>> +server may be USBIP_RET_SUBMIT and USBIP_RET_UNLINK respectively.
>>> +
>>> + virtual host controller                                 usb host
>>> +      "client"                                           "server"
>>> +  (imports USB devices)                             (exports USB
> devices)
>>> +          |                                                 |
>>> +          |                  OP_REQ_IMPORT                  |
>>> +          | ----------------------------------------------> |
>>> +          |                                                 |
>>> +          |                  OP_REP_IMPORT                  |
>>> +          | <---------------------------------------------- |
>>> +          |                                                 |
>>> +          |                                                 |
>>> +          |            USBIP_CMD_SUBMIT(seqnum = n)         |
>>> +          | ----------------------------------------------> |
>>> +          |                                                 |
>>> +          |            USBIP_RET_SUBMIT(seqnum = n)         |
>>> +          | <---------------------------------------------- |
>>> +          |                        .                        |
>>> +          |                        :                        |
>>> +          |                                                 |
>>> +          |            USBIP_CMD_SUBMIT(seqnum = m)         |
>>> +          | ----------------------------------------------> |
>>> +          |                                                 |
>>> +          |            USBIP_CMD_SUBMIT(seqnum = m+1)       |
>>> +          | ----------------------------------------------> |
>>> +          |                                                 |
>>> +          |            USBIP_CMD_SUBMIT(seqnum = m+2)       |
>>> +          | ----------------------------------------------> |
>>> +          |                                                 |
>>> +          |            USBIP_RET_SUBMIT(seqnum = m)         |
>>> +          | <---------------------------------------------- |
>>> +          |                                                 |
>>> +          |            USBIP_CMD_SUBMIT(seqnum = m+3)       |
>>> +          | ----------------------------------------------> |
>>> +          |                                                 |
>>> +          |            USBIP_RET_SUBMIT(seqnum = m+1)       |
>>> +          | <---------------------------------------------- |
>>> +          |                                                 |
>>> +          |            USBIP_CMD_SUBMIT(seqnum = m+4)       |
>>> +          | ----------------------------------------------> |
>>> +          |                                                 |
>>> +          |            USBIP_RET_SUBMIT(seqnum = m+2)       |
>>> +          | <---------------------------------------------- |
>>> +          |                        .                        |
>>> +          |                        :                        |
>>> +          |                                                 |
>>> +          |               USBIP_CMD_UNLINK                  |
>>> +          | ----------------------------------------------> |
>>> +          |                                                 |
>>> +          |               USBIP_RET_UNLINK                  |
>>> +          | <---------------------------------------------- |
>>> +          |                                                 |
>>> +
>>> +The fields are in network (big endian) byte order meaning that the
> most significant
>>> +byte (MSB) is stored at the lowest address.
>>> +
>>> +
>>> +OP_REQ_DEVLIST: Retrieve the list of exported USB devices.
>>> +
>>> + Offset    | Length | Value      | Meaning
>>>
> +-----------+--------+------------+---------------------------------------------------
>>> + 0         | 2      | 0x0100     | Binary-coded decimal USBIP
> version number: v1.0.0
>>>
> +-----------+--------+------------+---------------------------------------------------
>>> + 2         | 2      | 0x8005     | Command code: Retrieve the list
> of exported USB
>>> +           |        |            |   devices.
>>>
> +-----------+--------+------------+---------------------------------------------------
>>> + 4         | 4      | 0x00000000 | Status: unused, shall be set to 0
>>> +
>>> +OP_REP_DEVLIST: Reply with the list of exported USB devices.
>>> +
>>> + Offset    | Length | Value      | Meaning
>>>
> +-----------+--------+------------+---------------------------------------------------
>>> + 0         | 2      | 0x0100     | Binary-coded decimal USBIP
> version number: v1.0.0.
>>>
> +-----------+--------+------------+---------------------------------------------------
>>> + 2         | 2      | 0x0005     | Reply code: The list of exported
> USB devices.
>>>
> +-----------+--------+------------+---------------------------------------------------
>>> + 4         | 4      | 0x00000000 | Status: 0 for OK
>>>
> +-----------+--------+------------+---------------------------------------------------
>>> + 8         | 4      | n          | Number of exported devices: 0
> means no exported
>>> +           |        |            |   devices.
>>>
> +-----------+--------+------------+---------------------------------------------------
>>> + 0x0C      |        |            | From now on the exported n
> devices are described,
>>> +           |        |            |   if any. If no devices are
> exported the message
>>> +           |        |            |   ends with the previous "number
> of exported
>>> +           |        |            |   devices" field.
>>>
> +-----------+--------+------------+---------------------------------------------------
>>> +           | 256    |            | path: Path of the device on the
> host exporting the
>>> +           |        |            |   USB device, string closed with
> zero byte, e.g.
>>> +           |        |            |  
> "/sys/devices/pci0000:00/0000:00:1d.1/usb3/3-2"
>>> +           |        |            |   The unused bytes shall be
> filled with zero
>>> +           |        |            |   bytes.
>>>
> +-----------+--------+------------+---------------------------------------------------
>>> + 0x10C     | 32     |            | busid: Bus ID of the exported
> device, string
>>> +           |        |            |   closed with zero byte, e.g.
> "3-2". The unused
>>> +           |        |            |   bytes shall be filled with zero
> bytes.
>>>
> +-----------+--------+------------+---------------------------------------------------
>>> + 0x12C     | 4      |            | busnum
>>>
> +-----------+--------+------------+---------------------------------------------------
>>> + 0x130     | 4      |            | devnum
>>>
> +-----------+--------+------------+---------------------------------------------------
>>> + 0x134     | 4      |            | speed
>>>
> +-----------+--------+------------+---------------------------------------------------
>>> + 0x138     | 2      |            | idVendor
>>>
> +-----------+--------+------------+---------------------------------------------------
>>> + 0x13A     | 2      |            | idProduct
>>>
> +-----------+--------+------------+---------------------------------------------------
>>> + 0x13C     | 2      |            | bcdDevice
>>>
> +-----------+--------+------------+---------------------------------------------------
>>> + 0x13E     | 1      |            | bDeviceClass
>>>
> +-----------+--------+------------+---------------------------------------------------
>>> + 0x13F     | 1      |            | bDeviceSubClass
>>>
> +-----------+--------+------------+---------------------------------------------------
>>> + 0x140     | 1      |            | bDeviceProtocol
>>>
> +-----------+--------+------------+---------------------------------------------------
>>> + 0x141     | 1      |            | bConfigurationValue
>>>
> +-----------+--------+------------+---------------------------------------------------
>>> + 0x142     | 1      |            | bNumConfigurations
>>>
> +-----------+--------+------------+---------------------------------------------------
>>> + 0x143     | 1      |            | bNumInterfaces
>>>
> +-----------+--------+------------+---------------------------------------------------
>>> + 0x144     |        | m_0        | From now on each interface is
> described, all
>>> +           |        |            |   together bNumInterfaces times,
> with the
>>> +           |        |            |   the following 4 fields:
>>>
> +-----------+--------+------------+---------------------------------------------------
>>> +           | 1      |            | bInterfaceClass
>>>
> +-----------+--------+------------+---------------------------------------------------
>>> + 0x145     | 1      |            | bInterfaceSubClass
>>>
> +-----------+--------+------------+---------------------------------------------------
>>> + 0x146     | 1      |            | bInterfaceProtocol
>>>
> +-----------+--------+------------+---------------------------------------------------
>>> + 0x147     | 1      |            | padding byte for alignment, shall
> be set to zero
>>>
> +-----------+--------+------------+---------------------------------------------------
>>> + 0xC +     |        |            | The second exported USB device
> starts at i=1
>>> + i*0x138 + |        |            | with the busid field.
>>> + m_(i-1)*4 |        |            |
>>> +
>>> +OP_REQ_IMPORT: Request to import (attach) a remote USB device.
>>> +
>>> + Offset    | Length | Value      | Meaning
>>>
> +-----------+--------+------------+---------------------------------------------------
>>> + 0         | 2      | 0x0100     | Binary-coded decimal USBIP
> version number: v1.0.0
>>>
> +-----------+--------+------------+---------------------------------------------------
>>> + 2         | 2      | 0x8003     | Command code: import a remote USB
> device.
>>>
> +-----------+--------+------------+---------------------------------------------------
>>> + 4         | 4      | 0x00000000 | Status: unused, shall be set to 0
>>>
> +-----------+--------+------------+---------------------------------------------------
>>> + 8         | 32     |            | busid: the busid of the exported
> device on the
>>> +           |        |            |   remote host. The possible
> values are taken
>>> +           |        |            |   from the message field
> OP_REP_DEVLIST.busid.
>>> +           |        |            |   A string closed with zero, the
> unused bytes
>>> +           |        |            |   shall be filled with zeros.
>>>
> +-----------+--------+------------+---------------------------------------------------
>>> +
>>> +OP_REP_IMPORT: Reply to import (attach) a remote USB device.
>>> +
>>> + Offset    | Length | Value      | Meaning
>>>
> +-----------+--------+------------+---------------------------------------------------
>>> + 0         | 2      | 0x0100     | Binary-coded decimal USBIP
> version number: v1.0.0
>>>
> +-----------+--------+------------+---------------------------------------------------
>>> + 2         | 2      | 0x0003     | Reply code: Reply to import.
>>>
> +-----------+--------+------------+---------------------------------------------------
>>> + 4         | 4      | 0x00000000 | Status: 0 for OK
>>> +           |        |            |         1 for error
>>>
> +-----------+--------+------------+---------------------------------------------------
>>> + 8         |        |            | From now on comes the details of
> the imported
>>> +           |        |            |   device, if the previous status
> field was OK (0),
>>> +           |        |            |   otherwise the reply ends with
> the status field.
>>>
> +-----------+--------+------------+---------------------------------------------------
>>> +           | 256    |            | path: Path of the device on the
> host exporting the
>>> +           |        |            |   USB device, string closed with
> zero byte, e.g.
>>> +           |        |            |  
> "/sys/devices/pci0000:00/0000:00:1d.1/usb3/3-2"
>>> +           |        |            |   The unused bytes shall be
> filled with zero
>>> +           |        |            |   bytes.
>>>
> +-----------+--------+------------+---------------------------------------------------
>>> + 0x108     | 32     |            | busid: Bus ID of the exported
> device, string
>>> +           |        |            |   closed with zero byte, e.g.
> "3-2". The unused
>>> +           |        |            |   bytes shall be filled with zero
> bytes.
>>>
> +-----------+--------+------------+---------------------------------------------------
>>> + 0x128     | 4      |            | busnum
>>>
> +-----------+--------+------------+---------------------------------------------------
>>> + 0x12C     | 4      |            | devnum
>>>
> +-----------+--------+------------+---------------------------------------------------
>>> + 0x130     | 4      |            | speed
>>>
> +-----------+--------+------------+---------------------------------------------------
>>> + 0x134     | 2      |            | idVendor
>>>
> +-----------+--------+------------+---------------------------------------------------
>>> + 0x136     | 2      |            | idProduct
>>>
> +-----------+--------+------------+---------------------------------------------------
>>> + 0x138     | 2      |            | bcdDevice
>>>
> +-----------+--------+------------+---------------------------------------------------
>>> + 0x139     | 1      |            | bDeviceClass
>>>
> +-----------+--------+------------+---------------------------------------------------
>>> + 0x13A     | 1      |            | bDeviceSubClass
>>>
> +-----------+--------+------------+---------------------------------------------------
>>> + 0x13B     | 1      |            | bDeviceProtocol
>>>
> +-----------+--------+------------+---------------------------------------------------
>>> + 0x13C     | 1      |            | bConfigurationValue
>>>
> +-----------+--------+------------+---------------------------------------------------
>>> + 0x13D     | 1      |            | bNumConfigurations
>>>
> +-----------+--------+------------+---------------------------------------------------
>>> + 0x13E     | 1      |            | bNumInterfaces
>>> +
>>> +USBIP_CMD_SUBMIT: Submit an URB
>>> +
>>> + Offset    | Length | Value      | Meaning
>>>
> +-----------+--------+------------+---------------------------------------------------
>>> + 0         | 4      | 0x00000001 | command: Submit an URB
>>>
> +-----------+--------+------------+---------------------------------------------------
>>> + 4         | 4      |            | seqnum: the sequence number of
> the URB to submit
>>>
> +-----------+--------+------------+---------------------------------------------------
>>> + 8         | 4      |            | devid
>>>
> +-----------+--------+------------+---------------------------------------------------
>>> + 0xC       | 4      |            | direction: 0: USBIP_DIR_IN
>>> +           |        |            |            1: USBIP_DIR_OUT
>>>
> +-----------+--------+------------+---------------------------------------------------
>>> + 0x10      | 4      |            | ep: endpoint number, possible
> values are: 0...15
>>>
> +-----------+--------+------------+---------------------------------------------------
>>> + 0x14      | 4      |            | transfer_flags: possible values
> depend on the
>>> +           |        |            |   URB transfer type, see below
>>>
> +-----------+--------+------------+---------------------------------------------------
>>> + 0x18      | 4      |            | transfer_buffer_length
>>>
> +-----------+--------+------------+---------------------------------------------------
>>> + 0x1C      | 4      |            | start_frame: specify the selected
> frame to
>>> +           |        |            |   transmit an ISO frame, ignored
> if URB_ISO_ASAP
>>> +           |        |            |   is specified at transfer_flags
>>>
> +-----------+--------+------------+---------------------------------------------------
>>> + 0x20      | 4      |            | number_of_packets: number of ISO
> packets
>>>
> +-----------+--------+------------+---------------------------------------------------
>>> + 0x24      | 4      |            | interval: maximum time for the
> request on the
>>> +           |        |            |   server-side host controller
>>>
> +-----------+--------+------------+---------------------------------------------------
>>> + 0x28      | 8      |            | setup: data bytes for USB setup,
> filled with
>>> +           |        |            |   zeros if not used
>>>
> +-----------+--------+------------+---------------------------------------------------
>>> + 0x30      |        |            | URB data. For ISO transfers the
> padding between
>>> +           |        |            |   each ISO packets is not
> transmitted.
>>> +
>>> +
>>> +  Allowed transfer_flags  | value      | control | interrupt | bulk
>     | isochronous
>>> +
> -------------------------+------------+---------+-----------+----------+-------------
>>> +  URB_SHORT_NOT_OK        | 0x00000001 | only in | only in   | only
> in  | no
>>> +  URB_ISO_ASAP            | 0x00000002 | no      | no        | no  
>     | yes
>>> +  URB_NO_TRANSFER_DMA_MAP | 0x00000004 | yes     | yes       | yes  
>    | yes
>>> +  URB_NO_FSBR             | 0x00000020 | yes     | no        | no  
>     | no
>>> +  URB_ZERO_PACKET         | 0x00000040 | no      | no        | only
> out | no
>>> +  URB_NO_INTERRUPT        | 0x00000080 | yes     | yes       | yes  
>    | yes
>>> +  URB_FREE_BUFFER         | 0x00000100 | yes     | yes       | yes  
>    | yes
>>> +  URB_DIR_MASK            | 0x00000200 | yes     | yes       | yes  
>    | yes
>>> +
>>> +
>>> +USBIP_RET_SUBMIT: Reply for submitting an URB
>>> +
>>> + Offset    | Length | Value      | Meaning
>>>
> +-----------+--------+------------+---------------------------------------------------
>>> + 0         | 4      | 0x00000002 | command
>>>
> +-----------+--------+------------+---------------------------------------------------
>>> + 4         | 4      |            | seqnum: URB sequence number
>>>
> +-----------+--------+------------+---------------------------------------------------
>>> + 8         | 4      |            | devid
>>>
> +-----------+--------+------------+---------------------------------------------------
>>> + 0xC       | 4      |            | direction: 0: USBIP_DIR_IN
>>> +           |        |            |            1: USBIP_DIR_OUT
>>>
> +-----------+--------+------------+---------------------------------------------------
>>> + 0x10      | 4      |            | ep: endpoint number
>>>
> +-----------+--------+------------+---------------------------------------------------
>>> + 0x14      | 4      |            | status: zero for successful URB
> transaction,
>>> +           |        |            |   otherwise some kind of error
> happened.
>>>
> +-----------+--------+------------+---------------------------------------------------
>>> + 0x18      | 4      | n          | actual_length: number of URB data
> bytes
>>>
> +-----------+--------+------------+---------------------------------------------------
>>> + 0x1C      | 4      |            | start_frame: for an ISO frame the
> actually
>>> +           |        |            |   selected frame for transmit.
>>>
> +-----------+--------+------------+---------------------------------------------------
>>> + 0x20      | 4      |            | number_of_packets
>>>
> +-----------+--------+------------+---------------------------------------------------
>>> + 0x24      | 4      |            | error_count
>>>
> +-----------+--------+------------+---------------------------------------------------
>>> + 0x28      | 8      |            | setup: data bytes for USB setup,
> filled with
>>> +           |        |            |   zeros if not used
>>>
> +-----------+--------+------------+---------------------------------------------------
>>> + 0x30      | n      |            | URB data bytes. For ISO transfers
> the padding
>>> +           |        |            |   between each ISO packets is not
> transmitted.
>>> +
>>> +USBIP_CMD_UNLINK: Unlink an URB
>>> +
>>> + Offset    | Length | Value      | Meaning
>>>
> +-----------+--------+------------+---------------------------------------------------
>>> + 0         | 4      | 0x00000003 | command: URB unlink command
>>>
> +-----------+--------+------------+---------------------------------------------------
>>> + 4         | 4      |            | seqnum: URB sequence number to
> unlink: FIXME: is this so?
>>>
> +-----------+--------+------------+---------------------------------------------------
>>> + 8         | 4      |            | devid
>>>
> +-----------+--------+------------+---------------------------------------------------
>>> + 0xC       | 4      |            | direction: 0: USBIP_DIR_IN
>>> +           |        |            |            1: USBIP_DIR_OUT
>>>
> +-----------+--------+------------+---------------------------------------------------
>>> + 0x10      | 4      |            | ep: endpoint number: zero
>>>
> +-----------+--------+------------+---------------------------------------------------
>>> + 0x14      | 4      |            | seqnum: the URB sequence number
> given previously
>>> +           |        |            |   at USBIP_CMD_SUBMIT.seqnum field
>>> +
>>> +USBIP_RET_UNLINK: Reply for URB unlink
>>> +
>>> + Offset    | Length | Value      | Meaning
>>>
> +-----------+--------+------------+---------------------------------------------------
>>> + 0         | 4      | 0x00000004 | command: reply for the URB unlink
> command
>>>
> +-----------+--------+------------+---------------------------------------------------
>>> + 4         | 4      |            | seqnum: the unlinked URB sequence
> number
>>>
> +-----------+--------+------------+---------------------------------------------------
>>> + 8         | 4      |            | devid
>>>
> +-----------+--------+------------+---------------------------------------------------
>>> + 0xC       | 4      |            | direction: 0: USBIP_DIR_IN
>>> +           |        |            |            1: USBIP_DIR_OUT
>>>
> +-----------+--------+------------+---------------------------------------------------
>>> + 0x10      | 4      |            | ep: endpoint number
>>>
> +-----------+--------+------------+---------------------------------------------------
>>> + 0x14      | 4      |            | status: This is the value
> contained in the
>>> +           |        |            |   urb->status in the URB
> completition handler.
>>> +           |        |            |   FIXME: a better explanation needed.
>>>
>> _______________________________________________
>> devel mailing list
>> devel@linuxdriverproject.org <mailto:devel@linuxdriverproject.org>
>> http://driverdev.linuxdriverproject.org/mailman/listinfo/devel
>>
> 
> 
> 
> -- 
> Thanks ~
> Matt Chen
> 
> 
> 

