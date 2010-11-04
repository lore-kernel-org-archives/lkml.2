Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754254Ab0KDBKe (ORCPT <rfc822;w@1wt.eu>);
	Wed, 3 Nov 2010 21:10:34 -0400
Received: from mail-qw0-f46.google.com ([209.85.216.46]:41062 "EHLO
	mail-qw0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754192Ab0KDBKc (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 3 Nov 2010 21:10:32 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=sender:message-id:date:from:user-agent:mime-version:to:cc:subject
         :references:in-reply-to:content-type:content-transfer-encoding;
        b=vWQ6Ot13cA8j9pY4hkDHPMjSLuBJ/b7eoBb/gknwSLITBr8q9rfgBDlPlU7BRzY3rZ
         KaJ+Dtw87VzUZfALIy7fYnowNZgEbJ7cs8pRatCoxCtCDbWGOuqf8nndSm/Jz5JNDy2c
         8cuJ0AggjUY2ra+IhtKgwUGI/4MklYfyBldGM=
Message-ID: <4CD20820.1070406@lwfinger.net>
Date: Wed, 03 Nov 2010 20:10:56 -0500
From: Larry Finger <Larry.Finger@lwfinger.net>
User-Agent: Mozilla/5.0 (X11; U; Linux x86_64; en-US; rv:1.9.1.14) Gecko/20101013 SUSE/3.0.9 Thunderbird/3.0.9
MIME-Version: 1.0
To: Alan Stern <stern@rowland.harvard.edu>
CC: pali.rohar@gmail.com, Greg Kroah-Hartman <gregkh@suse.de>,
        LKML <linux-kernel@vger.kernel.org>
Subject: Re: [RFC/RFT] OHCI: Fix for regression in 2.6.37-rc1 since commit
 3df7169e7
References: <Pine.LNX.4.44L0.1011031647140.15616-100000@netrider.rowland.org>
In-Reply-To: <Pine.LNX.4.44L0.1011031647140.15616-100000@netrider.rowland.org>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 11/03/2010 04:04 PM, Alan Stern wrote:
> 
> This patch is definitely wrong -- it defeats the entire purpose of 
> rewriting the control register!  That write was added _specifically_ to 
> put the controller into reset, i.e., to change the functional state.
> 
> Furthermore, the write does the same thing as ohci_hcd.c does in its
> ohci_usb_reset() routine.  Regardless, ohci_run() does a complete host
> controller reset, which should override anything done in pci-quirks.c.  
> Perhaps _that_ routine needs some attention.

It is looking as if your patch is exposing a different bug. When I disable the
write in pci_quirks leaving the controllers in OPER or RESUME mode, then
ohci_run() is not called. I'm still trying to find out why.

Larry
