Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932093Ab0EXR2v (ORCPT <rfc822;w@1wt.eu>);
	Mon, 24 May 2010 13:28:51 -0400
Received: from p01c11o143.mxlogic.net ([208.65.144.66]:43586 "EHLO
	p01c11o143.mxlogic.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1758034Ab0EXR2u convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 24 May 2010 13:28:50 -0400
X-MXL-Hash: 4bfab752139355bf-294827badd4dd2dc4c8223405c79141abc6459c8
X-MXL-Hash: 4bfab74d43621c49-6ee61a20a15e0a53d2283a84ba0a27fcf4bf6bc3
X-MimeOLE: Produced By Microsoft Exchange V6.5
Content-class: urn:content-classes:message
MIME-Version: 1.0
Content-Type: text/plain;
	charset="us-ascii"
Content-Transfer-Encoding: 8BIT
Subject: RE: [PATCH 2.6.34-rc6] net: Improve ks8851 snl transmit performance
Date: Mon, 24 May 2010 10:28:40 -0700
Message-ID: <14385191E87B904DBD836449AA30269D6DF528@MORGANITE.micrel.com>
In-Reply-To: <20100516.002607.84408834.davem@davemloft.net>
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
Thread-Topic: [PATCH 2.6.34-rc6] net: Improve ks8851 snl transmit performance
Thread-Index: Acr0yQhxLpO0hi71RKafmU5sQ4QSrwGnNgIg
References: <14385191E87B904DBD836449AA30269D021A64@MORGANITE.micrel.com> <20100516.002607.84408834.davem@davemloft.net>
From: "Ha, Tristram" <Tristram.Ha@Micrel.Com>
To: "David Miller" <davem@davemloft.net>
Cc: <ben@simtec.co.uk>, <netdev@vger.kernel.org>,
       <linux-kernel@vger.kernel.org>, <x0066660@ti.com>, <s-jan@ti.com>
X-OriginalArrivalTime: 24 May 2010 17:28:43.0164 (UTC) FILETIME=[8EA11DC0:01CAFB66]
X-Spam: [F=0.2000000000; CM=0.500; S=0.200(2010051701)]
X-MAIL-FROM: <tristram.ha@micrel.com>
X-SOURCE-IP: [65.218.208.2]
X-AnalysisOut: [v=1.0 c=1 a=Bt-WsZ86bRwA:10 a=uEzv4HemXiYA:10 a=VphdPIyG4k]
X-AnalysisOut: [EA:10 a=kj9zAlcOel0A:10 a=J3BOMSfJb05aRia9DmE+FQ==:17 a=Q4]
X-AnalysisOut: [n7fi2PAAAA:8 a=sSG4jb5y4Xv0pkJvkYEA:9 a=e_PzOBZiooD3GhPzrY]
X-AnalysisOut: [kA:7 a=ZrQiG3M1pEUkvoFtmQAwGSz2L2QA:4 a=CjuIK1q_8ugA:10 a=]
X-AnalysisOut: [yJsD6ztlz_8A:10]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

David Miller wrote:
> From: "Ha, Tristram" <Tristram.Ha@Micrel.Com>
> Date: Thu, 6 May 2010 15:50:27 -0700
> 
>> From: Tristram Ha <Tristram.Ha@micrel.com>
>> 
>> Under heavy transmission the driver will put 4 1514-byte packets in
>> queue and stop the device transmit queue.  Only the last packet
>> triggers the transmit done interrupt and wakes up the device transmit
>> queue.  That means a bit of time is wasted when the CPU cannot send
>> any more packet.
>> 
>> The new implementation triggers the transmit interrupt when the
>> transmit buffer left is less than 3 packets.  The maximum transmit
>> buffer size is 6144 bytes.  This allows the device transmit queue to
>> be restarted sooner so that CPU can send more packets.
>> 
>> For TCP receiving it also has the benefit of not triggering any
transmit interrupt at all.
>> 
>> There is a driver option no_tx_opt so that the driver can revert to
>> original implementation.  This allows user to verify if the transmit
>> performance actually improves.
>> 
>> Signed-off-by: Tristram Ha <Tristram.Ha@micrel.com>
> 
> First, if you want to post patches you have to format them properly as
ascii text with no longer
> than 80 column lines in your commit message. 
> I really don't want to hear about your email client being a reason you
can't do this properly :-)
> 
> Second, I don't think you can use the skb->ip_summed for this hacked
state tracking you are
> using.  The packet might be shared with other entities, and therefore
if you change the field it
> won't be correct for them any more.  

Sorry about the patch description.  I must have forgotten the rules.

As the socket buffer is accepted by the lowest level network driver and
reaches the end of its life, I think using one of its variables
temporarily does not cause any harm.
