Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760122Ab0JZREl (ORCPT <rfc822;w@1wt.eu>);
	Tue, 26 Oct 2010 13:04:41 -0400
Received: from claw.goop.org ([74.207.240.146]:38156 "EHLO claw.goop.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753137Ab0JZREk (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 26 Oct 2010 13:04:40 -0400
Message-ID: <4CC70A26.2090200@goop.org>
Date: Tue, 26 Oct 2010 10:04:38 -0700
From: Jeremy Fitzhardinge <jeremy@goop.org>
User-Agent: Mozilla/5.0 (X11; U; Linux x86_64; en-US; rv:1.9.2.9) Gecko/20100921 Fedora/3.1.4-1.fc13 Lightning/1.0b3pre Thunderbird/3.1.4
MIME-Version: 1.0
To: Avi Kivity <avi@redhat.com>
CC: Glauber Costa <glommer@redhat.com>, kvm@vger.kernel.org,
        linux-kernel@vger.kernel.org, Marcelo Tosatti <mtosatti@redhat.com>,
        Zachary Amsden <zamsden@redhat.com>,
        "Xen-devel@lists.xensource.com" <Xen-devel@lists.xensource.com>
Subject: Re: [PATCH 1/5] Add a global synchronization point for pvclock
References: <1271356648-5108-1-git-send-email-glommer@redhat.com> <1271356648-5108-2-git-send-email-glommer@redhat.com> <4CC6130B.8020908@goop.org> <4CC68DE1.1060604@redhat.com>
In-Reply-To: <4CC68DE1.1060604@redhat.com>
Content-Type: text/plain; charset=ISO-8859-15
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

 On 10/26/2010 01:14 AM, Avi Kivity wrote:
>  On 10/26/2010 01:30 AM, Jeremy Fitzhardinge wrote:
>> Unfortunately this is breaking Xen save/restore: if you restore on a
>> host which was booted more recently than the save host, causing the
>> system time to be smaller.  The effect is that the domain's time leaps
>> forward to a fixed point, and stays there until the host catches up to
>> the source host...
>
> Shouldn't save/restore also save the timebase?

Xen doesn't guarantee the system time is monotonic across those kinds of
events.  The domain could maintain its own offset to maintain an
illusion of monotonicity, but I think its simpler to just zero
last_value on resume.

    J
