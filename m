Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756297Ab2ESRnt (ORCPT <rfc822;w@1wt.eu>);
	Sat, 19 May 2012 13:43:49 -0400
Received: from queue01.mail.zen.net.uk ([212.23.3.234]:38023 "EHLO
	queue01.mail.zen.net.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755607Ab2ESRnr convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 19 May 2012 13:43:47 -0400
From: "Andrew Bird (Sphere Systems)" <ajb@spheresystems.co.uk>
Organization: Sphere Systems Ltd
To: =?utf-8?q?Bj=C3=B8rn_Mork?= <bjorn@mork.no>
Subject: Re: [PATCH] USB CDC-Ether - Add ZTE WWAN matches before generic Ethernet
Date: Sat, 19 May 2012 18:42:38 +0100
User-Agent: KMail/1.13.7 (Linux/2.6.43.2-6.fc15.i686; KDE/4.6.5; i686; ; )
Cc: oliver@neukum.name, gregkh@linuxfoundation.org, linux-usb@vger.kernel.org,
        netdev@vger.kernel.org, linux-kernel@vger.kernel.org
References: <1337435767-9544-1-git-send-email-ajb@spheresystems.co.uk> <87aa14jcyi.fsf@nemi.mork.no>
In-Reply-To: <87aa14jcyi.fsf@nemi.mork.no>
MIME-Version: 1.0
Content-Type: Text/Plain;
  charset="utf-8"
Content-Transfer-Encoding: 8BIT
Message-Id: <201205191842.38567.ajb@spheresystems.co.uk>
X-Originating-Smarthost01-IP: [82.71.70.22]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Saturday 19 May 2012, Bjørn Mork wrote:
> Andrew Bird <ajb@spheresystems.co.uk> writes:
> > Some ZTE WWAN devices have generic CDC Ether descriptors. Add those
> > into the whitelist so that we get FLAG_WWAN on the interface
> 
> Are you sure none of these export QMI via the CDC Ether control
> interface?  Or are they not Qualcomm devices at all?
> 
> As usual, if you see a spurious "CDC: unexpected notification 01" logged
> from cdc_ether, then there is reason to examine those closer.  If you
> don't see any such messages, then there isn't any QMI there.
> 
> 
> Bjørn

Hi Bjørn,
	No these are devices that use the Icera chipset. They have cdc-acm serial 
ports and firmware has implemented AT commands for (de)activating the pseudo 
Ethernet and getting IP + DNS values etc. Actually applying this patch will 
provide little in terms of operation except to make the interface name wwan%d 
unstead of usb%d and to flag the interface such that Network Manager does not 
try to bring it up via DHCP as soon as it appears, like it would with a fixed 
Ethernet interface.

Good tip about the 'unexpected notification 01' I'll look out for that!

Andrew
