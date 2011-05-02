Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755402Ab1EBTq4 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 2 May 2011 15:46:56 -0400
Received: from 74-93-104-97-Washington.hfc.comcastbusiness.net ([74.93.104.97]:47587
	"EHLO sunset.davemloft.net" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751771Ab1EBTqz convert rfc822-to-8bit
	(ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 2 May 2011 15:46:55 -0400
Date: Mon, 02 May 2011 12:46:22 -0700 (PDT)
Message-Id: <20110502.124622.226785624.davem@davemloft.net>
To: agimenez@sysvalve.es
Cc: linux-kernel@vger.kernel.org, dgiagio@gmail.com, dborca@yahoo.com,
        pmcenery@gmail.com, david.hill@ubisoft.com, linux-usb@vger.kernel.org,
        netdev@vger.kernel.org
Subject: Re: [PATCH] ipheth.c: Enable IP header alignment
From: David Miller <davem@davemloft.net>
In-Reply-To: <1304364912-15444-1-git-send-email-agimenez@sysvalve.es>
References: <1304264799.2833.82.camel@localhost>
	<1304364912-15444-1-git-send-email-agimenez@sysvalve.es>
X-Mailer: Mew version 6.3 on Emacs 23.1 / Mule 6.0 (HANACHIRUSATO)
Mime-Version: 1.0
Content-Type: Text/Plain; charset=iso-8859-1
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: L. Alberto Giménez <agimenez@sysvalve.es>
Date: Mon,  2 May 2011 21:35:12 +0200

> Since commit ea812ca1b06113597adcd8e70c0f84a413d97544 (x86: Align skb w/ start
> of cacheline on newer core 2/Xeon Arch), NET_IP_ALIGN changed from 2 to 0, and
> the constant is used to reserve more room for the socket buffer.
> 
> Some people have reported that tethering stopped working and David Hill
> submited a patch that redefined NET_IP_ALIGN. Pointed by Ben Hutchings, the
> patch has been reworked to use a private constant.
> 
> I have no more an iPhone device to test it, so it is only compile-tested.
> 
> Signed-off-by: L. Alberto Giménez <agimenez@sysvalve.es>

Why did this break things?

I'm not applying a fix when nobody can explain the reason why:

1) Things broke in the first place
2) Forcing reservation of 2 bytes fixes things

Where is the built in assumption about "2" and why does it exist?  Why
can't we fix this code not to have such assumptions in the first
place?
