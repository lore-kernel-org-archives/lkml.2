Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752128Ab1L0WTr (ORCPT <rfc822;w@1wt.eu>);
	Tue, 27 Dec 2011 17:19:47 -0500
Received: from smtpq1.tb.mail.iss.as9143.net ([212.54.42.164]:33854 "EHLO
	smtpq1.tb.mail.iss.as9143.net" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751903Ab1L0WTo (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 27 Dec 2011 17:19:44 -0500
Message-ID: <4EFA447C.3030906@gmail.com>
Date: Tue, 27 Dec 2011 23:19:40 +0100
From: Rene Herman <rene.herman@gmail.com>
User-Agent: Mozilla/5.0 (X11; Linux i686; rv:9.0) Gecko/20111224 Thunderbird/9.0.1
MIME-Version: 1.0
To: Andre Guedes <andre.guedes@openbossa.org>, linux-kernel@vger.kernel.org,
        linux-bluetooth@vger.kernel.org
Subject: Re: [bluetooth] linux-3.x regression (bisected)
References: <4EF3BACA.1080405@gmail.com> <CACJA=fVezGGcgAtbzG=+ouWq0PiHbgXN1YPwL+VDUphWS7wnrw@mail.gmail.com> <4EFA1EB8.9090005@gmail.com> <20111227203008.GA13870@joana>
In-Reply-To: <20111227203008.GA13870@joana>
Content-Type: multipart/mixed;
 boundary="------------000301050501070309020804"
X-Ziggo-spambar: --
X-Ziggo-spamscore: -2.9
X-Ziggo-spamreport: ALL_TRUSTED=-1,BAYES_00=-1.9,CM_META_TB_NOARR=0.5,FREEMAIL_FROM=0.5,PROLO_TRUST_RDNS=-3,RDNS_DYNAMIC=0.982,SPF_NEUTRAL=0.779,TW_BF=0.077,TW_UH=0.077,TW_XF=0.077
X-Ziggo-Spam-Status: No
X-Spam-Flag: No
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This is a multi-part message in MIME format.
--------------000301050501070309020804
Content-Type: text/plain; charset=ISO-8859-15; format=flowed
Content-Transfer-Encoding: 7bit

On 27-12-11 21:30, Gustavo Padovan wrote:

> Seems your extfeatures is telling you something different from what it really
> supports. Can you try with the following diff (use the dynamic debug that Andre
> told you)

Attached. The result is "features: 0xff".

I suppose that (should) mean(s) "all features"; if that's not actually a 
valid possibility due, perhaps, to undefined or mutually exclusive bits 
then maybe it's an option to take 0xff to mean that the adapter doesn't 
in fact support any of them?

> Also the output of hcidump would nice.

If the below (which is what hcidump spit back at me at some as far as I 
could determine random moment) is not what you wanted, I believe you 
will need to specify which action to take while monitoring things with 
hcidump.

==============
HCI sniffer - Bluetooth packet analyzer ver 2.1
device: hci0 snap_len: 1028 filter: 0xffffffff
< HCI Command: Reset (0x03|0x0003) plen 0
 > HCI Event: Command Complete (0x0e) plen 4
     Reset (0x03|0x0003) ncmd 1
     status 0x00
< HCI Command: Read Local Supported Features (0x04|0x0003) plen 0
 > HCI Event: Command Complete (0x0e) plen 12
     Read Local Supported Features (0x04|0x0003) ncmd 1
     status 0x00
     Features: 0xff 0xfe 0xff 0x7e 0x98 0x19 0x00 0x80
< HCI Command: Read Local Version Information (0x04|0x0001) plen 0
 > HCI Event: Command Complete (0x0e) plen 12
     Read Local Version Information (0x04|0x0001) ncmd 1
     status 0x00
     HCI Version: 2.0 (0x3) HCI Revision: 0x2da
     LMP Version: 2.0 (0x3) LMP Subversion: 0x2da
     Manufacturer: Integrated System Solution Corp. (57)
< HCI Command: Read Buffer Size (0x04|0x0005) plen 0
 > HCI Event: Command Complete (0x0e) plen 11
     Read Buffer Size (0x04|0x0005) ncmd 1
     status 0x00
     ACL MTU 1021:4 SCO MTU 48:10
< HCI Command: Read BD ADDR (0x04|0x0009) plen 0
 > HCI Event: Command Complete (0x0e) plen 10
     Read BD ADDR (0x04|0x0009) ncmd 1
     status 0x00 bdaddr 00:11:67:C0:12:9E
< HCI Command: Read Class of Device (0x03|0x0023) plen 0
 > HCI Event: Command Complete (0x0e) plen 7
     Read Class of Device (0x03|0x0023) ncmd 1
     status 0x00 class 0x000000
< HCI Command: Read Local Name (0x03|0x0014) plen 0
 > HCI Event: Command Complete (0x0e) plen 252
     Read Local Name (0x03|0x0014) ncmd 1
     status 0x00 name 'ISSCEDRBTA'
< HCI Command: Read Voice Setting (0x03|0x0025) plen 0
 > HCI Event: Command Complete (0x0e) plen 6
     Read Voice Setting (0x03|0x0025) ncmd 1
     status 0x00 voice setting 0x0060
< HCI Command: Set Event Filter (0x03|0x0005) plen 1
     type 0 condition 0
     Clear all filters
 > HCI Event: Command Complete (0x0e) plen 4
     Set Event Filter (0x03|0x0005) ncmd 1
     status 0x00
< HCI Command: Write Connection Accept Timeout (0x03|0x0016) plen 2
     timeout 32000
 > HCI Event: Command Complete (0x0e) plen 4
     Write Connection Accept Timeout (0x03|0x0016) ncmd 1
     status 0x00
< HCI Command: Delete Stored Link Key (0x03|0x0012) plen 7
     bdaddr 00:00:00:00:00:00 all 1
 > HCI Event: Command Complete (0x0e) plen 6
     Delete Stored Link Key (0x03|0x0012) ncmd 1
     status 0x00 deleted 0
< HCI Command: Set Event Mask (0x03|0x0001) plen 8
     Mask: 0xfffffbff07180000
 > HCI Event: Command Complete (0x0e) plen 4
     Set Event Mask (0x03|0x0001) ncmd 1
     status 0x00
< HCI Command: Read Local Supported Commands (0x04|0x0002) plen 0
 > HCI Event: Command Complete (0x0e) plen 68
     Read Local Supported Commands (0x04|0x0002) ncmd 1
     status 0x00
     Commands: ffffef03ceffffffffffff9ff30fe8ff3c
< HCI Command: Write Inquiry Mode (0x03|0x0045) plen 1
     mode 1
 > HCI Event: Command Complete (0x0e) plen 4
     Write Inquiry Mode (0x03|0x0045) ncmd 1
     status 0x00
< HCI Command: Read Local Extended Features (0x04|0x0004) plen 1
     page 1
 > HCI Event: Command Complete (0x0e) plen 14
     Read Local Extended Features (0x04|0x0004) ncmd 1
     status 0x00 page 0 max 0
     Features: 0xff 0xfe 0xff 0x7e 0x98 0x19 0x00 0x80
< HCI Command: Write Default Link Policy Settings (0x02|0x000f) plen 2
     policy 0x07
     Link policy: RSWITCH HOLD SNIFF
 > HCI Event: Command Complete (0x0e) plen 4
     Write Default Link Policy Settings (0x02|0x000f) ncmd 1
     status 0x00
< HCI Command: LE Read Buffer Size (0x08|0x0002) plen 0
==============

Rene.

--------------000301050501070309020804
Content-Type: text/plain;
 name="bluetooth-3.1.6-dbg.dmesg"
Content-Transfer-Encoding: 7bit
Content-Disposition: attachment;
 filename="bluetooth-3.1.6-dbg.dmesg"

usb 2-1: new full speed USB device number 2 using uhci_hcd
Bluetooth: Generic Bluetooth USB driver ver 0.6
hci_register_dev:ecfff800 name  bus 1 owner efffd6a0
hci_dev_get:0
hci_power_on:hci0
hci_dev_get:0
hci_dev_open:hci0 ecfff800
__hci_request:hci0 start
hci_init_req:hci0 0
hci_send_cmd:hci0 opcode 0xc03 plen 0
hci_send_cmd:skb len 3
hci_send_cmd:hci0 opcode 0x1003 plen 0
hci_send_cmd:skb len 3
hci_send_cmd:hci0 opcode 0x1001 plen 0
hci_send_cmd:skb len 3
hci_send_cmd:hci0 opcode 0x1005 plen 0
hci_send_cmd:skb len 3
hci_send_cmd:hci0 opcode 0x1009 plen 0
hci_send_cmd:skb len 3
hci_send_cmd:hci0 opcode 0xc23 plen 0
hci_send_cmd:skb len 3
hci_send_cmd:hci0 opcode 0xc14 plen 0
hci_send_cmd:skb len 3
hci_send_cmd:hci0 opcode 0xc25 plen 0
hci_send_cmd:skb len 3
hci_send_cmd:hci0 opcode 0xc05 plen 1
hci_send_cmd:skb len 4
hci_send_cmd:hci0 opcode 0xc16 plen 2
hci_send_cmd:skb len 5
hci_send_cmd:hci0 opcode 0xc12 plen 7
hci_send_cmd:skb len 10
hci_cmd_task:hci0 cmd 1
hci_send_frame:hci0 type 1 len 3
hci_dev_get:0
hci_dev_get:0
hci_dev_open:hci0 ecfff800
usbcore: registered new interface driver btusb
hci_rx_task:hci0
hci_cc_reset:hci0 status 0x0
hci_req_complete:hci0 command 0x0c03 result 0x00
hci_cmd_task:hci0 cmd 1
hci_send_frame:hci0 type 1 len 3
hci_dev_get:0
hci_del_off_timer:hci0
hci_rx_task:hci0
hci_cc_read_local_features:hci0 status 0x0
hci_cc_read_local_features:hci0 features 0xfffeff7e98190080
hci_cmd_task:hci0 cmd 1
hci_send_frame:hci0 type 1 len 3
hci_dev_get:0
hci_del_off_timer:hci0
hci_rx_task:hci0
hci_cc_read_local_version:hci0 status 0x0
hci_cc_read_local_version:hci0 manufacturer 57 hci ver 3:730
hci_send_cmd:hci0 opcode 0xc01 plen 8
hci_send_cmd:skb len 11
hci_send_cmd:hci0 opcode 0x1002 plen 0
hci_send_cmd:skb len 3
hci_send_cmd:hci0 opcode 0xc45 plen 1
hci_send_cmd:skb len 4
hci_dev_get:0
hci_send_cmd:hci_del_off_timer:hci0
hci0 opcode 0x1004 plen 1
hci_send_cmd:skb len 4
hci_cmd_task:hci0 cmd 1
hci_send_frame:hci0 type 1 len 3
hci_rx_task:hci0
hci_cc_read_buffer_size:hci0 status 0x0
hci_cc_read_buffer_size:hci0 acl mtu 1021:4 sco mtu 48:10
hci_cmd_task:hci0 cmd 1
hci_send_frame:hci0 type 1 len 3
hci_dev_get:0
hci_del_off_timer:hci0
hci_rx_task:hci0
hci_cc_read_bd_addr:hci0 status 0x0
hci_req_complete:hci0 command 0x1009 result 0x00
hci_cmd_task:hci0 cmd 1
hci_send_frame:hci0 type 1 len 3
hci_dev_get:0
hci_del_off_timer:hci0
hci_rx_task:hci0
hci_cc_read_class_of_dev:hci0 status 0x0
hci_cc_read_class_of_dev:hci0 class 0x000000
hci_cmd_task:hci0 cmd 1
hci_send_frame:hci0 type 1 len 3
hci_dev_get:0
hci_del_off_timer:hci0
hci_rx_task:hci0
hci_cc_read_local_name:hci0 status 0x0
hci_cmd_task:hci0 cmd 1
hci_send_frame:hci0 type 1 len 3
hci_dev_get:0
hci_del_off_timer:hci0
hci_rx_task:hci0
hci_cc_read_voice_setting:hci0 status 0x0
hci_cc_read_voice_setting:hci0 voice setting 0x0060
hci_cmd_task:hci0 cmd 1
hci_send_frame:hci0 type 1 len 4
hci_dev_get:0
hci_del_off_timer:hci0
hci_rx_task:hci0
hci_cc_set_event_flt:hci0 status 0x0
hci_req_complete:hci0 command 0x0c05 result 0x00
hci_cmd_task:hci0 cmd 1
hci_send_frame:hci0 type 1 len 5
hci_dev_get:0
hci_del_off_timer:hci0
hci_rx_task:hci0
hci_cc_write_ca_timeout:hci0 status 0x0
hci_req_complete:hci0 command 0x0c16 result 0x00
hci_cmd_task:hci0 cmd 1
hci_send_frame:hci0 type 1 len 10
hci_dev_get:0
hci_del_off_timer:hci0
hci_rx_task:hci0
hci_cc_delete_stored_link_key:hci0 status 0x0
hci_req_complete:hci0 command 0x0c12 result 0x00
hci_cmd_task:hci0 cmd 1
hci_send_frame:hci0 type 1 len 11
hci_dev_get:0
hci_del_off_timer:hci0
hci_rx_task:hci0
hci_cc_set_event_mask:hci0 status 0x0
hci_req_complete:hci0 command 0x0c01 result 0x00
hci_cmd_task:hci0 cmd 1
hci_send_frame:hci0 type 1 len 3
hci_dev_get:0
hci_del_off_timer:hci0
hci_rx_task:hci0
hci_cc_read_local_commands:hci0 status 0x0
hci_send_cmd:hci0 opcode 0x80f plen 2
hci_send_cmd:skb len 5
hci_req_complete:hci0 command 0x1002 result 0x00
hci_cmd_task:hci0 cmd 1
hci_send_frame:hci0 type 1 len 4
hci_dev_get:0
hci_del_off_timer:hci0
hci_rx_task:hci0
hci_cc_write_inquiry_mode:hci0 status 0x0
hci_req_complete:hci0 command 0x0c45 result 0x00
hci_cmd_task:hci0 cmd 1
hci_send_frame:hci0 type 1 len 4
hci_dev_get:0
hci_del_off_timer:hci0
hci_rx_task:hci0
hci_cc_read_local_ext_features:hci0 status 0x0
hci_cc_read_local_ext_features:features 0xff
hci_req_complete:hci0 command 0x1004 result 0x00
hci_cmd_task:hci0 cmd 1
hci_send_frame:hci0 type 1 len 5
hci_dev_get:0
hci_del_off_timer:hci0
hci_rx_task:hci0
hci_cc_write_def_link_policy:hci0 status 0x0
hci_sent_cmd_data:hci0 opcode 0x80f
hci_req_complete:hci0 command 0x080f result 0x00
hci_dev_get:0
hci_del_off_timer:hci0
__hci_request:hci0 end: err 0
__hci_request:hci0 start
hci_le_init_req:hci0
hci_send_cmd:hci0 opcode 0x2002 plen 0
hci_send_cmd:skb len 3
hci_cmd_task:hci0 cmd 1
hci_send_frame:hci0 type 1 len 3
Bluetooth: hci0 command tx timeout
hci_cmd_task:hci0 cmd 1
__hci_request:hci0 end: err -110
__hci_request:hci0 start
hci_init_req:hci0 0
hci_send_cmd:hci0 opcode 0xc03 plen 0
hci_send_cmd:skb len 3
hci_send_cmd:hci0 opcode 0x1003 plen 0
hci_send_cmd:skb len 3
hci_send_cmd:hci0 opcode 0x1001 plen 0
hci_send_cmd:skb len 3
hci_send_cmd:hci0 opcode 0x1005 plen 0
hci_send_cmd:skb len 3
hci_send_cmd:hci0 opcode 0x1009 plen 0
hci_send_cmd:skb len 3
hci_send_cmd:hci0 opcode 0xc23 plen 0
hci_send_cmd:skb len 3
hci_send_cmd:hci0 opcode 0xc14 plen 0
hci_send_cmd:skb len 3
hci_send_cmd:hci0 opcode 0xc25 plen 0
hci_send_cmd:skb len 3
hci_send_cmd:hci0 opcode 0xc05 plen 1
hci_send_cmd:skb len 4
hci_send_cmd:hci0 opcode 0xc16 plen 2
hci_send_cmd:skb len 5
hci_send_cmd:hci0 opcode 0xc12 plen 7
hci_send_cmd:skb len 10
hci_cmd_task:hci0 cmd 1
hci_send_frame:hci0 type 1 len 3
hci_rx_task:hci0
hci_cc_reset:hci0 status 0x0
hci_req_complete:hci0 command 0x0c03 result 0x00
hci_cmd_task:hci0 cmd 1
hci_send_frame:hci0 type 1 len 3
hci_dev_get:0
hci_del_off_timer:hci0
hci_rx_task:hci0
hci_cc_read_local_features:hci0 status 0x0
hci_cc_read_local_features:hci0 features 0xfffeff7e98190080
hci_cmd_task:hci0 cmd 1
hci_send_frame:hci0 type 1 len 3
hci_dev_get:0
hci_del_off_timer:hci0
hci_rx_task:hci0
hci_cc_read_local_version:hci0 status 0x0
hci_cc_read_local_version:hci0 manufacturer 57 hci ver 3:730
hci_send_cmd:hci0 opcode 0xc01 plen 8
hci_send_cmd:skb len 11
hci_send_cmd:hci0 opcode 0x1002 plen 0
hci_send_cmd:skb len 3
hci_send_cmd:hci0 opcode 0xc45 plen 1
hci_send_cmd:skb len 4
hci_send_cmd:hci0 opcode 0x1004 plen 1
hci_send_cmd:skb len 4
hci_cmd_task:hci0 cmd 1
hci_send_frame:hci0 type 1 len 3
hci_dev_get:0
hci_del_off_timer:hci0
hci_rx_task:hci0
hci_cc_read_buffer_size:hci0 status 0x0
hci_cc_read_buffer_size:hci0 acl mtu 1021:4 sco mtu 48:10
hci_cmd_task:hci0 cmd 1
hci_send_frame:hci0 type 1 len 3
hci_dev_get:0
hci_del_off_timer:hci0
hci_rx_task:hci0
hci_cc_read_bd_addr:hci0 status 0x0
hci_req_complete:hci0 command 0x1009 result 0x00
hci_cmd_task:hci0 cmd 1
hci_send_frame:hci0 type 1 len 3
hci_dev_get:0
hci_del_off_timer:hci0
hci_rx_task:hci0
hci_cc_read_class_of_dev:hci0 status 0x0
hci_cc_read_class_of_dev:hci0 class 0x000000
hci_cmd_task:hci0 cmd 1
hci_send_frame:hci0 type 1 len 3
hci_dev_get:0
hci_del_off_timer:hci0
hci_rx_task:hci0
hci_cc_read_local_name:hci0 status 0x0
hci_cmd_task:hci0 cmd 1
hci_send_frame:hci0 type 1 len 3
hci_dev_get:0
hci_del_off_timer:hci0
hci_rx_task:hci0
hci_cc_read_voice_setting:hci0 status 0x0
hci_cmd_task:hci0 cmd 1
hci_send_frame:hci0 type 1 len 4
hci_dev_get:0
hci_del_off_timer:hci0
hci_rx_task:hci0
hci_cc_set_event_flt:hci0 status 0x0
hci_req_complete:hci0 command 0x0c05 result 0x00
hci_cmd_task:hci0 cmd 1
hci_send_frame:hci0 type 1 len 5
hci_dev_get:0
hci_del_off_timer:hci0
hci_rx_task:hci0
hci_cc_write_ca_timeout:hci0 status 0x0
hci_req_complete:hci0 command 0x0c16 result 0x00
hci_cmd_task:hci0 cmd 1
hci_send_frame:hci0 type 1 len 10
hci_dev_get:0
hci_del_off_timer:hci0
hci_rx_task:hci0
hci_cc_delete_stored_link_key:hci0 status 0x0
hci_req_complete:hci0 command 0x0c12 result 0x00
hci_cmd_task:hci0 cmd 1
hci_send_frame:hci0 type 1 len 11
hci_dev_get:0
hci_del_off_timer:hci0
hci_rx_task:hci0
hci_cc_set_event_mask:hci0 status 0x0
hci_req_complete:hci0 command 0x0c01 result 0x00
hci_cmd_task:hci0 cmd 1
hci_send_frame:hci0 type 1 len 3
hci_dev_get:0
hci_del_off_timer:hci0
hci_rx_task:hci0
hci_cc_read_local_commands:hci0 status 0x0
hci_send_cmd:hci0 opcode 0x80f plen 2
hci_send_cmd:skb len 5
hci_req_complete:hci0 command 0x1002 result 0x00
hci_cmd_task:hci0 cmd 1
hci_send_frame:hci0 type 1 len 4
hci_dev_get:0
hci_del_off_timer:hci0
hci_rx_task:hci0
hci_cc_write_inquiry_mode:hci0 status 0x0
hci_req_complete:hci0 command 0x0c45 result 0x00
hci_cmd_task:hci0 cmd 1
hci_send_frame:hci0 type 1 len 4
hci_dev_get:0
hci_del_off_timer:hci0
hci_rx_task:hci0
hci_cc_read_local_ext_features:hci0 status 0x0
hci_cc_read_local_ext_features:features 0xff
hci_req_complete:hci0 command 0x1004 result 0x00
hci_cmd_task:hci0 cmd 1
hci_send_frame:hci0 type 1 len 5
hci_dev_get:0
hci_del_off_timer:hci0
hci_rx_task:hci0
hci_cc_write_def_link_policy:hci0 status 0x0
hci_sent_cmd_data:hci0 opcode 0x80f
hci_req_complete:hci0 command 0x080f result 0x00
hci_dev_get:0
hci_del_off_timer:hci0
__hci_request:hci0 end: err 0
__hci_request:hci0 start
hci_le_init_req:hci0
hci_send_cmd:hci0 opcode 0x2002 plen 0
hci_send_cmd:skb len 3
hci_cmd_task:hci0 cmd 1
hci_send_frame:hci0 type 1 len 3
Bluetooth: hci0 command tx timeout
hci_cmd_task:hci0 cmd 1
__hci_request:hci0 end: err -110

--------------000301050501070309020804--
