Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753873Ab2ARTaq (ORCPT <rfc822;w@1wt.eu>);
	Wed, 18 Jan 2012 14:30:46 -0500
Received: from mail-iy0-f174.google.com ([209.85.210.174]:33061 "EHLO
	mail-iy0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752011Ab2ARTap (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 18 Jan 2012 14:30:45 -0500
Date: Wed, 18 Jan 2012 11:30:40 -0800
From: Tejun Heo <tj@kernel.org>
To: "Srivatsa S. Bhat" <srivatsa.bhat@linux.vnet.ibm.com>
Cc: "Rafael J. Wysocki" <rjw@sisk.pl>,
        Linux PM list <linux-pm@vger.kernel.org>,
        LKML <linux-kernel@vger.kernel.org>, horms@verge.net.au,
        "pavel@ucw.cz" <pavel@ucw.cz>, Len Brown <lenb@kernel.org>
Subject: Re: [Update][PATCH] PM / Hibernate: Fix s2disk regression related
 to unlock_system_sleep()
Message-ID: <20120118193040.GA28538@google.com>
References: <201201172345.15010.rjw@sisk.pl>
 <201201180015.56510.rjw@sisk.pl>
 <4F16C24A.4050007@linux.vnet.ibm.com>
 <CAOS58YMBWrD2cMyPJG0Xf16i1vnkB8xerdeqWJ=fk7HVNpoPAw@mail.gmail.com>
 <4F16F94C.4020000@linux.vnet.ibm.com>
 <CAOS58YPW3hB3ibaYPLBqhu=2jZTAjjF7DZaXO=hK5tookAX7YA@mail.gmail.com>
 <4F16FF0D.1030606@linux.vnet.ibm.com>
 <20120118173037.GE30664@google.com>
 <4F171BF8.50803@linux.vnet.ibm.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <4F171BF8.50803@linux.vnet.ibm.com>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hello,

On Thu, Jan 19, 2012 at 12:52:32AM +0530, Srivatsa S. Bhat wrote:
> Somehow I don't think its a hack, based on my perception as described
> above. But feel free to prove me wrong :-)

Thanks for the explanation.  Yeah, I agree and it's much simpler this
way, which is nice.  So, in short, because freezing state can't change
across lock_system_sleep(), there's no reason to check for freezing
state on unlock and this nicely resolves the freezer problem together.

The only thing to be careful is, then, we need to set and clear SKIP
inside pm_mutex.

Thanks.

-- 
tejun
