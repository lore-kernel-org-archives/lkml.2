Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753968Ab0IHTuM (ORCPT <rfc822;w@1wt.eu>);
	Wed, 8 Sep 2010 15:50:12 -0400
Received: from mail-ww0-f44.google.com ([74.125.82.44]:63822 "EHLO
	mail-ww0-f44.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753608Ab0IHTuH (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 8 Sep 2010 15:50:07 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=from:to:subject:date:user-agent:cc:references:in-reply-to
         :mime-version:content-type:content-transfer-encoding:message-id;
        b=woD/9/6qoTOAjLMPDoYU8J3wq305YaaCYD//EC8lpyG424u8Gev8CPa3QIQ7sxI7R8
         JkcURQsJiR0R7x+hAuFWkevc4i4RAyjASGFhLNqaLAwtR6YGGUMZyWUoY1CnfZ7knHBT
         U0QrlH+P6OQpzn5a1yK7xgBlkfdGOE728dh7g=
From: Pedro Francisco <pedrogfrancisco@gmail.com>
To: Stefan Richter <stefanr@s5r6.in-berlin.de>
Subject: Re: 2.6.35.4: sudo rmmod ahci @ 2.6.35.4 succeeds: filesystem access errors follow
Date: Wed, 8 Sep 2010 20:49:53 +0100
User-Agent: KMail/1.13.2 (Linux/2.6.32-24-generic; KDE/4.4.2; i686; ; )
Cc: Alejandro Riveira =?iso-8859-1?q?Fern=E1ndez?= 
	<ariveira@gmail.com>,
        linux-kernel@vger.kernel.org
References: <201009071834.27953.pedrogfrancisco@gmail.com> <201009072247.18438.pedrogfrancisco@gmail.com> <4C87D5E9.1060307@s5r6.in-berlin.de>
In-Reply-To: <4C87D5E9.1060307@s5r6.in-berlin.de>
MIME-Version: 1.0
Content-Type: Text/Plain;
  charset="us-ascii"
Content-Transfer-Encoding: 7bit
Message-Id: <201009082049.54128.pedrogfrancisco@gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wednesday 08 September 2010 19:28:57 Stefan Richter wrote:
> Pedro Francisco wrote:
> > That makes no sense. That's what the force option "-f" is for. It's my
> > opinion the usage count for ahci on `lsmod' should be 1 and not 0.
> > Whoever still wants to remove it can use the `rmmod -f ahci'
> 
> The usage count of a module is only there to ensure that function calls
> into the module succeed.  As long as some other part of the kernel has a
> pointer of a function in the module, removal of the module needs to be
> prevented.
> 
> "rmmod ahci" on the other hand is something like pulling the SATA cable. 
> Or ejection of the controller from an ExpressCard slot.  The driver
> shutdown causes the controller device and thus its child devices (disk
> devices behind the controller) to go away, and that's it.  You can do also
> # echo $DEVICE_ID > /sys/module/ahci/drivers/pci\:ahci/unbind
> which tells the driver to let go of the controller.

Hum ok... Still I find it weird since on 2.6.32 I've, after `lsmod | grep -i 
ahci':
ahci                   32200  4
and on 2.6.35.4:
ahci                   32200  0

Why the change of behaviour? Is it because of the split of libahci from ahci ?

-- 
Pedro
