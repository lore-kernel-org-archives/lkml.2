Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754763Ab1HCOxx (ORCPT <rfc822;w@1wt.eu>);
	Wed, 3 Aug 2011 10:53:53 -0400
Received: from nat28.tlf.novell.com ([130.57.49.28]:60011 "EHLO
	nat28.tlf.novell.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753205Ab1HCOxt convert rfc822-to-8bit (ORCPT
	<rfc822;groupwise-jbeulich@novell.com:6:1>);
	Wed, 3 Aug 2011 10:53:49 -0400
Message-Id: <4E396F090200007800073F59@nat28.tlf.novell.com>
X-Mailer: Novell GroupWise Internet Agent 8.0.1 
Date: Wed, 03 Aug 2011 15:53:44 +0100
From: "Jan Beulich" <jbeulich@novell.com>
To: <daniel.stodden@citrix.com>, <Ian.Campbell@eu.citrix.com>,
        <jaxboe@fusionio.com>, <annie.li@oracle.com>, <joe.jin@oracle.com>,
        <konrad.wilk@oracle.com>, <KURT.HACKEL@oracle.com>
Cc: <xen-devel@lists.xensource.com>, <greg.marsden@oracle.com>,
        <linux-kernel@vger.kernel.org>
Subject: Re: [Xen-devel] [PATCH 0/3] xen-blkback: refactor vbd
	 remove/disconnect.
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 8BIT
Content-Disposition: inline
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

>>> Joe Jin 08/03/11 4:10 AM >>> 
>1. start guest with the latest kernel. 
>2. attach new block device by xm block-attach in Dom0 
>3. mount new disk in guest 
>4. execute xm block-detach to detach the block device in dom0 until timeout 
>5. try to unmount the disk in guest, umount hung. at here, any IOs to the 
>device will hang. 

A bogus sequence of operations - an operator in Dom0 shouldn't remove
a device that is still in use in a guest, except as an exceptionasl measure
(and then other bad behavior is to be expected). What's the use case?

Jan
