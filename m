Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754487Ab1FCLsu (ORCPT <rfc822;w@1wt.eu>);
	Fri, 3 Jun 2011 07:48:50 -0400
Received: from eu1sys200aog107.obsmtp.com ([207.126.144.123]:47162 "EHLO
	eu1sys200aog107.obsmtp.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752120Ab1FCLss convert rfc822-to-8bit
	(ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 3 Jun 2011 07:48:48 -0400
From: Alexey ORISHKO <alexey.orishko@stericsson.com>
To: Oliver Neukum <oneukum@suse.de>
Cc: "Valdis.Kletnieks@vt.edu" <Valdis.Kletnieks@vt.edu>,
        Dan Williams <dcbw@redhat.com>, Stefan Metzmacher <metze@samba.org>,
        Oliver Neukum <oliver@neukum.name>,
        Greg Kroah-Hartman <gregkh@suse.de>,
        "linux-usb@vger.kernel.org" <linux-usb@vger.kernel.org>,
        "netdev@vger.kernel.org" <netdev@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Date: Fri, 3 Jun 2011 13:47:43 +0200
Subject: RE: [PATCH] TODO FLAG_POINTTOPOINT => FLAG_WWAN? usbnet/cdc_ncm:
 mark ncm devices as "mobile broadband devices" with FLAG_WWAN
Thread-Topic: [PATCH] TODO FLAG_POINTTOPOINT => FLAG_WWAN? usbnet/cdc_ncm:
 mark ncm devices as "mobile broadband devices" with FLAG_WWAN
Thread-Index: Acwh28I4PR43zZiDRmmPM6LDPwEfYwABIbEQ
Message-ID: <2AC7D4AD8BA1C640B4C60C61C8E520153E3C13B659@EXDCVYMBSTM006.EQ1STM.local>
References: <1306922913-17803-1-git-send-email-metze@samba.org>
 <201106031201.21933.oneukum@suse.de>
 <2AC7D4AD8BA1C640B4C60C61C8E520153E3C13B620@EXDCVYMBSTM006.EQ1STM.local>
 <201106031250.28041.oneukum@suse.de>
In-Reply-To: <201106031250.28041.oneukum@suse.de>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
acceptlanguage: en-US
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 8BIT
MIME-Version: 1.0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

> -----Original Message-----
> From: Oliver Neukum [mailto:oneukum@suse.de]
> Sent: Friday, June 03, 2011 12:50 PM
> 
> Well, but cdc-ether usually means that you can start up dhcp and use
> the
> interface as a network card. Can the same be done with cdc-ncm or do
> you always
> need to establish a connection through a secondary interface?
> 

Some solutions (also based on cdc_ether driver) present IP address assigned
by 3G network. Initially device carrier is OFF. As soon as 3G network PDP
context is established, device send notification 
USB_CDC_NOTIFY_NETWORK_CONNECTION and host driver set carrier ON.

In such a case the problem is the lack of control channel definition in both
CDC ECM and CDC NCM. In order for mobile device to setup 3G connection
some application from PC must setup PDP context. The usual way to do it via
modem by using AT commands. So, it might be CDC ACM or some proprietary
solution. 
As a result you have to have vendor specific solution to find "real" control
channel (/dev/ttyACMx or other) and setup connection.
The need to know interface name is needed if you want to set default
route to that interface. Do you want to do it while you have pc broadband 
connection at hand? Probably not. 
I've tried to run 3g modem with cdc_ncm on Ubuntu 8 and later without any
need to specify interface names, same for Fedora.

So connection manager has to know: control interface, vendor- 
specific (or ever product specific) AT command sequence and optionally 
network interface name.
To sort this out, someone need either to track VID/PID or get
information by other means, for example via AT channel by guessing the
right tty device name.

Anyway, all this discussion is user space application problems.
Solution would be different from vendor to vendor.

/alexey

