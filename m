Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752986Ab0KFSx7 (ORCPT <rfc822;w@1wt.eu>);
	Sat, 6 Nov 2010 14:53:59 -0400
Received: from one.firstfloor.org ([213.235.205.2]:57220 "EHLO
	one.firstfloor.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751739Ab0KFSx5 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 6 Nov 2010 14:53:57 -0400
Date: Sat, 6 Nov 2010 19:53:50 +0100
From: Andi Kleen <andi@firstfloor.org>
To: Davidlohr Bueso <dave@gnu.org>
Cc: Andi Kleen <andi@firstfloor.org>,
        "Paul E. McKenney" <paulmck@linux.vnet.ibm.com>,
        LKML <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH] mce: fix RCU lockdep from mce_log()
Message-ID: <20101106185350.GA23824@basil.fritz.box>
References: <1288993499.2065.4.camel@cowboy>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1288993499.2065.4.camel@cowboy>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Nov 05, 2010 at 06:44:59PM -0300, Davidlohr Bueso wrote:
> Hi,
> 
> Please review this patch, I am not very familiar with MCE/RCU so I'm not sure that this is the correct fix (otherwise consider it a bug report :)).
> This does "fix" the message though and I can use MCE normally.

The patch is certainly not correct. The variable needs to be read
independently of the mutex.

-Andi
